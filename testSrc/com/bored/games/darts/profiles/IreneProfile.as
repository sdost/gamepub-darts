package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.assets.icons.Irene_Portrait_BMP;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.models.dae_DartFlightThin;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.assets.icons.TheProfessor_Portrait_BMP;
	import com.bored.games.darts.logic.AIShotCandidate;
	import flash.display.Sprite;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	
	/**
	 * ...
	 * @author sam
	 */
	public class IreneProfile extends EnemyProfile
	{
		
		public function IreneProfile() 
		{
			super("Irene");
			
			this.age = 26;
			this.height = 80;
			this.weight = 30;
			this.bio = "Femme fatale.";
			
			this.portrait = new Irene_Portrait_BMP(150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_irene", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightThin.data));
			
			this.accuracy = AppSettings.instance.ireneAccuracy;
			this.stepScale = AppSettings.instance.ireneStepScale;
		}//end constructor()
		
		override public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{
			var _gameType:String = a_gameType;
			var myStats:Object = a_myStats;
			var clipList:Vector.<Sprite> = new Vector.<Sprite>();
			
			var sectionCount:int = 0;
			
			if (_gameType == "CRICKET") {				
				var points:int = 15;
				while ( points <= 20 ) {
					if ( a_allStats[DartsGlobals.instance.localPlayer.playerNum][points] < 3 )
					{
						sectionCount++;
					}
					++points;
				}
				if ( a_allStats[DartsGlobals.instance.localPlayer.playerNum][25] < 3 ) {						
					sectionCount++;
				}
				
				var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
				var modifier:String = "";
				
				if (sectionCount <= 3) 
				{
					var die:Number = Math.random();
					
					if ( die < .35 ) 
					{
						modifier = BeeLineAbility.NAME;
					}
				}
				
				points = 15;
				while ( points <= 20 ) {
					if ( myStats[points] == 0 )
					{
						addShot( myShotList, points, 3, false, modifier );
					}
					else if ( myStats[points] == 1 )
					{
						addShot( myShotList, points, 2, false, modifier );
					}
					else if ( myStats[points] == 2 )
					{
						addShot( myShotList, points, 1, false, modifier );
					}
					++points;
				}
				if ( myStats[25] < 3 ) {						
					addShot( myShotList, 25, 2, false, modifier );
				}
			}
			
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			if ( a_allStats[DartsGlobals.instance.localPlayer.playerNum][lastPlayerScore.points] < 3 && DartsGlobals.instance.cpuPlayer.hasAbility(ShieldAbility.NAME) )
			{
				addShot(myShotList, lastPlayerScore.points, lastPlayerScore.multiplier, false, ShieldAbility.NAME);
			}
			
			return myShotList;
		}//end generateShotList()
				
		override public function handleShot(a_points:int, a_multiplier:int):void
		{
			var stats:Object = DartsGlobals.instance.gameManager.scoreManager.getPlayerStats(DartsGlobals.instance.localPlayer.playerNum);
			
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
			
			if ( _shotIntention.points != a_points && sectionCount > 3 && DartsGlobals.instance.cpuPlayer.hasAbility(DoOverAbility.NAME) ) {
				for each( var ability:Ability in abilities )
				{
					if ( ability.name == DoOverAbility.NAME ) {
						DartsGlobals.instance.gameManager.abilityManager.activateAbility(ability);
					}
				}
			}
		}//end handleShot()
		
	}//end IreneProfile

}//end com.bored.games.darts.profiles