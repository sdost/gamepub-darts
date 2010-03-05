package com.bored.games.darts.states 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AIShotManager;
	import com.bored.games.darts.states.statemachines.AIOpponentFSM;
	import com.bored.games.events.InputStateEvent;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AIMoveToShot extends State
	{
		private var _shotMgr:AIShotManager;
		
		private var _mouseX:Number;
		private var _mouseY:Number;
		
		private var _destX:Number;
		private var _destY:Number;
		
		public function AIMoveToShot(a_name:String, a_mgr:AIShotManager, a_sm:IStateMachine) 
		{
			super(a_name, a_sm);
			
			_shotMgr = a_mgr;
			
			_mouseX = 350;
			_mouseY = 275;
			
		}//end constructor()
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			trace(_shotMgr.releasePoint.toString());
			
			_shotMgr.controller.generateInputEvent(_mouseX, _mouseY, false);
			
			_destX = (_shotMgr.releasePoint.x * 700) / (5 * Math.tan(50 * Math.PI / 180)) + 350;
			_destY = -((_shotMgr.releasePoint.x * 550) / (5 * Math.tan(50 * Math.PI / 180)) - 275);
			
			trace("Dest: [" + _destX + ", " + _destY + "]");
			
			DartsGlobals.instance.stage.addEventListener(Event.ENTER_FRAME, processMove);
			
		}//end onEnter()
		
		private function processMove(a_evt:Event):void
		{
			_mouseX += (_destX - _mouseX) / 4;
			_mouseY += (_destY - _mouseY) / 4;
			
			_shotMgr.controller.generateInputEvent(_mouseX, _mouseY, false);
			
			if ( Math.abs(_mouseX - _destX) < 1 && Math.abs(_mouseY - _destY) < 1 ) {
				DartsGlobals.instance.stage.removeEventListener(Event.ENTER_FRAME, processMove);
				(this.stateMachine as AIOpponentFSM).transitionToNextState();
			}
		}//end processMove()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{

		}//end onExit()
		
	}//end AIMoveToShot

}//end com.bored.games.darts.states