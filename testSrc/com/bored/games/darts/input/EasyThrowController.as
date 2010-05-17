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
		
		private var _timer:Timer;
		
		private var _direction:int;
		
		override public function startThrow(a_inputController:InputController):void
		{			
			_buttonDown = false;
			_state = CIRCLE_STATE;
			
			_angle = 0;
			_radius = 95;
			_direction = -1;
			
			_timer = new Timer(AppSettings.instance.easyThrowUpdate);
			_timer.addEventListener(TimerEvent.TIMER, updateCursorPosition, false, 0, true);			
			_timer.start();
			
			a_inputController.pause = false;
		}//end startThrow()
		
		override public function onInputUpdate(a_evt:InputStateEvent):void
		{
			if (!a_evt.button) {
				if (_buttonDown) {
					_state++;
				}
			}
			
			_buttonDown = a_evt.button;
		}//end onInputUpdate()
		
		private function updateCursorPosition(evt:Event):void
		{
			switch(_state) {
				case CIRCLE_STATE:
					_angle += 18;
					if (_angle == 360) _angle = 0;				
				break;
				case RADIAL_STATE:
					_radius += 10 * _direction;
				
					if ( _radius < 0 ) {
						_radius = 0;
						_direction = 1;
					} else if ( _radius > 95 ) {
						_radius = 95;
						_direction = -1;
					}
				break;
				case THROW_STATE:
					_timer.removeEventListener(TimerEvent.TIMER, updateCursorPosition);
					_timer.stop();
						
					DartsGlobals.instance.gameManager.playerThrow(
						DartsGlobals.instance.gameManager.currentDart.position.x,
						DartsGlobals.instance.gameManager.currentDart.position.y,
						0,
						AppSettings.instance.dartSweetSpotThrust,
						0,
						AppSettings.instance.simulationStepScale
					);
				break;
				default:
				break;
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