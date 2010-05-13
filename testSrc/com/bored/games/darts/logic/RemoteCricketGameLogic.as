package com.bored.games.darts.logic 
{
	import com.bored.games.darts.logic.DartsGameLogic
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class RemoteCricketGameLogic extends DartsGameLogic
	{
		public static const PLAYER_ONE:int = 1;
		public static const PLAYER_TWO:int = 2;	
		
		public function RemoteCricketGameLogic() 
		{
			_scoreManager = new CricketScoreManager();
		}//end constructor()
		
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