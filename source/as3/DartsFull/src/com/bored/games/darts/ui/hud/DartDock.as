﻿package com.bored.games.darts.ui.hud 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AbstractScoreManager;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.CricketScoreManager;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.greensock.TweenLite;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class DartDock extends ContentHolder
	{
		private var _counterText:TextField;
		
		public function DartDock(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
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
			
		}//end GameReadyPopup() constructor.
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var slot:Object;
			
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			_counterText = descendantsDict["counter_text"] as TextField;
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			this.contentsMC.alpha = 1;
			
			this.alpha = 0;
			
		}//end addedToStage()
		
		public function update():void
		{
			if ( DartsGlobals.instance.gameManager.currentTurn )
			{
				_counterText.text = DartsGlobals.instance.gameManager.currentTurn.throwsRemaining.toString();
			}
		}//end update()
		
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
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_counterText = null;
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 