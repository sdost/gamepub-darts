package com.bored.games.darts.states.statemachines
{
	import com.inassets.statemachines.Finite.FiniteStateMachine;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IState;
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class GameFSM extends FiniteStateMachine
	{
		protected var _states:Array;
		
		protected var _initialized:Boolean = false;
		
		public function GameFSM(a_name:String = "GameFSM" ) 
		{
			super(a_name);
			
			if(_initialized)
			{
				throw new Error("GameFSM::GameFSM(): Already initialized, only construct once!"); 
			}
			
			_states = new Array();
			
			if(_states.length)
			{
				this.setInitialState(_states[0] as IState);
				_initialized = true;
			}
			
		}//end PreloaderFSM() constructor.
		
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
				throw new Error("GameFSM::start(): Not yet initialized, add a state, in which the first added will be the initial state, and then we can start().");
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
				throw new Error("GameFSM::transitionToNextState() could not find current state!");
			}
			
			if(++indexOfCurrentState >= _states.length)
			{
				throw new Error("GameFSM::transitionToNextState() Currently in last state, '" + (_states[indexOfCurrentState-1] as State).name + "', cannot continue!");
			}
			
			this.transition(_states[indexOfCurrentState] as IState);
			
		}//end transitionToNextState()
		
		public function transitionToStateNamed(a_stateName:String):void
		{
			var foundState:State;
			
			for(var i:int = 0; i < _states.length; i++)
			{
				foundState = _states[i];
				if(foundState.name == a_stateName)
				{
					break;
				}
				foundState = null;
			}
			
			if(foundState)
			{
				this.transition(foundState);
			}
			else
			{
				throw new Error("GameFSM::transitionToStateNamed(): State named '" + a_stateName + "' not found!");
			}
			
		}//end transitionToStateNamed()
		
	}//end class PreloaderFSM
	
}//end package com.bored.loaders.preloaders.states
