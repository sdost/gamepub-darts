package com.bored.games.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author sam
	 */
	public class InputStateEvent extends Event 
	{
		public static const UPDATE:String = "input_Update"
		
		public var x:Number, y:Number, button:Boolean;
		
		public function InputStateEvent(type:String, x:Number, y:Number, but:Boolean, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			
			this.x = x;
			this.y = y;
			
			this.button = but;
			
		} //end constructor()
		
		public override function clone():Event 
		{ 
			return new InputStateEvent(type, x, y, button, bubbles, cancelable);
		} //end clone()
		
		public override function toString():String 
		{ 
			return formatToString("InputStateEvent", "type", "x", "y", "button", "bubbles", "cancelable", "eventPhase"); 
		} //end toString()
		
	}//end InputStateEvent
	
}//end com.bored.games.dart.controllers.events