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
		
		override public function addPlayer(a_name:String):void
		{
			_scoreboard[a_name] = new Object();
			_scoreboard[a_name][Board.FIFTEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_name][Board.SIXTEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_name][Board.SEVENTEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_name][Board.EIGHTEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_name][Board.NINETEEN] = CricketScoreManager.EMPTY;
			_scoreboard[a_name][Board.TWENTY] = CricketScoreManager.EMPTY;
			_scoreboard[a_name][Board.BULL] = CricketScoreManager.EMPTY;
			
		}//end addPlayer()
		
		override public function submitThrowHit(a_name:String, a_section:uint, a_multiplier:uint = 1):void
		{
			trace("Throw: " + a_name + ", " + a_section + ", " + a_multiplier);
			
			if (a_section < Board.FIFTEEN) return;
			
			var score:uint = _scoreboard[a_name][a_section];
			
			if ( score < CLOSED_OUT ) 
			{
				score += a_multiplier;
				if (score > CLOSED_OUT) score = CLOSED_OUT;
				
				_scoreboard[a_name][a_section] = score;
			}
		}//end submitThrowHit()
		
		override public function submitThrowMiss(a_name:String):void
		{
			// TODO: probably nothing??
		}//end submitThrowMiss();
		
		override public function getScores(a_name:String):Object
		{
			return _scoreboard[a_name];
		}//end getScores();
		
	}//end CricketScoreManager()

}//end com.bored.games.darts.logic