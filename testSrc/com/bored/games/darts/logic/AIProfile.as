package com.bored.games.darts.logic 
{
	import com.bored.games.darts.objects.Board;
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
				
		public function AIProfile(a_name:String = "") 
		{
			_name = a_name;
		}//end constructor()
		
		public function pickShot(a_shots:Vector.<AIShotCandidate>):AIShotCandidate
		{
			return a_shots[Math.floor(Math.random() * a_shots.length)];
		}//end pickShot()
		
	}//end AIProfile

}//end com.bored.games.darts.logic