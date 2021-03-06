﻿package com.bored.games.darts.states 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.modals.PracticeModeModal;
	import com.bored.games.darts.ui.TitleScreen;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
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
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	/**
	 * ....
	 * @author Samuel Dost
	 */
	public class Attract extends State
	{
		private var _titleScreen:TitleScreen;
		
		public function Attract(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end Attract() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			DartsGlobals.addWarning("Attract::onEnter()");
			
			DartsGlobals.instance.hideControlPanel();
			
			var titleScreenImg:Sprite;
			
			try
			{
				titleScreenImg = SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.attractScreenSprite);
				_titleScreen = new TitleScreen(titleScreenImg, false, true);
				_titleScreen.addEventListener(TitleScreen.STORY_GAME_CLICKED_EVT, onStoryGameClicked, false, 0, true);
				_titleScreen.addEventListener(TitleScreen.PRACTICE_CRICKET_GAME_CLICKED_EVT, onPracticeGameClicked, false, 0, true);
				_titleScreen.addEventListener(TitleScreen.PRACTICE_501_GAME_CLICKED_EVT, onPracticeGameClicked, false, 0, true);
				_titleScreen.addEventListener(TitleScreen.MULTIPLAYER_GAME_CLICKED_EVT, onMultiplayerGameClicked, false, 0, true);
				DartsGlobals.instance.screenSpace.addChild(_titleScreen);
				
				DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("title_sound", "button_title_mp3") );
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("Attract::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
			
		private function onStoryGameClicked(e_evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("title_sound");
			
			DartsGlobals.instance.gameType = DartsGlobals.TYPE_CRICKET;
			DartsGlobals.instance.gameMode = DartsGlobals.GAME_STORY;
			DartsGlobals.instance.throwMode = DartsGlobals.THROW_EXPERT;
			
			(this.stateMachine as GameFSM).transitionToStateNamed("IntroStory");
		}//end onResumeGameClicked();

		private function onPracticeGameClicked(e_evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("title_sound");
			
			if (e_evt.type == TitleScreen.PRACTICE_CRICKET_GAME_CLICKED_EVT)
			{
				DartsGlobals.instance.gameType = DartsGlobals.TYPE_CRICKET;
			}
			else if (e_evt.type == TitleScreen.PRACTICE_501_GAME_CLICKED_EVT)
			{
				DartsGlobals.instance.gameType = DartsGlobals.TYPE_FIVEOHONE;
			}
			
			DartsGlobals.instance.gameMode = DartsGlobals.GAME_PRACTICE;
			
			DartsGlobals.instance.showModalPopup(PracticeModeModal);
		}//end onNewGameClicked();
		
		private function onMultiplayerGameClicked(e_evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("title_sound");
			
			/*
			if (e_evt.type == TitleScreen.MULTIPLAYER_CRICKET_GAME_CLICKED_EVT)
			{
				DartsGlobals.instance.multiplayerGameId = AppSettings.instance.cricketMultiplayerGameId;
				DartsGlobals.instance.gameType = DartsGlobals.TYPE_CRICKET;
			}
			else if (e_evt.type == TitleScreen.MULTIPLAYER_501_GAME_CLICKED_EVT)
			{
				DartsGlobals.instance.multiplayerGameId = AppSettings.instance.fiveOhOneMultiplayerGameId;
				DartsGlobals.instance.gameType = DartsGlobals.TYPE_FIVEOHONE;
			}
			*/
			
			DartsGlobals.instance.gameMode = DartsGlobals.GAME_MULTIPLAYER;
			DartsGlobals.instance.throwMode = DartsGlobals.THROW_BEGINNER;
			
			(this.stateMachine as GameFSM).transitionToStateNamed("Multiplayer");
		}//end onResumeGameClicked();
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			DartsGlobals.addWarning("Attract::onExit()");
			
			_titleScreen.removeEventListener(TitleScreen.STORY_GAME_CLICKED_EVT, onStoryGameClicked);
			_titleScreen.removeEventListener(TitleScreen.PRACTICE_CRICKET_GAME_CLICKED_EVT, onPracticeGameClicked);
			_titleScreen.removeEventListener(TitleScreen.PRACTICE_501_GAME_CLICKED_EVT, onPracticeGameClicked);
			_titleScreen.removeEventListener(TitleScreen.MULTIPLAYER_GAME_CLICKED_EVT, onMultiplayerGameClicked);
			
			_titleScreen.destroy();
			
			_titleScreen = null;
		}//end onExit()
		
	}//end class Attract
	
}//end package com.bored.games.darts.states