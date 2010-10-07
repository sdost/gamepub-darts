package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.darts.objects.I3D;
	import com.bored.games.objects.GameElement;
	import com.bored.games.darts.utils.TrajectoryCalculator;
	import com.sven.utils.AppSettings;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DartTrajectoryAction extends Action
	{
		private static const NAME:String = "com.bored.games.darts.actions.DartTrajectoryAction";
		private var _calc:TrajectoryCalculator;
		
		private var _thrust:Number = 0;
		private var _theta:Number = 0;
		private var _gravity:Number = 0;
		private var _lean:Number = 0;
		private var _finalZ:Number = 0;
		private var _stepScale:Number = 0;
		
		private var _lastUpdate:int = -1;
		
		public function DartTrajectoryAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
			_calc = new TrajectoryCalculator();
			
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			_thrust = a_params.thrust;
			_theta = a_params.theta;
			_gravity = a_params.gravity;
			_lean = a_params.lean;
			_finalZ = a_params.finalZ;
			_stepScale = a_params.stepScale;
		}//end initParams()
		
		override public function startAction():void
		{
			super.startAction();
			
			_calc.initialPosition = new Vector3D(_gameElement.x, _gameElement.y, _gameElement.z);
			_calc.thrust = _thrust;
			_calc.theta = _theta;
			_calc.gravity = _gravity;
			
			trace("Trajectory: " + _calc.toString());
			
			(_gameElement as I3D).pitch = 90;
			(_gameElement as I3D).roll = 0;
			
			_lastUpdate = -1;
		}//end startAction()
		
		public function get minimumThrust():int
		{
			return AppSettings.instance.dartMinThrust;
		}//end get minimumThrust()
	
		override public function update(a_time:Number):void
		{
			var adjust:Number = 0;
			
			if ( _lastUpdate < 0 ) 
			{
				_lastUpdate = a_time;
			}
			else
			{				
				var diff:int = a_time - _lastUpdate;
				
				_lastUpdate = a_time;
				
				adjust = Number( diff / 33 );
			}
			
			var z:Number = _gameElement.z + _calc.thrustVector.x * _stepScale * adjust;
			
			if ( z > this._finalZ ) z = this._finalZ;
			
			var y:Number = _calc.calculateHeightAtPos(z);
			var x:Number = _calc.initialPosition.x + (z * _lean * _stepScale);
				
			var rad:Number = Math.atan2(y - _gameElement.y, z - _gameElement.z);
	
			(_gameElement as I3D).pitch = rad * 180 / Math.PI + 90;
			
			(_gameElement as I3D).roll += AppSettings.instance.dartRollSpeed;
					
			_gameElement.x = x;
			_gameElement.y = y;
			_gameElement.z = z;	
		}//end update()
		
	}//end TrajectoryAction

}