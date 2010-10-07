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
	import com.sven.factories.SpriteFactory;
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
	public class ThrowTutorialModal extends ContentHolder
	{
		public function ThrowTutorialModal() 
		{
			super(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.throwTutorialModalSprite), false, true);
			
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
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function dismissPopup():void
		{
			DartsGlobals.instance.processModalQueue();
			DartsGlobals.instance.externalServices.setData("seenThrowTutorial", true);
			DartsGlobals.instance.gameManager.pause(false);
		}//end handleClick()
		
	}//end ThrowTutorialModal

}//end com.bored.games.darts.ui.modals