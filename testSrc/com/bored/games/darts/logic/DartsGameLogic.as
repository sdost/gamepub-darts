package com.bored.games.darts.logic 
{
	import com.bored.games.controllers.InputController;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.GameUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.sven.utils.AppSettings;
	/**
	 * ...
	 * @author sam
	 */
	public class DartsGameLogic
	{		
		protected var _scoreManager:AbstractScoreManager;
		
		protected var _currentTurn:DartsTurn;
		protected var _currentPlayer:int;
		protected var _currentDart:Dart;
		
		protected var _darts:Vector.<Dart>;
		
		protected var _inputController:InputController;
		
		protected var _players:Vector.<DartsPlayer>;
		
		protected var _dartboardClip:Sprite;
		
		protected var _buttonDown:Boolean;
		
		public function DartsGameLogic() 
		{
			_scoreManager = new AbstractScoreManager();
		}//end constructor()
		
		public function set dartboardClip(a_clip:MovieClip):void
		{
			_dartboardClip = a_clip;
		}//end set dartboardClip()
		
		public function get dartboardClip():Sprite
		{
			return _dartboardClip;
		}//end dartboardClip()
		
		public function set inputController(a_input:InputController):void
		{
			_inputController = a_input;
			_inputController.addEventListener(InputStateEvent.UPDATE, onInputUpdate);
		}//end set inputController()
		
		public function getDartboardClip(a_points:int, a_multiple:int):Sprite
		{
			return _dartboardClip["c_" + a_points + "_" + a_multiple + "_mc"];
		}//end getDartboardClip()
		
		public function get gameType():String
		{
			
		}//end get gameType()
		
		public function registerPlayer(a_player:DartsPlayer):void
		{
			if ( _players == null ) {
				_players = new Vector.<DartsPlayer>();
				_currentPlayer = 1;
			}
			
			a_player.dartGame = this;
			_players.push(a_player);
			_scoreManager.initPlayerStats(_players.length);
		}//end registerPlayer()
		
		public function newGame():void
		{
			GameUtils.newGame();
		}//end startGame()
		
		public function update(a_time:Number = 0):void
		{
			_currentDart.update(a_time);
		}//end update();
		
		public function get scoreManager():AbstractScoreManager
		{
			return _scoreManager;
		}// end get scoreManager()
		
		public function startNewTurn():void
		{
			_currentTurn = new DartsTurn(this, AppSettings.instance.throwsPerTurn);
		}//end startNewRound()
		
		public function createNewDart():void
		{
			_currentTurn.advanceThrows();
			_currentDart = new Dart(AppSettings.instance.dartRadius);
			this.darts.push(_currentDart);
			
			_currentDart.position.x = AppSettings.instance.defaultReleasePositionX;
			_currentDart.position.y = AppSettings.instance.defaultReleasePositionY;
			_currentDart.position.z = AppSettings.instance.defaultReleasePositionZ;
			
			_players[_currentPlayer].takeTheShot(_currentTurn.throwsRemaining);
		}//end createNewDart()
		
		public function get darts():Vector.<Dart>
		{
			if ( _darts == null ) {
				_darts = new Vector.<Dart>();
			}
			return _darts;
		}//end get darts()
		
		public function endTurn():void
		{
			_currentPlayer++;
			
			if (_currentPlayer > _players.length) _currentPlayer = 1;
		}//end endTurn()
				
		public function playerAim():void
		{
			_inputController.pause = false;	
		}//end playerAim()
		
		public function playerThrow(a_x:Number, a_y:Number, a_z:Number, a_thrust:Number, a_xvel:Number):void
		{
			_inputController.pause = true;
			
			_currentDart.initThrowParams(a_x, a_y, a_z, a_thrust, AppSettings.instance.defaultAngle, AppSettings.instance.defaultGravity, a_velX);
		}//end playerThrow()
		
		private function onInputUpdate(a_evt:InputStateEvent):void
		{			
			if (_buttonDown) {
				if ( !a_evt.button ) {
					if ( _cumAvgSpeed ) {
						_thrust = Math.min((_cumAvgSpeed / 50), AppSettings.instance.dartMaxThrust);
						
						if ( _thrust >= AppSettings.instance.dartMinThrust ) 
						{
							playerThrow(_currentDart.position.x, _currentDart.position.y, _currentDart.position.z, _thrust, _velX / 1000);
						}
					}
					_mouseTimer.removeEventListener( TimerEvent.TIMER, updateCurrentMouseVelocity );
					_mouseTimer.stop();
					_mouseTimer.reset();
				}
			} else {
				if ( a_evt.button ) {
					trace("Starting mouse timer??");
					_oX = _mousePosition.x;
					_oY = _mousePosition.y;
					_velX = 0;
					_velY = 0;
					_speed = 0;
					_cumAvgSpeed = 0;
					_num = 0;
					_mouseTimer.addEventListener( TimerEvent.TIMER, updateCurrentMouseVelocity );
					_mouseTimer.start();
				} else {					
					_currentDart.position.x = (((a_evt.x - 350) * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 700);
					_currentDart.position.y = (((a_evt.y - 275) * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 550);
				}
			}
			
			_buttonDown = a_evt.button;
		}//end onInputUpdate()
		
		private function updateCurrentMouseVelocity(e:TimerEvent):void
		{
			var nX:Number = _mousePosition.x;
			var nY:Number = _mousePosition.y;
			var dx:Number = nX - _oX;
			var dy:Number = nY - _oY;
    
			_oX = nX;
			_oY = nY;
			_velX = dx * 1000 / _mouseTimer.delay;
			_velY = dy * 1000 / _mouseTimer.delay;
			_speed = Math.sqrt( _velX * _velX + _velY * _velY );
			
			_cumAvgSpeed = _cumAvgSpeed + ((_speed - _cumAvgSpeed) / ++_num);
		}//end updateCurrentMouseVelocity()
		
	}//end AbstractGameLogic

}//end com.bored.games.darts.logic