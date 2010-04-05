package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ShieldDartboardAction extends Action
	{
		private static const NAME:String = "com.bored.games.darts.actions.ShieldDartboardAction";
		private var _section:int;
		
		public function ShieldDartboardAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			_section = a_params.section;
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
	
		override public function update(a_time:Number):void
		{
			var z:Number = _gameElement.position.z + _calc.thrustVector.x * AppSettings.instance.simulationStepScale;
			var y:Number = _calc.calculateHeightAtPos(z);
			var x:Number = _gameElement.position.x + _lean * AppSettings.instance.simulationStepScale;
				
			var rad:Number = Math.atan2(y - _gameElement.position.y, z - _gameElement.position.z);
	
			_gameElement.pitch = rad * 180 / Math.PI + 90;
			
			_gameElement.roll += AppSettings.instance.dartRollSpeed;
					
			_gameElement.position.x = x;
			_gameElement.position.y = y;
			_gameElement.position.z = z;	
		}//end update()
		
	}//end ShieldDartboardAction

}//end com.bored.games.darts.actions