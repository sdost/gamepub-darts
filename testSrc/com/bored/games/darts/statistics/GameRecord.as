package com.bored.games.darts.statistics 
{
	/**
	 * ...
	 * @author sam
	 */
	public class GameRecord
	{
		private var _throws:int;
		private var _scoringThrows:int;
		private var _doubles:int;
		private var _triples:int;
		
		private var _lastScore:Object;
		
		private var _win:Boolean;
		
		public function GameRecord() 
		{
			_throws = 0;
			_scoringThrows = 0;
			_doubles = 0;
			_triples = 0;
			_lastScore = { };
			_win = false;
		}//end constructor()
		
		public function recordThrow(a_points:int, a_multiplier:int, a_scoringThrow:Boolean):void
		{
			if (a_scoringThrow) 
			{
				_scoringThrows++;
				
				if ( _scoringThrows == 9 )
				{
					AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_NINER);
				}
			}
			else
			{
				_scoringThrows = 0;
			}
						
			_lastScore = { points: a_points, multiplier: a_multiplier };
			
			_throws++;
			
			if (a_multiplier == 2) _doubles++;
			else if (a_multiplier == 3) _triples++;
			
			if ( _doubles == 3 ) 
			{
				AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_THREE_DOUBLE);
			}
			
			if ( _triples == 3 )			
			{
				AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_THREE_TRIPLES);
			}
		}//end logThrow()
		
		public function recordEndOfGame( a_win:Boolean ):void
		{
			_win = a_win;
		}//end recordEndOfGame()
		
		public function get throws():int
		{
			return _throws;
		}//end get throws()
		
		public function get scoringThrows():int
		{
			return _scoringThrows;
		}//end get scoringThrows()
		
		public function get doubles():int
		{
			return _doubles;
		}//end get doubles()
		
		public function get triples():int
		{
			return _triples;
		}//end get triples()
		
		public function get lastScore():Object
		{
			return _lastScore;
		}//end get lastScore()
		
		public function wonGame():Boolean
		{
			return _win;
		}//end wonGame()
		
	}//end GameRecord

}//end com.bored.games.darts.statistics