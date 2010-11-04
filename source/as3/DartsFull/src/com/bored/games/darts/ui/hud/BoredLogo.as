package com.bored.games.darts.ui.hud 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.ui.buttons.ToggleButton;
	import com.bored.games.darts.ui.modals.AchievementsModal;
	import com.bored.games.darts.ui.modals.QuitModal;
	import com.bored.services.BoredServices;
	import com.greensock.TweenLite;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundManager;
	import com.sven.utils.AppSettings;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.net.navigateToURL;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BoredLogo extends ContentHolder
	{
		public var _boredButton:MightyButton;
		
		public function BoredLogo(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
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
			
			var boredButtonImg:MovieClip = descendantsDict["boredBtn_mc"] as MovieClip;
			
			if (boredButtonImg)
			{
				_boredButton = new MightyButton(boredButtonImg, false);
				_boredButton.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onLogoPress, false, 0 , true);
				_boredButton.pause(false);
			}
			else
			{
				throw new Error("BoredLogo::buildFrom(): _boredButton=" + _boredButton);
			}
				
			_boredButton.buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			
			return descendantsDict;
		}//end buildFrom()
		
		private function onMouseOver(a_evt:MouseEvent):void
		{
			Mouse.show();
		}//end onMouseOver()
		
		private function onLogoPress(e:Event):void
		{
			//BoredServices.			
		}//end onLogoPress()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			this.contentsMC.alpha = 1;
			
			this.alpha = 0;
		}//end addedToStage()
		
		public function show():void
		{
			TweenLite.to(this, 2, {alpha:1} );
		}//end show()
		
		public function hide():void
		{
			TweenLite.to(this, 2, {alpha:0} );
		}//end hide()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			_boredButton.buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			_boredButton.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onLogoPress);
			_boredButton = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}//end destroy()
		
	}//end BoredLogo

}//end com.bored.games.darts.ui.hud