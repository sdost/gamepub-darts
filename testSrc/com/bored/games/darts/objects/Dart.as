package com.bored.games.darts.objects 
{
	import com.bored.games.elements.GameElement;
	import com.bored.games.math.TrajectoryCalculator;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Dart extends GameElement
	{
		private var _trajCalc:TrajectoryCalculator;
		
		public function Dart() 
		{
			super();
			_trajCalc = new TrajectoryCalculator();
			
		}//end constructor()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
			
			var x:Number = this.position.x;
			var y:Number = _trajCalc.calculateHeightAtPos(x);
			
			this.position.setCoords(x, y);
		}//end update()
		
		public function initThrowParams(releaseX:Number, releaseY:Number, thrust:Number, angle:Number, grav:Number, dist:Number):void
		{
			this.position.setCoords( releaseX, releaseY );
			
			_trajCalc.initialPosition = this.position;
			_trajCalc.thrust = thrust;
			_trajCalc.theta = Math.PI / 180 * angle;
			_trajCalc.gravity = grav;
		
		}//end initThrowParams()
		
	}//end Dart

}//end com.bored.games.darts.object