package com.bored.games.darts.profiles 
{
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
	public class ProfessorProfile extends EnemyProfile
	{
		
		public function ProfessorProfile() 
		{
			super("Professor");
			
			this.age = 75;
			this.height = 100;
			this.weight = 50;
			this.bio = "Weird Old Guy.";
			
			this.portrait = new TheProfessor_Portrait_BMP(150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_theprofessor", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightThin.data));
			
			this.accuracy = 0.9;
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
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 3, true));
						sectionCount++;
					}
					else if ( myStats[points] == 1 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 2, true));
						sectionCount++;
					}
					else if ( myStats[points] == 2 )
					{
						clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1, true));
						sectionCount++;
					}
					++points;
				}
				if ( myStats[25] < 3 ) {						
					clipList.push(DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 2, true));
					sectionCount++;
				}
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
				addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(lastPlayerScore.points, lastPlayerScore.multiplier, true), "shield");
			}
			
			return myShotList;
		}//end generateShotList()
		
		override public function pickShot(a_dartsRemaining:int, a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			for each( var shot:AIShotCandidate in a_shots )
			{
				if ( a_dartsRemaining == 0 && shot.modifier == "shield" )
				{
					_shotIntention = shot;
					return _shotIntention;
				}
			}
			
			if( a_shots.length > 0 )
				_shotIntention = a_shots[Math.floor(Math.random() * a_shots.length)];
			else
				_shotIntention = new AIShotCandidate(0, 0);
				
			return _shotIntention;
		}//end pickShot()
		
		override public function handleShot(a_points:int, a_multiplayer:int):void
		{
			
		}//end handleShot()
		
	}//end ProfessorProfile

}//end com.bored.games.darts.profiles