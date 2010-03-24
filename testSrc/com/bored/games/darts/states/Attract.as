package com.bored.games.darts.states 
{
	import com.bored.games.assets.AttractScreen_MC;
	import com.bored.games.darts.ui.AttractScreen;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	/**
	 * ....
	 * @author Samuel Dost
	 */
	public class Attract extends State
	{
		private var _attractScreen:AttractScreen;
		
		public function Attract(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end Attract() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			var attractScreenImg:MovieClip;
			
			try
			{
				attractScreenImg = new AttractScreen_MC();
				_attractScreen = new AttractScreen(attractScreenImg, false, true);
				_attractScreen.addEventListener(AttractScreen.NEW_GAME_CLICKED_EVT, onNewGameClicked, false, 0, true);
				_attractScreen.addEventListener(AttractScreen.RESUME_GAME_CLICKED_EVT, onResumeGameClicked, false, 0, true);
				_attractScreen.addEventListener(AttractScreen.STORE_CLICKED_EVT, onStoreClicked, false, 0, true);
				DartsGlobals.instance.screenSpace.addChild(_attractScreen);
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("Attract::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
		
		private function onNewGameClicked(e_evt:Event):void
		{
			(this.stateMachine as GameFSM).transitionToNextState();
			
		}//end onNewGameClicked();
		
		private function onResumeGameClicked(e_evt:Event):void
		{
			DartsGlobals.instance.gameManager.loadGameState( { } );
			
			(this.stateMachine as GameFSM).transitionToNextState();
		}//end onResumeGameClicked();
		
		private function onStoreClicked(e_evt:Event):void
		{
			(this.stateMachine as GameFSM).transitionToStateNamed("GameStore");
		}//end onResumeGameClicked();
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			_attractScreen.removeEventListener(AttractScreen.NEW_GAME_CLICKED_EVT, onNewGameClicked);
			_attractScreen.removeEventListener(AttractScreen.RESUME_GAME_CLICKED_EVT, onResumeGameClicked);
			
		}//end onExit()
		
	}//end class AttractState
	
}//end package com.bored.games.darts.states