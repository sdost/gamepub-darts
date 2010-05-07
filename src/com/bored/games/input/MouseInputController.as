package com.bored.games.input
{
	import com.bored.games.input.InputController;
	import com.bored.games.events.InputStateEvent;
	import com.tadSrc.tadsClasses.DOMExEvent;
	import com.tadSrc.tadsClasses.DOMExEventDispatcher;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	
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
			_listener.addEventListener(MouseEvent.MOUSE_MOVE, handleMousePositionUpdate, true, 400, true);
			_listener.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, true, 401, true);
			_listener.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, true, 402, true);
			_listener.addEventListener(MouseEvent.ROLL_OUT, handleMouseRollOut, true, 403, true);
		}//end setupListeners()
		
		private function removeListeners():void
		{
			_listener.removeEventListener(MouseEvent.MOUSE_MOVE, handleMousePositionUpdate, true);
			_listener.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, true);
			_listener.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp, true);
			_listener.removeEventListener(MouseEvent.ROLL_OUT, handleMouseRollOut, true);
		}//end removeListeners()
				
		private function handleMousePositionUpdate(evt:* = null):void
		{
			var x:Number = evt.stageX;
			var y:Number = evt.stageY;
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y));		
		}//end handleMouseMove()
		
		private function handleMouseDown(evt:* = null):void
		{			
			var x:Number = evt.stageX;
			var y:Number = evt.stageY;
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, InputStateEvent.DOWN));
		}//end handleMouseButtons()
		
		private function handleMouseUp(evt:* = null):void
		{
			var x:Number = evt.stageX;
			var y:Number = evt.stageY;
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, InputStateEvent.UP));
		}//end handleMouseButtons()
		
		private function handleMouseRollOut(evt:* = null):void
		{
			trace("Leaving: " + evt.currentTarget);
			trace("Entering: " + evt.relatedObject);
			trace("Target: " + evt.target);
			
			var x:Number = evt.stageX;
			var y:Number = evt.stageY;
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, InputStateEvent.UP));
		}//end handleMouseButtons()
		
	}//end MouseInputController

}//end com.bored.games.darts.controllers