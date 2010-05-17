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
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_UPDATE, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_END, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_RESULTS, handleStateChange);
		}//end constructor()
		
		private function onGameEnd(e:Event):void
		{
			// TODO: handle game ending...
		}//end onGameEnd()

		override public function startNewTurn():void
		{
			_currentTurn = new DartsTurn(this, _throwsPerTurn);
			
			_lastDart = null;
		}//end startNewRound()
		
		override public function playerThrow(a_x:Number, a_y:Number, a_z:Number, a_thrust:Number, a_lean:Number, a_stepScale:Number):void
		{			
			super.playerThrow(a_x, a_y, a_z, a_thrust, a_lean, a_stepScale);
			
			DartsGlobals.instance.multiplayerClient.sendGameState(
				{
					action: "playerThrow",
					x: a_x,
					y: a_y,
					z: a_z,
					thrust: a_thrust,
					lean: a_lean,
					stepScale: a_stepScale
				} 
			);
		}//end playerThrow()
		
		private function handleStateChange(e:Event):void
		{
			trace("State: " + e.type);
			
			switch(e.type)
			{
				case TurnBasedGameClient.ROUND_START:
					startNewTurn();
					break;
				case TurnBasedGameClient.ROUND_END:
					break;
				case TurnBasedGameClient.ROUND_RESULTS:
					break;
					
				case TurnBasedGameClient.TURN_START:
					nextDart();
					break;
				case TurnBasedGameClient.TURN_WAIT:
					break;
				case TurnBasedGameClient.TURN_UPDATE:
					break;
				case TurnBasedGameClient.TURN_END:
					break;
				case TurnBasedGameClient.TURN_RESULTS:
					break;
					
				default:
					break;
			}
		}//end handleStateChange()
		
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
		
	}//end RemoteCricketGameLogic

}//end com.bored.games.darts.logic