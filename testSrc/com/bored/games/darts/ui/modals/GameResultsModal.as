package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.modal.ResultsModal_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		
		public function GameResultsModal() 
		{
			super(new ResultsModal_MC(), false, true);
		}//end constructor()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_rematchBtnImg = descendantsDict["rematchBtn_mc"] as MovieClip;
			_nextMatchBtnImg = descendantsDict["nextMatchBtn_mc"] as MovieClip;
			
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
			
			return descendantsDict;
			
		}//end buildFrom()
		
		public function init(a_object:Object):void
		{
			// TODO: maybe nothing here?
		}//end init()
		
		private function onRematchClicked(a_evt:Event):void
		{
			_rematchBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onRematchClicked);
			_nextMatchBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onNextMatchClicked);

			DartsGlobals.instance.processModalQueue();
		}//end onRematchClicked()
		
		private function onNextMatchClicked(a_evt:Event):void
		{
			_rematchBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onRematchClicked);
			_nextMatchBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onNextMatchClicked);

			DartsGlobals.instance.processModalQueue();
		}//end onRematchClicked()
		
	}//end GameResultsModal

}//end com.bored.games.darts.ui.modals