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
	
	/**
	 * ...
	 * @author sam
	 */
	public class MouseInputController extends InputController
	{
		private var _listener:DisplayObjectContainer;
		//private var _mouseMoveHandler:DOMExEventDispatcher;
		//private var _mouseDownHandler:DOMExEventDispatcher;
		//private var _mouseUpHandler:DOMExEventDispatcher;
		
		public function MouseInputController(listener:DisplayObjectContainer) 
		{
			super();	
			_listener = listener;
			//_mouseMoveHandler = new DOMExEventDispatcher("document.onmousemove", ["clientX", "clientY"]);
			//_mouseDownHandler = new DOMExEventDispatcher("document.onmousedown", ["clientX", "clientY", "button"]);
			//_mouseUpHandler = new DOMExEventDispatcher("document.onmouseup", ["clientX", "clientY", "button"]);
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
			_listener.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMousePositionUpdate, true, 400, true);
			_listener.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, true, 401, true);
			_listener.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, true, 402, true);
			_listener.stage.addEventListener(MouseEvent.ROLL_OUT, handleMouseRollOut, true, 403, true);
			//_mouseMoveHandler.addEventListener(DOMExEvent.DOMEX_EVENT, handleMousePositionUpdate, false, 0, true);
			//_mouseDownHandler.addEventListener(DOMExEvent.DOMEX_EVENT, handleMouseDown, false, 0, true);
			//_mouseUpHandler.addEventListener(DOMExEvent.DOMEX_EVENT, handleMouseUp, false, 0, true);
		}//end setupListeners()
		
		private function removeListeners():void
		{
			//trace("Removing mouse listeners...");
			_listener.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMousePositionUpdate, true);
			_listener.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, true);
			_listener.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp, true);
			_listener.stage.removeEventListener(MouseEvent.ROLL_OUT, handleMouseRollOut, true);
			//_mouseMoveHandler.removeEventListener(DOMExEvent.DOMEX_EVENT, handleMousePositionUpdate);
			//_mouseDownHandler.removeEventListener(DOMExEvent.DOMEX_EVENT, handleMouseDown);
			//_mouseUpHandler.removeEventListener(DOMExEvent.DOMEX_EVENT, handleMouseUp);
		}//end removeListeners()
				
		private function handleMousePositionUpdate(evt:* = null):void
		{
			var x:Number = (evt as MouseEvent != null) ? evt.stageX : evt.eventPropertiesArray[0];
			var y:Number = (evt as MouseEvent != null) ? evt.stageY : evt.eventPropertiesArray[1];
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y));
			
			//if( dispatched )
				//trace("dispatching InputStateEvent??");
		
		}//end handleMouseMove()
		
		private function handleMouseDown(evt:* = null):void
		{
			var x:Number = (evt as MouseEvent != null) ? evt.stageX : evt.eventPropertiesArray[0];
			var y:Number = (evt as MouseEvent != null) ? evt.stageY : evt.eventPropertiesArray[1];
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, InputStateEvent.DOWN));
			
			//if( dispatched )
				//trace("dispatching InputStateEvent??");
			
		}//end handleMouseButtons()
		
		private function handleMouseUp(evt:* = null):void
		{
			var x:Number = (evt as MouseEvent != null) ? evt.stageX : evt.eventPropertiesArray[0];
			var y:Number = (evt as MouseEvent != null) ? evt.stageY : evt.eventPropertiesArray[1];
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, InputStateEvent.UP));
			
			//if( dispatched )
				//trace("dispatching InputStateEvent??");
			
		}//end handleMouseButtons()
		
		private function handleMouseRollOut(evt:* = null):void
		{
			var x:Number = (evt as MouseEvent != null) ? evt.stageX : evt.eventPropertiesArray[0];
			var y:Number = (evt as MouseEvent != null) ? evt.stageY : evt.eventPropertiesArray[1];
			
			var dispatched:Boolean = this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, x, y, InputStateEvent.UP));
			
			//if( dispatched )
				//trace("dispatching InputStateEvent??");
			
		}//end handleMouseButtons()
		
	}//end MouseInputController

}//end com.bored.games.darts.controllers