package com.bored.games.darts.states 
{
	import com.bored.games.assets.GameplayScreen_MC;
	import com.bored.games.darts.ui.GameplayScreen;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import com.bored.games.darts.DartsGlobals;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Gameplay extends State
	{		
		private var _gameplayScreen:Sprite;
		
		public function Gameplay(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end Gameplay() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			var gameplayScreenImg:MovieClip;
			
			try
			{
				gameplayScreenImg = new GameplayScreen_MC();
				_gameplayScreen = new GameplayScreen(gameplayScreenImg, false, true);
				_gameplayScreen.addEventListener(GameplayScreen.CALCULATE_CLICKED_EVT, onCalculateClicked, false, 0, true);
				
				DartsGlobals.instance.screenSpace.addChild(_gameplayScreen);
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("Gameplay::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
		
		private function onCalculateClicked(e:Event):void
		{
			// TODO: probably nothing...
		}//end onCalculateClicked()
		
		private function finished(...args):void
		{
			//(this.stateMachine as GameFSM).transitionToNextState();
			
		}//end finished()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			
			
		}//end onExit()
		
	}//end class Gameplay

}//end package com.bored.games.darts.states