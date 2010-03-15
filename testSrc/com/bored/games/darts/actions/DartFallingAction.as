package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DartFallingAction extends Action
	{
		private static const NAME:String = "com.bored.games.darts.actions.DartFallingAction";
		
		private var _time:Number = 0;
		
		private var _gravity:Number = 0;
		private var _yFloor:Number = 0;
		
		public function DartFallingAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			_gravity = a_params.gravity;
			_yFloor = a_params.yFloor;
		}//end initParams()
		
		override public function startAction():void
		{
			super.startAction();
			
			_time = getTimer();
		}//end startAction()
	
		override public function update(a_time:Number):void
		{
			_gameElement.orientation += (0 - _gameElement.orientation) / 8;
			
			var elapsed:Number = (a_time - _time)/1000;
			
			var moveY:Number = _gravity * elapsed * elapsed;
			
			_gameElement.position.y -= moveY / 40;
			if (_gameElement.position.y <= _yFloor)
			{
				this.finished = true;
			}
		}//end update()
		
	}//end FallingAction

}//end com.bored.games.darts.actions