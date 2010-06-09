package com.bored.games.darts.statistics 
{
	/**
	 * ...
	 * @author sam
	 */
	public class TurnRecord
	{
		private var _throws:int;
		
		private var _singles:int;
		private var _doubles:int;
		private var _triples:int;
		
		// Three-in-a-bed tracking
		private var _threeInABed:Boolean;
		private var _section:int;
		
		public function TurnRecord() 
		{
			_throws = 0;
			
			_threeInABed = true;
			_section = -1;
			
			_singles = 0;
			_doubles = 0;
			_triples = 0;
		}//end constructor()
		
		public function recordThrow(a_points:int, a_multiplier:int):void
		{		
			_throws++;
			
			if ( _threeInABed ) 
			{
				if ( _section < 0 )
					_section = a_points;
				
				_threeInABed = (_section == a_points);
				
				if ( _throws == 3 )
					AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_THREE_IN_A_BED);
			}
			
			if (a_multiplier == 1) _singles++;
			else if (a_multiplier == 2) _doubles++;
			else if (a_multiplier == 3) _triples++;
			
			if ( _doubles == 3 ) 
			{
				AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_C_6);
			}
			
			if ( _triples == 3 )			
			{
				AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_C_9);
			}
			
			if ( _singles == 1 && _doubles == 2 && _triples == 3 )
			{
				AchievementTracker.bestowAchievement(AchievementTracker.ACHIEVEMENT_SHANGHAI);
			}
		}//end logThrow()
		
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
		
	}//end TurnRecord

}//end com.bored.games.darts.statistics