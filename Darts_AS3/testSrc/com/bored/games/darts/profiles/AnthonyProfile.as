package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.assets.icons.Anthony_Portrait_BMP;
	import com.bored.games.darts.assets.icons.Simon_Portrait_BMP;
	import com.bored.games.darts.logic.AIShotCandidate;
	import com.bored.games.darts.models.dae_DartFlightModHex;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	import flash.display.Sprite;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	
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
			this.bio = "A dartshark that toys with you. Hides his skills and gets better if you target things oddly...";
			
			this.portrait = new Anthony_Portrait_BMP(150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_anthony", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightModHex.data));
			
			this.accuracy = AppSettings.instance.anthonyAccuracy;
			this.stepScale = AppSettings.instance.anthonyStepScale;
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
					if ( myStats[points] < 3 ) 
					{
						if ( points % 2 == 1 )
						{
							addShot(myShotList, points, 3, false, "boost");
							addShot(myShotList, points, 2, false, "boost");
							addShot(myShotList, points, 1, false, "boost");
						} 
						else
						{
							addShot(myShotList, points, 3);
							addShot(myShotList, points, 2);
							addShot(myShotList, points, 1);
						}
					}
					if ( myStats[points] == 2 )
					{
						die = Math.random();
						if ( die < .5 && points % 2 == 0 ) {
							addShot(myShotList, points, 1, false, BeeLineAbility.NAME);
						} else {
							addShot(myShotList, points, 1);
						}
					}
					++points;
				}
				if ( myStats[25] < 3 ) {	
					if ( points % 2 == 0 )
					{
						addShot(myShotList, 25, 2, false, "boost");
						addShot(myShotList, 25, 1, false, "boost");
					} 
					else
					{
						addShot(myShotList, 25, 2, false, "");
						addShot(myShotList, 25, 1, false, "");
					}
					if ( myStats[25] == 2 )
					{
						die = Math.random();
						if( die < .5 ) {
							addShot(myShotList, 25, 1, false, BeeLineAbility.NAME);
						} else {
							addShot(myShotList, 25, 1, false, "");
						}
					}
				}
			}
			
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			return myShotList;
		}//end generateShotList()
		
		override public function pickShot(a_dartsRemaining:int, a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			for each( var shot:AIShotCandidate in a_shots )
			{
				if ( shot.modifier == "boost" )
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
		
	}//end AnthonyProfile

}//end com.bored.games.darts.profiles