package com.bored.games.darts.logic 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author sam
	 */
	public class AIShotCandidate
	{
		private var _point:Point;		
		private var _risk:int;
		private var _reward:int;
		
		public function AIShotCandidate(a_x:Number, a_y:Number, a_risk:int = 0, a_reward:int = 0) 
		{
			_point = new Point(a_x, a_y);
			_risk = a_risk;
			_reward = a_reward;
		}//end construtor()
		
		public function get point():Point
		{
			return _point;
		}//end get point()
		
		public function get risk():int
		{
			return _risk;
		}//end get risk()
		
		public function get reward():int
		{
			return _reward;
		}//end get reward()
		
	}//end AIShotCandidate

}//end com.bored.games.darts.logic