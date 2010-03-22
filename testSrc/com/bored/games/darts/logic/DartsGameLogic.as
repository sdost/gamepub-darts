package com.bored.games.darts.logic 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.objects.Cursor;
	import com.bored.games.darts.objects.ShieldDart;
	import com.bored.games.darts.ui.modals.GameResultsModal;
	import com.bored.games.input.InputController;
	import com.bored.games.darts.input.ThrowController;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.GameUtils;
	import com.sven.utils.SpriteFactory;
	import flash.display.Bitmap;
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
		
		protected var _blockedSections:Vector.<String>;
		
		protected var _inputController:InputController;
		protected var _throwController:ThrowController;
		
		protected var _players:Vector.<DartsPlayer>;
		
		protected var _dartboardClip:Sprite;
		
		protected var _abilityManager:AbilityManager;
		
		protected var _throwsPerTurn:int = 0;
		
		protected var _cursor:Cursor;
		
		private var _pattern:RegExp = /c_[0-9]+_[0-9]+_mc/;
		
		public function DartsGameLogic() 
		{
			_throwsPerTurn = AppSettings.instance.throwsPerTurn;
			_scoreManager = new AbstractScoreManager();
			_abilityManager = new AbilityManager();
			_blockedSections = new Vector.<String>();
			_cursor = new Cursor(SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.hud.Cursor_MC"));
		}//end constructor()
		
		public function loadGameState(a_state:Object):void
		{
			// TODO translate state object into game logic state
		}//end loadGameState()
		
		public function saveGameState():Object
		{
			return null;
			// TODO translate game logic state into state object
		}//end saveGameState()
		
		public function set dartboardClip(a_clip:Sprite):void
		{
			_dartboardClip = a_clip;
		}//end set dartboardClip()
		
		public function get dartboardClip():Sprite
		{
			return _dartboardClip;
		}//end dartboardClip()
		
		public function get throwsPerTurn():int
		{
			return _throwsPerTurn;
		}//end get throwsPerTurn()
		
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
		
		public function get abilityManager():AbilityManager
		{
			return _abilityManager;
		}//end get abilityManager()
		
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
				_darts = new Vector.<Dart>();
				_currentPlayer = 1;
			}
			
			a_player.dartGame = this;
			
			for each( var ability:Ability in a_player.abilities )
			{
				_abilityManager.registerAbility(ability);
			}
			
			for each( var dart:Dart in a_player.darts )
			{
				dart.position.x = -1000;
				dart.position.y = -1000;
				_darts.push(dart);
			}
			
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
			for each ( var dart:Dart in _darts )
			{
				dart.update(a_time);
			}
			
			if ( _currentDart && _currentDart.position.z >=  AppSettings.instance.dartboardPositionZ )
			{
				_currentDart.finishThrow();
				
				_currentDart.position.z = AppSettings.instance.dartboardPositionZ;			
				
				var p:Point = new Point( ( _currentDart.position.x / AppSettings.instance.dartboardScale ) * (_dartboardClip.width/2), ( -_currentDart.position.y / AppSettings.instance.dartboardScale ) * (_dartboardClip.height/2) );
				
				var objects:Array = _dartboardClip.getObjectsUnderPoint(p);
				
				if (objects.length > 0) {
					if (_pattern.test(objects[0].parent.name) && _blockedSections.indexOf(objects[0].parent.name) < 0) {
						var arr:Array = objects[0].parent.name.split("_");
						this.scoreManager.submitThrow(_currentPlayer, Number(arr[1]), Number(arr[2]));
						
						if(_currentDart is ShieldDart) {
							_blockedSections.push(objects[0].parent.name);
						}
					} 
					else
					{
						_currentDart.beginFalling();
					}
				}
				else
				{
					_currentDart.beginFalling();
				}
				
				if (_currentTurn.throwsRemaining == 0) {
					var win:Boolean = checkForWin();
					resetDarts();
					
					endTurn();
					
					if (win) {
						endGame();
						DartsGlobals.instance.showModalPopup(GameResultsModal);
					} else {
						_abilityManager.processTurn();
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
			_currentTurn = new DartsTurn(this, _throwsPerTurn);
			
			_blockedSections = new Vector.<String>();
			
			nextDart();
		}//end startNewRound()
		
		public function nextDart():void
		{
			var ind:int = _currentTurn.advanceThrows() - 1;
			_currentDart = _players[_currentPlayer - 1].darts[ind];
			_currentDart.reset();
			
			_currentDart.position.x = AppSettings.instance.defaultStartPositionX;
			_currentDart.position.y = AppSettings.instance.defaultStartPositionY;
			_currentDart.position.z = AppSettings.instance.defaultStartPositionZ;
			
			_players[_currentPlayer-1].takeTheShot();
		}//end createNewDart()
		
		public function resetDart():void
		{	
			/*
			if (_darts.length > 1) {
				_currentTurn.redoThrow();
				_darts.pop();
				_currentDart = _darts[_darts.length - 1];
				_currentDart.reset();
				_currentDart.pitch = 90;
			}
			
			_currentDart.position.x = AppSettings.instance.defaultStartPositionX;
			_currentDart.position.y = AppSettings.instance.defaultStartPositionY;
			_currentDart.position.z = AppSettings.instance.defaultStartPositionZ;
			
			_players[_currentPlayer-1].takeTheShot();
			*/
		}//end resetDart()
		
		public function resetDarts():void
		{
			for each( var dart:Dart in _players[_currentPlayer - 1].darts )
			{
				dart.position.x = AppSettings.instance.defaultStartPositionX;
				dart.position.y = AppSettings.instance.defaultStartPositionY;
				dart.position.z = AppSettings.instance.defaultStartPositionZ;
			}
		}//end resetDarts()
		
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
		
		public function get cursor():Cursor
		{
			return _cursor;
		}//end get cursor()
		
	}//end AbstractGameLogic

}//end com.bored.games.darts.logic