package com.bored.games.darts.logic 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.objects.Cursor;
	import com.bored.games.darts.objects.Dartboard;
	import com.bored.games.darts.ui.modals.ClickContinueModal;
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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author sam
	 */
	public class DartsGameLogic extends EventDispatcher
	{		
		public static const GAME_END:String = "gameEnd";
		
		protected var _scoreManager:AbstractScoreManager;
		
		protected var _currentTurn:DartsTurn;
		protected var _currentPlayer:int;
		protected var _currentDart:Dart;
		protected var _lastDart:Dart;
		
		protected var _darts:Vector.<Dart>;
		
		protected var _inputController:InputController;
		protected var _throwController:ThrowController;
		
		protected var _players:Vector.<DartsPlayer>;
		
		protected var _abilityManager:AbilityManager;
		
		protected var _throwsPerTurn:int = 0;
		
		protected var _dartboard:Dartboard;
		
		protected var _cursor:Cursor;
		
		public function DartsGameLogic() 
		{
			_throwsPerTurn = AppSettings.instance.throwsPerTurn;
			_scoreManager = new AbstractScoreManager();
			_abilityManager = new AbilityManager();
			
			_dartboard = new Dartboard(SpriteFactory.getSpriteByQualifiedName("com.bored.games.assets.DartboardColorMap_MC"));
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
			return _dartboard.boardSprite.getChildByName("c_" + a_points + "_" + a_multiple + "_mc") as Sprite;
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
			a_player.playerNum = _players.length + 1;
			
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
			
			_scoreManager.clearScoreBoard();
			
			if( _inputController && _throwController )
				_inputController.addEventListener(InputStateEvent.UPDATE, _throwController.onInputUpdate);
				
		}//end startGame()
		
		public function endGame():void
		{
			GameUtils.endGame();
			
			if( _inputController && _throwController )
				_inputController.removeEventListener(InputStateEvent.UPDATE, _throwController.onInputUpdate);
				
			_abilityManager.initialize();
				
			_darts = null;
		
			_inputController = null;
			_throwController = null;
		
			_players = null;
			
			this.dispatchEvent(new Event(GAME_END));
		}//end endGame()
		
		public function update(a_time:Number = 0):void
		{			
			_dartboard.update(a_time);
			_cursor.update(a_time);
			
			for each ( var dart:Dart in _darts )
			{
				dart.update(a_time);
			}
			
			if ( _currentDart && _currentDart.position.z >=  AppSettings.instance.dartboardPositionZ )
			{
				_currentDart.finishThrow();
				
				if ( !_dartboard.submitDartPosition(_currentDart.position.x, _currentDart.position.y, _currentDart.blockBoard) ) 
				{
					_currentDart.beginFalling();
				}
				
				if (_currentTurn.throwsRemaining == 0) {
					var win:Boolean = checkForWin();
					
					if (win) {
						endGame();
						DartsGlobals.instance.showModalPopup(GameResultsModal);
					} else {
						_abilityManager.processTurn();
						_currentDart = null;
						DartsGlobals.instance.showModalPopup(ClickContinueModal);
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
			
			_lastDart = null;
			
			nextDart();
		}//end startNewRound()
		
		public function nextDart():void
		{
			_lastDart = _currentDart;
			
			var ind:int = _currentTurn.advanceThrows() - 1;
			_currentDart = _players[_currentPlayer - 1].darts[ind];
			_currentDart.reset();
			
			_currentDart.position.x = AppSettings.instance.defaultStartPositionX;
			_currentDart.position.y = AppSettings.instance.defaultStartPositionY;
			_currentDart.position.z = AppSettings.instance.defaultStartPositionZ;
			
			_players[_currentPlayer-1].takeTheShot();
		}//end createNewDart()
		
		public function get lastDart():Dart
		{
			return _lastDart;
		}//end lastDart()
		
		public function redoDart():void
		{	
			_currentDart.position.x = AppSettings.instance.defaultStartPositionX;
			_currentDart.position.y = AppSettings.instance.defaultStartPositionY;
			_currentDart.position.z = AppSettings.instance.defaultStartPositionZ;
			
			if( _lastDart ) {
				_currentTurn.redoThrow();
				_currentDart = _lastDart;
				_currentDart.reset();
				
				_currentDart.position.x = AppSettings.instance.defaultStartPositionX;
				_currentDart.position.y = AppSettings.instance.defaultStartPositionY;
				_currentDart.position.z = AppSettings.instance.defaultStartPositionZ;
			}
			
			_players[_currentPlayer-1].takeTheShot();
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
		
		public function get currentPlayer():int
		{
			return _currentPlayer;
		}//end get currentPlayer()
		
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
			_cursor.show();
			_inputController.pause = false;
		}//end playerAim()
		
		public function playerThrow(a_x:Number, a_y:Number, a_z:Number, a_thrust:Number, a_lean:Number):void
		{			
			_cursor.hide();
			_cursor.resetCursorImage();
			_inputController.pause = true;
			_currentDart.initThrowParams(a_x, a_y, a_z, a_thrust, AppSettings.instance.defaultAngle, AppSettings.instance.defaultGravity, a_lean);
		}//end playerThrow()
		
		public function get cursor():Cursor
		{
			return _cursor;
		}//end get cursor()
		
		public function get dartboard():Dartboard
		{
			return _dartboard;
		}//end get dartboard()
		
	}//end AbstractGameLogic

}//end com.bored.games.darts.logic