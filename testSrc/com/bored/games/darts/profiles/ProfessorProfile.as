package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.DartsGlobals;
	import com.jac.soundManager.SMSound;
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
			this.bio = "Impeccable in every way. Highly experienced with darts and powers.";
			
			this.portrait = new TheProfessor_Portrait_BMP(150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_theprofessor", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightHeart.data));
			
			this.accuracy = AppSettings.instance.professorAccuracy;
			this.stepScale = AppSettings.instance.professorStepScale;
					
			DartsGlobals.instance.soundManager.addSoundController(_voSoundController);
			
			// Prethrow
			_voSoundController.addSound( new SMSound("generic_prethrow1", "TheProf_Throw3Alright_mp3") );
			_voSoundController.addSound( new SMSound("generic_prethrow2", "TheProf_Throw4Hmm_mp3") );			
			
			// Throw
			_voSoundController.addSound( new SMSound("generic_throw1", "TheProf_Throw1Grunt_mp3") );
			_voSoundController.addSound( new SMSound("generic_throw2", "TheProf_Throw2Grunt_mp3") );
			
			// Success
			_voSoundController.addSound( new SMSound("generic_success1", "TheProf_SuccessBrilliant_mp3") );
			_voSoundController.addSound( new SMSound("generic_success2", "TheProf_SuccessExpected_mp3") );
			
			// Miss
			_voSoundController.addSound( new SMSound("generic_miss1", "TheProf_MissSigh_mp3") );
			_voSoundController.addSound( new SMSound("generic_miss2", "TheProf_MissDisgustedGrunt_mp3") );
			
			// Special Dart
			_voSoundController.addSound( new SMSound("generic_special1", "TheProf_SpcDartAskedForIt_mp3") );
			_voSoundController.addSound( new SMSound("generic_special2", "TheProf_SpcDartHowDoYou_mp3") );
		}//end constructor()
		
		override public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{
			var _gameType:String = a_gameType;
			var myStats:Object = a_myStats;
			var clipList:Vector.<Sprite> = new Vector.<Sprite>();
			
			var sectionCount:int = 0;
			
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
			
			var modifier:String = "";
			
			if (sectionCount <= 3) 
			{
				var die:Number = Math.random();
				
				if ( die < .35 ) 
				{
					modifier = BeeLineAbility.NAME;
				}
			}
			
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			
			var points:int = 15;
			while ( points <= 20 ) {
				if ( myStats[points] == 0 )
				{
					addShot(myShotList, points, 3, true, modifier);
				}
				else if ( myStats[points] == 1 )
				{
					addShot(myShotList, points, 2, true, modifier);
				}
				else if ( myStats[points] == 2 )
				{
					addShot(myShotList, points, 1, true, modifier);
				}
				++points;
			}
			if ( myStats[25] < 3 ) {						
				addShot(myShotList, 25, 2, true, modifier);
			}
			
			var lastPlayerScore:Object = DartsGlobals.instance.localPlayer.record.lastScore;
			
			if ( a_allStats[DartsGlobals.instance.localPlayer.playerNum][lastPlayerScore.points] < 3 && DartsGlobals.instance.cpuPlayer.hasAbility(ShieldAbility.NAME) )
			{
				addShot(myShotList, lastPlayerScore.points, lastPlayerScore.multiplier, true, ShieldAbility.NAME);
			}
			
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
			var version:int = Math.ceil( Math.random() * 2 );
			
			if ( _shotIntention.points == a_points && _shotIntention.multiplier == a_multiplier ) 
			{						
				_voSoundController.play("generic_success" + version.toString());
			}
			else 
			{
				_voSoundController.play("generic_miss" + version.toString());
			}
			
			
			if ( _shotIntention.points != a_points && _shotIntention.multiplier == 1 && DartsGlobals.instance.cpuPlayer.hasAbility(DoOverAbility.NAME) ) {
				DartsGlobals.instance.gameManager.abilityManager.activateAbility(DartsGlobals.instance.cpuPlayer.getAbilityByName(DoOverAbility.NAME));
			}
		}//end handleShot()
		
	}//end ProfessorProfile

}//end com.bored.games.darts.profiles