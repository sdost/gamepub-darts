package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.logic.RemoteCricketGameLogic;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.sven.factories.SpriteFactory;
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
	public class OpponentQuitModal extends ContentHolder
	{
		private var _lobbyBtnImg:MovieClip;
		private var _lobbyBtn:MightyButton;
		
		public function OpponentQuitModal() 
		{
			super(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.opponentQuitModalSprite), false, true);
		
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
			
			Mouse.show();
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("yes_sound", "button_x_yes_mp3") );
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("no_sound", "button_x_no_mp3") );
		}//end addedToStage()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_lobbyBtnImg = descendantsDict["lobbyBtn_mc"] as MovieClip;
			
			if (_lobbyBtnImg) 
			{
				_lobbyBtn = new MightyButton(_lobbyBtnImg, false);
				_lobbyBtn.pause(false);
				_lobbyBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, lobbyClicked, false, 0, true);
			}
			else
			{
				throw new Error("OpponentQuitModal::buildFrom(): _lobbyBtnImg=" + _lobbyBtnImg);
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function lobbyClicked(evt:Event):void
		{
			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.resetDarts();
			DartsGlobals.instance.gameManager.endTurn();
			
			DartsGlobals.instance.gameManager.pause(false);
			
			DartsGlobals.instance.gameManager.dispatchEvent(new Event(RemoteCricketGameLogic.RETURN_TO_LOBBY));
		}//end onYesClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();	
			
			_lobbyBtnImg = null;
			
			_lobbyBtn = null;
						
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
		}//end destroy()
		
	}//end OpponentQuitModal

}//end com.bored.games.darts.ui.modals