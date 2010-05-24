package com.sven.utils 
{	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author sam
	 */
	public class TrajectoryCalculator
	{
		private var _startPosition:Vector3D;
		private var _theta:Number = 0;
		private var _thrustForce:Number = 0;
		private var _gravityForce:Number = 0;
		
		private var _thrustVector:Vector3D;
		
		public function TrajectoryCalculator() 
		{
			_startPosition = new Vector3D();			
			_thrustVector = new Vector3D();
		} //end TrajectoryCalculator constructor()
		
		public function set initialPosition(a_pos:Vector3D):void
		{
			_startPosition.x = a_pos.x;
			_startPosition.y = a_pos.y;
			_startPosition.z = a_pos.z;
			
			recalculateThrustVector();
		}//end setReleasePosition()
		
		public function set theta(a_ang:Number):void
		{
			_theta = a_ang;
			
			recalculateThrustVector();
		}//end set theta()
		
		public function set gravity(a_grav:Number):void
		{
			_gravityForce = a_grav;
		}//end set gravity()
		
		public function set thrust(a_thrust:Number):void
		{
			_thrustForce = a_thrust;
			
			recalculateThrustVector();
		}//end set thrust()
				
		private function recalculateThrustVector():void
		{
			var unit:Vector3D = new Vector3D(1, 0, 0);
			var rotX:Number = unit.x * Math.cos(_theta) - unit.y * Math.sin(_theta);
			var rotY:Number = unit.x * Math.sin(_theta) + unit.y * Math.cos(_theta);
			
			_thrustVector.x = rotX * _thrustForce;
			_thrustVector.y = rotY * _thrustForce;
		}//end recalculateThrustVector()
		
		public function get thrustVector():Vector3D
		{
			return _thrustVector;
		}//end get thrustVector()
		
		public function calculateHeightAtPos(a_pos:Number):Number
		{			
			return _startPosition.y + (a_pos - _startPosition.z) * (_thrustVector.y / _thrustVector.x) - .5 * (a_pos - _startPosition.z) * (a_pos - _startPosition.z) * _gravityForce / Math.pow(_thrustVector.x, 2);
		}//end calculateHeightAtPos()
		
		public function toString():String
		{
			var str:String = new String("TrajectoryCalculator: @(" + _startPosition.x + ", " + _startPosition.y + ", " + _startPosition.z + ")\n");
			str += new String("\t theta: " + _theta + "\n");
			str += new String("\t thrust: " + _thrustForce + "\n");
			str += new String("\t gravity: " + _gravityForce + "\n");
			str += new String("\t thrust vector: " + _thrustVector.toString());
			
			return str;
		}//end toString()
		
	}//end class TrajectoryCalculator

}//end com.bored.games.darts.math