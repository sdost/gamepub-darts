package com.bored.games.darts.states 
{
	import com.bored.games.assets.GameplayScreen_MC;
	import com.bored.games.controllers.InputController;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.ui.GameplayScreen;
	import com.bored.games.events.InputStateEvent;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.input.MouseManager;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Gameplay extends State
	{		
		private var _gameplayScreen:GameplayScreen;
		
		private var _buttonDown:Boolean;
		private var _inputController:InputController;
		
		private var _releasePos:Vector3D = new Vector3D(0, -.6, 2);
		private	var _thrust:Number = 20;
		private var _angleX:Number = 3;
		private	var _angleY:Number = 0;
		private var _grav:Number = 9.8;
		private var _dist:Number = 20;
		
		private var _darts:Array;
		
		private var _currDartIdx:uint;
		
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
				
				DartsGlobals.instance.screenSpace.addChild(_gameplayScreen);
				
				_inputController = DartsGlobals.instance.inputController;
				_inputController.addEventListener(InputStateEvent.UPDATE, inputUpdate);
				_inputController.pause = false;
				_buttonDown = false;
				
				_darts = new Array();
				_darts.push(new Dart());
				_darts.push(new Dart());
				_darts.push(new Dart());
				
				_currDartIdx = 0;
				
				
				
				_gameplayScreen.addEventListener(Event.ENTER_FRAME, update, false, 0, false);
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("Gameplay::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
		
		private function update(a_evt:Event):void
		{
			_gameplayScreen.render();
		}//end updateDisplay()
		
		private function inputUpdate(a_evt:InputStateEvent):void
		{
			if (_buttonDown)
			{
				if (a_evt.button) { // dragging
					MouseManager.updateDrag(a_evt.x, a_evt.y);
					_angleY = MouseManager.calculateDragAngle()-90;
					var len:Number = MouseManager.calculateDragLength() / 100;
					if ( len > 1 ) len = 1;
					_angleX = len * 10;
					_thrust = len * 50;
				} else {
					_buttonDown = false;					
					(_darts[_currDartIdx] as Dart).initThrowParams(_releasePos.y, _releasePos.z, _thrust, _angleX, _grav, _dist);
				}
			} else {
				if (a_evt.button) {
					_buttonDown = true;
					MouseManager.beginDrag(a_evt.x, a_evt.y);
				} else {
					_releasePos.x = (a_evt.x)/100;
					_releasePos.y = (a_evt.y)/100;
					_releasePos.z = 2;
					
					(_darts[_currDartIdx] as Dart).position.setCoords(_releasePos.x, _releasePos.y);
				}
			}
		}//end onInputUpdate()
		
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