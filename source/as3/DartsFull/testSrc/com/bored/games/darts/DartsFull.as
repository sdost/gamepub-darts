package com.bored.games.darts
{
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.profiles.UserProfile;
	import com.bored.games.darts.states.LogoSplash;
	import com.bored.games.darts.states.Multiplayer;
	import com.bored.games.darts.states.Practice;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.animations.CutsceneManager;
	import com.bored.games.darts.states.GameConfirm;
	import com.bored.games.darts.states.Gameplay;
	import com.bored.games.darts.states.CPUOpponentSelect;
	import com.bored.games.darts.states.GameStore;
	import com.bored.games.darts.states.IntroStory;
	import com.bored.games.darts.states.Initialization;
	import com.bored.games.darts.states.Attract;
	import com.bored.services.BoredServices;
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
	public class DartsFull extends Panel
	{
		protected var _myStateMachine:GameFSM;
		
		public function DartsFull() 
		{		
			super();
				
		}//end BasicPreloader() constructor.
		
		public function init(a_params:Object):void
		{
			
		}//end init()
		
		public function setBoredServices(a_servicesObj:Object):void
		{
			BoredServices.servicesObj = a_servicesObj;
			
		}//end setBoredServices()
		
		override protected function addedToStage(a_evt:Event = null):void
		{
			super.addedToStage();
			
			DartsGlobals.instance.gameType = DartsGlobals.TYPE_CRICKET;
			
			DartsGlobals.instance.stateMachine = _myStateMachine = new GameFSM();
			
			addStates();
			
			stage.align = StageAlign.TOP_LEFT;
			
			CutsceneManager.instance.loadScript("opening.scene");
			
			// set the global stage value.
			DartsGlobals.instance.stage = this.stage;
			
			DartsGlobals.instance.playerProfile = new UserProfile();
			
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
			_myStateMachine.addState(new LogoSplash("LogoSplash", _myStateMachine));
			_myStateMachine.addState(new Initialization("Initialization", _myStateMachine));
			_myStateMachine.addState(new Attract("Attract", _myStateMachine));
			_myStateMachine.addState(new IntroStory("IntroStory", _myStateMachine));
			_myStateMachine.addState(new CPUOpponentSelect("CPUOpponentSelect", _myStateMachine));
			_myStateMachine.addState(new GameConfirm("GameConfirm", _myStateMachine));
			_myStateMachine.addState(new Gameplay("Gameplay", _myStateMachine));
			
			_myStateMachine.addState(new GameStore("GameStore", _myStateMachine));
			_myStateMachine.addState(new Practice("Practice", _myStateMachine));
			_myStateMachine.addState(new Multiplayer("Multiplayer", _myStateMachine));
		}//end addStates()
		
	}//end class DartsFull
	
}//end package com.bored.games.darts