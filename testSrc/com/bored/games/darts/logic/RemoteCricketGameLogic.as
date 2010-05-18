package com.bored.games.darts.logic 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.gs.game.GameClient;
	import com.bored.gs.game.ITurnBased;
	import com.bored.gs.game.TurnBasedGameClient;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class RemoteCricketGameLogic extends DartsGameLogic
	{
		public function RemoteCricketGameLogic()
		{
			_scoreManager = new CricketScoreManager();
			
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_END, onGameEnd);
			
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
			// TODO: handle game ending...
		}//end onGameEnd()
		
		override public function playerThrow(a_x:Number, a_y:Number, a_z:Number, a_thrust:Number, a_lean:Number, a_stepScale:Number):void
		{			
			super.playerThrow(a_x, a_y, a_z, a_thrust, a_lean, a_stepScale);
			
			(DartsGlobals.instance.multiplayerClient as ITurnBased).sendTurnUpdate(
				{
					action: "p_t",
					x: a_x,
					y: a_y,
					z: a_z,
					thr: a_thrust,
					lean: a_lean,
					step: a_stepScale
				} 
			);
		}//end playerThrow()
		
		private function handleStateChange(e:Event):void
		{
			trace("State: " + e.type);
			
			var obj:Object;
			
			switch(e.type)
			{
				case TurnBasedGameClient.ROUND_START:
					break;
				case TurnBasedGameClient.ROUND_END:
					break;
				case TurnBasedGameClient.ROUND_RESULTS:
					break;
					
				case TurnBasedGameClient.TURN_START:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.TURN_START);
					_currentPlayer = obj.pid;
					startNewTurn();
					break;
				case TurnBasedGameClient.TURN_WAIT:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.TURN_WAIT);
					_currentPlayer = obj.pid;
					startNewTurn();
					break;
				case TurnBasedGameClient.TURN_UPDATE:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.TURN_UPDATE);
					if ( obj.action == "p_t" && obj.pid != DartsGlobals.instance.localPlayer.playerNum)
					{
						super.playerThrow(obj.x, obj.y, obj.z, obj.thr, obj.lean, obj.step);						
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
		
		override public function endTurn():void
		{
			(DartsGlobals.instance.multiplayerClient as ITurnBased).sendTurnEnd();
			
			_cursor.hide();
			
			_currentDart = null;
		}//end endTurn()
		
		override public function get gameType():String
		{
			return "CRICKET";
		}//end get gameType()
		
		override protected function checkForWin():Boolean
		{
			var stats:Object = this.scoreManager.getPlayerStats(_currentPlayer);
					
			var win:Boolean = true;
			
			for ( var i:int = 15; i <= 20; i++ ) {
				if ( stats[i] < 3 ) win = false;
			}
			if ( stats[25] < 3 ) win = false;
			
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
				
				if ( !_dartboard.submitDartPosition(_currentDart.position.x, _currentDart.position.y, _currentDart.blockBoard) ) 
				{
					_currentDart.beginFalling();
				}
				
				var win:Boolean = checkForWin();
					
				if (win) 
				{
					_winner = _currentPlayer;
					
					if (_winner == DartsGlobals.instance.localPlayer.playerNum && DartsGlobals.instance.localPlayer.record.throws <= 9) 
					{
						//AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_PERFECT_NINER);
					}
					
					endGame();
					pause(true);
					return;
				}
				
				_currentTurn.advanceThrows();
				
				if (_currentTurn.throwsRemaining == 0) 
				{
					_abilityManager.processTurn();
					_currentDart = null;
					//pause(true);
										
					_soundController.play("turn_switch_" + Math.ceil(Math.random() * 4).toString());
					
					DartsGlobals.instance.gameManager.resetDarts();
					DartsGlobals.instance.gameManager.endTurn();
				}
				else
				{
					nextDart();
				}
			}
		}//end update();
		
	}//end RemoteCricketGameLogic

}//end com.bored.games.darts.logic