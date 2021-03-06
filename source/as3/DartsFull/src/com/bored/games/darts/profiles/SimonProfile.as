﻿package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.models.dae_DartFlightPincer;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.sven.factories.ImageFactory;
	import com.sven.utils.AppSettings;
	import flash.display.Sprite;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AIShotCandidate;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	
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
			this.bio = "Defensive and aggressive. Be careful with shields. Frustrates his opponents with wits and steel.";
			
			this.portrait = ImageFactory.getBitmapDataByQualifiedName("com.bored.games.darts.assets.icons.Simon_Portrait_BMP", 150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_simon", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightPincer.data));
			this.dartSkin.skinid = "simon";
			this.dartSkin.flightid = "pincer";
			
			this.accuracy = AppSettings.instance.simonAccuracy;
			this.stepScale = AppSettings.instance.simonStepScale;
			
			this.prize = 500;
		}//end constructor()
		
		override public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{
			var _gameType:String = a_gameType;
			var myStats:Object = a_myStats;
			var clipList:Vector.<Sprite> = new Vector.<Sprite>();
			
			var sectionCount:int = 0;
				
			var points:int = 15;
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
			var modifier:String = "";
			
			var die:Number;
			
			if (sectionCount <= 3) 
			{
				die = Math.random();
				
				if ( die < .35 ) 
				{
					modifier = BeeLineAbility.NAME;
				}
			}
			
			points = 15;
			while ( points <= 20 ) {
				
				trace("SimonProfile::generateShotList() -- points = " + points);
				
				die = Math.random();
				
				if ( myStats[points] >= 3 )
				{
					++points;
					continue;
				}
				
				if ( die < .4 )
				{
					addShot( myShotList, points, 1, false, modifier );
				}
				else if ( die < .6 )
				{
					addShot( myShotList, points, 3, false, modifier );
				}
				else if ( die < .8 )
				{
					addShot( myShotList, points, 2, false, modifier );
				}
				else if ( die < 1.0 )
				{
					addShot( myShotList, points, 1, false, modifier );
				}
				++points;
			}
			if ( myStats[25] < 3 ) {
				die = Math.random();
				if ( die < .4 ) 
				{
					addShot( myShotList, 25, 1, false, modifier );
				}
				else if ( die < .6 )
				{
					addShot( myShotList, 25, 2, false, modifier );
				}
				else if ( die < 1.0 )
				{
					addShot( myShotList, 25, 1, false, modifier );
				}
			}
						
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			if ( a_allStats[DartsGlobals.instance.localPlayer.playerNum][lastPlayerScore.points] < 3 && DartsGlobals.instance.opponentPlayer.hasAbility(ShieldAbility.NAME) )
			{
				addShot(myShotList, lastPlayerScore.points, lastPlayerScore.multiplier, false, ShieldAbility.NAME);
			}
			
			return myShotList;
			/*
			var _gameType:String = a_gameType;
			var myStats:Object = a_myStats;
			var clipList:Vector.<Sprite> = new Vector.<Sprite>();
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			
			var sectionCount:int = 0;
			
			var lastCPUScore:Object = DartsGlobals.instance.opponentPlayer.record.lastScore;
			
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
			*/
		}//end generateShotList()
		
		override public function pickShot(a_dartsRemaining:int, a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			/*
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
			*/
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
			/*
			if ( _shotIntention.points != a_points && _shotIntention.multiplier == 1 && DartsGlobals.instance.opponentPlayer.hasAbility(DoOverAbility.NAME) ) {
				DartsGlobals.instance.gameManager.abilityManager.activateAbility(DartsGlobals.instance.opponentPlayer.getAbilityByName(DoOverAbility.NAME));
			}
			*/
		}//end handleShot()
		
	}//end SimonProfile

}//end com.bored.games.darts.profiles