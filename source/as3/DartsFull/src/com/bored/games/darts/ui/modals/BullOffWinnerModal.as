package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.DartsGlobals;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.sven.containers.Panel;
	import com.sven.utils.AppSettings;
	import com.sven.utils.SpriteFactory;
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
			super(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.bullOffWinnerModalSprite), false, true);
			
			if (this.stage) {
				addedToStage();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			
		}//end constructor()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
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
				_playerNameText.text = DartsGlobals.instance.gameManager.players[DartsGlobals.instance.gameManager.currentPlayer].playerName;
			}
			else
			{
				throw new Error("BullOffWinnerModal::buildFrom(): _playerNameText=" + _playerNameText);
			}
			
			if (_playerImage)
			{
				_playerImage.addChild(DartsGlobals.instance.gameManager.players[DartsGlobals.instance.gameManager.currentPlayer].portrait);
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
						
			DartsGlobals.instance.showModalPopup(TurnAnnounceModal);
		}//end handleClick()
		
		override public function destroy(...args):void
		{
			super.destroy();	
			
			_playerNameText = null;
			_playerImage = null;
						
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
		}//end destroy()
		
	}//end BullOffWinnerModal

}//end com.bored.games.darts.ui.modals