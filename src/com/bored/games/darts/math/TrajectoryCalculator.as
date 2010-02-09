package com.bored.games.darts.math 
{	
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author sam
	 */
	public class TrajectoryCalculator
	{
		private var _releasePosition:Vector3D;
		private var _theta_x:Number = 0;
		private var _theta_y:Number = 0;
		private var _thrustForce:Number = 0;
		private var _gravityForce:Number = 0;
		
		private var _thrustVector:Vector3D;
		private var _gravityVector:Vector3D;
		
		public function TrajectoryCalculator() 
		{
			_releasePosition = new Vector3D();
			
			_thrustVector = new Vector3D();
			_gravityVector = new Vector3D();
		} //end TrajectoryCalculator constructor()
		
		public function setReleasePosition(a_x:Number, a_y:Number, a_z:Number):void
		{
			_releasePosition.x = a_x;
			_releasePosition.y = -a_y;
			_releasePosition.z = a_z;
			
			recalculateThrustVector();
		}//end setReleasePosition()
		
		public function set theta_x(a_ang:Number):void
		{
			_theta_x = a_ang;
			
			recalculateThrustVector();
		}//end set theta_x()
		
		public function set theta_y(a_ang:Number):void
		{
			_theta_y = a_ang;
			
			recalculateThrustVector();
		}//end set theta_y()
		
		public function set gravity(a_grav:Number):void
		{
			_gravityForce = a_grav;
			
			recalculateGravityVector();
		}//end set gravity()
		
		public function set thrust(a_thrust:Number):void
		{
			_thrustForce = a_thrust;
			
			recalculateThrustVector();
		}//end set thrust()
		
		public function get releasePosition():Vector3D
		{
			return _releasePosition.clone();
		}//end get releasePosition()
		
		public function get theta_x():Number
		{
			return _theta_x;
		}//end get theta()
		
		public function get theta_y():Number
		{
			return _theta_y;
		}//end get theta_y()
		
		public function get gravity():Number
		{
			return _gravityForce;
		}//end get gravity()
		
		public function get thrust():Number
		{
			return _thrustForce;
		}//end set thrust()
		
		private function recalculateThrustVector():void
		{
			var unit:Vector3D = new Vector3D(0, 0, 1);
			
			var x_rotate_unit:Vector3D = new Vector3D();
			
			x_rotate_unit.x = unit.x;
			x_rotate_unit.y = unit.z * Math.sin(_theta_x) - unit.y * Math.cos(_theta_x);
			x_rotate_unit.z = unit.y * Math.sin(_theta_x) + unit.z * Math.cos(_theta_x);
			
			var y_rotate_unit:Vector3D = new Vector3D();
			
			y_rotate_unit.x = x_rotate_unit.z * Math.sin(_theta_y) + x_rotate_unit.x * Math.cos(_theta_y);
			y_rotate_unit.y = x_rotate_unit.y;
			y_rotate_unit.z = x_rotate_unit.z * Math.cos(_theta_y) - x_rotate_unit.x * Math.sin(_theta_y);
			
			_thrustVector.x = y_rotate_unit.x * _thrustForce;
			_thrustVector.y = -y_rotate_unit.y * _thrustForce;
			_thrustVector.z = y_rotate_unit.z * _thrustForce;
		}//end recalculateThrustVector()
		
		private function recalculateGravityVector():void
		{
			var direction:Vector3D = new Vector3D(0, _gravityForce, 0); 
			
			_gravityVector.x = direction.x;
			_gravityVector.y = -direction.y;
			_gravityVector.z = direction.z;
		}//end recalculateGravityVector()
		
		public function calculateHeightAtPos(a_z:Number):Number
		{			
			var height:Number = _releasePosition.y + a_z * (_thrustVector.y / _thrustVector.z) - .5 * a_z * a_z * _gravityVector.y / Math.pow(_thrustVector.z, 2);
			
			return height;
		}//end calculateHeightAtX()
		
	}//end class TrajectoryCalculator

}//end com.bored.games.darts.math