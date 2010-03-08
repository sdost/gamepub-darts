package com.bored.games.darts.logic 
{
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author sam
	 */
	public class AIOpponentProfile
	{
		/**
		 * Colormap definition of dartboard. Ana
		 */
		private var _boardColorMap:BitmapData;
		
		/**
		 * Define the level of shot-riskiness the AI is willing to allow when deciding on a shot.
		 */
		private var _riskCurrency:int;
				
		public function AIOpponentProfile() 
		{
			_riskCurrency = 1;
		}//end constructor()
		
		public function acquireColorMap(a_bmp:BitmapData):void
		{
			_boardColorMap = a_bmp;
		}//end acquireColorMap()
		
		public function doRiskCheck(a_shot:AIShotCandidate):Boolean
		{
			// TODO: Test shot riskiness against risk currency.
			return true;
		}//end doRiskCheck()
		
		public function pickOneShot(a_shotList:Array):AIShotCandidate
		{
			// TODO: random picker function, possibly guided by subclass opponent speicific heuristic.
			return new AIShotCandidate();
		}//end pickOneShot()
		
	}//end AIProfile

}//end com.bored.games.darts.logic