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
	public class BullOffClickContinueModal extends Panel
	{
		
		public function BullOffClickContinueModal() 
		{
			super();
			
			addChild(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.clickModalSprite));
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
			
			DartsGlobals.instance.gameManager.resetDarts();
			DartsGlobals.instance.gameManager.endTurn();
			DartsGlobals.instance.gameManager.startNewBullOff();
			
			//DartsGlobals.instance.gameManager.pause(false);
		}//end handleClick()
		
	}//end BullOffClickContinueModal

}//end com.bored.games.darts.ui.modals