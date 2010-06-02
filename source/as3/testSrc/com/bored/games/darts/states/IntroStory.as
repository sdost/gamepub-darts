package com.bored.games.darts.states 
{
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.bored.games.animations.Cutscene;
	import com.bored.games.animations.CutsceneManager;
	import com.bored.games.darts.assets.buttons.SkipAllButton_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.inassets.ui.buttons.MightyButton;
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
		
		private var _skipButton:MightyButton;
		
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
			
			_skipButton = new MightyButton(new SkipAllButton_MC());
			_skipButton.pause(false);
			_skipButton.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onSkipClicked, false, 0, true);
			
			_skipButton.buttonContents.x = AppSettings.instance.skipButtonPositionX;
			_skipButton.buttonContents.y = AppSettings.instance.skipButtonPositionY;
			
			DartsGlobals.instance.screenSpace.addChild(_openingCutscene);
			DartsGlobals.instance.screenSpace.addChild(_skipButton.buttonContents);
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("skipall_sound", "button_skipall_mp3") );
			
			_openingCutscene.startScene();
			
			_openingCutscene.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}//end onEnter()
		
		private function onClick(a_evt:MouseEvent):void
		{
			_openingCutscene.advanceDialogue();
		}//end onClick()
		
		private function onSkipClicked(evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("skipall_sound");
			
			(this.stateMachine as GameFSM).transitionToNextState();
		}//end onSkipClicked()
		
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
			DartsGlobals.instance.screenSpace.removeChild(_skipButton.buttonContents);
			
			_openingCutscene = null;
			_skipButton = null;
		}//end onExit()
		
	}//end class AttractState
	
}//end package com.bored.games.darts.states