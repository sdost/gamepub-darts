package com.bored.games.darts.states 
{
	import com.bored.games.darts.logic.AIShotManager;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AIMoveToShot extends State
	{
		private var _shotMgr:AIShotManager;
		
		public function AIMoveToShot(a_name:String, a_mgr:AIShotManager, a_sm:IStateMachine) 
		{
			super(a_name, a_sm);
			
			_shotMgr = a_mgr;
			
		}//end constructor()
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			trace(_shotMgr.currentShot.releasePoint.toString());
		}//end onEnter()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{

		}//end onExit()
		
	}//end AIMoveToShot

}//end com.bored.games.darts.states