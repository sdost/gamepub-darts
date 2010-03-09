package com.bored.games.darts.states 
{
	import com.bored.games.darts.logic.AIShotManager;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AIPerformShot extends State
	{
		private var _shotMgr:AIShotManager;
		
		private var _mouseX:Number;
		private var _mouseY:Number;
		
		private var _thrustTimer:Timer;
		
		private var _avg:Number;
		
		public function AIPerformShot(a_name:String, a_mgr:AIShotManager, a_sm:IStateMachine) 
		{
			super(a_name, a_sm);
			
			_shotMgr = a_mgr;
			
			_thrustTimer = new Timer(1000, 0)
		}//end constructor()
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			_avg = 0;
			
			_mouseX = (_shotMgr.releasePoint.x * 700) / (5 * Math.tan(50 * Math.PI / 180)) + 350;
			_mouseY = -((_shotMgr.releasePoint.x * 550) / (5 * Math.tan(50 * Math.PI / 180)) - 275);
			
			_shotMgr.controller.generateInputEvent(_mouseX, _mouseY, true);
			
			_thrustTimer.addEventListener(TimerEvent.TIMER, generateThrust);
			_thrustTimer.start();
		}//end onEnter()
		
		private function generateThrust(a_evt:Event):void
		{
			_mouseX += 0;
			_mouseY += _shotMgr.thrust * 50;
			
			_shotMgr.controller.generateInputEvent(_mouseX, _mouseY, true);
			
			_avg++;
			
			if (_avg >= 5) {
				_thrustTimer.removeEventListener(TimerEvent.TIMER, generateThrust);
				_thrustTimer.stop();
				_shotMgr.controller.generateInputEvent(_mouseX, _mouseY, false);
			}
		}//end generateThrust()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			
		}//end onExit()
		
	}//end AIPerformShot

}//end com.bored.games.darts.states