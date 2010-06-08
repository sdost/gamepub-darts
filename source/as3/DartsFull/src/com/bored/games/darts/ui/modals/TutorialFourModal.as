package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.GameUtils;
	import com.greensock.TweenMax;
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
	public class TutorialFourModal extends ContentHolder
	{
		private var _tutorialPopup:TextField;
		
		public function TutorialFourModal() 
		{
			super(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.tutorialModalSprite), false, true);
			
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
			
			TweenMax.delayedCall(10, dismissPopup);
		}//end addedToStage()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_tutorialPopup = descendantsDict["tutorialPopup_text"] as TextField;
			
			if (_tutorialPopup) 
			{
				_tutorialPopup.text = "The icons on the lower left are special abilities. Click to use them; they recharge after a number of rounds.";
			}
			else
			{
				throw new Error("TutorialFourModal::buildFrom(): _tutorialPopup=" + _tutorialPopup);
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function dismissPopup():void
		{
			DartsGlobals.instance.processModalQueue();
		}//end handleClick()
		
		override public function destroy(...args):void
		{
			super.destroy();	
			
			_tutorialPopup = null;
						
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
		}//end destroy()
		
	}//end TutorialFourModal

}//end com.bored.games.darts.ui.modals