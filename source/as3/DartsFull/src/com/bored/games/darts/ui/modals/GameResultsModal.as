package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.GameUtils;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
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
	public class GameResultsModal extends ContentHolder
	{
		private var _rematchBtn:MightyButton;
		private var _rematchBtnImg:MovieClip;
		
		private var _nextMatchBtn:MightyButton;
		private var _nextMatchBtnImg:MovieClip;
		
		private var _matchValue:TextField;
		private var _statField:TextField;
		private var _headerField:TextField;
		
		public function GameResultsModal() 
		{
			super(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.resultsModalSprite), false, true);
			
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
		}//end addedToStage()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_rematchBtnImg = descendantsDict["rematchBtn_mc"] as MovieClip;
			_nextMatchBtnImg = descendantsDict["nextMatchBtn_mc"] as MovieClip;
			
			_matchValue = descendantsDict["matchValue_text"] as TextField;
			_statField = descendantsDict["statField_text"] as TextField;
			_headerField = descendantsDict["headerField_text"] as TextField;
			
			if (_rematchBtnImg)
			{
				_rematchBtn = new MightyButton(_rematchBtnImg, false);
				_rematchBtn.pause(false);
				_rematchBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onRematchClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameResultsModal::buildFrom(): _rematchBtnImg=" + _rematchBtnImg);
			}
			
			if (_nextMatchBtnImg)
			{
				_nextMatchBtn = new MightyButton(_nextMatchBtnImg, false);
				_nextMatchBtn.pause(false);
				_nextMatchBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onNextMatchClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameResultsModal::buildFrom(): _nextMatchBtnImg=" + _nextMatchBtnImg);
			}
			
			if (_matchValue) 
			{
				_matchValue.text = "Blah blah";
			}
			else
			{
				throw new Error("GameResultsModal::buildFrom(): _matchValue=" + _matchValue);
			}
			
			if (_statField) 
			{
				_statField.text = "Throws: " + DartsGlobals.instance.localPlayer.record.throws + "\n";
				_statField.appendText("Time: " + formatTime(GameUtils.playTime) + "\n");
				_statField.appendText("Doubles: " + DartsGlobals.instance.localPlayer.record.doubles + "\n");
				_statField.appendText("Triples: " + DartsGlobals.instance.localPlayer.record.triples);
			}
			else
			{
				throw new Error("GameResultsModal::buildFrom(): _statField=" + _statField);
			}
			
			if (_headerField) 
			{
				if ( DartsGlobals.instance.localPlayer.record.wonGame() ) {
					_headerField.text = "Victory!";
				} else {
					_headerField.text = "Defeat!";
				}
			}
			else
			{
				throw new Error("GameResultsModal::buildFrom(): _headerField=" + _headerField);
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function formatTime(a_ms:int):String
		{
			var min:int = Math.floor((a_ms / 1000) / 60);
			var sec:int = Math.floor((a_ms - min * 60 * 1000) % 60);
			
			return min + ":" + ((sec < 10) ? "0" : "") + sec;
		}//end formatTime()
		
		public function init(a_object:Object):void
		{
			// TODO: maybe nothing here?
		}//end init()
		
		private function onRematchClicked(a_evt:Event):void
		{
			_rematchBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onRematchClicked);
			_nextMatchBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onNextMatchClicked);

			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.resetDarts();
			DartsGlobals.instance.gameManager.endTurn();
			
			DartsGlobals.instance.gameManager.newGame();
			DartsGlobals.instance.gameManager.startNewTurn();
			
			DartsGlobals.instance.gameManager.pause(false);
		}//end onRematchClicked()
		
		private function onNextMatchClicked(a_evt:Event):void
		{
			_rematchBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onRematchClicked);
			_nextMatchBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onNextMatchClicked);

			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.resetDarts();
			DartsGlobals.instance.gameManager.endTurn();
			
			DartsGlobals.instance.gameManager.pause(false);
			
			DartsGlobals.instance.gameManager.dispatchEvent(new Event(DartsGameLogic.GAME_END));
		}//end onRematchClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();	
			
			_rematchBtnImg = null;
			_nextMatchBtnImg = null;
			
			_matchValue = null;
			_statField = null;
			_headerField = null;
			
			_nextMatchBtn = null
			_rematchBtn = null;
						
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
		}//end destroy()
		
	}//end GameResultsModal

}//end com.bored.games.darts.ui.modals