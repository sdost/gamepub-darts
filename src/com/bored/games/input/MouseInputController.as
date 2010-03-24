package com.bored.games.input
{
	import com.bored.games.input.InputController;
	import com.bored.games.events.InputStateEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
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
			} else {
				setupListeners();
			}
		}//end set pause()
		
		private function setupListeners():void
		{
			//trace("Adding mouse listeners...");
			//_listener.addEventListener(Event.MOUSE_LEAVE, handleMouseLeave, true, 399, true);
			_listener.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, true, 400, true);
			_listener.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseButtons, true, 401, true);
			_listener.addEventListener(MouseEvent.MOUSE_UP, handleMouseButtons, true, 402, true);
		}//end setupListeners()
		
		private function removeListeners():void
		{
			//trace("Removing mouse listeners...");
			//_listener.removeEventListener(Event.MOUSE_LEAVE, handleMouseLeave, true);
			_listener.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, true);
			_listener.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseButtons, true);
			_listener.removeEventListener(MouseEvent.MOUSE_UP, handleMouseButtons, true);
		}//end removeListeners()
		
		private function handleMouseLeave(evt:Event):void
		{
			var x:Number = (evt.target as Stage).mouseX;
			var y:Number = (evt.target as Stage).mouseY;
			var but:Boolean = false;
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, but));
			
			//if( dispatched )
				//trace("dispatching InputStateEvent??");
		
		}//end handleMouseMove()
		
		private function handleMouseMove(evt:MouseEvent):void
		{
			var x:Number = evt.stageX;
			var y:Number = evt.stageY;
			var but:Boolean = evt.buttonDown;
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, but));
			
			//if( dispatched )
				//trace("dispatching InputStateEvent??");
		
		}//end handleMouseMove()
		
		private function handleMouseButtons(evt:MouseEvent):void
		{
			var x:Number = evt.stageX;
			var y:Number = evt.stageY;
			var but:Boolean = evt.buttonDown;
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, but));
			
			//if( dispatched )
				//trace("dispatching InputStateEvent??");
			
		}//end handleMouseButtons()
		
	}//end MouseInputController

}//end com.bored.games.darts.controllers