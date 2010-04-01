package com.bored.games.darts.logic 
{
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.system.System;
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
		
		public function pickShot(a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			var shot:AIShotCandidate;
			
			if( a_shots.length > 0 )
				shot = a_shots[Math.floor(Math.random() * a_shots.length)];
			else
				shot = new AIShotCandidate(0, 0);
				
			return shot;
		}//end pickShot()
		
		public function get name():String
		{
			return _name;
		}//end get name()
		
	}//end AIProfile

}//end com.bored.games.darts.logic