package com.bored.games.darts.states 
{
	import com.bored.games.input.InputController;
	import com.bored.games.input.MouseInputController;
	import com.bored.games.darts.input.GestureThrowController;
	import com.bored.games.darts.input.ThrowController;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.logic.AIProfile;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.DartsTurn;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.GameStoreScreen;
	import com.bored.games.events.InputStateEvent;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.sven.utils.AppSettings;
	import com.sven.utils.SpriteFactory;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import com.bored.games.darts.DartsGlobals;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import mx.binding.Binding;
	import mx.binding.utils.BindingUtils;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class GameStore extends State
	{		
		private var _gameStoreScreen:GameStoreScreen;
						
		public function GameStore(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end GameStore() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{						
			var gameStoreScreenImg:MovieClip;
			
			try
			{
				gameStoreScreenImg = new MovieClip();
				_gameStoreScreen = new GameStoreScreen(gameStoreScreenImg, false, true);
				DartsGlobals.instance.screenSpace.addChild(_gameStoreScreen);
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("GameStore::onEnter(): Caught error=" + e);
			}
			
			DartsGlobals.instance.externalServices.showStore();
			DartsGlobals.instance.externalServices.addEventListener(AbstractExternalService.STORE_HIDDEN, onStoreHidden);
			
		}//end onEnter()
		
		private function onStoreHidden(a_evt:Event):void
		{
			(this.stateMachine as GameFSM).transitionToStateNamed("Attract");
		}//end onStoreHidden()
				
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
		
	}//end class GameStore

}//end package com.bored.games.darts.states