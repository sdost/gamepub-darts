package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.abilities.ShieldAbility;
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
			this.bio = "A \"chav\" way past his prime. An aggressive risk taker. Known to favor Doubles and Triples.";
			
			this.portrait =ImageFactory.getBitmapDataByQualifiedName("com.bored.games.darts.assets.icons.Mack_Portrait_BMP", 150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_mack", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightOval.data));
			
			this.accuracy = AppSettings.instance.mackAccuracy;
			this.stepScale = AppSettings.instance.mackStepScale;
			
			this.prize = 100;
		}//end constructor()
		
		override public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{
			var _gameType:String = a_gameType;
			var myStats:Object = a_myStats;
			var clipList:Vector.<Sprite> = new Vector.<Sprite>();
			
			var sectionCount:int = 0;
			
			var die:Number;
			
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			
			if (_gameType == "CRICKET") {				
				var points:int = 15;
				while ( points <= 20 ) {
					if ( a_myStats[points] < 3 ) {
						die = Math.random();
						
						if ( die < .4 )
						{
							addShot(myShotList, points, 2);
						}
						else if ( die < .8 )
						{
							addShot(myShotList, points, 3);
						}
						else if ( die < 1.0 )
						{
							addShot(myShotList, points, 1);
						}
					}
					++points;
				}
				if ( myStats[25] < 3 ) {						
					die = Math.random();
					
					if ( die < .4 )
					{
						addShot(myShotList, 25, 2);
					}
					else if ( die < .8 )
					{
						addShot(myShotList, 25, 2);
					}
					else if ( die < 1.0 )
					{
						addShot(myShotList, 25, 1);
					}
				}
			}
			
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			if ( a_allStats[DartsGlobals.instance.localPlayer.playerNum][lastPlayerScore.points] < 3 && DartsGlobals.instance.opponentPlayer.hasAbility(ShieldAbility.NAME) )
			{
				die = Math.random();
				
				if ( die < .5 )
				{
					addShot(myShotList, lastPlayerScore.points, lastPlayerScore.multiplier, false, ShieldAbility.NAME);
				}
			}
			
			return myShotList;
		}//end generateShotList()
		
		override public function pickShot(a_dartsRemaining:int, a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			for each( var shot:AIShotCandidate in a_shots )
			{
				var die:Number = Math.random();
				
				if ( a_dartsRemaining == 0 && shot.modifier == ShieldAbility.NAME && die < .5 )
				{
					_shotIntention = shot;
					return _shotIntention;
				}
			}
			
			if( a_shots.length > 0 )
				_shotIntention = a_shots[Math.floor(Math.random() * a_shots.length)];
			else
				_shotIntention = new AIShotCandidate(0, 0, 25, 2);
				
			return _shotIntention;
		}//end pickShot()
		
				
		override public function handleShot(a_points:int, a_multiplier:int):void
		{
			
		}//end handleShot()
		
	}//end MackProfile		

}//end com.bored.games.darts.profiles