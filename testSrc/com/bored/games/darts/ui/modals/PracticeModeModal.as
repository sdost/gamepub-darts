﻿package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.assets.AcheivementsModal_MC;
	import com.bored.games.darts.assets.modal.PracticeModal_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.jac.soundManager.SMSound;
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
	public class PracticeModeModal extends ContentHolder
	{
		private var _beginnerBtnImg:MovieClip;
		private var _beginnerBtn:MightyButton;
		
		private var _expertBtnImg:MovieClip;
		private var _expertBtn:MightyButton;
		
		public function PracticeModeModal() 
		{
			super(new PracticeModal_MC(), false, true);
		
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
			
			_beginnerBtnImg = descendantsDict["beginnerButton_mc"] as MovieClip;
			_expertBtnImg = descendantsDict["expertButton_mc"] as MovieClip;
			
			if (_beginnerBtnImg) 
			{
				_beginnerBtn = new MightyButton(_beginnerBtnImg, false);
				_beginnerBtn.pause(false);
				_beginnerBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onBeginningClicked, false, 0, true);
			}
			else
			{
				throw new Error("PracticeModeModal::buildFrom(): _beginnerBtnImg=" + _beginnerBtnImg);
			}
			
			if (_expertBtnImg) 
			{
				_expertBtn = new MightyButton(_expertBtnImg, false);
				_expertBtn.pause(false);
				_expertBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onExpertClicked, false, 0, true);
			}
			else
			{
				throw new Error("PracticeModeModal::buildFrom(): _expertBtnImg=" + _expertBtnImg);
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function onBeginningClicked(evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("yes_sound");
			
			_beginnerBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onBeginningClicked);
			_expertBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onExpertClicked);

			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.practiceMode = DartsGlobals.PRACTICE_BEGINNER;
			
			finish();
		}//end onYesClicked()
		
		private function onExpertClicked(evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("no_sound");
			
			_beginnerBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onBeginningClicked);
			_expertBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onExpertClicked);
			
			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.practiceMode = DartsGlobals.PRACTICE_EXPERT;
			
			finish();
		}//end onYesClicked()
		
		private function finish():void
		{
			(DartsGlobals.instance.stateMachine as GameFSM).transitionToStateNamed("Practice");
		}//end finish()
		
	}//end PracticeModeModal

}//end com.bored.games.darts.ui.modals