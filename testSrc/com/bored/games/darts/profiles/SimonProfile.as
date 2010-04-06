package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.assets.icons.Simon_Portrait_BMP;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	import flash.display.Sprite;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AIShotCandidate;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SimonProfile extends EnemyProfile
	{
		
		public function SimonProfile() 
		{
			super("Simon");
			
			this.age = 22;
			this.height = 185;
			this.weight = 70;
			this.bio = "Brit-punk rocker, past his prime.";
			
			this.portrait = new Simon_Portrait_BMP(150, 150);
			
			this.setDartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_simon", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight));
			
			this.accuracy = 0.2;
		}//end constructor()
		
		override public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{
			var _gameType:String = a_gameType;
			var myStats:Object = a_myStats;
			var clipList:Vector.<Sprite> = new Vector.<Sprite>();
			
			var sectionCount:int = 0;
			
			var die:Number;
			
			if (_gameType == "CRICKET") {				
				var points:int = 15;
				while ( points <= 20 ) {					
					if ( a_myStats[points] < 3 ) {
						die = Math.random();
						
						if ( die < .4 )
						{
							clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1, true));
						}
						else if ( die < .6 )
						{
							clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 3, true));
						}
						else if ( die < .8 )
						{
							clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 2, true));
						}
						else if ( die < 1.0 )
						{
							clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1, true));
						}
					}
					++points;
				}
				if ( myStats[25] < 3 ) {						
					die = Math.random();
					
					if ( die < .4 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 1, true));
					}
					else if ( die < .6 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 2, true));
					}
					else if ( die < 1.0 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 1, true));
					}
				}
			}
			
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			var clip:Sprite;
			
			die = Math.random();
				
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
			
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			if ( a_allStats[DartsGlobals.instance.localPlayer.playerNum][lastPlayerScore.points] < 3 && DartsGlobals.instance.cpuPlayer.hasAbility("shield") )
			{
				addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(lastPlayerScore.points, lastPlayerScore.multiplier, true), "shield");
			}
			
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
		
	}//end SimonProfile

}//end com.bored.games.darts.profiles