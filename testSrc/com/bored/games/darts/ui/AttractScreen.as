package com.bored.games.darts.ui 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.DartsGlobals;
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
	public class AttractScreen extends ContentHolder
	{
		public static const NEW_GAME_CLICKED_EVT:String = "NewGameClickedEvent";
		public static const RESUME_GAME_CLICKED_EVT:String = "ResumeGameClickedEvent";
		
		private var _background:Sprite;
		private var _buildBackground:Boolean = false;
		
		private var _newGameBtn:MightyButton;
		private var _newGameBtnImg:MovieClip;
		
		private var _resumeGameBtn:MightyButton;
		private var _resumeGameBtnImg:MovieClip;
		
		public function AttractScreen(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true, a_buildBackground:Boolean = false) 
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
			
			_newGameBtnImg = descendantsDict["newGameBtn_mc"] as MovieClip;
			_resumeGameBtnImg = descendantsDict["resumeGameBtn_mc"] as MovieClip;
			
			if (_newGameBtnImg)
			{
				_newGameBtn = new MightyButton(_newGameBtnImg, false);
				_newGameBtn.pause(false);
				_newGameBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onNewGameClicked, false, 0, true);
			}
			else
			{
				throw new Error("AttractScreen::buildFrom(): _newGameBtnImg=" + _newGameBtnImg);
			}
			
			if (_resumeGameBtnImg)
			{
				_resumeGameBtn = new MightyButton(_resumeGameBtnImg, false);
				_resumeGameBtn.pause(false);
				_resumeGameBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onResumeGameClicked, false, 0, true);
			}
			else
			{
				throw new Error("AttractScreen::buildFrom(): _resumeGameBtnImg=" + _resumeGameBtnImg);
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
			
			Tweener.addTween(this, {alpha:1, time:2 } );
			
		}//end addedToStage()
		
		private function onNewGameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(NEW_GAME_CLICKED_EVT));
			
			if (_newGameBtn)
			{
				_newGameBtn.pause(true);
			}
			
			if (_resumeGameBtn)
			{
				_resumeGameBtn.pause(true);
			}
			
			Tweener.addTween(this, { alpha:0, onComplete:destroy, time:0.4 } );
			
		}//end onPlayNowClicked()
		
		private function onResumeGameClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(RESUME_GAME_CLICKED_EVT));
			
			if (_newGameBtn)
			{
				_newGameBtn.pause(true);
			}
			
			if (_resumeGameBtn)
			{
				_resumeGameBtn.pause(true);
			}
			
			// simply hide ourselves and remove ourselves from the display list.
			Tweener.addTween(this, {alpha:0, onComplete:destroy, time:0.4 } );
			
		}//end onIgnoreClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			if(_newGameBtn)
			{
				_newGameBtn.removeEventListener(MouseEvent.CLICK, onNewGameClicked);
			}
			
			if (_resumeGameBtn)
			{
				_resumeGameBtn.removeEventListener(MouseEvent.CLICK, onResumeGameClicked);
			}
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_newGameBtn = null;
			_resumeGameBtn = null;
			_background = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 