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
		private static const MAP_DENSITY:int = 400;
		
		private var _shotMap:Array;
		
		/**
		 * Define the level of shot-riskiness the AI is willing to allow when deciding on a shot.
		 */
		private var _riskCurrency:int;
				
		public function AIProfile() 
		{
			_riskCurrency = 1;
		}//end constructor()
		
	}//end AIProfile

}//end com.bored.games.darts.logic