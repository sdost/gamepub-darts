package com.bored.games.darts.input 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.input.ThrowController;
	import com.bored.games.darts.ui.modals.ThrowTutorialModal;
	import com.bored.games.darts.events.InputStateEvent;
	import com.bored.games.darts.input.InputController;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class TwoClickThrowController extends ThrowController
	{
		private static const INIT_THROW:int = 0
		private static const START_THROW:int = 1;
		private static const END_THROW:int = 2;
		
		private var _state:int;
		
		protected var _buttonDown:Boolean;
		private var _mousePosition:Point;
		
		private var _timer:Timer;
		
		private var _direction:int;
		
		override public function startThrow(a_inputController:InputController):void
		{	
			_buttonDown = false;
			_state = INIT_THROW;
			
			trace("TwoClickThrowController::startThrow() -- _state = " + _state);
			
			_timer = new Timer(AppSettings.instance.simpleThrowUpdate);
			_timer.addEventListener(TimerEvent.TIMER, updateCursorPosition, false, 0, true);			
			_timer.start();
			
			a_inputController.pause = false;
		}//end startThrow()
		
		override public function onInputUpdate(a_evt:InputStateEvent):void
		{			
			if ( _mousePosition == null )
			{
				_mousePosition = new Point();
			}
			_mousePosition.x = a_evt.x;
			_mousePosition.y = a_evt.y;
			
			if (!a_evt.button) {
				if (_buttonDown) {
					_state++;
				}
			}
			
			if (_state == INIT_THROW)
			{
				//Mouse.hide();
				DartsGlobals.instance.gameManager.cursor.x = (((_mousePosition.x - 350) * AppSettings.instance.cursorPositionZ * Math.tan(57.5 * Math.PI / 180))/ 700);
				DartsGlobals.instance.gameManager.cursor.y = (((275 - _mousePosition.y) * AppSettings.instance.cursorPositionZ * Math.tan(51 * Math.PI / 180))/ 550);
				DartsGlobals.instance.gameManager.cursor.z = AppSettings.instance.cursorPositionZ;
				
				DartsGlobals.instance.gameManager.currentDart.x = (((_mousePosition.x - 350) * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 700);
				DartsGlobals.instance.gameManager.currentDart.y = (((275 - _mousePosition.y) * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 550);
				DartsGlobals.instance.gameManager.currentDart.z = 0;
			}
			
			_buttonDown = a_evt.button;
		}//end onInputUpdate()
		
		private function updateCursorPosition(evt:Event):void
		{
			switch(_state) {
				case START_THROW:
					_show = true;
					_thrust += _direction;
				
					if ( _thrust < AppSettings.instance.dartMinThrust ) {
						_thrust = AppSettings.instance.dartMinThrust;
						_direction = 1;
					} else if ( _thrust > AppSettings.instance.dartMaxThrust ) {
						_thrust = AppSettings.instance.dartMaxThrust;
						_direction = -1;
					}
				break;
				case END_THROW:
					_show = false;
					_timer.removeEventListener(TimerEvent.TIMER, updateCursorPosition);
					_timer.stop();
					
					_timer = null;
						
					DartsGlobals.instance.gameManager.playerThrow(
						DartsGlobals.instance.gameManager.currentDart.x,
						DartsGlobals.instance.gameManager.currentDart.y,
						0,
						AppSettings.instance.dartSweetSpotThrust,
						0,
						AppSettings.instance.simulationStepScale
					);
				break;
				default:
				break;
			}
		}//end updateMousePosition()
		
		override public function resetThrowParams():void 
		{
			super.resetThrowParams();
			
			_buttonDown = false;
			_state = INIT_THROW;
			
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, updateCursorPosition);			
				_timer.stop();
			}
		}
		
	}//end TwoClickThrowController

}//end com.bored.games.darts.input