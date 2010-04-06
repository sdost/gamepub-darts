package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.assets.icons.Anthony_Portrait_BMP;
	import com.bored.games.darts.assets.icons.Simon_Portrait_BMP;
	import com.bored.games.darts.logic.AIShotCandidate;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	import flash.display.Sprite;
	import com.bored.games.darts.DartsGlobals;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AnthonyProfile extends EnemyProfile
	{
		
		public function AnthonyProfile() 
		{
			super("Anthony");
			
			this.age = 20;
			this.height = 155;
			this.weight = 70;
			this.bio = "Crazy sociopath.";
			
			this.portrait = new Anthony_Portrait_BMP(150, 150);
			
			this.setDartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_anthony", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight));
			
			this.accuracy = 0.2;
		}//end constructor()
		
		override public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{
			var _gameType:String = a_gameType;
			var myStats:Object = a_myStats;
			var clipList:Vector.<Sprite> = new Vector.<Sprite>();
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			
			var sectionCount:int = 0;
			
			var die:Number;
			
			if (_gameType == "CRICKET") {				
				var points:int = 15;
				while ( points <= 20 ) {
					if ( points % 2 == 0 )
					{
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 3, true), "boost");
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 2, true), "boost");
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1, true), "boost");
					} 
					else
					{
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 3, true), "");
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 2, true), "");
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1, true), "");
					}
					if ( myStats[points] == 2 )
					{
						die = Math.random();
						if ( die < .5 && points % 2 == 0 ) {
							addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1, true), "beeline");
						} else {
							addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1, true), "");
						}
					}
					++points;
				}
				if ( myStats[25] < 3 ) {	
					if ( points % 2 == 0 )
					{
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 2, true), "boost");
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 1, true), "boost");
					} 
					else
					{
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 2, true), "");
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 1, true), "");
					}
					if ( myStats[25] == 2 )
					{
						die = Math.random();
						if( die < .5 ) {
							addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 1, true), "beeline");
						} else {
							addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 1, true), "");
						}
					}
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
				if ( shot.ability == "shield" )
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
		
	}//end AnthonyProfile

}//end com.bored.games.darts.profiles