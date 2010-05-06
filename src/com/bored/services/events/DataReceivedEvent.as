package com.bored.services.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class DataReceivedEvent extends Event
	{
		public var key:String;
		public var data:*;
		
		public function DataReceivedEvent(type:String, a_key:String, a_data:*, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			
			key = a_key;
			data = a_data;
			
		}//end DataReceivedEvent()
		
		override public function clone():Event 
		{
			return new DataReceivedEvent(this.type, this.key, this.data, this.bubbles, this.cancelable);
			
		}//end clone()
		
		public override function toString():String
		{
			return formatToString("DataReceivedEvent", "type", "key", "data", "bubbles", "cancelable");
			
		}//end toString()

		
	}//end class DataReceivedEvent
	
}//end package com.bored.services.events
