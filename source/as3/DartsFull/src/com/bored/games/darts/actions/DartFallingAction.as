﻿package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.darts.objects.I3D;
	import com.bored.games.objects.GameElement;
	import flash.utils.getTimer;
	import com.sven.utils.AppSettings;
	
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
		private var _zBounceRange:Number = 0;
		private var _zBounce:Number = 0;
		
		public function DartFallingAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			_gravity = a_params.gravity;
			_yFloor = a_params.yFloor;
			_zBounceRange = a_params.zBounceRange;
		}//end initParams()
		
		override public function startAction():void
		{
			super.startAction();
			
			_time = getTimer();
			
			_zBounce = Math.floor(_gameElement.z - (Math.random() * _zBounceRange));
		}//end startAction()
	
		override public function update(a_time:Number):void
		{
			(_gameElement as I3D).pitch += (0 - (_gameElement as I3D).pitch) / 8;
			_gameElement.z += (_zBounce - _gameElement.z) / 8;
			
			var elapsed:Number = (a_time - _time)/1000;
			
			var moveY:Number = _gravity * elapsed * elapsed;
			
			_gameElement.y -= moveY * AppSettings.instance.simulationStepScale;
			if (_gameElement.y <= _yFloor)
			{
				this.finished = true;
			}
		}//end update()
		
	}//end FallingAction

}//end com.bored.games.darts.actions