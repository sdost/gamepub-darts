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
		private var _abilityName:String;
		
		public function AIShotCandidate(a_x:Number, a_y:Number, a_ability:String = "") 
		{
			_point = new Point(a_x, a_y);
			_abilityName = a_ability;
		}//end construtor()
		
		public function get point():Point
		{
			return _point;
		}//end get point()
		
		public function get ability():String
		{
			return _abilityName;
		}//end get risk()
		
	}//end AIShotCandidate

}//end com.bored.games.darts.logic