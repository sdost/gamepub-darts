package com.bored.games.darts.logic 
{
	import com.bored.games.darts.logic.DartsGameLogic
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CricketGameLogic extends DartsGameLogic
	{	
		
		public static const HUMAN_PLAYER:int = 1;
		public static const CPU_PLAYER:int = 2;	
		
		public function CricketGameLogic() 
		{
			_scoreManager = new CricketScoreManager();
		}//end constructor()
		
		override public function get gameType():String
		{
			return "CRICKET";
		}//end get gameType()
		
		override public function nextPlayer():void
		{
			_currentPlayer++;
			
			if (_currentPlayer > _players.length) _currentPlayer = 1;
		}//end nextPlayer()
		
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
		
	}//end CricketGameLogic

}//end com.bored.games.darts.logic