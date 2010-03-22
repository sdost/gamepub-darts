package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BeeLineTrajectoryAction extends Action
	{
		private static const NAME:String = "com.bored.games.darts.actions.BeeLineTrajectoryAction";
		
		private var _speed:Number = 0;
		
		public function BeeLineTrajectoryAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);	
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			_speed = a_params.thrust;
		}//end initParams()
		
		override public function startAction():void
		{
			super.startAction();
			
			_gameElement.roll = 0;
		}//end startAction()
	
		override public function update(a_time:Number):void
		{
			_gameElement.roll += 3;
			
			var z:Number = _gameElement.position.z + _speed/40;
			_gameElement.position.z = z;	
		}//end update()
		
	}//end BeeLineTrajectoryAction

}//end com.bored.games.darts.actions