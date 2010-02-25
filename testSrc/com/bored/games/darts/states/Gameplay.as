package com.bored.games.darts.states 
{
	import com.bored.games.assets.GameplayScreen_MC;
	import com.bored.games.config.ConfigManager;
	import com.bored.games.controllers.InputController;
	import com.bored.games.controllers.MouseInputController;
	import com.bored.games.darts.objects.Board;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.GameplayScreen;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.graphics.ImageFactory;
	import com.bored.games.input.MouseStroke;
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
		private static var AIM:uint = 0;
		private static var READY:uint = 1;
		private static var SHOOT:uint = 2;
		private static var RELEASE:uint = 4;
		
		private var _gameplayScreen:GameplayScreen;
		
		private var _buttonDown:Boolean;
		private var _inputController:InputController;
		
		private var _releasePos:Vector3D;
		private	var _thrust:Number;
		private var _angle:Number;
		private var _grav:Number;
		
		private var _darts:Vector.<Dart>;
		private var _dartboard:Board;
		
		private var _boardCollisionMap:BitmapData;
		
		private var _currDartIdx:uint;
		
		private var _currentStroke:MouseStroke;
		
		private var _inputState:uint = AIM;
		
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
				_dartboard.setCollisionMap(ImageFactory.getBitmapDataByQualifiedName(boardConfig.collisionMap.bitmap, boardConfig.collisionMap.width, boardConfig.collisionMap.height));
				_dartboard.position.x = boardConfig.position.x;
				_dartboard.position.y = boardConfig.position.y;
				_dartboard.position.z = boardConfig.position.z;
				
				_gameplayScreen.setDartReferences(_darts);
				_gameplayScreen.setBoardReference(_dartboard);
				
				_gameplayScreen.addEventListener(Event.ENTER_FRAME, update, false, 0, false);
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
				
				var result:int = _dartboard.checkForCollision(_darts[_currDartIdx], _darts[_currDartIdx].radius);
				
				if (result > 0)
				{					
					_darts[_currDartIdx].finishThrow();
					_currDartIdx++;
					
					if (_currDartIdx >= _darts.length) {
						_currDartIdx = 0;
						_darts[0].reset();
						_darts[1].reset();
						_darts[2].reset();
					}
					
					_inputState = AIM;
					_currentStroke = null;
				} 
			}
			
			_gameplayScreen.render();
		}//end updateDisplay()
		
		private function inputUpdate(a_evt:InputStateEvent):void
		{
			if (_buttonDown)
			{	
				if(a_evt.button) {
					if (_inputState == READY) {
						
						trace("Vector: " + _currentStroke.vector.toString());
						
						(_darts[_currDartIdx] as Dart).position.z = -0.2 * Math.abs(_currentStroke.vector.y / ConfigManager.config.readyThreshold);
						
						if (_currentStroke.vector.y >= ConfigManager.config.readyThreshold) // TODO externalize this value...
						{
							_inputState = SHOOT;
							trace("Moving to SHOOT state.");
						}
					}
				} else {
					if (_inputState == SHOOT) {
						
						trace("Velocity: " + _currentStroke.vel.toString());
						
						if (_currentStroke.vel.y < 0 && (Math.abs(_currentStroke.vel.y)*ConfigManager.config.shootMultiplier) > ConfigManager.config.shootThreshold) // TODO externalize this value...
						{
							_thrust = Math.abs(_currentStroke.vel.y) * ConfigManager.config.shootMultiplier;
							var offset:Number = _currentStroke.vel.x;
							
							_buttonDown = false;
							if( _currDartIdx < _darts.length ) {
								(_darts[_currDartIdx] as Dart).initThrowParams(_releasePos.x, _releasePos.y, _releasePos.z, _thrust, _angle, _grav);
								_inputState = RELEASE;
								trace("Moving to RELEASE state.");
							}
						} else {
							_inputState = AIM;
							trace("Moving to AIM state.");
						}
					}
					
					_buttonDown = false;
				}
				/*
				if (a_evt.button) { // dragging
					MouseManager.updateDrag(a_evt.x, a_evt.y);
					var vec:Vector3D = MouseManager.dragVector;
					var ratio:Number = vec.length / 100;
					ratio = ratio > 1 ? 1 : ratio;
					_angle = ratio * 10;
					_thrust = ratio * 30;
				} else {
					_buttonDown = false;
					if( _currDartIdx < _darts.length ) {
						(_darts[_currDartIdx] as Dart).initThrowParams(_releasePos.x, _releasePos.y, _releasePos.z, _thrust, _angle, _grav);
					}
				}
				*/
			} else {
				if (a_evt.button) {
					if (_inputState == AIM) {
						_buttonDown = true;
						//MouseManager.beginDrag(a_evt.x, a_evt.y);
						_currentStroke = new MouseStroke(_inputController as MouseInputController, a_evt.x, a_evt.y, a_evt.timestamp);
						_inputState = READY;
						trace("Moving to READY state.");
					}
				} else {
					if(_inputState == AIM) {
						_releasePos.x = (a_evt.x - 350)/400;
						_releasePos.y = -(a_evt.y - 275)/400;
						_releasePos.z = 0;
						
						if( _currDartIdx < _darts.length && !_darts[_currDartIdx].throwing ) {
							(_darts[_currDartIdx] as Dart).position.x = _releasePos.x;
							(_darts[_currDartIdx] as Dart).position.y = _releasePos.y;
							(_darts[_currDartIdx] as Dart).position.z = _releasePos.z;
						}
					}
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
			_gameplayScreen.removeEventListener(Event.ENTER_FRAME, update);
		}//end onExit()
		
	}//end class Gameplay

}//end package com.bored.games.darts.states