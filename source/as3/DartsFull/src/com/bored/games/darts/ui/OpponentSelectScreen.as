package com.bored.games.darts.ui 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.profiles.AnthonyProfile;
	import com.bored.games.darts.profiles.BigBillProfile;
	import com.bored.games.darts.profiles.IreneProfile;
	import com.bored.games.darts.profiles.MackProfile;
	import com.bored.games.darts.profiles.OldManProfile;
	import com.bored.games.darts.profiles.ProfessorProfile;
	import com.bored.games.darts.profiles.SammyProfile;
	import com.bored.games.darts.profiles.SimonProfile;
	import com.hybrid.ui.ToolTip;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundController;
	import com.sven.utils.FontFactory;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class OpponentSelectScreen extends ContentHolder
	{
		public static const OPPONENT_CHOSEN_EVT:String = "OpponentChosenEvent";
		public static const SHOW_STORE_EVT:String = "ShowStoreEvent";
		
		private var _toolTipDict:Dictionary;
		
		private var _background:Sprite;
		private var _buildBackground:Boolean = false;
		
		private var _ireneBtn:MightyButton;
		private var _ireneBtnImg:MovieClip;
		
		private var _oldmanBtn:MightyButton;
		private var _oldmanBtnImg:MovieClip;
		
		private var _mackBtn:MightyButton;
		private var _mackBtnImg:MovieClip;
		
		private var _anthonyBtn:MightyButton;
		private var _anthonyBtnImg:MovieClip;
		
		private var _professorBtn:MightyButton;
		private var _professorBtnImg:MovieClip;
		
		private var _sammyBtn:MightyButton;
		private var _sammyBtnImg:MovieClip;
		
		private var _simonBtn:MightyButton;
		private var _simonBtnImg:MovieClip;
		
		private var _barkeepBtn:MightyButton;
		private var _barkeepBtnImg:MovieClip;
		
		private var _bigbillBtn:MightyButton;
		private var _bigbillBtnImg:MovieClip;
		
		private var _titleFont:TextFormat;
		private var _consoleFont:TextFormat;
		
		private var _characterSounds:SoundController;
		
		public function OpponentSelectScreen(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true, a_buildBackground:Boolean = false) 
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
			
			_toolTipDict = new Dictionary(false);
			
			_ireneBtnImg = descendantsDict["irene_mc"] as MovieClip;
			_oldmanBtnImg = descendantsDict["oldman_mc"] as MovieClip;		
			_mackBtnImg = descendantsDict["mack_mc"] as MovieClip;		
			_anthonyBtnImg = descendantsDict["anthony_mc"] as MovieClip;		
			_professorBtnImg = descendantsDict["professor_mc"] as MovieClip;		
			_sammyBtnImg = descendantsDict["sammy_mc"] as MovieClip;		
			_simonBtnImg = descendantsDict["simon_mc"] as MovieClip;
			_barkeepBtnImg = descendantsDict["barkeep_mc"] as MovieClip;
			_bigbillBtnImg = descendantsDict["bigbill_mc"] as MovieClip;
			
			var myFont:Font = FontFactory.getFontByQualifiedName("CooperStd");
			
			_titleFont = new TextFormat();
			_titleFont.font = myFont.fontName;
			_titleFont.size = 20;
			_titleFont.bold = true;
			_titleFont.color = 0x000000;
			
			_consoleFont = new TextFormat();
			_consoleFont.font = myFont.fontName;
			_consoleFont.size = 18;
			_consoleFont.bold = false;
			_consoleFont.color = 0x000000;
			
			_characterSounds = new SoundController("character_select_sounds");
			
			if (_ireneBtnImg)
			{
				_ireneBtn = new MightyButton(_ireneBtnImg, false);
				_ireneBtn.pause(false);
				_ireneBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOpponentClicked, false, 0, true);
				
				_ireneBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, function(a_evt:Event):void {
					generateToolTip(_ireneBtnImg).show(_ireneBtnImg, "Irene", "Prize: 1000 coins");
				});
			}
			else
			{
				throw new Error("OpponentSelectScreen::buildFrom(): _ireneBtnImg=" + _ireneBtnImg);
			}
			
			if (_oldmanBtnImg)
			{
				_oldmanBtn = new MightyButton(_oldmanBtnImg, false);
				_oldmanBtn.pause(false);
				_oldmanBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOpponentClicked, false, 0, true);
				
				_oldmanBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, function(a_evt:Event):void {
					generateToolTip(_oldmanBtnImg).show(_oldmanBtnImg, "Old Man", "Tutorial");
				});
			}
			else
			{
				throw new Error("OpponentSelectScreen::buildFrom(): _oldmanBtnImg=" + _oldmanBtnImg);
			}
			
			if (_mackBtnImg)
			{
				_mackBtn = new MightyButton(_mackBtnImg, false);
				_mackBtn.pause(false);
				_mackBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOpponentClicked, false, 0, true);
				
				_mackBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, function(a_evt:Event):void {
					generateToolTip(_mackBtnImg).show(_mackBtnImg, "Mack", "Prize: 100 coins");
				});
			}
			else
			{
				throw new Error("OpponentSelectScreen::buildFrom(): _mackBtnImg=" + _mackBtnImg);
			}
			
			if (_anthonyBtnImg)
			{
				_anthonyBtn = new MightyButton(_anthonyBtnImg, false);
				_anthonyBtn.pause(false);
				_anthonyBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOpponentClicked, false, 0, true);
				
				_anthonyBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, function(a_evt:Event):void {
					generateToolTip(_anthonyBtnImg).show(_anthonyBtnImg, "Anthony", "Prize: 250 coins");
				});
			}
			else
			{
				throw new Error("OpponentSelectScreen::buildFrom(): _anthonyBtnImg=" + _anthonyBtnImg);
			}
			
			if (_professorBtnImg)
			{
				_professorBtn = new MightyButton(_professorBtnImg, false);
				_professorBtn.pause(false);
				_professorBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOpponentClicked, false, 0, true);
				
				_professorBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, function(a_evt:Event):void {
					generateToolTip(_professorBtnImg).show(_professorBtnImg, "The Professor", "Prize: 2000 coins");
				});
				
				// Character Select...
				_characterSounds.addSound( new SMSound("prof_start1", "TheProf_ChrSelLetsPlayDarts_mp3") );
				_characterSounds.addSound( new SMSound("prof_start2", "TheProf_ChrSelTakeYouOn_mp3") );
				_characterSounds.addSound( new SMSound("prof_start3", "TheProf_ChrSelChallengeAccepted_mp3") );
				_characterSounds.addSound( new SMSound("prof_start4", "TheProf_ChrSelTimeForDarts_mp3") );
			}
			else
			{
				throw new Error("OpponentSelectScreen::buildFrom(): _professorBtnImg=" + _professorBtnImg);
			}
			
			if (_sammyBtnImg)
			{
				_sammyBtn = new MightyButton(_sammyBtnImg, false);
				_sammyBtn.pause(false);
				_sammyBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOpponentClicked, false, 0, true);
				
				_sammyBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, function(a_evt:Event):void {
					generateToolTip(_sammyBtnImg).show(_sammyBtnImg, "Sammy", "Prize: 50 coins");
				});
			}
			else
			{
				throw new Error("OpponentSelectScreen::buildFrom(): _sammyBtnImg=" + _sammyBtnImg);
			}
			
			if (_simonBtnImg)
			{
				_simonBtn = new MightyButton(_simonBtnImg, false);
				_simonBtn.pause(false);
				_simonBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOpponentClicked, false, 0, true);
				
				_simonBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, function(a_evt:Event):void {
					generateToolTip(_simonBtnImg).show(_simonBtnImg, "Simon", "Prize: 500 coins");
				});
			}
			else
			{
				throw new Error("OpponentSelectScreen::buildFrom(): _simonBtnImg=" + _simonBtnImg);
			}
			
			if (_barkeepBtnImg)
			{
				_barkeepBtn = new MightyButton(_barkeepBtnImg, false);
				_barkeepBtn.pause(false);
				_barkeepBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOpponentClicked, false, 0, true);
				
				_barkeepBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, function(a_evt:Event):void {
					generateToolTip(_barkeepBtnImg).show(_barkeepBtnImg, "Barkeep", "Store");
				});
			}
			else
			{
				throw new Error("OpponentSelectScreen::buildFrom(): _barkeepBtnImg=" + _barkeepBtnImg);
			}
			
			if (_bigbillBtnImg)
			{
				_bigbillBtn = new MightyButton(_bigbillBtnImg, false);
				_bigbillBtn.pause(false);
				_bigbillBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onOpponentClicked, false, 0, true);
				
				_bigbillBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, function(a_evt:Event):void {
					generateToolTip(_bigbillBtnImg).show(_bigbillBtnImg, "Big Bill", "Prize: 1500 coins");
				});
			}
			else
			{
				throw new Error("OpponentSelectScreen::buildFrom(): _bigbillBtnImg=" + _bigbillBtnImg);
			}
			
			if(_buildBackground)
			{
				_background = new Sprite();
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function generateToolTip(a_sprite:Sprite):ToolTip
		{
			var toolTip:ToolTip = new ToolTip();
			toolTip.colors = [ 0xFFFFFF, 0xFFFFCD6 ];
			toolTip.autoSize = true;
			toolTip.cornerRadius = 20;
			toolTip.align = "center";
			toolTip.border = 0x000000;
			toolTip.borderSize = 1;
			toolTip.titleFormat = _titleFont;
			toolTip.contentFormat = _consoleFont;
			
			return toolTip;
		}//end generateToolTip()
		
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
		
		private function onOpponentClicked(a_evt:ButtonEvent):void
		{						
			DartsGlobals.instance.opponentProfile = null;
			
			if(_ireneBtn)
			{
				if (a_evt.mightyButton == _ireneBtn) {
					DartsGlobals.instance.opponentProfile = new IreneProfile();
				}
				
				_ireneBtn.pause(true);
			}
			
			if(_oldmanBtn)
			{
				if (a_evt.mightyButton == _oldmanBtn) {
					DartsGlobals.instance.opponentProfile = new OldManProfile();
				}
				
				_oldmanBtn.pause(true);
			}
			
			if(_mackBtn)
			{
				if (a_evt.mightyButton == _mackBtn) {
					DartsGlobals.instance.opponentProfile = new MackProfile();
				}
				
				_mackBtn.pause(true);
			}
			
			if(_anthonyBtn)
			{
				if (a_evt.mightyButton == _anthonyBtn) {
					DartsGlobals.instance.opponentProfile = new AnthonyProfile();
				}
				
				_anthonyBtn.pause(true);
			}
			
			if(_professorBtn)
			{
				if (a_evt.mightyButton == _professorBtn) {
					DartsGlobals.instance.opponentProfile = new ProfessorProfile();
					
					var version:int = Math.ceil( Math.random() * 4 );
					
					_characterSounds.play("prof_start" + version.toString());
				}
				
				_professorBtn.pause(true);
			}
			
			if(_sammyBtn)
			{
				if (a_evt.mightyButton == _sammyBtn) {
					DartsGlobals.instance.opponentProfile = new SammyProfile();
				}
				
				_sammyBtn.pause(true);
			}
			
			if(_simonBtn)
			{
				if (a_evt.mightyButton == _simonBtn) {
					DartsGlobals.instance.opponentProfile = new SimonProfile();
				}
				
				_simonBtn.pause(true);
			}
			
			if(_barkeepBtn)
			{
				if (a_evt.mightyButton == _barkeepBtn) {
					this.dispatchEvent(new Event(SHOW_STORE_EVT));
					return;
				}
				
				_barkeepBtn.pause(true);
			}
			
			if(_bigbillBtn)
			{
				if (a_evt.mightyButton == _bigbillBtn) {
					DartsGlobals.instance.opponentProfile = new BigBillProfile();
				}
				
				_bigbillBtn.pause(true);
			}
			
			if (DartsGlobals.instance.opponentProfile) 
			{
				this.dispatchEvent(new Event(OPPONENT_CHOSEN_EVT));
			}
			
			Tweener.addTween(this, { alpha:0, onComplete:destroy, time:0.4 } );
			
		}//end onPlayNowClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			if(_ireneBtn)
			{
				_ireneBtn.removeEventListener(MouseEvent.CLICK, onOpponentClicked);
			}
			
			if(_oldmanBtn)
			{
				_oldmanBtn.removeEventListener(MouseEvent.CLICK, onOpponentClicked);
			}
			
			if(_mackBtn)
			{
				_mackBtn.removeEventListener(MouseEvent.CLICK, onOpponentClicked);
			}
			
			if(_anthonyBtn)
			{
				_anthonyBtn.removeEventListener(MouseEvent.CLICK, onOpponentClicked);
			}
			
			if(_professorBtn)
			{
				_professorBtn.removeEventListener(MouseEvent.CLICK, onOpponentClicked);
			}
			
			if(_sammyBtn)
			{
				_sammyBtn.removeEventListener(MouseEvent.CLICK, onOpponentClicked);
			}
			
			if(_simonBtn)
			{
				_simonBtn.removeEventListener(MouseEvent.CLICK, onOpponentClicked);
			}
			
			if(_barkeepBtn)
			{
				_barkeepBtn.removeEventListener(MouseEvent.CLICK, onOpponentClicked);
			}
			
			if(_bigbillBtn)
			{
				_bigbillBtn.removeEventListener(MouseEvent.CLICK, onOpponentClicked);
			}
			
						
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_ireneBtn = null;		
			_oldmanBtn = null;		
			_mackBtn = null;		
			_anthonyBtn = null;		
			_professorBtn = null;		
			_sammyBtn = null;		
			_simonBtn = null;		
			_barkeepBtn = null;		
			_bigbillBtn = null;
			_background = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class OpponentSelectScreen
	
}//end package com.bored.games.darts.ui 