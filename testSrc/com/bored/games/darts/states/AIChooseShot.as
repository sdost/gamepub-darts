package com.bored.games.darts.states 
{
	import com.bored.games.darts.logic.AIShotManager;
	import com.bored.games.darts.states.statemachines.AIOpponentFSM;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AIChooseShot extends State
	{
		private var _shotMgr:AIShotManager;
		
		public function AIChooseShot(a_name:String, a_mgr:AIShotManager, a_sm:IStateMachine) 
		{
			super(a_name, a_sm);	
			
			_shotMgr = a_mgr;
		}//end constructor()
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			//TODO generate shot list, pick shot, pick start position based on dest point
			
			_shotMgr.currentShot.destPoint.x = 0.8;
			_shotMgr.currentShot.destPoint.y = 0.8;
			_shotMgr.currentShot.destPoint.z = 5;
			
			_shotMgr.currentShot.releasePoint.x = 0.8;
			_shotMgr.currentShot.releasePoint.y = 0.8;
			_shotMgr.currentShot.releasePoint.z = 0;
			
			(this.stateMachine as AIOpponentFSM).transitionToNextState();
		}//end onEnter()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{

		}//end onExit()
		
	}//end AIChooseShot

}//end com.bored.games.darts.states