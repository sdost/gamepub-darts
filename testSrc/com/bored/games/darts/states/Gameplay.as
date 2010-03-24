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
	import com.bored.games.darts.ui.GameplayScreen;
	import com.bored.games.events.InputStateEvent;
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
	public class Gameplay extends State
	{				
		private var _gameplayScreen:GameplayScreen;
		
		private var _gameManager:DartsGameLogic;
		
		private var _inputController:MouseInputController;
		private var _throwController:ThrowController;
		
		private var _releasePos:Vector3D;
		private	var _thrust:Number;
		private var _angle:Number;
		private var _grav:Number;
		
		private var _darts:Vector.<Dart>;
		private var _currDartIdx:uint;
		
		private var _currentTurn:DartsTurn;
		private var _turns:uint = 0;
		
		private var _trackShot:Boolean = true;
						
		public function Gameplay(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end Gameplay() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{									
			_inputController = new MouseInputController(DartsGlobals.instance.screenSpace);
			_throwController = new GestureThrowController();
			
			DartsGlobals.instance.gameManager.inputController = _inputController;
			DartsGlobals.instance.gameManager.throwController = _throwController;
			DartsGlobals.instance.gameManager.newGame();
			
			try
			{				
				_gameplayScreen = new GameplayScreen();
				
				DartsGlobals.instance.screenSpace.addChild(_gameplayScreen);
				
				DartsGlobals.instance.stage.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
				
				DartsGlobals.instance.gameManager.startNewTurn();
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("Gameplay::onEnter(): Caught error=" + e.getStackTrace());
			}			
		}//end onEnter()
		
		private function update(a_evt:Event):void
		{
			DartsGlobals.instance.gameManager.update(getTimer());
			_gameplayScreen.render();
		}//end updateDisplay()
				
		private function finished(...args):void
		{
		}//end finished()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			_gameplayScreen.removeEventListener(Event.ENTER_FRAME, update);
		}//end onExit()
		
	}//end class Gameplay

}//end package com.bored.games.darts.states