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
		
		public static const PLAYER_ONE:int = 1;
		public static const PLAYER_TWO:int = 2;	
		
		public function CricketGameLogic() 
		{
			_scoreManager = new CricketScoreManager();
		}//end constructor()
		
		override public function get gameType():String
		{
			return "CRICKET";
		}//end get gameType()
		
	}//end CricketGameLogic

}//end com.bored.games.darts.logic