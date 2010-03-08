package com.bored.games.darts.states 
{
	import com.bored.games.controllers.AIController;
	import com.bored.games.controllers.InputController;
	import com.bored.games.controllers.MouseInputController;
	import com.bored.games.darts.logic.AbstractGameLogic;
	import com.bored.games.darts.logic.AIOpponentProfile;
	import com.bored.games.darts.logic.AIShotManager;
	import com.bored.games.darts.logic.CricketGameMode;
	import com.bored.games.darts.logic.DartsTurn;
	import com.bored.games.darts.objects.Board;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.GameplayScreen;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.graphics.ImageFactory;
	import com.bored.games.input.MouseStroke;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.sven.utils.AppSettings;
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
	import flash.text.TextField;
	import com.bored.games.darts.DartsGlobals;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import mx.binding.Binding;
	import mx.binding.utils.BindingUtils;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Gameplay extends State
	{		
		private static const AIM:uint = 0;
		private static const READY:uint = 1;
		private static const SHOOT:uint = 2;
		private static const START_SHOT:uint = 4;
		private static const RELEASE:uint = 8;
		
		private var _gameplayScreen:GameplayScreen;
		
		private var _buttonDown:Boolean;
		private var _playerInputController:InputController;
		private var _opponentInputController:InputController;
		
		private var _releasePos:Vector3D;
		private	var _thrust:Number;
		private var _angle:Number;
		private var _yaw:Number;
		private var _grav:Number;
		
		private var _darts:Vector.<Dart>;
		private var _currDartIdx:uint;
		
		private var _dartboard:Board;
		
		private var _currentTurn:DartsTurn;
		private var _turns:uint = 0;
		
		private var _trackShot:Boolean = true;
		
		private var _oX:Number;
		private var _oY:Number;
		private var _velX:Number;
		private var _velY:Number;
		private var _speed:Number;
		private var _num:Number;
		private var _cumAvgSpeed:Number;
		
		private var _mousePosition:Point = new Point();;
		
		private var _opponentProfile:AIOpponentProfile;
		private var _opponentShooter:AIShotManager;

		private var _mouseTimer:Timer = new Timer(50, 0);
						
		public function Gameplay(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end Gameplay() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			_releasePos = new Vector3D( AppSettings.instance.defaultReleasePositionX, AppSettings.instance.defaultReleasePositionY, AppSettings.instance.defaultReleasePositionZ );
			_thrust = AppSettings.instance.defaultThrust;
			_angle = AppSettings.instance.defaultAngle;
			_grav = AppSettings.instance.defaultGravity;
			
			var gameplayScreenImg:MovieClip;
			
			_opponentProfile = new AIOpponentProfile();
			
			try
			{
				_gameplayScreen = new GameplayScreen();
				
				DartsGlobals.instance.screenSpace.addChild(_gameplayScreen);
				
				_buttonDown = false;
				
				_playerInputController = new MouseInputController(DartsGlobals.instance.screenSpace);
				_playerInputController.addEventListener(InputStateEvent.UPDATE, inputUpdate);
				_playerInputController.pause = true;
				
				_opponentInputController = new AIController();
				_opponentInputController.addEventListener(InputStateEvent.UPDATE, inputUpdate);
				_opponentInputController.pause = true;
								
				_darts = new Vector.<Dart>();
				for (var i:int = 0; i < AppSettings.instance.throwsPerTurn; i++) {
					_darts.push(new Dart(AppSettings.instance.dartRadius));
				}
				
				_currDartIdx = 0;
				
				_dartboard = new Board();
				
				var bmp:BitmapData = new BitmapData(900, 900, true, 0x00000000);
				
				var mtx:Matrix = new Matrix();
				mtx.translate(450, 450);
				
				var cls:Class = getDefinitionByName(AppSettings.instance.boardCollisionMap) as Class;
				
				bmp.draw(new cls(), mtx);
				
				_dartboard.setCollisionMap(bmp);
				_dartboard.position.x = AppSettings.instance.dartboardPositionX;
				_dartboard.position.y = AppSettings.instance.dartboardPositionY;
				_dartboard.position.z = AppSettings.instance.dartboardPositionZ;
				
				_opponentProfile.acquireColorMap(bmp);
				
				_gameplayScreen.setDartReferences(_darts);
				_gameplayScreen.setBoardReference(_dartboard);
				
				_gameplayScreen.addEventListener(Event.ENTER_FRAME, update, false, 0, false);
				
				_currentTurn = DartsGlobals.instance.logicManager.startNewTurn(AbstractGameLogic.PLAYER_TURN);
				_playerInputController.pause = false;
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("Gameplay::onEnter(): Caught error=" + e.getStackTrace());
			}
			
		}//end onEnter()
		
		private function update(a_evt:Event):void
		{
			for (var i:int = 0; i < _darts.length; i++)
			{
				_darts[i].update();
			}
				
			var result:Object = _dartboard.checkForCollision(_darts[_currDartIdx], _darts[_currDartIdx].radius);
			
			if (result.section)
			{		
				_currentTurn.submitThrowResult(result);
				
				if (_currentTurn.hasThrowsRemaining()) _currentTurn.advanceThrows();
				
				if(_opponentShooter) _opponentShooter.endShot();
				
				_darts[_currDartIdx].finishThrow();
				_gameplayScreen.finishThrow(_currentTurn.owner);
				_currDartIdx++;
				
				if (_currDartIdx >= _darts.length) {
					
					_mouseTimer.removeEventListener( TimerEvent.TIMER, updateCurrentMouseVelocity );
					_mouseTimer.stop();
					_mouseTimer.reset();
					
					_currDartIdx = 0;
					for (var j:int = 0; j < _darts.length; j++) {
						_darts[j].reset();
					}
					
					var win:Boolean = DartsGlobals.instance.logicManager.checkForWinState();
					
					if (win) {
						trace("Hey! " + _currentTurn.owner + " has won the game!");
					} else {
						_turns++;
						
						if ( _turns % 2 == 0 ) {
							_currentTurn = DartsGlobals.instance.logicManager.startNewTurn(AbstractGameLogic.PLAYER_TURN);
							_playerInputController.pause = false;
							_opponentInputController.pause = true;
							_opponentShooter = null;
						} else {
							_currentTurn = DartsGlobals.instance.logicManager.startNewTurn(AbstractGameLogic.OPPONENT_TURN);
							_playerInputController.pause = true;
							_opponentInputController.pause = false;
							_opponentShooter = new AIShotManager(AppSettings.instance.aiOpponentName, (_opponentInputController as AIController), _opponentProfile);
						}
					}
				}
				
				if(_opponentShooter) _opponentShooter.beginShot(_currDartIdx);
			} 
			
			_gameplayScreen.render();
		}//end updateDisplay()
		
		private function inputUpdate(a_evt:InputStateEvent):void
		{
			_mousePosition.x = a_evt.x;
			_mousePosition.y = a_evt.y;
			
			if (_buttonDown) {
				if ( !a_evt.button ) {
					if ( _cumAvgSpeed ) {
						_thrust = Math.min((_cumAvgSpeed / 50), AppSettings.instance.dartMaxThrust);
						
						if ( _thrust >= AppSettings.instance.dartMinThrust ) 
						{
							_gameplayScreen.updateThrowSpeed(_thrust, (_velX / 1000));
							_darts[_currDartIdx].initThrowParams(_releasePos.x, _releasePos.y, _releasePos.z, _thrust, _angle, _grav, _velX / 1000);
						}
					}
					_mouseTimer.removeEventListener( TimerEvent.TIMER, updateCurrentMouseVelocity );
					_mouseTimer.stop();
					_mouseTimer.reset();
					_gameplayScreen.resetThrow();
					_buttonDown = false;
				}
			} else {
				if ( a_evt.button ) {
					_gameplayScreen.startThrow();
					_buttonDown = true;
					trace("Starting mouse timer??");
					_oX = _mousePosition.x;
					_oY = _mousePosition.y;
					_velX = 0;
					_velY = 0;
					_speed = 0;
					_cumAvgSpeed = 0;
					_num = 0;
					_mouseTimer.addEventListener( TimerEvent.TIMER, updateCurrentMouseVelocity );
					_mouseTimer.start();
				} else {					
					_releasePos.x = (((_mousePosition.x - 350) * _dartboard.position.z * Math.tan(50 * Math.PI / 180)) / 700);
					_releasePos.y = (((275 - _mousePosition.y) * _dartboard.position.z * Math.tan(50 * Math.PI / 180)) / 550);
					
					if( !_darts[_currDartIdx].throwing ) {
						_darts[_currDartIdx].position.x = _releasePos.x;
						_darts[_currDartIdx].position.y = _releasePos.y;
						_darts[_currDartIdx].position.z = _releasePos.z;
					}
				}
			}
		}//end onInputUpdate()

		private function updateCurrentMouseVelocity(e:TimerEvent):void
		{
			var nX:Number = _mousePosition.x;
			var nY:Number = _mousePosition.y;
			var dx:Number = nX - _oX;
			var dy:Number = nY - _oY;
    
			_oX = nX;
			_oY = nY;
			_velX = dx * 1000 / _mouseTimer.delay;
			_velY = dy * 1000 / _mouseTimer.delay;
			_speed = Math.sqrt( _velX * _velX + _velY * _velY );
			
			_cumAvgSpeed = _cumAvgSpeed + ((_speed - _cumAvgSpeed) / ++_num);
		}//end updateCurrentMouseVelocity()
		
		private function finished(...args):void
		{
			//(this.stateMachine as GameFSM).transitionToNextState();
			
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