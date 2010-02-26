package com.bored.games.darts.logic 
{
	import com.bored.games.darts.logic.AbstractGameLogic;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CricketGameMode extends AbstractGameLogic
	{					
		public function CricketGameMode() 
		{
			_scoreManager = new CricketScoreManager();
			_scoreManager.addPlayer(PLAYER_TURN);
			_scoreManager.addPlayer(OPPONENT_TURN);
		}//end constructor()
		
		override public function checkForWinState():Boolean
		{
			var scoreBoard:Dictionary = scoreManager.getScores(_currentTurn.owner);
			
			var win:Boolean = true;
			for each( score in scoreBoard ) 
			{
				if ( score < CricketScoreManager.CLOSED_OUT ) {
					win = false;
					break;
				}
			}
			
			return win;
		}//end checkForWinState()
		
	}//end CricketType

}//end com.bored.games.darts.logic