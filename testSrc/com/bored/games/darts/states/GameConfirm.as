﻿package com.bored.games.darts.states 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.darts.assets.screen.ConfirmScreen_MC;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.player.ComputerPlayer;
	import com.bored.games.darts.player.LocalPlayer;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.GameConfirmScreen;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class GameConfirm extends State
	{		
		private var _gameConfirmScreen:GameConfirmScreen;
		
		public function GameConfirm(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end GameConfirm() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{			
			trace("GameConfirm::onEnter()");
					
			var gameConfirmScreenImg:MovieClip;
			
			try
			{
				gameConfirmScreenImg = new ConfirmScreen_MC();
				_gameConfirmScreen = new GameConfirmScreen(gameConfirmScreenImg, false, true);
				_gameConfirmScreen.addEventListener(GameConfirmScreen.PLAY_CLICKED_EVT, onPlay, false, 0, true);
				_gameConfirmScreen.addEventListener(GameConfirmScreen.BACK_CLICKED_EVT, onBack, false, 0, true);
				_gameConfirmScreen.addEventListener(GameConfirmScreen.LAUNCH_STORE_EVT, onLaunchStore, false, 0, true);
				DartsGlobals.instance.screenSpace.addChild(_gameConfirmScreen);
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("Attract::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
		
		public function onPlay(a_evt:Event):void
		{
			DartsGlobals.instance.gameManager.registerPlayer( DartsGlobals.instance.localPlayer );
			DartsGlobals.instance.gameManager.registerPlayer( DartsGlobals.instance.cpuPlayer );
			
			(this.stateMachine as GameFSM).transitionToNextState();
		}//end onPlay()
		
		public function onBack(a_evt:Event):void
		{			
			(this.stateMachine as GameFSM).transitionToStateNamed("CPUOpponentSelect");
		}//end onBack()
		
		public function onLaunchStore(a_evt:Event):void
		{
			(this.stateMachine as GameFSM).transitionToStateNamed("GameStore");
		}//end onLaunchStore()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			_gameConfirmScreen.removeEventListener(GameConfirmScreen.BACK_CLICKED_EVT, onBack);
			_gameConfirmScreen.removeEventListener(GameConfirmScreen.PLAY_CLICKED_EVT, onPlay);
			_gameConfirmScreen.removeEventListener(GameConfirmScreen.LAUNCH_STORE_EVT, onLaunchStore);
		}//end onExit()
		
	}//end class Initialization
	
}//end package com.bored.games.darts.states