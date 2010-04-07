package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.assets.icons.BigBill_Portrait_BMP;
	import com.bored.games.darts.assets.icons.Sammy_Portrait_BMP;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AIShotCandidate;
	import com.bored.games.darts.models.dae_DartFlightPincer;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	import flash.display.Sprite;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BigBillProfile extends EnemyProfile
	{
		
		public function BigBillProfile() 
		{
			super("Big Bill");
			
			this.age = 32;
			this.height = 105;
			this.weight = 90;
			this.bio = "A big guy with a big ego, and a big temper.";
			
			this.portrait = new BigBill_Portrait_BMP(150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_bigbill", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightPincer.data));
			
			this.accuracy = 0.7;
		}//end constructor()
		
		override public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{
			var _gameType:String = a_gameType;
			var myStats:Object = a_myStats;
			var clipList:Vector.<Sprite> = new Vector.<Sprite>();
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			
			var sectionCount:int = 0;
			
			var lastCPUScore:Object = DartsGlobals.instance.cpuPlayer.record.lastScore;
			
			if (_gameType == "CRICKET") {				
				var points:int = 15;
				while ( points <= 20 ) {					
					if ( myStats[points] < 3 )
					{
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 3, true), (lastCPUScore.points == 17) ? "boost" : "");
					}
					++points;
				}
				if ( myStats[25] < 3 ) {	
					addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 2, true), (lastCPUScore.points == 17) ? "boost" : "");
				}
			}
			
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			return myShotList;
		}//end generateShotList()
		
		override public function pickShot(a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			var shot:AIShotCandidate;
			
			for each( shot in a_shots ) 
			{
				if ( shot.modifier == "shield" )
				{
					return shot;
				}
			}
			
			if( a_shots.length > 0 )
				shot = a_shots[Math.floor(Math.random() * a_shots.length)];
			else
				shot = new AIShotCandidate(0, 0);
				
			return shot;
		}//end pickShot()
		
	}//end BigBillProfile
		

}//end com.bored.games.darts.profiles