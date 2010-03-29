package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.modal.ResultsModal_MC;
	import com.bored.games.darts.DartsGlobals;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author sam
	 */
	public class GameResultsModal extends MovieClip
	{
		
		public function GameResultsModal() 
		{
			addChild(new ResultsModal_MC());
		}
		
		public function init(a_object:Object):void
		{
			DartsGlobals.instance.stage.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}//end init()
		
		private function handleClick(a_evt:MouseEvent):void
		{
			DartsGlobals.instance.stage.removeEventListener(MouseEvent.CLICK, handleClick);
			
			DartsGlobals.instance.processModalQueue();
		}//end handleClick()
		
	}//end GameResultsModal

}//end com.bored.games.darts.ui.modals