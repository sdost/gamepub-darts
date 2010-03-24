package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.ResultsModal;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author sam
	 */
	public class GameResultsModal extends MovieClip
	{
		
		public function GameResultsModal() 
		{
			addChild(new ResultsModal());
		}
		
		public function init(a_object:Object):void
		{
			
		}//end init()
		
	}//end GameResultsModal

}//end com.bored.games.darts.ui.modals