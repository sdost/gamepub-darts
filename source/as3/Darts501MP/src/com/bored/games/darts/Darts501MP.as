﻿package com.bored.games.darts
{
	import com.bored.games.darts.profiles.UserProfile;
	import com.bored.games.darts.states.Multiplayer;
	import com.bored.games.darts.states.MultiplayerGameConfirm;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.animations.CutsceneManager;
	import com.bored.games.darts.states.GameConfirm;
	import com.bored.games.darts.states.Gameplay;
	import com.bored.games.darts.states.Initialization;
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
	public class Darts501MP extends Panel
	{
		protected var _myStateMachine:GameFSM;
		
		public function Darts501MP() 
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
		
			DartsGlobals.instance.gameType = DartsGlobals.TYPE_FIVEOHONE;
			DartsGlobals.instance.gameMode = DartsGlobals.GAME_MULTIPLAYER;
			DartsGlobals.instance.throwMode = DartsGlobals.THROW_BEGINNER;
			
			
			DartsGlobals.instance.stateMachine = _myStateMachine = new GameFSM();
			
			addStates();
			
			stage.align = StageAlign.TOP_LEFT;
			
			//CutsceneManager.instance.loadScript("opening.scene");
			
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
			_myStateMachine.addState(new Initialization("Initialization", _myStateMachine));
			_myStateMachine.addState(new Multiplayer("Multiplayer", _myStateMachine));
			_myStateMachine.addState(new MultiplayerGameConfirm("GameConfirm", _myStateMachine));
			_myStateMachine.addState(new Gameplay("Gameplay", _myStateMachine));			
		}//end addStates()
		
	}//end class Darts501MP
	
}//end package com.bored.games.darts