package com.bored.games.controllers 
{
	import com.bored.games.controllers.InputController;
	import com.bored.games.events.InputStateEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author sam
	 */
	public class MouseInputController extends InputController
	{
		private var _listener:DisplayObjectContainer;
		
		public function MouseInputController(listener:DisplayObjectContainer) 
		{
			super();	
			_listener = listener;
		}//end constructor()
		
		override public function set pause(a_pause:Boolean):void
		{			
			super.pause = a_pause;
			
			if (_paused) {
				removeListeners();
				//_listener.mouseEnabled = false;
				//_listener.mouseChildren = false;
			} else {
				setupListeners();
				//_listener.mouseEnabled = true;
				//_listener.mouseChildren = true;
			}
		}//end set pause()
		
		private function setupListeners():void
		{
			_listener.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, true, 400, true);
			_listener.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseButtons, true, 401, true);
			_listener.addEventListener(MouseEvent.MOUSE_UP, handleMouseButtons, true, 402, true);
		}//end setupListeners()
		
		private function removeListeners():void
		{
			_listener.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			_listener.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseButtons);
			_listener.removeEventListener(MouseEvent.MOUSE_UP, handleMouseButtons);
		}//end removeListeners()
		
		private function handleMouseMove(evt:MouseEvent):void
		{
			var x:Number = evt.stageX;
			var y:Number = evt.stageY;
			var but:Boolean = evt.buttonDown;
			
			this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, but));
		
		}//end handleMouseMove()
		
		private function handleMouseButtons(evt:MouseEvent):void
		{
			var x:Number = evt.stageX;
			var y:Number = evt.stageY;
			var but:Boolean = evt.buttonDown;
			
			this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, but));
			
		}//end handleMouseButtons()
		
	}//end MouseInputController

}//end com.bored.games.darts.controllers