package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.AcheivementsModal_MC;
	import com.bored.games.darts.assets.HelpModal_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class HelpModal extends ContentHolder
	{
		private var _okayBtnImg:MovieClip;
		private var _okayBtn:MightyButton;
		
		public function HelpModal() 
		{
			super(new HelpModal_MC, false, true);
		
			if (this.stage) {
				addedToStage();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			
		}//end constructor()
		
		private function addedToStage(a_evt:Event = null):void
		{
			Mouse.show();
		}//end addedToStage()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_okayBtnImg = descendantsDict["okayBtn_mc"] as MovieClip;
			
			if (_okayBtnImg) 
			{
				_okayBtn = new MightyButton(_okayBtnImg, false);
				_okayBtn.pause(false);
				_okayBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOkayClicked, false, 0, true);
			}
			else
			{
				throw new Error("AchievementModal::buildFrom(): _okayBtnImg=" + _okayBtnImg);
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function onOkayClicked(evt:Event):void
		{			
			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.pause(false);
		}//end onOkayClicked()
		
	}//end HelpModal

}//end com.bored.games.darts.ui.modals