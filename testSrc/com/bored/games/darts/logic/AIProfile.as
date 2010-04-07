package com.bored.games.darts.logic 
{
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
	public class AIProfile
	{		
		protected var _name:String;
		public var accuracy:Number = 0.5;
		
		public function AIProfile(a_name:String = "") 
		{
			_name = a_name;
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
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 1));
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 2));
						addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(points, 3));
					}
					++points;
				}
				if ( myStats[25] < 3 ) {
					addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 1));
					addShot(myShotList, DartsGlobals.instance.gameManager.dartboard.getDartboardClip(25, 2));
				}
			}
			
			return myShotList;
		}//end generateShotList()
		
		protected function addShot( a_shotList:Vector.<AIShotCandidate>, a_clip:Sprite, a_ability:String = "" ):void
		{
			if ( a_clip ) 
			{			
				var clipScaledX:Number = (a_clip.x / (DartsGlobals.instance.gameManager.dartboard.boardSprite.width/2)) * AppSettings.instance.dartboardScale;
				var clipScaledY:Number = (a_clip.y / (DartsGlobals.instance.gameManager.dartboard.boardSprite.height/2)) * AppSettings.instance.dartboardScale;
				
				a_shotList.push( new AIShotCandidate(clipScaledX, -clipScaledY, a_ability) );
			}
		}//end addShot()
		
		public function pickShot(a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			var shot:AIShotCandidate;
			
			if( a_shots.length > 0 )
				shot = a_shots[Math.floor(Math.random() * a_shots.length)];
			else
				shot = new AIShotCandidate(0, 0);
				
			return shot;
		}//end pickShot()
		
		public function handleShot(a_points:int, a_multiplayer:int):void
		{
			// TODO: allow the AI to react to the results of the shot.
		}//end handleShot()
		
		public function get name():String
		{
			return _name;
		}//end get name()
		
	}//end AIProfile

}//end com.bored.games.darts.logic