package com.bored.games.darts.ui.hud 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.ui.buttons.ToggleButton;
	import com.bored.games.darts.ui.modals.AchievementsModal;
	import com.bored.games.darts.ui.modals.HelpModal;
	import com.bored.games.darts.ui.modals.QuitModal;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CashPanel extends ContentHolder
	{
		private var _gameCash:TextField;
		
		public function CashPanel(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
		{
			super(a_img, a_buildFromAllDescendants, a_bAddContents);
			
			if (this.stage)
			{
				addedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
		}//end constructor()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			_gameCash = descendantsDict["gameCash_text"] as TextField;
			
			if (_gameCash)
			{
				_gameCash.text = "$" + DartsGlobals.instance.externalServices.getData("gameCash");
				this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			}
			else
			{
				throw new Error("CashPanel::buildFrom(): _gameCash=" + _gameCash);
			}
						
			return descendantsDict;
		}//end buildFrom()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			this.contentsMC.alpha = 1;
			
			this.alpha = 0;
		}//end addedToStage()
		
		private function update(a_evt:Event):void
		{
			_gameCash.text = "$" + DartsGlobals.instance.externalServices.getData("gameCash");
		}//end update()
		
		public function show():void
		{
			Tweener.addTween(this, {alpha:1, time:2 } );
		}//end show()
		
		public function hide():void
		{
			Tweener.addTween(this, {alpha:0, time:2 } );
		}//end hide()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}//end destroy()
		
	}//end CashPanel

}//end com.bored.games.darts.ui.hud