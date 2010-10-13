package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.DartsGlobals;
	import com.greensock.TweenMax;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.sven.containers.Panel;
	import com.sven.utils.AppSettings;
	import com.sven.factories.SpriteFactory;
	import flash.display.Bitmap;
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
		
		private var _throwsFirstText:TextField;
		
		private var _delayedCall:TweenMax;
		
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
				if ( DartsGlobals.instance.gameManager.bullOffWinner == DartsGlobals.instance.localPlayer.playerNum ) 
				{
					_playerNameText.text = "You";
					
				}
				else
				{
					_playerNameText.text = DartsGlobals.instance.gameManager.players[DartsGlobals.instance.gameManager.bullOffWinner].playerName;
				}
			}
			else
			{
				throw new Error("BullOffWinnerModal::buildFrom(): _playerNameText=" + _playerNameText);
			}
			
			if (_playerImage)
			{
				var portrait:Bitmap = new Bitmap(DartsGlobals.instance.gameManager.players[DartsGlobals.instance.gameManager.bullOffWinner].portrait);
				portrait.smoothing = true;
				portrait.width = 58;
				portrait.height = 58;
				
				_playerImage.addChild(portrait);
			}
			else
			{
				throw new Error("BullOffWinnerModal::buildFrom(): _playerImage=" + _playerImage);
			}
			
			_throwsFirstText = descendantsDict["throwsFirst_text"] as TextField;
			
			if (_throwsFirstText)
			{
				if ( DartsGlobals.instance.gameManager.bullOffWinner == DartsGlobals.instance.localPlayer.playerNum ) 
				{
					_throwsFirstText.text = "Throw First!";
					
				}
				else
				{
					_throwsFirstText.text = "Throws First!";
				}
			}
			else
			{
				throw new Error("BullOffWinnerModal::buildFrom(): _throwsFirstText=" + _throwsFirstText);
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
		
		override public function destroy(...args):void
		{
			super.destroy();	
			
			_playerNameText = null;
			_playerImage = null;
			
			_delayedCall = null;
						
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
		}//end destroy()
		
	}//end BullOffWinnerModal

}//end com.bored.games.darts.ui.modals