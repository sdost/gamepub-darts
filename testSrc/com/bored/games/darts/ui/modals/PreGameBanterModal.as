package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.modals.ConversationModal_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.GameUtils;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
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
	public class PreGameBanterModal extends ContentHolder
	{
		private var _playerOnePortrait:MovieClip;
		private var _playerTwoPortrait:MovieClip;
		
		private var _playerOneBanter:TextField;
		private var _playerTwoBanter:TextField;
		
		public function PreGameBanterModal() 
		{
			super(new ConversationModal_MC(), false, true);
			
			if (this.stage) {
				addedToStage();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			
		}//end constructor()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			this.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}//end addedToStage()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_playerOnePortrait = descendantsDict["playerOnePortrait_mc"] as MovieClip;
			_playerTwoPortrait = descendantsDict["playerTwoPortrait_mc"] as MovieClip;
			
			_playerOneBanter = descendantsDict["playerOneBanter_text"] as TextField;
			_playerTwoBanter = descendantsDict["playerTwoBanter_text"] as TextField;
			
			if (_playerOnePortrait)
			{
				_playerOnePortrait.addChild(DartsGlobals.instance.gameManager.players[0].portrait);
			}
			else
			{
				throw new Error("PreGameBanterModal::buildFrom(): _playerOnePortrait=" + _playerOnePortrait);
			}
			
			if (_playerTwoPortrait)
			{
				_playerTwoPortrait.addChild(DartsGlobals.instance.gameManager.players[1].portrait);
			}
			else
			{
				throw new Error("PreGameBanterModal::buildFrom(): _playerTwoPortrait=" + _playerTwoPortrait);
			}

			
			if (_playerOneBanter) 
			{
				_playerOneBanter.text = "Blah blah...";
			}
			else
			{
				throw new Error("PreGameBanterModal::buildFrom(): _playerOneBanter=" + _playerOneBanter);
			}
			
			if (_playerTwoBanter) 
			{
				_playerTwoBanter.text = DartsGlobals.instance.enemyProfile.firstMatch;
			}
			else
			{
				throw new Error("PreGameBanterModal::buildFrom(): _playerTwoBanter=" + _playerTwoBanter);
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function handleClick(a_evt:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.CLICK, handleClick);
			
			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.pause(false);
			
			//DartsGlobals.instance.gameManager.bullOff();
			
			DartsGlobals.instance.gameManager.startNewTurn();
		}//end handleClick()
		
		private function formatTime(a_ms:int):String
		{
			var min:int = Math.floor((a_ms / 1000) / 60);
			var sec:int = Math.floor((a_ms - min * 60 * 1000) % 60);
			
			return min + ":" + ((sec < 10) ? "0" : "") + sec;
		}//end formatTime()
		
	}//end PreGameBanterModal

}//end com.bored.games.darts.ui.modals