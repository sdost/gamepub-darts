package com.bored.games.darts.input 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.input.ThrowController;
	import com.bored.games.darts.ui.modals.ThrowTutorialModal;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.input.InputController;
	import com.sven.utils.AppSettings;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import mx.logging.targets.MiniDebugTarget;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SimplifiedThrowController extends ThrowController
	{
		protected var _buttonDown:Boolean;
		
		private var _mousePosition:Point;
		
		private var _mouseTimer:Timer;
		
		private var _direction:int;
		
		override public function onInputUpdate(a_evt:InputStateEvent):void
		{
			if ( _mousePosition == null )
			{
				_mousePosition = new Point();
			}
			_mousePosition.x = a_evt.x;
			_mousePosition.y = a_evt.y;
			
			if (_buttonDown) {
				if ( !a_evt.button ) {
					
					_mouseTimer.removeEventListener( TimerEvent.TIMER, updateThrust );
					_mouseTimer.stop();
					_mouseTimer.reset();
					
					if ( _thrust >= DartsGlobals.instance.gameManager.currentDart.minThrust ) 
					{
						var obj:Object = DartsGlobals.instance.gameManager.playerThrow(
							DartsGlobals.instance.gameManager.currentDart.position.x,
							DartsGlobals.instance.gameManager.currentDart.position.y,
							0,
							_thrust,
							_lean,
							AppSettings.instance.simulationStepScale
						);
						
						_trueThrust = obj.t;
						_trueAngle = obj.ang;
					} 
					else
					{
						DartsGlobals.instance.gameManager.currentDart.resetThrow();
					}
				}
			} else {
				if ( a_evt.button ) {
					resetThrowParams();					
					
					DartsGlobals.instance.gameManager.currentDart.pullBack();
					
					if ( _mouseTimer == null ) 
					{
						_mouseTimer = new Timer(AppSettings.instance.simpleThrowUpdate);
					}
					Mouse.show();
					_mouseTimer.addEventListener( TimerEvent.TIMER, updateThrust );
					_mouseTimer.start();
				} else {
					Mouse.hide();
					DartsGlobals.instance.gameManager.cursor.position.x = (((a_evt.x - 350) * AppSettings.instance.cursorPositionZ * Math.tan(57.5 * Math.PI / 180))/ 700);
					DartsGlobals.instance.gameManager.cursor.position.y = (((275 - a_evt.y) * AppSettings.instance.cursorPositionZ * Math.tan(51 * Math.PI / 180))/ 550);
					DartsGlobals.instance.gameManager.cursor.position.z = AppSettings.instance.cursorPositionZ;
					
					DartsGlobals.instance.gameManager.currentDart.position.x = (((a_evt.x - 350) * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 700);
					DartsGlobals.instance.gameManager.currentDart.position.y = (((275 - a_evt.y) * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 550);
					DartsGlobals.instance.gameManager.currentDart.position.z = 0;
				}
			}
			
			_buttonDown = a_evt.button;
		}//end onInputUpdate()
		
		private function updateThrust(e:TimerEvent):void
		{			
			_thrust += _direction;
				
			if ( _thrust < AppSettings.instance.dartMinThrust ) {
				_thrust = AppSettings.instance.dartMinThrust;
				_direction = 1;
			} else if ( _thrust > AppSettings.instance.dartMaxThrust ) {
				_thrust = AppSettings.instance.dartMaxThrust;
				_direction = -1;
			}
		}//end updateCurrentMouseVelocity()
		
	}//end SimplifiedThrowController

}//end com.bored.games.darts.input