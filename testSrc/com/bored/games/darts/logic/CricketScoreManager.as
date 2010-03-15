package com.bored.games.darts.logic 
{
	import com.bored.games.darts.logic.AbstractScoreManager;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CricketScoreManager extends AbstractScoreManager
	{		
		public static const EMPTY:uint 			= 0
		public static const STROKE_LEFT:uint 	= 1;
		public static const STROKE_RIGHT:uint 	= 2;
		public static const CLOSED_OUT:uint 	= 3;
		
		private var _scoreboard:Object;		
		
		public function CricketScoreManager() 
		{
			_scoreboard = new Object();
		}//end constructor()
		
		override public function initPlayerStats(a_playerNum:int):void
		{
			_scoreboard[a_playerNum] = new Object();
			_scoreboard[a_playerNum][15] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][16] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][17] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][18] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][19] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][20] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][25] = CricketScoreManager.EMPTY;
			
		}//end initPlayerStats()
		
		override public function submitThrow(a_playerNum:int, a_section:uint, a_multiplier:uint = 1):void
		{
			if (a_section < 15) return;
			
			var score:uint = _scoreboard[a_playerNum][a_section];
			
			if ( score < CLOSED_OUT ) 
			{
				score += a_multiplier;
				if (score > CLOSED_OUT) score = CLOSED_OUT;
				
				_scoreboard[a_playerNum][a_section] = score;
			}
		}//end submitThrow()
		
		override public function getPlayerStats(a_playerNum:int):Object
		{
			return _scoreboard[a_playerNum];
		}//end getPlayerStats();
		
		override public function getPlayerScore(a_playerNum:int):Number
		{
			var score:Number = 0;
			for ( var key:String in _scoreboard[a_playerNum] ) {
				score += Number(key) * _scoreboard[a_playerNum][key];				
			}
			
			return score;
		}//end getPlayerScore()
		
	}//end CricketScoreManager()

}//end com.bored.games.darts.logic