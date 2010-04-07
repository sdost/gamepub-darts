package com.bored.games.darts.profiles 
{
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
			
			this.accuracy = 0.7;
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
					if ( myStats[points] == 0 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 3, false));
					}
					else if ( myStats[points] == 1 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 2, false));
					}
					else if ( myStats[points] == 2 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1, false));
					}
					++points;
				}
				if ( myStats[25] < 3 ) {						
					clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 2, false));
				}
			}
			
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
			var clip:Sprite;
			
			
			if (sectionCount <= 3) 
			{
				var die:Number = Math.random();
				
				for each( clip in clipList ) {
					if ( die < .35 && DartsGlobals.instance.cpuPlayer.hasAbility("beeline") ) 
					{
						addShot(myShotList, clip, "beeline");
					}
					else
					{
						addShot(myShotList, clip, "");
					}	
				}
			}
			else 
			{
				for each( clip in clipList ) {
					addShot(myShotList, clip, "");
				}
			}
			
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			if ( a_allStats[DartsGlobals.instance.localPlayer.playerNum][lastPlayerScore.points] < 3 && DartsGlobals.instance.cpuPlayer.hasAbility("shield") )
			{
				addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(lastPlayerScore.points, lastPlayerScore.multiplier, false), "shield");
			}
			
			return myShotList;
		}//end generateShotList()
		
	}//end IreneProfile

}//end com.bored.games.darts.profiles