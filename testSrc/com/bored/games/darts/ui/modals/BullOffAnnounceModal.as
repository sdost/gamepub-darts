package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.modal.BullOffAnnounceModal_MC;
	import com.bored.games.darts.assets.modal.ContinueClick_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.sven.containers.Panel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BullOffAnnounceModal extends Panel
	{
		
		public function BullOffAnnounceModal() 
		{
			super();
			
			addChild(new BullOffAnnounceModal_MC());
		}//end constructor()
		
		override protected function addedToStage(a_evt:Event = null):void
		{
			super.addedToStage();
			
			this.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}//end addedToStage()
		
		private function handleClick(a_evt:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.CLICK, handleClick);
			
			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.pause(false);
			
			DartsGlobals.instance.gameManager.startNewBullOff();
		}//end handleClick()
		
	}//end BullOffAnnounceModal

}//end com.bored.games.darts.ui.modals