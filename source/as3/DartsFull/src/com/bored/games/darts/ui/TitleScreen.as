﻿package com.bored.games.darts.ui 
{
	import com.bored.games.darts.DartsGlobals;
	import com.greensock.TweenLite;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
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
	public class TitleScreen extends ContentHolder
	{
		public static const PRACTICE_GAME_CLICKED_EVT:String = "PracticeGameClickedEvent";
		public static const STORY_GAME_CLICKED_EVT:String = "StoryGameClickedEvent";
		public static const MULTIPLAYER_GAME_CLICKED_EVT:String = "MutliplayerGameClickedEvent";
		
		private var _background:Sprite;
		private var _buildBackground:Boolean = false;
		
		private var _practiceGameBtn:MightyButton;
		private var _practiceGameBtnImg:MovieClip;
		
		private var _storyGameBtn:MightyButton;
		private var _storyGameBtnImg:MovieClip;
		
		private var _multiplayerGameBtn:MightyButton;
		private var _multiplayerGameBtnImg:MovieClip;
		
		public function TitleScreen(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true, a_buildBackground:Boolean = false) 
		{
			super(a_img, a_buildFromAllDescendants, a_bAddContents);
			
			_buildBackground = a_buildBackground;
			
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
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_practiceGameBtnImg = descendantsDict["practiceButton_mc"] as MovieClip;
			_storyGameBtnImg = descendantsDict["storyButton_mc"] as MovieClip;
			_multiplayerGameBtnImg = descendantsDict["multiplayerButton_mc"] as MovieClip;
			
			if (_practiceGameBtnImg)
			{
				_practiceGameBtn = new MightyButton(_practiceGameBtnImg, false);
				_practiceGameBtn.pause(false);
				_practiceGameBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPracticeGameClicked, false, 0, true);
			}
			else
			{
				throw new Error("TitleScreen::buildFrom(): _practiceGameBtnImg=" + _practiceGameBtnImg);
			}
			
			if (_storyGameBtnImg)
			{
				_storyGameBtn = new MightyButton(_storyGameBtnImg, false);
				_storyGameBtn.pause(false);
				_storyGameBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onStoryGameClicked, false, 0, true);
			}
			else
			{
				throw new Error("TitleScreen::buildFrom(): _storyGameBtnImg=" + _storyGameBtnImg);
			}
			
			if (_multiplayerGameBtnImg)
			{
				_multiplayerGameBtn = new MightyButton(_multiplayerGameBtnImg, false);
				_multiplayerGameBtn.pause(false);
				_multiplayerGameBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onMultiplayerGameClicked, false, 0, true);
			}
			else
			{
				throw new Error("TitleScreen::buildFrom(): _multiplayerGameBtnImg=" + _multiplayerGameBtnImg);
			}
			
			if(_buildBackground)
			{
				_background = new Sprite();
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			// build our background.
			if (_background)
			{
				_background.graphics.beginFill(0x000000, .75);
				_background.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
				_background.graphics.endFill();
			}
			
			this.contentsMC.alpha = 1;
			
			this.alpha = 0;
			
			if(_background)
			{
				var contentIndex:int = this.getChildIndex(this.contents);
				this.addChildAt(_background, contentIndex);
			}
			
			this.contentsMC.x = (this.stage.stageWidth / 2) - (this.contentsMC.width / 2);
			this.contentsMC.y = (this.stage.stageHeight / 2) - (this.contentsMC.height / 2);
			
			TweenLite.to(this, 2, {alpha:1} );
			
		}//end addedToStage()
		
		private function onPracticeGameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(PRACTICE_GAME_CLICKED_EVT));
			
			if (_practiceGameBtn)
			{
				_practiceGameBtn.pause(true);
			}
			
			if (_storyGameBtn)
			{
				_storyGameBtn.pause(true);
			}
			
			if (_multiplayerGameBtn)
			{
				_multiplayerGameBtn.pause(true);
			}
			
			//Tweener.addTween(this, { alpha:0, onComplete:destroy, time:0.4 } );
			
		}//end onPracticeGameClicked()
		
		private function onStoryGameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(STORY_GAME_CLICKED_EVT));
			
			if (_practiceGameBtn)
			{
				_practiceGameBtn.pause(true);
			}
			
			if (_storyGameBtn)
			{
				_storyGameBtn.pause(true);
			}
			
			if (_multiplayerGameBtn)
			{
				_multiplayerGameBtn.pause(true);
			}
			
			// simply hide ourselves and remove ourselves from the display list.
			TweenLite.to(this, 0.4, {alpha:0, onComplete:destroy} );
			
		}//end onStoryGameClicked()
		
		private function onMultiplayerGameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(MULTIPLAYER_GAME_CLICKED_EVT));
			
			if (_practiceGameBtn)
			{
				_practiceGameBtn.pause(true);
			}
			
			if (_storyGameBtn)
			{
				_storyGameBtn.pause(true);
			}
			
			if (_multiplayerGameBtn)
			{
				_multiplayerGameBtn.pause(true);
			}
			
			// simply hide ourselves and remove ourselves from the display list.
			TweenLite.to(this, 0.4, {alpha:0, onComplete:destroy} );
			
		}//end onMultiplayerGameClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			if(_practiceGameBtn)
			{
				_practiceGameBtn.removeEventListener(MouseEvent.CLICK, onPracticeGameClicked);
			}
			
			if (_storyGameBtn)
			{
				_storyGameBtn.removeEventListener(MouseEvent.CLICK, onStoryGameClicked);
			}
			
			if (_multiplayerGameBtn)
			{
				_multiplayerGameBtn.removeEventListener(MouseEvent.CLICK, onMultiplayerGameClicked);
			}
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_practiceGameBtnImg = null;
			_storyGameBtnImg = null;
			_multiplayerGameBtnImg = null;
			
			_practiceGameBtn = null;
			_storyGameBtn = null;
			_multiplayerGameBtn = null;
			
			_background = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class TitleScreen
	
}//end package com.bored.games.darts.ui 