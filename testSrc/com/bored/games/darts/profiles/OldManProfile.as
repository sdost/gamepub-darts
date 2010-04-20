package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.assets.icons.Mack_Portrait_BMP;
	import com.bored.games.darts.assets.icons.OldMan_Portrait_BMP;
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
	public class OldManProfile extends EnemyProfile
	{
		public var _currentTurn:int = 0;
		
		public function OldManProfile() 
		{
			super("Old Man");
			
			this.age = 28;
			this.height = 105;
			this.weight = 180;
			this.bio = "Wizened old dude.";
			
			this.portrait = new OldMan_Portrait_BMP(150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_oldman", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightHeart.data));
			
			this.accuracy = 1.0;
			this.stepScale = 0.025;
		}//end constructor()
		
		override public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			
			if (_gameType == "CRICKET") 
			{				
				addShot(myShotList, lastPlayerScore.points, lastPlayerScore.multiplier, false, ShieldAbility.NAME);
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
		
	}//end OldManProfile		

}//end com.bored.games.darts.profiles