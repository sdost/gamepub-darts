package com.bored.games.darts.input 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.input.ThrowController;
	import com.bored.games.darts.ui.hud.ThrowIndicatorV4;
	import com.bored.games.darts.ui.modals.BasicThrowTutorialModal;
	import com.bored.games.darts.events.InputStateEvent;
	import com.bored.games.darts.input.InputController;
	import com.sven.factories.MovieClipFactory;
	import com.sven.utils.AppSettings;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ThreeClickThrowController extends ThrowController
	{
		private static const INIT_THROW:int = 0
		private static const START_Y_THROW:int = 1;
		private static const START_X_THROW:int = 2;
		private static const END_THROW:int = 3;
		
		private var _throwCursor:ThrowIndicatorV4;
		
		private var _state:int;
		
		protected var _buttonActive:Boolean;
		private var _mousePosition:Point;
		
		private var _timer:Timer;
		
		private var _direction:int;
		
		private var _lastInputStateEvent:InputStateEvent;
		
		public function ThreeClickThrowController()
		{
			_throwCursor = new ThrowIndicatorV4(MovieClipFactory.getMovieClipByQualifiedName("com.bored.games.darts.assets.hud.ThrowIndicatorCursor_MC"));
			_throwCursor.registerThrowController(this);
		}//end constructor()
		
		override public function startThrow(a_inputController:InputController):void
		{		
			_buttonActive = false;
			this.state = INIT_THROW;
			
			//DartsGlobals.addWarning("ThreeClickThrowController::startThrow(): this.state == INIT_THROW");
			
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, updateCursorPosition);			
				_timer.stop();
				_timer = null;
			}
			
			_timer = new Timer(AppSettings.instance.simpleThrowUpdate);
			_timer.addEventListener(TimerEvent.TIMER, updateCursorPosition, false, 0, true);			
			_timer.start();
			
			if ( !DartsGlobals.instance.externalServices.getData("seenBasicThrowTutorial") && DartsGlobals.instance.gameMode == DartsGlobals.GAME_PRACTICE )
			{
				DartsGlobals.instance.showModalPopup(BasicThrowTutorialModal);
				//DartsGlobals.instance.gameManager.pause(true);
			} 
			else 
			{				
				a_inputController.pause = false;
			}
			
			if (!_lastInputStateEvent)
			{
				_lastInputStateEvent = new InputStateEvent(InputStateEvent.UPDATE, 427, 325);
			}
			
			_lastInputStateEvent.origMouseEvt = null;
			this.onInputUpdate(_lastInputStateEvent);
			
		}//end startThrow()
		
		/**
		 * This is triggered via InputStateEvent dispatched by the MouseInputController, 
		 * for Mouse move, up, over, and roll-out events on the DartsGlobals.instance.screenSpace.
		 * @param	a_evt
		 */
		override public function onInputUpdate(a_evt:InputStateEvent):void
		{			
			_lastInputStateEvent = a_evt;
			
			if ( _mousePosition == null )
			{
				_mousePosition = new Point();
			}
			_mousePosition.x = a_evt.x;
			_mousePosition.y = a_evt.y;
			
			// otherwise we act on mouse-down.
			if (a_evt.origMouseEvt)
			{
				if (_buttonActive)
				{
					if (a_evt.origMouseEvt.type == MouseEvent.MOUSE_UP)
					{
						// no longer active!
						_buttonActive = false;
					}
					else if (a_evt.origMouseEvt.type == MouseEvent.ROLL_OUT)
					{
						// we are currently active, but the three-click throwing method doesn't care...just wait for the next activation of the throw.
						//_buttonActive = false;
					}
				}
				else
				{
					// the button is not currently active, so check for what makes it active, and increment our state, should we find it.
					if (a_evt.origMouseEvt.type == MouseEvent.MOUSE_DOWN)
					{
						_buttonActive = true;
						
						// mouse-down, go to next state.
						this.state++;
					}
				}
			}
			
			if (this.state == INIT_THROW)
			{
				//Mouse.hide();
				if (DartsGlobals.instance.gameManager)
				{
					if (DartsGlobals.instance.gameManager.cursor)
					{
						DartsGlobals.instance.gameManager.cursor.x = (((_mousePosition.x - 350) * AppSettings.instance.cursorPositionZ * Math.tan(57.5 * Math.PI / 180))/ 700);
						DartsGlobals.instance.gameManager.cursor.y = (((275 - _mousePosition.y) * AppSettings.instance.cursorPositionZ * Math.tan(51 * Math.PI / 180))/ 550);
						DartsGlobals.instance.gameManager.cursor.z = AppSettings.instance.cursorPositionZ;
					}
					else
					{
						DartsGlobals.addWarning("ThreeClickThrowController::onInputUpdate(): DartsGlobals.instance.gameManager.cursor=" + DartsGlobals.instance.gameManager.cursor + ", IS THIS A PROBLEM?");
					}
					
					if (DartsGlobals.instance.gameManager.currentDart)
					{
						DartsGlobals.instance.gameManager.currentDart.x = (((_mousePosition.x - 350) * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 700);
						DartsGlobals.instance.gameManager.currentDart.y = (((275 - _mousePosition.y) * AppSettings.instance.dartboardPositionZ * Math.tan(50 * Math.PI / 180)) / 550);
						DartsGlobals.instance.gameManager.currentDart.z = 0;
					}
					else
					{
						DartsGlobals.addWarning("ThreeClickThrowController::onInputUpdate(): DartsGlobals.instance.gameManager.currentDart=" + DartsGlobals.instance.gameManager.currentDart + ", IS THIS A PROBLEM?");
					}
				}
				else
				{
					DartsGlobals.addWarning("ThreeClickThrowController::onInputUpdate(): DartsGlobals.instance.gameManager=" + DartsGlobals.instance.gameManager + ", IS THIS A PROBLEM?");
				}
			}
			
		}//end onInputUpdate()
		
		private function updateCursorPosition(evt:Event):void
		{
			switch(this.state)
			{
				case START_Y_THROW:
					DartsGlobals.instance.gameManager.cursor.setCursorImage(_throwCursor);
					DartsGlobals.instance.gameManager.cursor.setCursorScale(1.2);
					_thrust += _direction;
				
					if ( _thrust < AppSettings.instance.dartMinThrust )
					{
						_thrust = AppSettings.instance.dartMinThrust;
						_direction = 1;
					}
					else if ( _thrust > AppSettings.instance.dartMaxThrust )
					{
						_thrust = AppSettings.instance.dartMaxThrust;
						_direction = -1;
					}
				break;
				case START_X_THROW:
					_lean += _direction / 3;
				
					if ( _lean < -2.5 )
					{
						_lean = -2.5;
						_direction = 1;
					}
					else if ( _lean > 2.5 )
					{
						_lean = 2.5;
						_direction = -1;
					}
				break;
				case END_THROW:
					
					DartsGlobals.addWarning("ThreeClickThrowController::updateCursorPosition(): END_THROW");
					
					DartsGlobals.instance.gameManager.cursor.resetCursorImage();
					_timer.removeEventListener(TimerEvent.TIMER, updateCursorPosition);
					_timer.stop();
					
					_timer = null;
						
					DartsGlobals.instance.gameManager.playerThrow(
						DartsGlobals.instance.gameManager.currentDart.x,
						DartsGlobals.instance.gameManager.currentDart.y,
						0,
						_thrust,
						_lean,
						AppSettings.instance.simulationStepScale
					);
				break;
				case INIT_THROW:
					break;
				default:
					DartsGlobals.addWarning("ThreeClickThrowController::updateCursorPosition(): this.state=" + this.state + ", NOT HANDLED HERE.");
				break;
			}
		}//end updateMousePosition()
		
		override public function resetThrowParams():void 
		{
			//DartsGlobals.addWarning("ThreeClickThrowController::resetThrowParams(): resetting this.state to INIT_THROW");
			
			super.resetThrowParams();
			
			_buttonActive = false;
			this.state = INIT_THROW;
			
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, updateCursorPosition);			
				_timer.stop();
				_timer = null;
			}
			
		}//end resetThrowParams()
		
		private function get state():int
		{
			return _state;
			
		}//end get state()
		
		private function set state(a_int:int):void
		{
			_state = a_int;
			
		}//end set state()
		
	}//end ThreeClickThrowController
	
}//end com.bored.games.darts.input