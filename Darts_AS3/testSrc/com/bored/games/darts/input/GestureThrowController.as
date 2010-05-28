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
	public class GestureThrowController extends ThrowController
	{
		protected var _buttonDown:Boolean;
		
		private var _mousePosition:Point;
		
		private var _lastMove:Number;
		private var _oX:Number;
		private var _oY:Number;
		private var _velX:Number;
		private var _velY:Number;
		private var _speed:Number;
		private var _num:Number;
		private var _cumAvgSpeed:Number;
		
		private var _mouseTimer:Timer;
		
		override public function startThrow(a_inputController:InputController):void
		{
			a_inputController.pause = false;
			
			if ( !DartsGlobals.instance.externalServices.getData("seenThrowTutorial") )
			{
				DartsGlobals.instance.showModalPopup(ThrowTutorialModal);
				DartsGlobals.instance.gameManager.pause(true);
			}
		}//end startThrow()
		
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
					
					_mouseTimer.removeEventListener( TimerEvent.TIMER, updateCurrentMouseVelocity );
					_mouseTimer.stop();
					_mouseTimer.reset();
				}
			} else {
				if ( a_evt.button ) {
					resetThrowParams();					
					_lastMove = 0;
					_oX = _mousePosition.x;
					_oY = _mousePosition.y;
					_velX = 0;
					_velY = 0;
					_speed = 0;
					_cumAvgSpeed = 0;
					_num = 0;
					
					DartsGlobals.instance.gameManager.currentDart.pullBack();
					
					if ( _mouseTimer == null ) 
					{
						_mouseTimer = new Timer(50);
					}
					Mouse.show();
					_mouseTimer.addEventListener( TimerEvent.TIMER, updateCurrentMouseVelocity );
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
		
		private function updateCurrentMouseVelocity(e:TimerEvent):void
		{			
			var nX:Number = _mousePosition.x;
			var nY:Number = _mousePosition.y;
			var dx:Number = nX - _oX;
			var dy:Number = nY - _oY;
			var oldVelX:Number = _velX;
			var oldVelY:Number = _velY;
			_lastMove = Math.sqrt( dx * dx + dy * dy );			
    
			_oX = nX;
			_oY = nY;
			_velX = dx * 1000 / _mouseTimer.delay;
			_velY = dy * 1000 / _mouseTimer.delay;
			_speed = Math.sqrt( _velX * _velX + _velY * _velY );
			
			if ( _velY * oldVelY < 0 ) {
				_cumAvgSpeed = 0;
				_thrust = 0;
				_lean = 0;
				_num = 0;
				return;
			}
			
			if ( Math.floor(_lastMove) < 1 ) {
				_cumAvgSpeed = 0;
				_thrust = 0;
				_lean = 0;
				_num = 0;
			} else { 			
				_cumAvgSpeed = _cumAvgSpeed + ((_speed - _cumAvgSpeed) / ++_num);
				_thrust = clamp((_cumAvgSpeed * AppSettings.instance.dartThrustScale), 0, AppSettings.instance.dartMaxThrust);
				_lean = _velX * AppSettings.instance.dartLeanScale;
			}
			
			/*
			 while( horse.dead )
			 {
				this.beat(horse);
			 }
			 */
		}//end updateCurrentMouseVelocity()
		
		private function clamp(a_num:Number, a_min:Number, a_max:Number):Number
		{
			if ( a_num <= a_min ) return a_min;
			
			else if ( a_num >= a_max ) return a_max;
			
			else return a_num;
		}//end clamp()
		
	}//end GestureThrowController

}//end com.bored.games.darts.input