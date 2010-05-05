package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.modal.BullOffWinnerModal_MC;
	import com.bored.games.darts.assets.modal.ContinueClick_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.sven.containers.Panel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BullOffWinnerModal extends ContentHolder
	{
		private var _playerNameText:TextField;
		private var _playerImage:MovieClip;
		
		public function BullOffWinnerModal() 
		{
			super(new BullOffWinnerModal_MC(), false, true);
			
			if (this.stage) {
				addedToStage();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			
		}//end constructor()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			DartsGlobals.instance.stage.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}//end addedToStage()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_playerNameText = descendantsDict["playerName_text"] as TextField;
			_playerImage = descendantsDict["playerPicHolder_mc"] as MovieClip;
			
			if (_playerNameText)
			{
				_playerNameText.text = DartsGlobals.instance.gameManager.players[DartsGlobals.instance.gameManager.currentPlayer-1].playerName;
			}
			else
			{
				throw new Error("BullOffWinnerModal::buildFrom(): _playerNameText=" + _playerNameText);
			}
			
			if (_playerImage)
			{
				_playerImage.addChild(DartsGlobals.instance.gameManager.players[DartsGlobals.instance.gameManager.currentPlayer-1].portrait);
			}
			else
			{
				throw new Error("BullOffWinnerModal::buildFrom(): _playerImage=" + _playerImage);
			}
					
			return descendantsDict;
			
		}//end buildFrom()
		
		private function handleClick(a_evt:MouseEvent):void
		{
			DartsGlobals.instance.stage.removeEventListener(MouseEvent.CLICK, handleClick);
			
			DartsGlobals.instance.processModalQueue();
						
			DartsGlobals.instance.gameManager.startNewTurn();
		}//end handleClick()
		
	}//end BullOffWinnerModal

}//end com.bored.games.darts.ui.modals