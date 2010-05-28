package com.bored.services.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class ObjectEvent extends Event
	{
		public var obj:*;
		
		public function ObjectEvent(type:String, a_obj:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			obj = a_obj;
			
		}//end ObjectEvent();
		
		override public function clone():Event 
		{
			return new ObjectEvent(this.type, this.obj, this.bubbles, this.cancelable);
			
		}//end clone()
		
	}//end ObjectEvent
	
	}//end package com.bored.services.events