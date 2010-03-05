package com.bored.games.darts.states 
{
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AIPerformShot extends State
	{
		
		public function AIPerformShot(a_name:String, a_initVals:Object, a_sm:IStateMachine) 
		{
			super(a_name, a_sm);
			
		}//end constructor()
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			
		}//end onEnter()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			
		}//end onExit()
		
	}//end AIPerformShot

}//end com.bored.games.darts.states