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
		private var _points:int;
		private var _multiplier:int;
		private var _modifier:String;
		
		public function AIShotCandidate(a_x:Number, a_y:Number, a_points:int, a_multiplier:int, a_modifier:String = "") 
		{
			_point = new Point(a_x, a_y);
			_points = a_points;
			_multiplier = a_multiplier;
			_modifier = a_modifier;
		}//end construtor()
		
		public function get point():Point
		{
			return _point;
		}//end get point()
		
		public function get points():int
		{
			return _points;
		}//end get points()
		
		public function get multiplier():int
		{
			return _multiplier;
		}//end get multiplier()
		
		public function get modifier():String
		{
			return _modifier;
		}//end get risk()
		
		public function toString():String
		{
			return _point + ", " + points + ", " + multiplier + ", " + modifier;
		}//end toString()
		
	}//end AIShotCandidate

}//end com.bored.games.darts.logic