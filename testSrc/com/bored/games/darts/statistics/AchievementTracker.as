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
		public static const ACHIEVEMENT_HAT_TRICK:String = "hat_trick";
		public static const ACHIEVEMENT_SHANGHAI:String = "shanghai";
		public static const ACHIEVEMENT_THREE_IN_A_BED:String = "three_in_a_bed";
		public static const ACHIEVEMENT_ROBIN_HOOD:String = "robin_hood";
		public static const ACHIEVEMENT_C_6:String = "c_6";
		public static const ACHIEVEMENT_C_9:String = "c_9";
		public static const ACHIEVEMENT_NINER:String = "niner";
		public static const ACHIEVEMENT_PERFECT_NINER:String = "perfect_niner";
				
		public static function bestowAchievement(a_id:String):void
		{
			DartsGlobals.instance.externalServices.bestowAchievement(a_id);
			DartsGlobals.instance.externalServices.addEventListener(AbstractExternalService.ACHIEVEMENT_EARNED, onAchievementEarned, false, 0, true);
		}//end bestowAchievement()
		
		private static function onAchievementEarned(a_evt:ObjectEvent):void
		{
			DartsGlobals.instance.externalServices.removeEventListener(AbstractExternalService.ACHIEVEMENT_EARNED, onAchievementEarned);
			
			for ( var obj:Object in a_evt.obj ) 
			{
				if ( obj.earned ) 
				{
					//DartsGlobals.instance.localPlayer.record.recordAchievement( obj );
				}
			}
		}//end onAchievementEarned()
		
	}//end AchievementTracker

}//end com.bored.games.darts.statistics

internal class AchievementTracker_SingletonEnforcer{}