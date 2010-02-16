package com.bored.games.darts.states 
{
	import com.bored.games.assets.GameplayScreen_MC;
	import com.bored.games.assets.DartboardTexture_BMP;
	import com.bored.games.config.ConfigManager;
	import com.bored.games.controllers.InputController;
	import com.bored.games.darts.objects.Board;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.states.statemachines.GameFSM;
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
		
		private var _releasePos:Vector3D;
		private	var _thrust:Number;
		private var _angle:Number;
		private var _grav:Number;
		
		private var _darts:Vector.<Dart>;
		private var _dartboard:Board;
		
		private var _boardCollisionMap:BitmapData;
		
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
			var gameplayConfig:XML = ConfigManager.getConfigNamespace("gameplay");
			
			_releasePos = new Vector3D( gameplayConfig.releasePosition.x, gameplayConfig.releasePosition.y, gameplayConfig.releasePosition.z );
			_thrust = gameplayConfig.thrust;
			_angle = gameplayConfig.angle;
			_grav = gameplayConfig.gravity;
			
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
				
				var dartConfig:XML = ConfigManager.getConfigNamespace("dart");
				
				_darts = new Vector.<Dart>();
				_darts.push(new Dart(dartConfig.radius));
				_darts.push(new Dart(dartConfig.radius));
				_darts.push(new Dart(dartConfig.radius));
				
				_currDartIdx = 0;
				
				_dartboard = new Board();
				_dartboard.setCollisionMap(new DartboardTexture_BMP(350, 350));
				_dartboard.position.x = 0.0;
				_dartboard.position.y = 0.0;
				_dartboard.position.z = 6.0;
				
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
				
				var collision:Boolean = _dartboard.checkForCollision(_darts[_currDartIdx].position, _darts[_currDartIdx].radius);
				
				if (collision)
				{
					_darts[_currDartIdx].finishThrow();
					_currDartIdx++;
					
					if (_currDartIdx >= _darts.length) {
						(this.stateMachine as GameFSM).transitionToStateNamed("Gameplay");
					}
				} 
			}
			
			_gameplayScreen.render();
		}//end updateDisplay()
		
		private function inputUpdate(a_evt:InputStateEvent):void
		{
			if (_buttonDown)
			{
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
			} else {
				if (a_evt.button) {
					_buttonDown = true;
					MouseManager.beginDrag(a_evt.x, a_evt.y);
				} else {
					_releasePos.x = (a_evt.x - 400)/100;
					_releasePos.y = -(a_evt.y - 300)/100;
					_releasePos.z = 2;
					
					if( _currDartIdx < _darts.length && !_darts[_currDartIdx].throwing ) {
						(_darts[_currDartIdx] as Dart).position.x = _releasePos.x;
						(_darts[_currDartIdx] as Dart).position.y = _releasePos.y;
						(_darts[_currDartIdx] as Dart).position.z = _releasePos.z;
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