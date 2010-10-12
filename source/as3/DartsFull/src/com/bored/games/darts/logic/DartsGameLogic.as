package com.bored.games.darts.logic 
{
	import adobe.utils.ProductManager;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.objects.Cursor;
	import com.bored.games.darts.objects.Dartboard;
	import com.bored.games.darts.profiles.OldManProfile;
	import com.bored.games.darts.statistics.AchievementTracker;
	import com.bored.games.darts.statistics.GameRecord;
	import com.bored.games.darts.ui.modals.BullOffClickContinueModal;
	import com.bored.games.darts.ui.modals.BullOffWinnerModal;
	import com.bored.games.darts.ui.modals.ClickContinueModal;
	import com.bored.games.darts.ui.modals.GameResultsModal;
	import com.bored.games.darts.ui.modals.TurnAnnounceModal;
	import com.bored.games.darts.input.InputController;
	import com.bored.games.darts.input.ThrowController;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.darts.events.InputStateEvent;
	import com.bored.games.GameUtils;
	import com.greensock.TweenMax;
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundController;
	import com.sven.factories.SpriteFactory;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author sam
	 */
	public class DartsGameLogic extends EventDispatcher
	{		
		public static const QUIT_TO_TITLE:String = "quitToTitle";
		public static const GAME_END:String = "gameEnd";
		public static const TURN_END:String = "turnEnd";
		public static const THROW_END:String = "throwEnd";
		
		public static const AT_REST:String = "atRest";
		
		protected var _scoreManager:AbstractScoreManager;
		
		protected var _currentTurn:DartsTurn;
		protected var _currentPlayer:int;
		protected var _currentDart:Dart;
		protected var _lastDart:Dart;
		
		protected var _darts:Vector.<Dart>;
		
		protected var _inputController:InputController;
		protected var _throwController:ThrowController;
		
		protected var _players:Object;
		
		protected var _abilityManager:AbilityManager;
		
		protected var _throwsPerTurn:int = 0;
		
		protected var _dartboard:Dartboard;
		
		protected var _cursor:Cursor;
		
		protected var _paused:Boolean = false;
		
		protected var _bullOff:Boolean = false;
		protected var _bullOffWinner:int;
		protected var _bullOffResults:Array;
		
		protected var _resting:Boolean = false;
		
		protected var _soundController:SoundController;
		
		public function DartsGameLogic() 
		{
			_throwsPerTurn = AppSettings.instance.throwsPerTurn;
			_scoreManager = new AbstractScoreManager();
			_abilityManager = new AbilityManager();
			
			_dartboard = new Dartboard(SpriteFactory.getSpriteByQualifiedName("com.bored.games.assets.DartboardColorMap_MC"));
			_cursor = new Cursor(SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.hud.Cursor_MC"));
			
			_soundController = new SoundController("gameSounds");
			DartsGlobals.instance.soundManager.addSoundController(_soundController);
			_soundController.addSound( new SMSound("throw_fast_1", "dartthrow_fast1_mp3") );
			_soundController.addSound( new SMSound("throw_fast_2", "dartthrow_fast2_mp3") );
			_soundController.addSound( new SMSound("throw_normal_1", "dartthrow_norm1_mp3") );
			_soundController.addSound( new SMSound("throw_normal_2", "dartthrow_norm2_mp3") );
			_soundController.addSound( new SMSound("turn_switch_1", "turnswitch1_mp3") );
			_soundController.addSound( new SMSound("turn_switch_2", "turnswitch2_mp3") );
			_soundController.addSound( new SMSound("turn_switch_3", "turnswitch3_mp3") );
			_soundController.addSound( new SMSound("turn_switch_4", "turnswitch4_mp3") );
			
			//DartsGlobals.instance.soundManager.getSoundControllerByID("loopsController").addSound( new SMSound("ambient_bar_loop", "loop_ambience_bar_wav", true) );
			//DartsGlobals.instance.soundManager.getSoundControllerByID("loopsController").addSound( new SMSound("theme_loop", "loop_theme1_wav", true) );
	
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
		
		public function get gameType():String
		{
			return "";
		}//end get gameType()
		
		public function set bullOff(a_bool:Boolean):void
		{
			_bullOff = a_bool;
		}//end set bullOff
		
		public function get bullOff():Boolean
		{
			return _bullOff;
		}//end get bullOff()
		
		public function set bullOffWinner(a_winner:int):void
		{
			_bullOffWinner = a_winner;
		}//end set bullOffWinner()
		
		public function get bullOffWinner():int
		{
			return _bullOffWinner;
		}//end get bullOffWinner()
		
		public function registerPlayer(a_player:DartsPlayer):void
		{
			if ( _players == null ) {
				_players = new Object();
				_darts = new Vector.<Dart>();
			}
			a_player.dartGame = this;
						
			for each( var ability:Ability in a_player.activeAbilities )
			{
				_abilityManager.registerAbility(ability);
			}
			
			for each( var dart:Dart in a_player.darts )
			{
				dart.x = -1000;
				dart.y = -1000;
				_darts.push(dart);
			}
			
			_players[a_player.playerNum] = a_player;
			_scoreManager.initPlayerStats(a_player.playerNum);
		}//end registerPlayer()
		
		public function get players():Object
		{
			return _players;
		}//end get players()
		
		public function newGame():void
		{	
			GameUtils.newGame();
			
			for each( var player:DartsPlayer in _players )
			{
				player.initGameRecord();
			}
			
			_abilityManager.resetAbilties();
			_scoreManager.clearScoreBoard();
			
			_currentPlayer = 1;
			
			if( _inputController && _throwController )
				_inputController.addEventListener(InputStateEvent.UPDATE, _throwController.onInputUpdate);				
		}//end startGame()
		
		public function endGame(a_winner:int):void
		{
			GameUtils.endGame();
						
			for each( var player:DartsPlayer in _players )
			{
				player.record.recordEndOfGame( a_winner == player.playerNum );
				player.record.gameTime = GameUtils.playTime;
			}
			
			_dartboard.resetBlockedSections();
			
			if( _inputController && _throwController )
				_inputController.removeEventListener(InputStateEvent.UPDATE, _throwController.onInputUpdate);
				
			Mouse.show();				
		}//end endGame()
		
		public function cleanup():void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("loopsController").stop("ambient_bar_loop");
			DartsGlobals.instance.soundManager.getSoundControllerByID("loopsController").stop("theme_loop");
			
			_abilityManager.initialize();
				
			_darts = null;
		
			_inputController = null;
			_throwController = null;
		
			_players = null;
			
			_paused = false;
		}//end cleanup();
		
		public function update(a_time:Number = 0):void
		{	
			if (_paused) return;
			
			_dartboard.update(a_time);
			_cursor.update(a_time);
			
			var resting:Boolean = true;
			for each ( var dart:Dart in _darts )
			{
				dart.update(a_time);
				
				resting = ((!dart.active) && resting);
			}
			
			_resting = resting;
			
			if (_resting) 
			{
				this.dispatchEvent(new Event(AT_REST));
			}
			
			handleGameLogic();
		}//end update();
		
		protected function handleGameLogic():void
		{	
			var winner:int;
			
			if ( _currentDart && ( _currentDart.z >= AppSettings.instance.dartboardPositionZ || _currentDart.y <= -10 ) )
			{	
				_currentDart.z = AppSettings.instance.dartboardPositionZ;
				
				_currentDart.finishThrow();	
				
				if ( _bullOff ) 
				{
					var dist:Number = _dartboard.getDistanceFromSection(_currentDart.x, _currentDart.y, 25, 2);
					
					_bullOffResults[_currentPlayer - 1] = dist;
					
					if ( _bullOffResults[0] > 0 && _bullOffResults[1] > 0 )
					{
						if ( _bullOffResults[0] < _bullOffResults[1] ) 
						{
							winner = 0;
						}
						else
						{
							winner = 1;
						}
						
						//resetDarts();
						_currentPlayer = winner + 1;
												
						_bullOff = false;
						_currentDart = null;
						DartsGlobals.instance.showModalPopup(BullOffWinnerModal);
						return;
					}
					
					_currentTurn.advanceThrows();
					
					if (_currentTurn.throwsRemaining == 0) 
					{
						_currentDart = null;
						//pause(true);
												
						_soundController.play("turn_switch_" + Math.ceil(Math.random() * 4).toString());
						
						endTurn();
					}
					else
					{
						nextDart();
					}
				}
				else 
				{
					if ( !_dartboard.submitDartPosition(_currentDart.x, _currentDart.y, _currentDart.blockBoard) ) 
					{
						_currentDart.beginFalling();
					}
					
					var win:Boolean = checkForWin();
						
					if (win) 
					{
						winner = _currentPlayer;
						
						if (winner == DartsGlobals.instance.localPlayer.playerNum && DartsGlobals.instance.localPlayer.record.throws <= 9) 
						{
							AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_PERFECT_NINER);
						}
						
						endGame(winner);
						pause(true);
						DartsGlobals.instance.showModalPopup(GameResultsModal);
						return;
					}
					
					_currentTurn.advanceThrows();
					
					if (_currentTurn.throwsRemaining == 0) 
					{
						_abilityManager.processTurn();
						_currentDart = null;
						//pause(true);
											
						_soundController.play("turn_switch_" + Math.ceil(Math.random() * 4).toString());
						
						endTurn();
					}
					else
					{
						nextDart();
					}
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
		}//end get scoreManager()
		
		public function startNewBullOff():void
		{			
			_bullOff = true;
			
			_currentPlayer = DartsGlobals.instance.localPlayer.playerNum;
			
			startNewTurn();
		}//end bullOff()
		
		public function startNewTurn():void
		{		
			resetDarts();
			
			if ( _bullOff )
			{
				if ( !_bullOffResults ) {
					_bullOffResults = new Array(2);
					_bullOffResults[0] = -1;
					_bullOffResults[1] = -1;
				}
				
				_currentTurn = new DartsTurn(this, 1);
			}
			else
			{
				_currentTurn = new DartsTurn(this, _throwsPerTurn);
			}
			
			(players[_currentPlayer] as DartsPlayer).clearTurnRecord();
			
			_lastDart = null;
			
			nextDart();
		}//end startNewRound()
		
		public function nextDart():void
		{	
			_lastDart = _currentDart;
			
			_currentDart = _players[_currentPlayer].darts[_currentTurn.throwIndex];
			_currentDart.reset();
			
			trace("Current Dart: " + _currentDart);
			
			_currentDart.x = AppSettings.instance.defaultStartPositionX;
			_currentDart.y = AppSettings.instance.defaultStartPositionY;
			_currentDart.z = AppSettings.instance.defaultStartPositionZ;
			
			dispatchEvent(new Event(THROW_END));
			
			_players[_currentPlayer].takeTheShot(_currentTurn.throwsRemaining);
		}//end nextDart()
		
		public function get lastDart():Dart
		{
			return _lastDart;
		}//end lastDart()
		
		public function redoDart():void
		{	
			_currentDart.x = AppSettings.instance.defaultStartPositionX;
			_currentDart.y = AppSettings.instance.defaultStartPositionY;
			_currentDart.z = AppSettings.instance.defaultStartPositionZ;
						
			if( _lastDart ) {
				_currentTurn.redoThrow();
				_currentDart = _lastDart;
				_currentDart.reset();
				
				_currentDart.x = AppSettings.instance.defaultStartPositionX;
				_currentDart.y = AppSettings.instance.defaultStartPositionY;
				_currentDart.z = AppSettings.instance.defaultStartPositionZ;
			}
						
			_players[_currentPlayer].takeTheShot(_currentTurn.throwsRemaining);
		}//end resetDart()
		
		public function resetDarts():void
		{
			for each( var dart:Dart in _darts )
			{
				dart.x = AppSettings.instance.defaultStartPositionX;
				dart.y = AppSettings.instance.defaultStartPositionY;
				dart.z = AppSettings.instance.defaultStartPositionZ;
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
		
		public function set currentPlayer(a_num:int):void
		{
			_currentPlayer = a_num;
		}//end set currentPlayer()
		
		public function get currentTurn():DartsTurn
		{
			return _currentTurn;
		}//end get currentTurn()
		
		public function get darts():Vector.<Dart>
		{
			if ( _darts == null ) {
				_darts = new Vector.<Dart>();
			}
			return _darts;
		}//end get darts()
		
		public function endTurn():void
		{
			_cursor.hide();
			
			_currentDart = null;
						
			if ( _resting ) {
				endCurrentTurn();
			} else {
				this.addEventListener(AT_REST, endCurrentTurn, false, 0, true);
			}
		}//end endTurn()
		
		protected function endCurrentTurn(e:Event = null):void
		{
			trace("DartsGameLogic::endCurrentTurn()");
			
			_resting = false;
			
			this.removeEventListener(AT_REST, endCurrentTurn);
			
			this.dispatchEvent( new Event(TURN_END) );
			
			nextPlayer();
		}//end endCurrentTurn()
		
		public function nextPlayer():void
		{
			DartsGlobals.instance.gameManager.startNewTurn();
		}//end nextPlayer()
				
		public function playerAim():void
		{
			_cursor.show();
			_throwController.startThrow(_inputController);
		}//end playerAim()
		
		public function playerThrow(a_x:Number, a_y:Number, a_z:Number, a_thrust:Number, a_lean:Number, a_stepScale:Number):Object
		{			
			//_cursor.hide();
			_cursor.resetCursorImage();
			_inputController.pause = true;
			
			var thrust:Number;
			var lean:Number;
			var angle:Number;
			
			var version:int;
			
			if ( a_thrust < AppSettings.instance.dartSweetSpotMin ) 
			{
				version = Math.ceil(2 * Math.random());
				
				_soundController.play("throw_normal_" + version.toString());
				
				thrust = (a_thrust > AppSettings.instance.defaultMinThrustThreshold) ? a_thrust : AppSettings.instance.defaultMinThrustThreshold;
				lean = a_lean;
				angle = AppSettings.instance.defaultAngle;
			}
			else if ( a_thrust > AppSettings.instance.dartSweetSpotMax ) 
			{
				version = Math.ceil(2 * Math.random());
				
				_soundController.play("throw_normal_" + version.toString());
								
				var scaler:Number = Math.log( AppSettings.instance.overthrowScale * (a_thrust - AppSettings.instance.dartSweetSpotThrust)
					/ (AppSettings.instance.dartMaxThrust - AppSettings.instance.dartSweetSpotThrust))
					/ Math.log(AppSettings.instance.overthrowExponent) + AppSettings.instance.overthrowOffset;
									
				thrust = a_thrust / scaler; // AppSettings.instance.dartSweetSpotThrust;
				lean = a_lean * scaler;
				angle = AppSettings.instance.defaultAngle * scaler;
			}
			else 
			{
				version = Math.ceil(2 * Math.random());
				
				_soundController.play("throw_fast_" + version.toString());
				
				thrust = AppSettings.instance.dartSweetSpotThrust;
				lean = a_lean;
				angle = AppSettings.instance.defaultAngle;
			}
			
			_currentDart.initThrowParams(a_x, a_y, a_z, thrust, angle, AppSettings.instance.defaultGravity, lean, AppSettings.instance.dartboardPositionZ, a_stepScale);
			
			return { t: thrust, ang: angle };
		}//end playerThrow()
		
		public function get cursor():Cursor
		{
			return _cursor;
		}//end get cursor()
		
		public function get dartboard():Dartboard
		{
			return _dartboard;
		}//end get dartboard()
		
		public function pause(a_bool:Boolean):void
		{
			trace("Pausing: " + a_bool);
						
			_paused = a_bool;
			
			if ( _inputController ) 
			{
				_inputController.pause = (_paused || (_currentPlayer != DartsGlobals.instance.localPlayer.playerNum));
			}
						
			if (_paused) 
			{
				DartsGlobals.instance.soundManager.getSoundControllerByID("loopsController").stop("ambient_bar_loop");
				DartsGlobals.instance.soundManager.getSoundControllerByID("loopsController").stop("theme_loop");
				TweenMax.pauseAll();
			}
			else
			{
				DartsGlobals.instance.soundManager.getSoundControllerByID("loopsController").play("ambient_bar_loop");
				DartsGlobals.instance.soundManager.getSoundControllerByID("loopsController").play("theme_loop");
				TweenMax.resumeAll();
			}
		}//end pause()
		
	}//end AbstractGameLogic

}//end com.bored.games.darts.logic