package com.bored.games.darts.logic 
{
	import com.bored.games.input.InputController;
	import com.bored.games.darts.input.ThrowController;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.GameUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.sven.utils.AppSettings;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
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
		protected var _throwController:ThrowController;
		
		protected var _players:Vector.<DartsPlayer>;
		
		protected var _dartboardClip:Sprite;
		
		private var _pattern:RegExp = /c_[0-9]+_[0-9]+_mc/;
		
		public function DartsGameLogic() 
		{
			_scoreManager = new AbstractScoreManager();
		}//end constructor()
		
		public function set dartboardClip(a_clip:Sprite):void
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
		}//end set inputController()
		
		public function set throwController(a_throw:ThrowController):void
		{
			_throwController = a_throw;
		}//end set inputController()
		
		public function get throwController():ThrowController
		{
			return _throwController;
		}//end get throwController()
		
		public function getDartboardClip(a_points:int, a_multiple:int):Sprite
		{
			return _dartboardClip.getChildByName("c_" + a_points + "_" + a_multiple + "_mc") as Sprite;
		}//end getDartboardClip()
		
		public function get gameType():String
		{
			return "";
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
			
			if( _inputController && _throwController )
				_inputController.addEventListener(InputStateEvent.UPDATE, _throwController.onInputUpdate);
				
		}//end startGame()
		
		public function endGame():void
		{
			GameUtils.endGame();
		}//end endGame()
		
		public function update(a_time:Number = 0):void
		{
			if (_currentDart) _currentDart.update(a_time);
			
			if ( _currentDart.position.z >=  AppSettings.instance.dartboardPositionZ )
			{
				_currentDart.position.z = AppSettings.instance.dartboardPositionZ;
				
				_currentDart.finishThrow();
				
				var p:Point = new Point( ( _currentDart.position.x / 1.2 ) * (_dartboardClip.width/2), ( -_currentDart.position.y / 1.2 ) * (_dartboardClip.height/2) );
				
				var objects:Array = _dartboardClip.getObjectsUnderPoint(p);
				
				if (objects.length > 0)
				{		
					if (_pattern.test(objects[0].parent.name)) {
						var arr:Array = objects[0].parent.name.split("_");
						this.scoreManager.submitThrow(_currentPlayer, Number(arr[1]), Number(arr[2]));
					}
				}
				
				if (_currentTurn.throwsRemaining == 0) {
					
					endTurn();
					
					var win:Boolean = checkForWin();
					
					if (win) {
						endGame();
					} else {
						startNewTurn();
					}
				} else {
					nextDart();
				}
			}
		}//end update();
		
		protected function checkForWin():Boolean
		{
			return false;
		}//end checkForWin()
		
		public function get scoreManager():AbstractScoreManager
		{
			return _scoreManager;
		}// end get scoreManager()
		
		public function startNewTurn():void
		{
			_currentTurn = new DartsTurn(this, AppSettings.instance.throwsPerTurn);
			
			_darts = null;
			
			nextDart();
		}//end startNewRound()
		
		public function nextDart():void
		{
			_currentTurn.advanceThrows();
			_currentDart = new Dart(AppSettings.instance.dartRadius);
			this.darts.push(_currentDart);
			
			_currentDart.position.x = AppSettings.instance.defaultReleasePositionX;
			_currentDart.position.y = AppSettings.instance.defaultReleasePositionY;
			_currentDart.position.z = AppSettings.instance.defaultReleasePositionZ;
			
			_players[_currentPlayer-1].takeTheShot();
		}//end createNewDart()
		
		public function get currentDart():Dart
		{
			return _currentDart;
		}//end moveDart()
		
		public function get darts():Vector.<Dart>
		{
			if ( _darts == null ) {
				_darts = new Vector.<Dart>();
			}
			return _darts;
		}//end get darts()
		
		public function endTurn():void
		{
			_currentDart = null;
			
			_currentPlayer++;
			
			if (_currentPlayer > _players.length) _currentPlayer = 1;
		}//end endTurn()
				
		public function playerAim():void
		{
			_inputController.pause = false;	
		}//end playerAim()
		
		public function playerThrow(a_x:Number, a_y:Number, a_z:Number, a_thrust:Number, a_lean:Number):void
		{			
			_inputController.pause = true;
			
			_currentDart.initThrowParams(a_x, a_y, a_z, a_thrust, AppSettings.instance.defaultAngle, AppSettings.instance.defaultGravity, a_lean);
		}//end playerThrow()
		
	}//end AbstractGameLogic

}//end com.bored.games.darts.logic