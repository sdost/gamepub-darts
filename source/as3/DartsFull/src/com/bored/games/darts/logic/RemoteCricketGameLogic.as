package com.bored.games.darts.logic 
{
	import com.adobe.serialization.json.JSON;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.darts.ui.modals.BullOffAnnounceModal;
	import com.bored.games.darts.ui.modals.BullOffClickContinueModal;
	import com.bored.games.darts.ui.modals.BullOffWinnerModal;
	import com.bored.games.darts.ui.modals.GameResultsModal;
	import com.bored.games.darts.ui.modals.MultiplayerGameResultsModal;
	import com.bored.games.darts.ui.modals.TurnAnnounceModal;
	import com.bored.games.darts.events.InputStateEvent;
	import com.bored.services.client.GameClient;
	import com.bored.services.client.TurnBasedGameClient;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class RemoteCricketGameLogic extends DartsGameLogic
	{
		public static const RESULTS_READY:String = "resultsReady";
		public static const RETURN_TO_LOBBY:String = "returnToLobby";
		
		private var _serverResults:Object = null;
		private var _winner:int = -1;
		
		public function RemoteCricketGameLogic()
		{
			_scoreManager = new CricketScoreManager();

			trace("Multiplayer Client: " + DartsGlobals.instance.multiplayerClient);
			
			//DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_START, onGameStart);
			
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_RESULTS, onGameEnd);
			
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_TIMER, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_TIMER_END, handleStateChange);
			
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
			var obj:Object = DartsGlobals.instance.multiplayerClient.getData(GameClient.GAME_RESULTS);
			DartsGlobals.instance.localPlayer.record.gameTime = obj.gameTime;
			DartsGlobals.instance.localPlayer.record.doubles = obj["playerStats" + DartsGlobals.instance.localPlayer.playerNum]["doubles"];
			DartsGlobals.instance.localPlayer.record.triples = obj["playerStats" + DartsGlobals.instance.localPlayer.playerNum]["triples"];
			DartsGlobals.instance.localPlayer.record.throws = obj["playerStats" + DartsGlobals.instance.localPlayer.playerNum]["throws"];
			DartsGlobals.instance.localPlayer.record.scoringThrows = obj["playerStats" + DartsGlobals.instance.localPlayer.playerNum]["scoringThrows"];
			DartsGlobals.instance.localPlayer.record.recordEndOfGame(obj["playerStats" + DartsGlobals.instance.localPlayer.playerNum]["win"]);
			
			DartsGlobals.instance.opponentPlayer.record.gameTime = obj.gameTime;
			DartsGlobals.instance.opponentPlayer.record.doubles = obj["playerStats" + DartsGlobals.instance.opponentPlayer.playerNum]["doubles"];
			DartsGlobals.instance.opponentPlayer.record.triples = obj["playerStats" + DartsGlobals.instance.opponentPlayer.playerNum]["triples"];
			DartsGlobals.instance.opponentPlayer.record.throws = obj["playerStats" + DartsGlobals.instance.opponentPlayer.playerNum]["throws"];
			DartsGlobals.instance.opponentPlayer.record.scoringThrows = obj["playerStats" + DartsGlobals.instance.opponentPlayer.playerNum]["scoringThrows"];
			DartsGlobals.instance.opponentPlayer.record.recordEndOfGame(obj["playerStats" + DartsGlobals.instance.opponentPlayer.playerNum]["win"]);
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
			
			DartsGlobals.instance.multiplayerClient.sendTurnUpdate(
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
					obj = DartsGlobals.instance.multiplayerClient.getData(TurnBasedGameClient.ROUND_START);
					if (_bullOff)
					{
						this.bullOffWinner = obj.first;
					}
					break;
				case TurnBasedGameClient.ROUND_END:
				case TurnBasedGameClient.TURN_END:
					DartsPlayer(_players[_currentPlayer]).turnTime = -1;
					break;
				case TurnBasedGameClient.ROUND_RESULTS:
					obj = DartsGlobals.instance.multiplayerClient.getData(TurnBasedGameClient.ROUND_RESULTS);
					/*
					if (_bullOff)
					{
						_winner = obj.winner;
					}
					*/
					break;
				case TurnBasedGameClient.TURN_START:
					obj = DartsGlobals.instance.multiplayerClient.getData(TurnBasedGameClient.TURN_START);
					trace("Current Player: " + obj.pid);
					cursor.show();
					_currentPlayer = obj.pid;
					if (_bullOff)
					{
						DartsGlobals.instance.showModalPopup(BullOffWinnerModal);
						_bullOff = false;
					}
					else
					{
						DartsGlobals.instance.showModalPopup(TurnAnnounceModal);
					}
					break;
				case TurnBasedGameClient.TURN_WAIT:
					obj = DartsGlobals.instance.multiplayerClient.getData(TurnBasedGameClient.TURN_WAIT);
					trace("Current Player: " + obj.pid);
					cursor.hide();
					_currentPlayer = obj.pid;
					if (_bullOff)
					{
						DartsGlobals.instance.showModalPopup(BullOffWinnerModal);
						_bullOff = false;
					}
					else
					{
						DartsGlobals.instance.showModalPopup(TurnAnnounceModal);
					}
					break;
				case TurnBasedGameClient.TURN_UPDATE:
					obj = DartsGlobals.instance.multiplayerClient.getData(TurnBasedGameClient.TURN_UPDATE);
					
					if (obj.action == "p_t" && _currentPlayer != DartsGlobals.instance.localPlayer.playerNum)
					{
						if( _currentDart ) _currentDart.initThrowParams(obj.x, obj.y, obj.z, obj.thr, obj.a, obj.g, obj.lean, obj.zf, obj.step);						
					} 
					else if (obj.action == "p_r") 
					{
						_serverResults = obj;
						this.dispatchEvent( new Event(RESULTS_READY) );
					}
					break;
				case TurnBasedGameClient.TURN_RESULTS:
					break;
				case GameClient.GAME_TIMER:
					obj = DartsGlobals.instance.multiplayerClient.getData(GameClient.GAME_TIMER);
					DartsPlayer(_players[_currentPlayer]).turnTime = obj.cnt;
					break;
				case GameClient.GAME_TIMER_END:
					DartsPlayer(_players[_currentPlayer]).turnTime = -1;
					_cursor.hide();
					_currentDart = null;
					_throwController.resetThrowParams();
					_inputController.pause = true;
					if( _currentPlayer == DartsGlobals.instance.localPlayer.playerNum ) endCurrentTurn();
					break;
				default:
					break;
			}
		}//end handleStateChange()
		
		override public function newGame():void 
		{
			super.newGame();
			
			DartsGlobals.instance.showModalPopup(BullOffAnnounceModal);
		}//end newGame()
		
		override public function endGame(a_winner:int):void
		{
			DartsGlobals.instance.multiplayerClient.removeEventListener(GameClient.GAME_RESULTS, onGameEnd);
			
			DartsGlobals.instance.multiplayerClient.removeEventListener(GameClient.GAME_TIMER, handleStateChange);
			DartsGlobals.instance.multiplayerClient.removeEventListener(GameClient.GAME_TIMER_END, handleStateChange);
			
			DartsGlobals.instance.multiplayerClient.removeEventListener(TurnBasedGameClient.ROUND_START, handleStateChange);
			DartsGlobals.instance.multiplayerClient.removeEventListener(TurnBasedGameClient.ROUND_END, handleStateChange);
			DartsGlobals.instance.multiplayerClient.removeEventListener(TurnBasedGameClient.ROUND_RESULTS, handleStateChange);
			
			DartsGlobals.instance.multiplayerClient.removeEventListener(TurnBasedGameClient.TURN_START, handleStateChange);
			DartsGlobals.instance.multiplayerClient.removeEventListener(TurnBasedGameClient.TURN_WAIT, handleStateChange);
			DartsGlobals.instance.multiplayerClient.removeEventListener(TurnBasedGameClient.TURN_UPDATE, handleStateChange);
			DartsGlobals.instance.multiplayerClient.removeEventListener(TurnBasedGameClient.TURN_END, handleStateChange);
			DartsGlobals.instance.multiplayerClient.removeEventListener(TurnBasedGameClient.TURN_RESULTS, handleStateChange);
			
			_dartboard.resetBlockedSections();
			
			if( _inputController && _throwController )
				_inputController.removeEventListener(InputStateEvent.UPDATE, _throwController.onInputUpdate);
				
			Mouse.show();				
		}//end endGame()
		
		override public function nextPlayer():void
		{
			
		}//end nextPlayer()
		
		override protected function endCurrentTurn(e:Event = null):void
		{			
			super.endCurrentTurn(e);
			
			DartsGlobals.instance.multiplayerClient.sendTurnEnd();
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
		
		override protected function handleGameLogic():void
		{
			if ( _currentDart && ( _currentDart.z >= AppSettings.instance.dartboardPositionZ || _currentDart.y <= -10 ) )
			{	
				_currentDart.z = AppSettings.instance.dartboardPositionZ;
				
				_currentDart.finishThrow();
				
				if (_serverResults || _bullOff) 
				{
					finishThrowResults();					
				}
				else
				{
					this.addEventListener(RESULTS_READY, finishThrowResults);
				}				
			}
		}//end handleGameLogic()
		
		private function finishThrowResults(e:Event = null):void
		{
			this.removeEventListener(RESULTS_READY, finishThrowResults);
			
			if ( _bullOff ) 
			{
				_currentTurn.advanceThrows();
				
				if (_currentTurn.throwsRemaining == 0) 
				{
					_currentDart = null;
											
					endTurn();
				}
			}
			else
			{
				for ( var key:String in _serverResults )
				{
					trace("_serverResults[" + key + "]: " + _serverResults[key]);
				}
				
				if ( !_dartboard.submitDartPositionUnscored(_currentDart.x, _currentDart.y, _currentDart.blockBoard, _serverResults) ) 
				{
					_currentDart.beginFalling();
				}
				
				_scoreManager.setScores(JSON.decode(_serverResults.scores));
				
				_serverResults = null;
				
				_currentTurn.advanceThrows();
				
				if ( _winner > 0 )
				{
					endTurn();
					pause(true);
					DartsGlobals.instance.showModalPopup(MultiplayerGameResultsModal);
					return;
				}
					
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
		
	}//end RemoteCricketGameLogic

}//end com.bored.games.darts.logic