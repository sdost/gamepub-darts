package com.bored.games.controllers 
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author sam
	 */
	public class InputController extends EventDispatcher
	{
		protected var _paused:Boolean = true;
		
		public function InputController() 
		{
			super();
		}//end constructor()
		
		public function set pause(a_pause:Boolean):void
		{
			_paused = a_pause;
		}//end set pause()
		
		public function get paused():Boolean
		{
			return _paused;
		}//end get paused()
		
	}//end InputController

}//end com.bored.games.controllers