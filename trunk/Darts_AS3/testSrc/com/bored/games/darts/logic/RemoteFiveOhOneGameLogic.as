package com.bored.games.darts.logic 
{
	import com.adobe.serialization.json.JSON;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.darts.ui.modals.BullOffClickContinueModal;
	import com.bored.games.darts.ui.modals.BullOffWinnerModal;
	import com.bored.games.darts.ui.modals.GameResultsModal;
	import com.bored.games.darts.ui.modals.TurnAnnounceModal;
	import com.bored.games.events.InputStateEvent;
	import com.bored.gs.game.GameClient;
	import com.bored.gs.game.IGameClient;
	import com.bored.gs.game.ITurnBased;
	import com.bored.gs.game.TurnBasedGameClient;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class RemoteFiveOhOneGameLogic extends DartsGameLogic
	{
		public static const RESULTS_READY:String = "resultsReady";
		
		private var _serverResults:Object = null;
		private var _dispatcher:EventDispatcher;
		
		public function RemoteFiveOhOneGameLogic()
		{
			_scoreManager = new FiveOhOneScoreManager();
			_dispatcher = new EventDispatcher();
			
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_RESULTS, onGameEnd);
			
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.ROUND_START, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.ROUND_END, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.ROUND_RESULTS, handleStateChange);
			
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_START, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_WAIT, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_UPDATE, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_END, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_RESULTS, handleStateChange);
		}//end constructor()
		
		private function onGameEnd(e:Event):void
		{
			var obj:Object = (DartsGlobals.instance.multiplayerClient as IGameClient).getData(GameClient.GAME_RESULTS);
			DartsGlobals.instance.localPlayer.record.gameTime = obj.gameTime;
			DartsGlobals.instance.localPlayer.record.doubles = obj["doubles_" + DartsGlobals.instance.localPlayer.playerNum];
			DartsGlobals.instance.localPlayer.record.triples = obj["triples_" + DartsGlobals.instance.localPlayer.playerNum];
			DartsGlobals.instance.localPlayer.record.throws = obj["throws_" + DartsGlobals.instance.localPlayer.playerNum];
			_winner = obj.winner;
		}//end onGameEnd()
		
		override public function playerThrow(a_x:Number, a_y:Number, a_z:Number, a_thrust:Number, a_lean:Number, a_stepScale:Number):Object
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
				
				thrust = a_thrust;
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
			
			(DartsGlobals.instance.multiplayerClient as ITurnBased).sendTurnUpdate(
				{
					action: "p_t",
					x: a_x,
					y: a_y,
					z: a_z,
					thr: thrust,
					a: angle,
					g: AppSettings.instance.defaultGravity,
					lean: lean,
					zf: AppSettings.instance.dartboardPositionZ,
					step: a_stepScale
				} 
			);
			
			_currentDart.initThrowParams(a_x, a_y, a_z, thrust, angle, AppSettings.instance.defaultGravity, lean, AppSettings.instance.dartboardPositionZ, a_stepScale);
			
			return { t: thrust, ang: angle };
		}//end playerThrow()
		
		private function handleStateChange(e:Event):void
		{
			trace("State: " + e.type);
			
			var obj:Object;
			
			switch(e.type)
			{
				case TurnBasedGameClient.ROUND_START:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.ROUND_START);
					_bullOff = obj.bulloff;
					break;
				case TurnBasedGameClient.ROUND_END:
					break;
				case TurnBasedGameClient.ROUND_RESULTS:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.ROUND_RESULTS);
					if (_bullOff)
					{
						_winner = obj.winner;
					}
					break;
				case TurnBasedGameClient.TURN_START:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.TURN_START);
					trace("Current Player: " + obj.pid);
					_currentPlayer = obj.pid;
					DartsGlobals.instance.showModalPopup(TurnAnnounceModal);
					break;
				case TurnBasedGameClient.TURN_WAIT:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.TURN_WAIT);
					trace("Current Player: " + obj.pid);
					_currentPlayer = obj.pid;
					DartsGlobals.instance.showModalPopup(TurnAnnounceModal);
					break;
				case TurnBasedGameClient.TURN_UPDATE:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.TURN_UPDATE);
					
					if ( obj.action == "p_t" && _currentPlayer != DartsGlobals.instance.localPlayer.playerNum)
					{
						if( _currentDart ) _currentDart.initThrowParams(obj.x, obj.y, obj.z, obj.thr, obj.a, obj.g, obj.lean, obj.zf, obj.step);						
					} 
					else if ( obj.action == "p_r" ) 
					{
						_serverResults = obj;
						_dispatcher.dispatchEvent( new Event(RESULTS_READY) );
					}
					break;
				case TurnBasedGameClient.TURN_END:
					break;
				case TurnBasedGameClient.TURN_RESULTS:
					break;
				default:
					break;
			}
		}//end handleStateChange()
		
		override public function endGame():void
		{
			_dartboard.resetBlockedSections();
			
			if( _inputController && _throwController )
				_inputController.removeEventListener(InputStateEvent.UPDATE, _throwController.onInputUpdate);
				
			Mouse.show();				
		}//end endGame()
		
		override public function endTurn():void
		{
			(DartsGlobals.instance.multiplayerClient as ITurnBased).sendTurnEnd();
			
			super.endTurn();
		}//end endTurn()
		
		override public function get gameType():String
		{
			return "CRICKET";
		}//end get gameType()
		
		override protected function checkForWin():Boolean
		{
			var score:int = this.scoreManager.getPlayerScore(_currentPlayer);
					
			trace("Score: " + score);
			
			var win:Boolean = true;
						
			if ( score < 501 ) 
			{
				win = false;
			}
			
			return win;
					
		}//end checkForWin()
		
		override public function update(a_time:Number = 0):void
		{	
			if (_paused) return;
			
			_dartboard.update(a_time);
			_cursor.update(a_time);
			
			for each ( var dart:Dart in _darts )
			{
				dart.update(a_time);
			}

			if ( _currentDart && ( _currentDart.position.z >= AppSettings.instance.dartboardPositionZ || _currentDart.position.y <= -10 ) )
			{	
				_currentDart.position.z = AppSettings.instance.dartboardPositionZ;
				
				_currentDart.finishThrow();
				
				if (_serverResults) 
				{
					finishThrowResults();					
				}
				else
				{
					_dispatcher.addEventListener(RESULTS_READY, finishThrowResults);
				}				
			}
		}//end update();
		
		private function finishThrowResults(e:Event = null):void
		{
			_dispatcher.removeEventListener(RESULTS_READY, finishThrowResults);
			
			if ( _bullOff ) 
			{
				if ( _winner > 0 )
				{										
					resetDarts();
					_currentPlayer = _winner;
					_winner = -1;
											
					_bullOff = false;
					_currentDart = null;
				}
				
				_serverResults = null;
				
				_currentTurn.advanceThrows();
				
				if (_currentTurn.throwsRemaining == 0) 
				{
					_currentDart = null;
					//pause(true);
											
					_soundController.play("turn_switch_" + Math.ceil(Math.random() * 4).toString());
					
					resetDarts();
					endTurn();
				}
				else
				{
					nextDart();
				}
			}
			else
			{
				for ( var key:String in _serverResults )
				{
					trace("_serverResults[" + key + "]: " + _serverResults[key]);
				}
				
				if ( !_dartboard.submitDartPositionUnscored(_currentDart.position.x, _currentDart.position.y, _currentDart.blockBoard, _serverResults) ) 
				{
					_currentDart.beginFalling();
				}
				
				_scoreManager.setScores(JSON.decode(_serverResults.scores));
				
				_serverResults = null;
				
				_currentTurn.advanceThrows();
				
				if ( _winner > 0 )
				{
					endGame();
					pause(true);
					DartsGlobals.instance.showModalPopup(GameResultsModal);
					return;
				}
					
				if (_currentTurn.throwsRemaining == 0) 
				{
					_abilityManager.processTurn();
					_currentDart = null;
					//pause(true);
										
					_soundController.play("turn_switch_" + Math.ceil(Math.random() * 4).toString());
					
					resetDarts();
					endTurn();
				}
				else
				{
					nextDart();
				}
			}
		}
		
	}//end RemoteFiveOhOneGameLogic

}//end com.bored.games.darts.logic