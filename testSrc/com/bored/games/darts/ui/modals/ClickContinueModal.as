package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.modal.ContinueClick_MC;
	import com.bored.games.darts.DartsGlobals;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ClickContinueModal extends MovieClip
	{
		
		public function ClickContinueModal() 
		{
			addChild(new ContinueClick_MC());			
		}//end constructor()
		
		public function init(a_object:Object):void
		{
			DartsGlobals.instance.stage.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}//end init()
		
		private function handleClick(a_evt:MouseEvent):void
		{
			DartsGlobals.instance.stage.removeEventListener(MouseEvent.CLICK, handleClick);
			
			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.resetDarts();
			DartsGlobals.instance.gameManager.endTurn();
			DartsGlobals.instance.gameManager.startNewTurn();
		}//end handleClick()
		
	}//end ClickContinueModal

}//end com.bored.games.darts.ui.modals