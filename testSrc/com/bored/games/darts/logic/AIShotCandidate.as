package com.bored.games.darts.logic 
{
	/**
	 * ...
	 * @author sam
	 */
	public class AIShotCandidate
	{
		private var _points:int;
		private var _multiplier:int;
		
		private var _riskiness:int;
		
		public function AIShotCandidate() 
		{
			_points = 0;
			_multiplier = 1;
			_riskiness = 0;
		}//end construtor()
		
	}//end AIShotCandidate

}//end com.bored.games.darts.logic