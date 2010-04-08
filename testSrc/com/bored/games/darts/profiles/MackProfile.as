﻿package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.assets.icons.Mack_Portrait_BMP;
	import com.bored.games.darts.assets.icons.Sammy_Portrait_BMP;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartFlightOval;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.skins.DartSkin;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	import flash.display.Sprite;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AIShotCandidate;
	
	/**
	 * ...
	 * @author sam
	 */
	public class MackProfile extends EnemyProfile
	{
		
		public function MackProfile() 
		{
			super("Mack");
			
			this.age = 28;
			this.height = 105;
			this.weight = 180;
			this.bio = "Dirty chav with terrible fashion sense.";
			
			this.portrait = new Mack_Portrait_BMP(150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_mack", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightOval.data));
			
			this.accuracy = 0.1;
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
							clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 2, false));
						}
						else if ( die < .8 )
						{
							clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 3, false));
						}
						else if ( die < 1.0 )
						{
							clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1, false));
						}
					}
					++points;
				}
				if ( myStats[25] < 3 ) {						
					die = Math.random();
					
					if ( die < .4 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 2, false));
					}
					else if ( die < .8 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 2, false));
					}
					else if ( die < 1.0 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 1, false));
					}
				}
			}
			
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			var clip:Sprite;
			
			for each( clip in clipList ) 
			{
				addShot(myShotList, clip, "");
			}
			
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			if ( a_allStats[DartsGlobals.instance.localPlayer.playerNum][lastPlayerScore.points] < 3 && DartsGlobals.instance.cpuPlayer.hasAbility("shield") )
			{
				die = Math.random();
				
				if ( die < .5 )
				{
					addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(lastPlayerScore.points, lastPlayerScore.multiplier, false), "shield");
				}
			}
			
			return myShotList;
		}//end generateShotList()
		
		override public function pickShot(a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			var shot:AIShotCandidate;
			
			for each( shot in a_shots ) 
			{
				var die:Number = Math.random();
				
				if ( shot.modifier == "shield" && die < .5 )
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
		
	}//end MackProfile		

}//end com.bored.games.darts.profiles