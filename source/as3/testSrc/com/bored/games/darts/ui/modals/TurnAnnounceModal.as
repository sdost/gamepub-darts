package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.modal.BullOffWinnerModal_MC;
	import com.bored.games.darts.assets.modal.ContinueClick_MC;
	import com.bored.games.darts.assets.modal.TurnAnnounceModal_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.greensock.TweenMax;
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
	public class TurnAnnounceModal extends ContentHolder
	{
		private var _playerNameText:TextField;
		private var _playerImage:MovieClip;
		
		private var _delayedCall:TweenMax;
		
		public function TurnAnnounceModal() 
		{
			super(new TurnAnnounceModal_MC(), false, true);
			
			if (this.stage) {
				addedToStage();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			
		}//end constructor()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			_delayedCall = TweenMax.delayedCall(3, dismissPopup);
			
			this.addEventListener(MouseEvent.CLICK, dismissPopup, false, 0, true);
		}//end addedToStage()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_playerNameText = descendantsDict["playerName_text"] as TextField;
			_playerImage = descendantsDict["playerPicHolder_mc"] as MovieClip;
			
			if (_playerNameText)
			{
				if ( DartsGlobals.instance.gameManager.currentPlayer == DartsGlobals.instance.localPlayer.playerNum ) 
				{
					_playerNameText.text = "Your Turn";
				}
				else
				{
					_playerNameText.text = DartsGlobals.instance.gameManager.players[DartsGlobals.instance.gameManager.currentPlayer].playerName + "'s Turn";
				}
			}
			else
			{
				throw new Error("TurnAnnounceModal::buildFrom(): _playerNameText=" + _playerNameText);
			}
			
			if (_playerImage)
			{
				_playerImage.addChild(DartsGlobals.instance.gameManager.players[DartsGlobals.instance.gameManager.currentPlayer].portrait);
			}
			else
			{
				throw new Error("TurnAnnounceModal::buildFrom(): _playerImage=" + _playerImage);
			}
					
			return descendantsDict;
			
		}//end buildFrom()
		
		private function dismissPopup(a_evt:Event = null):void
		{
			this.removeEventListener(MouseEvent.CLICK, dismissPopup);
			
			_delayedCall.kill();
			
			DartsGlobals.instance.processModalQueue();
			
			if ( DartsGlobals.instance.gameManager.currentPlayer == DartsGlobals.instance.localPlayer.playerNum ) 
			{
				DartsGlobals.instance.gameManager.pause(false);
			}
			
			DartsGlobals.instance.gameManager.startNewTurn();
		}//end handleClick()
	}//end TurnAnnounceModal

}//end com.bored.games.darts.ui.modals