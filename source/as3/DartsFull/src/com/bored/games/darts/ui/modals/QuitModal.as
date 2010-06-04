package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.sven.utils.SpriteFactory;
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
	public class QuitModal extends ContentHolder
	{
		private var _yesBtnImg:MovieClip;
		private var _yesBtn:MightyButton;
		
		private var _noBtnImg:MovieClip;
		private var _noBtn:MightyButton;
		
		public function QuitModal() 
		{
			super(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.quitModalSprite), false, true);
		
			if (this.stage) {
				addedToStage();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			
		}//end constructor()
		
		private function addedToStage(a_evt:Event = null):void
		{
			Mouse.show();
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("yes_sound", "button_x_yes_mp3") );
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("no_sound", "button_x_no_mp3") );
		}//end addedToStage()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_yesBtnImg = descendantsDict["yesBtn_mc"] as MovieClip;
			_noBtnImg = descendantsDict["noBtn_mc"] as MovieClip;
			
			if (_yesBtnImg) 
			{
				_yesBtn = new MightyButton(_yesBtnImg, false);
				_yesBtn.pause(false);
				_yesBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onYesClicked, false, 0, true);
			}
			else
			{
				throw new Error("QuitModal::buildFrom(): _yesBtnImg=" + _yesBtnImg);
			}
			
			if (_noBtnImg) 
			{
				_noBtn = new MightyButton(_noBtnImg, false);
				_noBtn.pause(false);
				_noBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onNoClicked, false, 0, true);
			}
			else
			{
				throw new Error("QuitModal::buildFrom(): _noBtnImg=" + _noBtnImg);
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function onYesClicked(evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("yes_sound");
			
			_yesBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onYesClicked);
			_noBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onNoClicked);

			DartsGlobals.instance.processModalQueue();
			
			//DartsGlobals.instance.gameManager.pause(false);
		
			DartsGlobals.instance.gameManager.dispatchEvent(new Event(DartsGameLogic.QUIT_TO_TITLE));
		}//end onYesClicked()
		
		private function onNoClicked(evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("no_sound");
			
			_yesBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onYesClicked);
			_noBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onNoClicked);
			
			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.pause(false);
		}//end onYesClicked()
		
	}//end QuitModal

}//end com.bored.games.darts.ui.modals