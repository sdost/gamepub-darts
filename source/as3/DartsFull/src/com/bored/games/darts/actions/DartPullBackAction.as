package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.objects.GameElement;
	import flash.utils.getTimer;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DartPullBackAction extends Action
	{
		private static const NAME:String = "com.bored.games.darts.actions.DartPullBackAction";
		
		private var _zPull:Number = 0;
		
		public function DartPullBackAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			_zPull = a_params.zPull;
		}//end initParams()
		
		override public function startAction():void
		{
			super.startAction();
		}//end startAction()
	
		override public function update(a_time:Number):void
		{
			_gameElement.z += (_zPull - _gameElement.z) / 8;
			
			if ( (Math.abs(_zPull - _gameElement.z) * AppSettings.instance.away3dEngineScale) < 1 )
			{
				_gameElement.z = _zPull;
				this.finished = true;
			}
		}//end update()
		
	}//end FallingAction

}//end com.bored.games.darts.actions