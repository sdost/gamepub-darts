package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.models.dae_DartFlightHexagon;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SammyProfile extends EnemyProfile
	{
		
		public function SammyProfile() 
		{
			super("Sammy");
			
			this.age = 32;
			this.height = 105;
			this.weight = 90;
			this.bio = "A local footie fan. Great at drinking. Terrible at darts.";
			
			this.portrait = ImageFactory.getBitmapDataByQualifiedName("com.bored.games.darts.assets.icons.Sammy_Portrait_BMP", 150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_sammy", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightHexagon.data));
			
			this.accuracy = AppSettings.instance.sammyAccuracy;
			this.stepScale = AppSettings.instance.sammyStepScale;
			
			this.prize = 50;
		}//end constructor()
		
				
		override public function handleShot(a_points:int, a_multiplier:int):void
		{
			var stats:Object = DartsGlobals.instance.gameManager.scoreManager.getPlayerStats(DartsGlobals.instance.opponentPlayer.playerNum);
			
			var sectionCount:int = 0;
			
			var points:int = 15;
			while ( points <= 20 ) {
				if ( stats[points] < 3 )
				{
					sectionCount++;
				}
				++points;
			}
			if ( stats[25] < 3 ) {						
				sectionCount++;
			}
			
			if ( _shotIntention.points != a_points /*&& sectionCount < 4*/ && DartsGlobals.instance.opponentPlayer.hasAbility(DoOverAbility.NAME) ) 
			{
				DartsGlobals.instance.gameManager.addEventListener(DartsGameLogic.THROW_END, useDoOver, false, 0, true);
			}
		}//end handleShot()
		
	}//end SammyProfile
		

}//end com.bored.games.darts.profiles