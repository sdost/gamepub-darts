package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.assets.icons.Irene_Portrait_BMP;
	import com.bored.games.darts.DartsGlobals;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.assets.icons.TheProfessor_Portrait_BMP;
	import com.bored.games.darts.logic.AIShotCandidate;
	import flash.display.Sprite;
	
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
			
			this.setDartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_irene", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight));
			
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
		
	}//end IreneProfile

}//end com.bored.games.darts.profiles