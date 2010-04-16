package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.TrajectoryCalculator;
	import com.sven.utils.AppSettings;
	
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
		private var _stepScale:Number = 0;
		
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
			_stepScale = a_params.stepScale;
		}//end initParams()
		
		override public function startAction():void
		{
			super.startAction();
			
			_calc.initialPosition = this._gameElement.position;
			_calc.thrust = _thrust;
			_calc.theta = _theta;
			_calc.gravity = _gravity;
			
			_gameElement.pitch = 90;
			_gameElement.roll = 0;
		}//end startAction()
		
		public function get minimumThrust():int
		{
			return AppSettings.instance.dartMinThrust;
		}//end get minimumThrust()
	
		override public function update(a_time:Number):void
		{
			var z:Number = _gameElement.position.z + _calc.thrustVector.x * _stepScale;
			var y:Number = _calc.calculateHeightAtPos(z);
			var x:Number = _gameElement.position.x + _lean * _stepScale;
				
			var rad:Number = Math.atan2(y - _gameElement.position.y, z - _gameElement.position.z);
	
			_gameElement.pitch = rad * 180 / Math.PI + 90;
			
			_gameElement.roll += AppSettings.instance.dartRollSpeed;
					
			_gameElement.position.x = x;
			_gameElement.position.y = y;
			_gameElement.position.z = z;	
		}//end update()
		
	}//end TrajectoryAction

}