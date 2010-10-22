package com.bored.games.darts.ui 
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
		public static const STORY_GAME_CLICKED_EVT:String = "StoryGameClickedEvent";
		public static const PRACTICE_CRICKET_GAME_CLICKED_EVT:String = "PracticeCricketGameClickedEvent";
		public static const PRACTICE_501_GAME_CLICKED_EVT:String = "Practice501GameClickedEvent";
		public static const MULTIPLAYER_CRICKET_GAME_CLICKED_EVT:String = "MutliplayerCricketGameClickedEvent";
		public static const MULTIPLAYER_501_GAME_CLICKED_EVT:String = "Mutliplayer501GameClickedEvent";
		
		private var _background:Sprite;
		private var _buildBackground:Boolean = false;
		
		private var _storyGameBtn:MightyButton;
		private var _storyGameBtnImg:MovieClip;
		
		private var _practiceCricketGameBtn:MightyButton;
		private var _practiceCricketGameBtnImg:MovieClip;
		
		private var _practice501GameBtn:MightyButton;
		private var _practice501GameBtnImg:MovieClip;		
		
		private var _multiplayerCricketGameBtn:MightyButton;
		private var _multiplayerCricketGameBtnImg:MovieClip;
		
		private var _multiplayer501GameBtn:MightyButton;
		private var _multiplayer501GameBtnImg:MovieClip;
		
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
			
			_storyGameBtnImg = descendantsDict["storyButton_mc"] as MovieClip;
			_practiceCricketGameBtnImg = descendantsDict["practiceCricketButton_mc"] as MovieClip;
			_practice501GameBtnImg = descendantsDict["practice501Button_mc"] as MovieClip;
			_multiplayerCricketGameBtnImg = descendantsDict["multiplayerCricketButton_mc"] as MovieClip;
			_multiplayer501GameBtnImg = descendantsDict["multiplayer501Button_mc"] as MovieClip;
					
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
			
			if (_practiceCricketGameBtnImg)
			{
				_practiceCricketGameBtn = new MightyButton(_practiceCricketGameBtnImg, false);
				_practiceCricketGameBtn.pause(false);
				_practiceCricketGameBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPracticeCricketGameClicked, false, 0, true);
			}
			else
			{
				throw new Error("TitleScreen::buildFrom(): _practiceCricketGameBtnImg=" + _practiceCricketGameBtnImg);
			}
			
			if (_practice501GameBtnImg)
			{
				_practice501GameBtn = new MightyButton(_practice501GameBtnImg, false);
				_practice501GameBtn.pause(false);
				_practice501GameBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPractice501GameClicked, false, 0, true);
			}
			else
			{
				throw new Error("TitleScreen::buildFrom(): _practice501GameBtnImg=" + _practice501GameBtnImg);
			}
			
			if (_multiplayerCricketGameBtnImg)
			{
				_multiplayerCricketGameBtn = new MightyButton(_multiplayerCricketGameBtnImg, false);
				_multiplayerCricketGameBtn.pause(false);
				_multiplayerCricketGameBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onMultiplayerCricketGameClicked, false, 0, true);
			}
			else
			{
				throw new Error("TitleScreen::buildFrom(): _multiplayerCricketGameBtnImg=" + _multiplayerCricketGameBtnImg);
			}
			
			if (_multiplayer501GameBtnImg)
			{
				_multiplayer501GameBtn = new MightyButton(_multiplayer501GameBtnImg, false);
				_multiplayer501GameBtn.pause(false);
				_multiplayer501GameBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onMultiplayer501GameClicked, false, 0, true);
			}
			else
			{
				throw new Error("TitleScreen::buildFrom(): _multiplayer501GameBtnImg=" + _multiplayer501GameBtnImg);
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
		
		private function onStoryGameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(STORY_GAME_CLICKED_EVT));
						
			if (_storyGameBtn)
			{
				_storyGameBtn.pause(true);
			}
			
			if (_practiceCricketGameBtn)
			{
				_practiceCricketGameBtn.pause(true);
			}
			
			if (_practice501GameBtn)
			{
				_practice501GameBtn.pause(true);
			}
			
			if (_multiplayerCricketGameBtn)
			{
				_multiplayerCricketGameBtn.pause(true);
			}
			
			if (_multiplayer501GameBtn)
			{
				_multiplayer501GameBtn.pause(true);
			}
			
			// simply hide ourselves and remove ourselves from the display list.
			TweenLite.to(this, 0.4, {alpha:0, onComplete:destroy} );
			
		}//end onStoryGameClicked()
		
		private function onPracticeCricketGameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(PRACTICE_CRICKET_GAME_CLICKED_EVT));
			
			if (_storyGameBtn)
			{
				_storyGameBtn.pause(true);
			}
			
			if (_practiceCricketGameBtn)
			{
				_practiceCricketGameBtn.pause(true);
			}
			
			if (_practice501GameBtn)
			{
				_practice501GameBtn.pause(true);
			}
			
			if (_multiplayerCricketGameBtn)
			{
				_multiplayerCricketGameBtn.pause(true);
			}
			
			if (_multiplayer501GameBtn)
			{
				_multiplayer501GameBtn.pause(true);
			}
			
			//Tweener.addTween(this, { alpha:0, onComplete:destroy, time:0.4 } );
			
		}//end onPracticeCricketGameClicked()
		
		private function onPractice501GameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(PRACTICE_501_GAME_CLICKED_EVT));
			
			if (_storyGameBtn)
			{
				_storyGameBtn.pause(true);
			}
			
			if (_practiceCricketGameBtn)
			{
				_practiceCricketGameBtn.pause(true);
			}
			
			if (_practice501GameBtn)
			{
				_practice501GameBtn.pause(true);
			}
			
			if (_multiplayerCricketGameBtn)
			{
				_multiplayerCricketGameBtn.pause(true);
			}
			
			if (_multiplayer501GameBtn)
			{
				_multiplayer501GameBtn.pause(true);
			}
			
			//Tweener.addTween(this, { alpha:0, onComplete:destroy, time:0.4 } );
			
		}//end onPractice501GameClicked()
		
		private function onMultiplayerCricketGameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(MULTIPLAYER_CRICKET_GAME_CLICKED_EVT));
			
			if (_storyGameBtn)
			{
				_storyGameBtn.pause(true);
			}
			
			if (_practiceCricketGameBtn)
			{
				_practiceCricketGameBtn.pause(true);
			}
			
			if (_practice501GameBtn)
			{
				_practice501GameBtn.pause(true);
			}
			
			if (_multiplayerCricketGameBtn)
			{
				_multiplayerCricketGameBtn.pause(true);
			}
			
			if (_multiplayer501GameBtn)
			{
				_multiplayer501GameBtn.pause(true);
			}
			
			// simply hide ourselves and remove ourselves from the display list.
			TweenLite.to(this, 0.4, {alpha:0, onComplete:destroy} );
			
		}//end onMultiplayerCricketGameClicked()
		
		private function onMultiplayer501GameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(MULTIPLAYER_501_GAME_CLICKED_EVT));
			
			if (_storyGameBtn)
			{
				_storyGameBtn.pause(true);
			}
			
			if (_practiceCricketGameBtn)
			{
				_practiceCricketGameBtn.pause(true);
			}
			
			if (_practice501GameBtn)
			{
				_practice501GameBtn.pause(true);
			}
			
			if (_multiplayerCricketGameBtn)
			{
				_multiplayerCricketGameBtn.pause(true);
			}
			
			if (_multiplayer501GameBtn)
			{
				_multiplayer501GameBtn.pause(true);
			}
			
			// simply hide ourselves and remove ourselves from the display list.
			TweenLite.to(this, 0.4, {alpha:0, onComplete:destroy} );
			
		}//end onMultiplayer501GameClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			if (_storyGameBtn)
			{
				_storyGameBtn.removeEventListener(MouseEvent.CLICK, onStoryGameClicked);
			}
			
			if (_practiceCricketGameBtn)
			{
				_practiceCricketGameBtn.removeEventListener(MouseEvent.CLICK, onPracticeCricketGameClicked);
			}
			
			if (_practice501GameBtn)
			{
				_practice501GameBtn.removeEventListener(MouseEvent.CLICK, onPractice501GameClicked);
			}
			
			if (_multiplayerCricketGameBtn)
			{
				_multiplayerCricketGameBtn.removeEventListener(MouseEvent.CLICK, onMultiplayerCricketGameClicked);
			}
			
			if (_multiplayer501GameBtn)
			{
				_multiplayer501GameBtn.removeEventListener(MouseEvent.CLICK, onMultiplayer501GameClicked);
			}
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_storyGameBtnImg = null;
			_practiceCricketGameBtnImg = null;
			_practice501GameBtnImg = null;
			_multiplayerCricketGameBtnImg = null;
			_multiplayer501GameBtnImg = null;
			
			_storyGameBtn = null;
			_practiceCricketGameBtn = null;
			_practice501GameBtn = null;
			_multiplayerCricketGameBtn = null;
			_multiplayer501GameBtn = null;
			
			_background = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class TitleScreen
	
}//end package com.bored.games.darts.ui 