package com.bored.games.darts
{
	import com.bored.games.darts.states.Gameplay;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.states.Initialization;
	import com.bored.games.darts.states.Attract;
	import com.sven.utils.AppSettings;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class DartsEntryPoint extends Sprite
	{
		protected var _myStateMachine:GameFSM;
		
		public function DartsEntryPoint() 
		{
			_myStateMachine = new GameFSM();
			
			addStates();
			
			if (this.stage)
			{
				addedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
			
		}//end BasicPreloader() constructor.
		
		protected function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage); // so that this only happens once.
			
			// set the global stage value.
			DartsGlobals.instance.stage = this.stage;
			
			AppSettings.instance.load("development.config");
			
			AppSettings.instance.addEventListener(Event.COMPLETE, onConfigReady);
		}
		
		private function onConfigReady(a_evt:Event):void
		{
			AppSettings.instance.removeEventListener(Event.COMPLETE, onConfigReady);
			
			// our flashVars were set before we were added to the stage, so, now that we're on the stage, we can start.
			_myStateMachine.start();
			
			trace("Added to Stage.");
			
		}//end addedToStage()
		
		protected function addStates():void
		{
			_myStateMachine.addState(new Initialization("Initialization", _myStateMachine));
			_myStateMachine.addState(new Attract("Attract", _myStateMachine));
			_myStateMachine.addState(new Gameplay("Gameplay", _myStateMachine));
			
		}//end addStates()
		
	}//end class DartsEntryPoint
	
}//end package com.bored.games.darts
