package com.bored.games.darts.input 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.input.ThrowController;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.input.InputController;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import mx.logging.targets.MiniDebugTarget;
	
	/**
	 * ...
	 * @author sam
	 */
	public class EasyThrowController extends ThrowController
	{
		private static const CIRCLE_STATE:int = 0;
		private static const RADIAL_STATE:int = 1;
		private static const THROW_STATE:int = 2;
		
		private var _state:int;
		
		protected var _buttonDown:Boolean;
		private var _mousePosition:Point;
		
		private var _radius:Number;
		private var _angle:Number;
		
		private var _direction:int;
		
		override public function startThrow(a_inputController:InputController):void
		{
			_buttonDown = false;
			_state = CIRCLE_STATE;
			
			_angle = 0;
			_radius = 95;
			_direction = -1;
			
			DartsGlobals.instance.screenSpace.addEventListener(Event.ENTER_FRAME, updateCursorPosition, false, 0, true);
			
			a_inputController.pause = false;
		}//end startThrow()
		
		override public function onInputUpdate(a_evt:InputStateEvent):void
		{
			if (a_evt.button) {
				if (_buttonDown) {
					// Do Nothing.
				} else {
					_state++;
					
					if (_state == THROW_STATE) {
						DartsGlobals.instance.screenSpace.removeEventListener(Event.ENTER_FRAME, updateCursorPosition);
						
						DartsGlobals.instance.gameManager.playerThrow(
							DartsGlobals.instance.gameManager.currentDart.position.x,
							DartsGlobals.instance.gameManager.currentDart.position.y,
							0,
							AppSettings.instance.dartSweetSpotThrust,
							0,
							AppSettings.instance.simulationStepScale
						);
					}
				}
			} else {
				if (_buttonDown) {
					// Nothing to do.
				} else {
					// Nothing to do??				
				}
			}
			
			_buttonDown = a_evt.button;
		}//end onInputUpdate()
		
		private function updateCursorPosition(evt:Event):void
		{
			if(_state == CIRCLE_STATE) {
				_angle += 9;
				if (_angle == 360) _angle = 0;				
			} else if (_state == RADIAL_STATE) {
				_radius += 10 * _direction;
				
				if ( _radius < 0 ) {
					_radius = 0;
					_direction = 1;
				} else if ( _radius > 95 ) {
					_radius = 95;
					_direction = -1;
				}
			}
			
			var x:Number = _radius * Math.cos(_angle * Math.PI / 180);
			var y:Number = _radius * Math.sin(_angle * Math.PI / 180);
			
			DartsGlobals.instance.gameManager.cursor.position.x = ((x * AppSettings.instance.cursorPositionZ * Math.tan(57.5 * Math.PI / 180))/ 700);
			DartsGlobals.instance.gameManager.cursor.position.y = ((-y * AppSettings.instance.cursorPositionZ * Math.tan(51 * Math.PI / 180))/ 550);
			DartsGlobals.instance.gameManager.cursor.position.z = AppSettings.instance.cursorPositionZ;
					
			DartsGlobals.instance.gameManager.currentDart.position.x = ((x * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 700);
			DartsGlobals.instance.gameManager.currentDart.position.y = ((-y * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 550);
			DartsGlobals.instance.gameManager.currentDart.position.z = 0;
		}//end updateMousePosition()
		
	}//end EasyThrowController

}//end com.bored.games.darts.input