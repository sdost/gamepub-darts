package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.DartsGlobals;
	import com.sven.containers.Panel;
	import com.sven.utils.AppSettings;
	import com.sven.utils.SpriteFactory;
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
			
			addChild(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.bullOffAnnounceModalSprite));
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
						
			DartsGlobals.instance.gameManager.bullOff = true;
			
			DartsGlobals.instance.showModalPopup(TurnAnnounceModal);
		}//end handleClick()
		
	}//end BullOffAnnounceModal

}//end com.bored.games.darts.ui.modals