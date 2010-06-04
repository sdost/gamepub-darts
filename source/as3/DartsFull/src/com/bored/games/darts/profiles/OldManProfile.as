package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartFlightOval;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.skins.DartSkin;
	import com.bored.games.darts.ui.modals.TutorialOneModal;
	import com.bored.games.darts.ui.modals.TutorialTwoModal;
	import com.bored.games.darts.ui.modals.TutorialThreeModal;
	import com.bored.games.darts.ui.modals.TutorialFourModal;
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
		public var _currentThrow:int = 0;
		public var _throwList:Vector.<AIShotCandidate>;
		
		public function OldManProfile() 
		{
			super("Old Man");
			
			this.age = 28;
			this.height = 105;
			this.weight = 180;
			this.bio = "Wizened old dude.";
			
			this.portrait = ImageFactory.getBitmapDataByQualifiedName("com.bored.games.darts.assets.icons.OldMan_Portrait_BMP", 150, 150);
			
			this.setDartSkin(new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_oldman", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, dae_DartFlightHeart.data));
			
			this.accuracy = 0.7;
		
			_throwList = new Vector.<AIShotCandidate>();
			
			buildTutorialThrows(_throwList);			
		}//end constructor()
		
		private function buildTutorialThrows(a_list:Vector.<AIShotCandidate>):void
		{
			// First Turn!
			addShot(a_list, 20, 1, false, "boost");
			addShot(a_list, 1, 1, false, "boost");
			addShot(a_list, 17, 1, false, "boost");
			
			// Second Turn!
			addShot(a_list, 20, 1, false, "boost");
			addShot(a_list, 1, 2, false, "boost");
			addShot(a_list, 18, 3, false, "boost");
			
			// Third Turn!
			addShot(a_list, 20, 1, false, "boost");
			addShot(a_list, 16, 1, false, "boost");
			addShot(a_list, 25, 1, false, "boost");
			
			// Fourth Turn!
			addShot(a_list, 8, 1, false, "boost");
			addShot(a_list, 2, 1, false, "boost");
			addShot(a_list, 10, 1, false, "boost");
			addShot(a_list, 17, 1, false, "boost");
			addShot(a_list, 17, 1, false, "boost");
			
		}//end buildTutorialsThrows()
		
		override public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{	
			if ( _currentThrow < 14 ) 
			{
				return _throwList;
			} else {
				return super.generateShotList(a_gameType, a_myStats, a_allStats);
			}
		}//end generateShotList()
		
		override public function pickShot(a_dartsRemaining:int, a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			if ( _currentThrow < 14 ) 
			{			
				if ( _currentThrow == 0 ) 
				{
					DartsGlobals.instance.showModalPopup(TutorialOneModal);
				}
				
				if ( _currentThrow == 3 ) 
				{
					DartsGlobals.instance.showModalPopup(TutorialTwoModal);
				}
				
				if ( _currentThrow == 6 ) 
				{
					DartsGlobals.instance.showModalPopup(TutorialThreeModal);
				}
				
				if ( _currentThrow == 9 )
				{
					DartsGlobals.instance.showModalPopup(TutorialFourModal);
				}
				
				var shot:AIShotCandidate = a_shots[_currentThrow++];
				
				return shot;
			} else {
				return super.pickShot(a_dartsRemaining, a_shots);
			}
		}//end pickShot()
			
		override public function handleShot(a_points:int, a_multiplier:int):void
		{
			if ( _currentThrow < 14 ) 
			{
				if ( a_points == 2 ) 
				{
					DartsGlobals.instance.gameManager.addEventListener(DartsGameLogic.THROW_END, useDoOver, false, 0, true);
				}
			}
		}//end handleShot()
		
	}//end OldManProfile		

}//end com.bored.games.darts.profiles