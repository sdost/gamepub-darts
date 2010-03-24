package com.bored.games.darts.states 
{
	import com.bored.games.animations.Cutscene;
	import com.bored.games.animations.CutsceneManager;
	import com.bored.games.assets.AttractScreen_MC;
	import com.bored.games.darts.ui.AttractScreen;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
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
	public class IntroStory extends State
	{
		private var _openingCutscene:Cutscene;
		
		public function IntroStory(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end IntroStory() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			_openingCutscene = CutsceneManager.instance.getScene("opening");
			_openingCutscene.addEventListener(Event.COMPLETE, onCutsceneComplete);
			
			DartsGlobals.instance.screenSpace.addChild(_openingCutscene);
			
			_openingCutscene.startScene();
			
			_openingCutscene.addEventListener(MouseEvent.CLICK, onClick);
		}//end onEnter()
		
		private function onClick(a_evt:MouseEvent):void
		{
			_openingCutscene.advanceDialogue();
		}//end onClick()
		
		private function onCutsceneComplete(a_evt:Event):void
		{
			(this.stateMachine as GameFSM).transitionToNextState();
		}//end onCutsceneComplete()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			DartsGlobals.instance.screenSpace.removeChild(_openingCutscene);
			
			_openingCutscene = null;
		}//end onExit()
		
	}//end class AttractState
	
}//end package com.bored.games.darts.states