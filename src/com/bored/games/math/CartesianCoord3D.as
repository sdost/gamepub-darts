package com.bored.games.math 
{
	import com.bored.games.math.CartesianCoord;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CartesianCoord3D extends CartesianCoord
	{
		protected var _z:Number;
		
		public function CartesianCoord3D(a_x:Number = 0, a_y:Number = 0, a_z:Number = 0) 
		{
			super(a_x, a_y);
			
			_z = a_z;
		}//end constructor()
	
		public function get z():Number
		{
			return _z;
		}//end z()
		
	}//end CartesianCoord3D

}//end com.bored.games.math