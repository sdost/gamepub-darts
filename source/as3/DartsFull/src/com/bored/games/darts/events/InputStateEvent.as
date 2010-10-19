package com.bored.games.darts.events 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class InputStateEvent extends Event 
	{
		public static const UP:int = 0;
		public static const DOWN:int = 1;
		public static const UPDATE:String = "input_Update";
		
		private static var _lastButtonState:Boolean = false;
		
		public var x:Number, y:Number, button:Boolean, timestamp:Number, origMouseEvt:MouseEvent;
		
		public function InputStateEvent(type:String, x:Number, y:Number, but:int = -1, a_origMouseEvt:MouseEvent = null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			
			this.x = x;
			this.y = y;
			origMouseEvt = a_origMouseEvt;
			
			if ( but < 0 ) 
			{
				this.button = _lastButtonState;
			} else {
				if ( but == UP ) {
					this.button = _lastButtonState = false;
				} else if ( but == DOWN ) {
					this.button = _lastButtonState = true;
				}
			}
			
			timestamp = getTimer();
			
		} //end constructor()
		
		public override function clone():Event 
		{ 
			return new InputStateEvent(type, x, y, (button ? 1 : 0), origMouseEvt, bubbles, cancelable);
		} //end clone()
		
		public override function toString():String 
		{ 
			return formatToString("InputStateEvent", "type", "x", "y", "button", "origMouseEvt", "bubbles", "cancelable", "eventPhase"); 
		} //end toString()
		
	}//end InputStateEvent
	
}//end com.bored.games.dart.controllers.events