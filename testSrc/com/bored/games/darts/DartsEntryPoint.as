﻿package com.bored.games.darts
{
	import com.bored.games.animations.CutsceneManager;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.states.Gameplay;
	import com.bored.games.darts.states.GameSelect;
	import com.bored.games.darts.states.GameStore;
	import com.bored.games.darts.states.IntroStory;
	import com.bored.games.darts.states.Initialization;
	import com.bored.games.darts.states.Attract;
	import com.sven.containers.Panel;
	import com.sven.utils.AppSettings;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class DartsEntryPoint extends Panel
	{
		protected var _myStateMachine:GameFSM;
		
		public function DartsEntryPoint() 
		{		
			super();
			
			_myStateMachine = new GameFSM();
			
			addStates();
			
		}//end BasicPreloader() constructor.
		
		override protected function addedToStage(a_evt:Event = null):void
		{
			super.addedToStage();
			
			stage.align = StageAlign.TOP_LEFT;
			
			CutsceneManager.instance.loadScript("opening.scene");
			
			// set the global stage value.
			DartsGlobals.instance.stage = this.stage;
			
			AppSettings.instance.load("development.config");
			
			AppSettings.instance.addEventListener(Event.COMPLETE, onConfigReady);
		}//end addedToStage()		
		
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
			_myStateMachine.addState(new IntroStory("IntroStory", _myStateMachine));
			_myStateMachine.addState(new GameSelect("GameSelect", _myStateMachine));
			_myStateMachine.addState(new Gameplay("Gameplay", _myStateMachine));
			
			_myStateMachine.addState(new GameStore("GameStore", _myStateMachine));			
		}//end addStates()
		
	}//end class DartsEntryPoint
	
}//end package com.bored.games.darts