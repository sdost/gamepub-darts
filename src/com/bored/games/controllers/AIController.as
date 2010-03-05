package com.bored.games.controllers 
{
	import com.bored.games.controllers.InputController;
	import com.bored.games.events.InputStateEvent;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AIController extends InputController
	{
		public function AIController() 
		{
			super();
	
		}//end constructor()
		
		public function generateInputEvent(a_x:Number, a_y:Number, a_button:Boolean):void
		{
			if( !_paused )
				this.dispatchEvent(new InputStateEvent(InputStateEvent.UPDATE, a_x, a_y, a_button));
		}//end generateInputEvent()
		
	}//end AIController

}//end com.bored.games.controllers