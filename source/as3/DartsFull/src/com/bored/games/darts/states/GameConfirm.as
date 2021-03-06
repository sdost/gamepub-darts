﻿package com.bored.games.darts.states 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartFlightHexagon;
	import com.bored.games.darts.models.dae_DartFlightModHex;
	import com.bored.games.darts.models.dae_DartFlightOval;
	import com.bored.games.darts.models.dae_DartFlightPincer;
	import com.bored.games.darts.models.dae_DartFlightThin;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.player.ComputerPlayer;
	import com.bored.games.darts.player.LocalPlayer;
	import com.bored.games.darts.player.RemotePlayer;
	import com.bored.games.darts.profiles.UserProfile;
	import com.bored.games.darts.skins.DartSkin;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.GameConfirmScreen;
	import com.bored.services.client.ChatClient;
	import com.bored.services.client.GameClient;
	import com.bored.services.client.TurnBasedGameClient;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.sven.factories.ImageFactory;
	import com.sven.factories.SpriteFactory;
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
			DartsGlobals.addWarning("GameConfirm::onEnter()");
						
			var gameConfirmScreenImg:Sprite;
			
			try
			{
				trace("Confirm Screen Sprite Name: " + AppSettings.instance.confirmScreenSprite);
				
				gameConfirmScreenImg = SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.confirmScreenSprite);
				_gameConfirmScreen = new GameConfirmScreen(gameConfirmScreenImg, false, true);
				_gameConfirmScreen.addEventListener(GameConfirmScreen.PLAY_CLICKED_EVT, onPlay, false, 0, true);
				_gameConfirmScreen.addEventListener(GameConfirmScreen.BACK_CLICKED_EVT, onBack, false, 0, true);
				_gameConfirmScreen.addEventListener(GameConfirmScreen.LAUNCH_STORE_EVT, onLaunchStore, false, 0, true);
				DartsGlobals.instance.screenSpace.addChild(_gameConfirmScreen);
				
				DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("store_sound", "button_getdarts_mp3") );
				DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("play_sound", "button_play_mp3") );
				DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("back_sound", "button_back_mp3") );
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("GameConfirm::onEnter(): Caught error=" + e + ", stacktrace=" + e.getStackTrace());
			}
			
		}//end onEnter()
		
		public function onPlay(a_evt:Event):void
		{
			DartsGlobals.addWarning("GameConfirm::onPlay()");
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("play_sound");
			
			DartsGlobals.instance.localPlayer.setAbilitiesSlot(0, 0);
			DartsGlobals.instance.localPlayer.setAbilitiesSlot(1, 1);
			DartsGlobals.instance.localPlayer.setAbilitiesSlot(2, 2);
			
			DartsGlobals.instance.opponentPlayer.setAbilitiesSlot(0, 0);
			DartsGlobals.instance.opponentPlayer.setAbilitiesSlot(1, 1);
			DartsGlobals.instance.opponentPlayer.setAbilitiesSlot(2, 2);
			
			DartsGlobals.instance.gameManager.registerPlayer( DartsGlobals.instance.localPlayer );			
			
			onReady();
		}//end onPlay()
		
		private function onReady(a_evt:Event = null):void
		{			
			DartsGlobals.instance.gameManager.registerPlayer( DartsGlobals.instance.opponentPlayer );			
			(this.stateMachine as GameFSM).transitionToNextState();
		}//end onReady()
		
		private function onBack(a_evt:Event):void
		{			
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("back_sound");
			
			(this.stateMachine as GameFSM).transitionToStateNamed("CPUOpponentSelect");
		}//end onBack()
		
		private function onLaunchStore(a_evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("store_sound");
			
			(this.stateMachine as GameFSM).transitionToStateNamed("GameStore");
		}//end onLaunchStore()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			DartsGlobals.addWarning("GameConfirm::onExit()");
			
			_gameConfirmScreen.removeEventListener(GameConfirmScreen.BACK_CLICKED_EVT, onBack);
			_gameConfirmScreen.removeEventListener(GameConfirmScreen.PLAY_CLICKED_EVT, onPlay);
			_gameConfirmScreen.removeEventListener(GameConfirmScreen.LAUNCH_STORE_EVT, onLaunchStore);
			
			_gameConfirmScreen.destroy();
			
			_gameConfirmScreen = null;
		}//end onExit()
		
	}//end class Initialization
	
}//end package com.bored.games.darts.states