package com.bored.games.darts.logic 
{
	import com.bored.games.darts.logic.AbstractScoreManager;
	import com.bored.games.darts.objects.Board;
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
		
		override public function registerPlayer(a_playerNum:int):void
		{
			_scoreboard[a_playerNum] = new Object();
			_scoreboard[a_playerNum][Board.FIFTEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][Board.SIXTEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][Board.SEVENTEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][Board.EIGHTEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][Board.NINETEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][Board.TWENTY] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][Board.BULL] = CricketScoreManager.EMPTY;
			
		}//end registerPlayer()
		
		override public function submitThrow(a_playerNum:int, a_section:uint, a_multiplier:uint = 1):void
		{
			trace("Throw: " + a_playerNum + ", " + a_section + ", " + a_multiplier);
			
			if (a_section < Board.FIFTEEN) return;
			
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
			for ( var key:Number in _scoreboard[a_playerNum] ) {
				score += key * _scoreboard[a_playerNum][key];				
			}
			
			return score;
		}//end getPlayerScore()
		
	}//end CricketScoreManager()

}//end com.bored.games.darts.logic