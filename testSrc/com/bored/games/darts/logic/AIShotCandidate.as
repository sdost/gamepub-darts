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
		private var _modifier:String;
		
		public function AIShotCandidate(a_x:Number, a_y:Number, a_modifier:String = "") 
		{
			_point = new Point(a_x, a_y);
			_modifier = a_modifier;
		}//end construtor()
		
		public function get point():Point
		{
			return _point;
		}//end get point()
		
		public function get modifier():String
		{
			return _modifier;
		}//end get risk()
		
	}//end AIShotCandidate

}//end com.bored.games.darts.logic