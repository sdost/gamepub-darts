package com.bored.games.darts.statistics 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.services.AbstractExternalService;
	import com.bored.services.events.ObjectEvent;
	/**
	 * ...
	 * @author sam
	 */
	public class AchievementTracker
	{
		public static const ACHIEVEMENT_THREE_DOUBLE:String = "three_doubles";
		public static const ACHIEVEMENT_THREE_TRIPLES:String = "three_triples";
		public static const ACHIEVEMENT_HAT_TRICK:String = "monsterproof_darts0_hattrick ";
		public static const ACHIEVEMENT_SHANGHAI:String = "monsterproof_darts0_shanghai ";
		public static const ACHIEVEMENT_THREE_IN_A_BED:String = "monsterproof_darts0_threeinabed ";
		public static const ACHIEVEMENT_ROBIN_HOOD:String = "monsterproof_darts0_robinhood ";
		public static const ACHIEVEMENT_C_6:String = "monsterproof_darts0_c6";
		public static const ACHIEVEMENT_C_9:String = "monsterproof_darts0_c9 ";
		public static const ACHIEVEMENT_NINER:String = "monsterproof_darts0_niner ";
		public static const ACHIEVEMENT_PERFECT_NINER:String = "monsterproof_darts0_perfectniner";
				
		public static function bestowAchievement(a_id:String):void
		{
			DartsGlobals.addWarning("AchievementTracker::bestowAchievement(" + a_id + ")");
			
			if ( DartsGlobals.instance.externalServices.loggedIn )
			{
				DartsGlobals.instance.externalServices.bestowAchievement(a_id);
			}
		}//end bestowAchievement()
		
	}//end AchievementTracker

}//end com.bored.games.darts.statistics

internal class AchievementTracker_SingletonEnforcer{}