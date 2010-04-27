package com.bored.games.darts.states 
{
	import com.bored.games.darts.assets.screens.TitleScreen_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.TitleScreen;
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
			var titleScreenImg:MovieClip;
			
			try
			{
				titleScreenImg = new TitleScreen_MC();
				_titleScreen = new TitleScreen(titleScreenImg, false, true);
				_titleScreen.addEventListener(TitleScreen.EASY_GAME_CLICKED_EVT, onEasyGameClicked, false, 0, true);
				_titleScreen.addEventListener(TitleScreen.HARD_GAME_CLICKED_EVT, onHardGameClicked, false, 0, true);
				DartsGlobals.instance.screenSpace.addChild(_titleScreen);
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("Attract::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
		
		private function onEasyGameClicked(e_evt:Event):void
		{
			DartsGlobals.instance.gameMode = DartsGlobals.EASY;
			(this.stateMachine as GameFSM).transitionToNextState();
			
		}//end onNewGameClicked();
		
		private function onHardGameClicked(e_evt:Event):void
		{
			DartsGlobals.instance.gameMode = DartsGlobals.HARD;
			(this.stateMachine as GameFSM).transitionToNextState();
		}//end onResumeGameClicked();
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{			
			_titleScreen.removeEventListener(TitleScreen.EASY_GAME_CLICKED_EVT, onEasyGameClicked);
			_titleScreen.removeEventListener(TitleScreen.HARD_GAME_CLICKED_EVT, onHardGameClicked);	
			
			_titleScreen.destroy();
			
			_titleScreen = null;
		}//end onExit()
		
	}//end class Attract
	
}//end package com.bored.games.darts.states