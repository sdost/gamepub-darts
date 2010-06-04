package com.bored.games.darts.logic 
{
	import com.bored.games.darts.profiles.Profile;
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.system.System;
	import flash.display.Sprite;
	import com.sven.utils.AppSettings;
	import com.bored.games.darts.DartsGlobals;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AIProfile extends Profile
	{		
		public var accuracy:Number;
		public var stepScale:Number;
		
		protected var _shotIntention:AIShotCandidate;
		
		public function AIProfile() 
		{
			accuracy = 0.5;
			stepScale = AppSettings.instance.simulationStepScale;
		}//end constructor()
		
		public function generateShotList(a_gameType:String, a_myStats:Object, a_allStats:Object):Vector.<AIShotCandidate>
		{
			var gameType:String = a_gameType;
			var myStats:Object = a_myStats;
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
						
			if (gameType == "CRICKET") {				
				var points:int = 15;
				while ( points <= 20 ) {
					if ( myStats[points] < 3 )
					{
						addShot(myShotList, points, 1);
						addShot(myShotList, points, 2);
						addShot(myShotList, points, 3);
					}
					++points;
				}
				if ( myStats[25] < 3 ) {
					addShot(myShotList, 25, 1);
					addShot(myShotList, 25, 2);
				}
			}
			
			return myShotList;
		}//end generateShotList()
		
		protected function addShot( a_shotList:Vector.<AIShotCandidate>, a_points:int, a_multiplier:int, a_nullIfBlocked:Boolean = false, a_ability:String = "" ):void
		{
			var clip:Sprite = DartsGlobals.instance.gameManager.dartboard.getDartboardClip(a_points, a_multiplier, a_nullIfBlocked);
			
			if ( clip ) 
			{			
				var clipScaledX:Number = (clip.x / (DartsGlobals.instance.gameManager.dartboard.sprite.width/2)) * AppSettings.instance.dartboardScale;
				var clipScaledY:Number = (clip.y / (DartsGlobals.instance.gameManager.dartboard.sprite.height/2)) * AppSettings.instance.dartboardScale;
				
				a_shotList.push( new AIShotCandidate(clipScaledX, -clipScaledY, a_points, a_multiplier, a_ability) );
			}
		}//end addShot()
		
		public function pickShot(a_dartsRemaining:int, a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			if( a_shots.length > 0 )
				_shotIntention = a_shots[Math.floor(Math.random() * a_shots.length)];
			else
				_shotIntention = new AIShotCandidate(0, 0, 25, 2);
				
			return _shotIntention;
		}//end pickShot()
		
		public function handleShot(a_points:int, a_multiplayer:int):void
		{
			// TODO: allow the AI to react to the results of the shot.
		}//end handleShot()
		
	}//end AIProfile

}//end com.bored.games.darts.logic