package com.bored.games.darts.ui.buttons 
{
	import com.inassets.ui.buttons.MightyButton;
	import flash.display.InteractiveObject;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ToggleButton extends MightyButton
	{
		private var _toggleOn:Boolean = false;
		
		public function ToggleButton(a_mc:InteractiveObject, a_bAddContents:Boolean = true) 
		{
			super(a_mc, a_bAddContents);
		}//end constructor()
		
		public function set toggleOn(a_bool:Boolean):void
		{
			_toggleOn = a_bool;
			
			this.gotoVisualState(OVER);
		}//end set toggleOn()
		
		override protected function get DISABLED():int
		{
			if (_toggleOn) {
				return 6;
			} else {
				return 3;
			}
		}//end get DISABLED()

		override protected function get DOWN():int
		{
			if (_toggleOn) {
				return 6;
			} else {
				return 3;
			}
		}//end get DOWN()

		override protected function get OVER():int
		{
			if (_toggleOn) {
				return 5;
			} else {
				return 2;
			}
		}//end get OVER()

		override protected function get UP():int
		{
			if (_toggleOn) {
				return 4;
			} else {
				return 1;
			}
		}//end get UP()
		
	}//end ToggleButton

}//end com.bored.games.darts.ui.buttons