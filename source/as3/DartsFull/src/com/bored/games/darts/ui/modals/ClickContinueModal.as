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
	public class ClickContinueModal extends Panel
	{
		
		public function ClickContinueModal() 
		{
			super();
			
			addChild(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.clickModalSprite));
		}//end constructor()
		
		override protected function addedToStage(a_evt:Event = null):void
		{			
			super.addedToStage();
			
			DartsGlobals.instance.stage.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}//end addedToStage()
		
		private function handleClick(a_evt:MouseEvent):void
		{
			DartsGlobals.instance.stage.removeEventListener(MouseEvent.CLICK, handleClick);
			
			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.resetDarts();
			DartsGlobals.instance.gameManager.endTurn();
			DartsGlobals.instance.gameManager.startNewTurn();
			
			//DartsGlobals.instance.gameManager.pause(false);
		}//end handleClick()
		
	}//end ClickContinueModal

}//end com.bored.games.darts.ui.modals