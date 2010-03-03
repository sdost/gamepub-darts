package com.bored.games.darts.states 
{
	import com.bored.games.assets.DartboardColorMap_MC;
	import com.bored.games.assets.GameplayScreen_MC;
	import com.bored.games.config.ConfigManager;
	import com.bored.games.controllers.InputController;
	import com.bored.games.controllers.MouseInputController;
	import com.bored.games.darts.logic.AbstractGameLogic;
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
		private var _inputController:InputController;
		
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
		
		private var _oX:Number;//last mouse x position
		private var _oY:Number;//last mouse y position
		private var _velX:Number;//velocity x per second
		private var _velY:Number;//velocity y per second
		private var _speed:Number;//change in position per second
		private var _num:Number;
		private var _cumAvgSpeed:Number;

		private var _mouseTimer:Timer = new Timer(50,0);
						
		public function Gameplay(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end Gameplay() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			var gameplayConfig:XML = ConfigManager.getConfigNamespace("gameplay");
			
			_releasePos = new Vector3D( gameplayConfig.releasePosition.x, gameplayConfig.releasePosition.y, gameplayConfig.releasePosition.z );
			_thrust = gameplayConfig.thrust;
			_angle = gameplayConfig.angle;
			_grav = gameplayConfig.gravity;
			
			var gameplayScreenImg:MovieClip;
			
			try
			{
				//gameplayScreenImg = new GameplayScreen_MC();
				_gameplayScreen = new GameplayScreen(/*gameplayScreenImg, false, true*/);
				
				DartsGlobals.instance.screenSpace.addChild(_gameplayScreen);
				
				_inputController = DartsGlobals.instance.inputController;
				_inputController.addEventListener(InputStateEvent.UPDATE, inputUpdate);
				_inputController.pause = false;
				_buttonDown = false;
				
				var dartConfig:XML = ConfigManager.getConfigNamespace("dart");
				
				_darts = new Vector.<Dart>();
				_darts.push(new Dart(dartConfig.radius));
				_darts.push(new Dart(dartConfig.radius));
				_darts.push(new Dart(dartConfig.radius));
				
				_currDartIdx = 0;
				
				var boardConfig:XML = ConfigManager.getConfigNamespace("dartboard");
				
				_dartboard = new Board();
				
				var bmp:BitmapData = new BitmapData(900, 900, true, 0x00000000);
				
				var mtx:Matrix = new Matrix();
				mtx.translate(450, 450);
				
				bmp.draw(new DartboardColorMap_MC(), mtx);
				
				//_gameplayScreen.addChild(new Bitmap(bmp));
				
				_dartboard.setCollisionMap(bmp);
				_dartboard.position.x = boardConfig.position.x;
				_dartboard.position.y = boardConfig.position.y;
				_dartboard.position.z = boardConfig.position.z;
				
				_gameplayScreen.setDartReferences(_darts);
				_gameplayScreen.setBoardReference(_dartboard);
				
				_gameplayScreen.addEventListener(Event.ENTER_FRAME, update, false, 0, false);
				
				_currentTurn = DartsGlobals.instance.logicManager.startNewTurn(AbstractGameLogic.PLAYER_TURN);
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
				
				var result:Object = _dartboard.checkForCollision(_darts[_currDartIdx], _darts[_currDartIdx].radius);
				
				if (result.section)
				{		
					_currentTurn.submitThrowResult(result);
					
					if (_currentTurn.hasThrowsRemaining()) _currentTurn.advanceThrows();
					
					_darts[_currDartIdx].finishThrow();
					_gameplayScreen.finishThrow(_currentTurn.owner);
					_currDartIdx++;
					
					if (_currDartIdx >= _darts.length) {
						_currDartIdx = 0;
						_darts[0].reset();
						_darts[1].reset();
						_darts[2].reset();
						
						var win:Boolean = DartsGlobals.instance.logicManager.checkForWinState();
						
						if (win) {
							trace("Hey! " + _currentTurn.owner + " has won the game!");
						} else {
							_turns++;
							
							if ( _turns % 2 == 0 ) {
								_currentTurn = DartsGlobals.instance.logicManager.startNewTurn(AbstractGameLogic.PLAYER_TURN);
							} else {
								_currentTurn = DartsGlobals.instance.logicManager.startNewTurn(AbstractGameLogic.OPPONENT_TURN);
							}
						}
					}
				} 
			}
			
			_gameplayScreen.render();
		}//end updateDisplay()
		
		private function inputUpdate(a_evt:InputStateEvent):void
		{
			if (_buttonDown) {
				if ( a_evt.button ) {
					if( !_mouseTimer.running ) {
						_oX = _gameplayScreen.stage.mouseX;
						_oY = _gameplayScreen.stage.mouseY;
						_velX = 0;
						_velY = 0;
						_speed = 0;
						_cumAvgSpeed = 0;
						_num = 0;
						_mouseTimer.addEventListener( TimerEvent.TIMER, updateCurrentMouseVelocity );
						_mouseTimer.start();
					}
				} else {
					if ( _cumAvgSpeed ) {
						_thrust = Math.min((_cumAvgSpeed / 50), ConfigManager.config.maxThrust);
						
						if ( _thrust >= ConfigManager.config.minThrust ) 
						{
							_gameplayScreen.updateThrowSpeed(_thrust, (_velX / 1000));
							_darts[_currDartIdx].initThrowParams(_releasePos.x, _releasePos.y, _releasePos.z, _thrust, _angle, _grav, _velX / 1000);
						}
					}
					_mouseTimer.stop();
					_gameplayScreen.resetThrow();
					_buttonDown = false;
				}
			} else {
				if ( a_evt.button ) {
					_gameplayScreen.startThrow();
					_buttonDown = true;
				} else {					
					_releasePos.x = (((a_evt.x - 350) * _dartboard.position.z * Math.tan(50 * Math.PI / 180)) / 700);
					_releasePos.y = (((275 - a_evt.y) * _dartboard.position.z * Math.tan(50 * Math.PI / 180)) / 550);
					
				
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
			var nX:Number = _gameplayScreen.stage.mouseX;
			var nY:Number = _gameplayScreen.stage.mouseY;
			var dx:Number = nX - _oX;
			var dy:Number = nY - _oY;
    
			_oX = nX;
			_oY = nY;
			_velX = dx * 1000 / _mouseTimer.delay;//per second
			_velY = dy * 1000 / _mouseTimer.delay;//per second
			_speed = Math.sqrt( _velX * _velX + _velY * _velY );
			
			_cumAvgSpeed = _cumAvgSpeed + ((_speed - _cumAvgSpeed) / ++_num);
			
			//_gameplayScreen.updateThrowSpeed(_speed);
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