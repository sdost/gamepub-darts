package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
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
			this.bio = "A lucky bastard. Accuracy increases if he hits his lucky number. Wary of shields.";
			
			this.firstMatch = "Now you're snookered, you gormless Yank. Time to throw a spanner in the works of your arrows!";
			
			this.portrait = new BigBill_Portrait_BMP(150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_bigbill", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightPincer.data));
			
			this.accuracy = AppSettings.instance.bigBillAccuracy;
			this.stepScale = AppSettings.instance.bigBillStepScale;
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
						addShot(myShotList, points, 3, true, (lastCPUScore.points == 17) ? "boost" : "");
					}
					++points;
				}
				if ( myStats[25] < 3 ) {	
					addShot(myShotList, 25, 2, true, (lastCPUScore.points == 17) ? "boost" : "");
				}
			}
			
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			return myShotList;
		}//end generateShotList()
		
		override public function pickShot(a_dartsRemaining:int, a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			for each( var shot:AIShotCandidate in a_shots )
			{
				if ( a_dartsRemaining == 0 && shot.modifier == ShieldAbility.NAME )
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
			if ( _shotIntention.points != a_points && _shotIntention.multiplier == 1 && DartsGlobals.instance.cpuPlayer.hasAbility(DoOverAbility.NAME) ) {
				for each( var ability:Ability in abilities )
				{
					if ( ability.name == DoOverAbility.NAME ) {
						DartsGlobals.instance.gameManager.abilityManager.activateAbility(ability);
					}
				}
			}
		}//end handleShot()
		
	}//end BigBillProfile
		

}//end com.bored.games.darts.profiles