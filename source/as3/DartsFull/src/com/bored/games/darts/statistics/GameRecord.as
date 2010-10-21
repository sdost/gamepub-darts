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
		private var _singles:int;
		private var _doubles:int;
		private var _triples:int;
		
		private var _lastScore:Object;
		
		private var _achievementsEarned:Vector.<Object>;
		
		private var _gameTime:int;
		
		private var _win:Boolean;
		
		private var _submitAchievements:Boolean;
		
		public function GameRecord(a_submitAchievements:Boolean) 
		{
			_submitAchievements = a_submitAchievements;
			_gameTime = 0;
			_throws = 0;
			_scoringThrows = 0;
			_singles = 0;
			_doubles = 0;
			_triples = 0;
			_lastScore = { };
			_achievementsEarned = new Vector.<Object>();
			_win = false;
		}//end constructor()
		
		public function recordThrow(a_points:int, a_multiplier:int, a_scoringThrow:Boolean):void
		{
			if (a_scoringThrow) 
			{
				_scoringThrows++;
				
				if ( _submitAchievements && _scoringThrows == 9 )
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
			
			if (a_multiplier == 1) _singles++;
			else if (a_multiplier == 2) _doubles++;
			else if (a_multiplier == 3) _triples++;
			
			if ( _submitAchievements && _doubles == 3 ) 
			{
				AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_THREE_DOUBLE);
			}
			
			if ( _submitAchievements && _triples == 3 )			
			{
				AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_THREE_TRIPLES);
			}
			
			if ( _submitAchievements && _singles == 1 && _doubles == 2 && _triples == 3 )
			{
				AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_SHANGHAI);
			}
		}//end logThrow()
		
		public function recordAchievement( a_achievementObj:Object ):void
		{
			_achievementsEarned.push(a_achievementObj);
		}//end recordAchievement()
		
		public function recordEndOfGame( a_win:Boolean ):void
		{
			_win = a_win;
		}//end recordEndOfGame()
		
		public function get gameTime():int
		{
			return _gameTime;
		}//end get gameTime()
		
		public function set gameTime(a_time:int):void
		{
			_gameTime = a_time;
		}//end get gameTime()
		
		public function get throws():int
		{
			return _throws;
		}//end get throws()
		
		public function set throws(a_throws:int):void
		{
			_throws = a_throws;
		}//end set doubles()
		
		public function get scoringThrows():int
		{
			return _scoringThrows;
		}//end get scoringThrows()
		
		public function set scoringThrows(a_scoringThrows:int):void
		{
			_scoringThrows = a_scoringThrows;
		}//end get scoringThrows()
		
		public function get doubles():int
		{
			return _doubles;
		}//end get doubles()
		
		public function set doubles(a_doubles:int):void
		{
			_doubles = a_doubles;
		}//end set doubles()
		
		public function get triples():int
		{
			return _triples;
		}//end get triples()
		
		public function set triples(a_triples:int):void
		{
			_triples = a_triples;
		}//end set doubles()
		
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