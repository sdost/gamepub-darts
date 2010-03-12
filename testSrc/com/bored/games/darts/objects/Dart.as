package com.bored.games.darts.objects 
{
	import caurina.transitions.Tweener;
	import com.bored.games.elements.GameElement;
	import com.bored.games.math.TrajectoryCalculator;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Dart extends GameElement
	{
		private var _trajCalc:TrajectoryCalculator;
		private var _radius:int;
		
		private var _xVel:Number;
		
		private var _orientation:Number;
		
		private var _throwing:Boolean;
		
		public function Dart(a_radius:int = 1) 
		{
			_trajCalc = new TrajectoryCalculator();
			
			_radius = a_radius;
			
			_orientation = 90;			
		}//end constructor()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
				
			if( _throwing ) {
				var z:Number = this.position.z + _trajCalc.thrustVector.x/40;
				var y:Number = _trajCalc.calculateHeightAtPos(z);
				var x:Number = this.position.x + _xVel / 40;
				
				var rad:Number = Math.atan2(y - this.position.y, z - this.position.z);
				_orientation = rad * 180 / Math.PI + 90;
					
				this.position.x = x;
				this.position.y = y;
				this.position.z = z;				
			}
		}//end update()
		
		public function get radius():int
		{
			return _radius;
		}//end get radius()
		
		public function get angle():Number
		{
			return _orientation;
		}//end get angle()

		public function initThrowParams(releaseX:Number, releaseY:Number, releaseZ:Number, thrust:Number, angle:Number, grav:Number, xvel:Number = 0):void
		{
			this.position.x = releaseX;
			this.position.y = releaseY;
			this.position.z = releaseZ;
			
			_trajCalc.initialPosition = this.position;
			_trajCalc.thrust = thrust;
			_trajCalc.theta = Math.PI / 180 * angle;
			_trajCalc.gravity = grav;
			
			_throwing = true;
			
			_xVel = xvel;			
		}//end initThrowParams()
		
		public function finishThrow():void
		{
			_throwing = false;
		}//end finishThrow()
		
	}//end Dart

}//end com.bored.games.darts.object