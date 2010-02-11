package com.bored.games.math 
{	
	import com.bored.games.math.CartesianCoord;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author sam
	 */
	public class TrajectoryCalculator
	{
		private var _startPosition:CartesianCoord;
		private var _theta:Number = 0;
		private var _thrustForce:Number = 0;
		private var _gravityForce:Number = 0;
		
		private var _thrustVector:Vector3D;
		
		public function TrajectoryCalculator() 
		{
			_startPosition = new CartesianCoord();
			
			_thrustVector = new Vector3D();
		} //end TrajectoryCalculator constructor()
		
		public function set initialPosition(a_pos:CartesianCoord):void
		{
			_startPosition.setCoords(a_pos);
			
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
			var unit:CartesianCoord = new CartesianCoord(1, 0);
			var rotX:Number = unit.x * Math.cos(_theta) - unit.y * Math.sin(_theta);
			var rotY:Number = unit.x * Math.sin(_theta) + unit.y * Math.cos(_theta);
			
			
			_thrustVector.x = rotX * _thrustForce;
			_thrustVector.y = rotY * _thrustForce;
		}//end recalculateThrustVector()
		
		public function calculateHeightAtPos(a_x:Number):Number
		{			
			return _startPosition.y + a_x * (_thrustVector.y / _thrustVector.x) - .5 * a_x * a_x * _gravityForce / Math.pow(_thrustVector.x, 2);
		}//end calculateHeightAtPos()
		
	}//end class TrajectoryCalculator

}//end com.bored.games.darts.math