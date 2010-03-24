package com.sven.containers 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Panel extends Sprite
	{
		public function Panel() 
		{
			if (this.stage)
			{
				addedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
		}//end constructor()
		
		protected function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage); // so that this only happens once.
		}//end addedToStage()
		
	}//end ResizeablePanel

}//end com.sven.containers