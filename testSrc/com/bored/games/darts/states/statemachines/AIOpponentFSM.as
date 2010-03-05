package com.bored.games.darts.states.statemachines
{
	import com.bored.games.controllers.AIController;
	import com.bored.games.darts.states.AIChooseShot;
	import com.bored.games.darts.states.AIMoveToShot;
	import com.bored.games.darts.states.AIPerformShot;
	import com.inassets.statemachines.Finite.FiniteStateMachine;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IState;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class AIOpponentFSM extends FiniteStateMachine
	{
		protected var _states:Array;
		protected var _initialized:Boolean = false;
		
		private var _inputController:AIController;
		
		public function AIOpponentFSM(a_name:String) 
		{			
			super(a_name);
			
			if(_initialized)
			{
				throw new Error("AIOpponentFSM::AIOpponentFSM(): Already initialized, only construct once!"); 
			}
			
			_states = new Array();
			
			if(_states.length)
			{
				this.setInitialState(_states[0] as IState);
				_initialized = true;
			}
			
		}//end PreloaderFSM() constructor.
		
		public function set inputController(a_controller:AIController):void
		{
			_inputController = a_controller;
		}//end set inputController()
		
		public function get inputController():AIController
		{
			return _inputController;
		}//end get inputController()
		
		public function addState(a_state:IState):void
		{
			_states.push(a_state);
			
		}//end addState()
		
		override public function start():void
		{
			if (!_initialized && _states.length)
			{
				this.setInitialState(_states[0] as IState);
				_initialized = true;
			}
			
			if (!_initialized)
			{
				throw new Error("AIOpponentFSM::start(): Not yet initialized, add a state, in which the first added will be the initial state, and then we can start().");
			}
			
			super.start();
			
		}//end start()
		
		public function transitionToNextState():void
		{
			var indexOfCurrentState:int = -1;
			
			for(var i:int = 0; i < _states.length; i++)
			{
				if(this.currentState == _states[i])
				{
					indexOfCurrentState = i;
					break;
				} 
			}
			
			if(-1 == indexOfCurrentState)
			{
				throw new Error("AIOpponentFSM::transitionToNextState() could not find current state!");
			}
			
			if(++indexOfCurrentState >= _states.length)
			{
				throw new Error("AIOpponentFSM::transitionToNextState() Currently in last state, '" + (_states[indexOfCurrentState-1] as State).name + "', cannot continue!");
			}
			
			this.transition(_states[indexOfCurrentState] as IState);
			
		}//end transitionToNextState()
		
		public function resetStates():void
		{
			this.transition(_states[0] as IState);
		}//end resetStates()
		
	}//end class PreloaderFSM
	
}//end package com.bored.loaders.preloaders.states
