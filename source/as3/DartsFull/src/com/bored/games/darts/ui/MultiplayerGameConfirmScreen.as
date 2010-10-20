package com.bored.games.darts.ui 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartFlightHexagon;
	import com.bored.games.darts.models.dae_DartFlightModHex;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	import com.bored.services.BoredServices;
	import com.greensock.TweenLite;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.jac.soundManager.SMSound;
	import com.sven.factories.ImageFactory;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import com.sven.utils.AppSettings;
	import mx.binding.utils.ChangeWatcher;
	import mx.controls.Text;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class MultiplayerGameConfirmScreen extends ContentHolder
	{
		public static const PLAY_CLICKED_EVT:String = "PlayClickedEvent";
		public static const BACK_CLICKED_EVT:String = "BackClickedEvent";
		public static const LAUNCH_STORE_EVT:String = "LaunchClickedEvent";
		
		private var _background:Sprite;
		
		private var _backBtn:MightyButton;
		private var _backBtnImg:MovieClip;
		
		private var _playBtn:MightyButton;
		private var _playBtnImg:MovieClip;
		
		private var _storeBtn:MightyButton;
		private var _storeBtnImg:MovieClip;
		
		private var _dartSelectLeftBtn:MightyButton;
		private var _dartSelectLeftBtnImg:MovieClip;
		
		private var _dartSelectRightBtn:MightyButton;
		private var _dartSelectRightBtnImg:MovieClip;
		
		private var _playerName:TextField;
		private var _playerRecord:TextField;
		private var _playerPortrait:MovieClip;
		private var _playerReadyCheck:MovieClip;
		
		private var _opponentName:TextField;
		private var _opponentRecord:TextField;
		private var _opponentPortrait:MovieClip;
		private var _opponentReadyCheck:MovieClip;
		
		private var _dartIcon:MovieClip;
		
		private var _skinIndex:int;
		private var _skinBitmap:Bitmap;
		
		private var _playerPortraitChangeWatcher:ChangeWatcher;
		private var _opponentPortraitChangeWatcher:ChangeWatcher;
		
		private var _buildBackground:Boolean = false;
		
		public function MultiplayerGameConfirmScreen(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true, a_buildBackground:Boolean = false) 
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
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("dartselect_sound", "button_dartselect_click_mp3") );
			
		}//end GameReadyPopup() constructor.
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			_backBtnImg = descendantsDict["backBtn_mc"] as MovieClip;
			_playBtnImg = descendantsDict["playBtn_mc"] as MovieClip;
			
			_dartSelectLeftBtnImg = descendantsDict["dartSelectLeft_mc"] as MovieClip;
			_dartSelectRightBtnImg = descendantsDict["dartSelectRight_mc"] as MovieClip;
			
			_playerName = descendantsDict["playerName_text"] as TextField;
			_playerRecord = descendantsDict["playerRecord_text"] as TextField;
			_playerPortrait = descendantsDict["playerPortrait_mc"] as MovieClip;
			_playerReadyCheck = descendantsDict["playerReadyCheck_mc"] as MovieClip;
			
			_opponentName = descendantsDict["opponentName_text"] as TextField;
			_opponentRecord = descendantsDict["opponentRecord_text"] as TextField;
			_opponentPortrait = descendantsDict["opponentPortrait_mc"] as MovieClip;
			_opponentReadyCheck = descendantsDict["opponentReadyCheck_mc"] as MovieClip;
			
			_dartIcon = descendantsDict["dartIcon_mc"] as MovieClip;
			
			if (_backBtnImg)
			{
				_backBtn = new MightyButton(_backBtnImg, false);
				_backBtn.pause(false);
				_backBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onBackClicked, false, 0, true);
			}
			else
			{
				throw new Error("MultiplayerGameConfirmScreen::buildFrom(): _backBtnImg=" + _backBtnImg);
			}
			
			if (_playBtnImg)
			{
				_playBtn = new MightyButton(_playBtnImg, false);
				_playBtn.pause(false);
				_playBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPlayClicked, false, 0, true);
			}
			else
			{
				throw new Error("MultiplayerGameConfirmScreen::buildFrom(): _playBtnImg=" + _playBtnImg);
			}
			
			if (_dartSelectLeftBtnImg)
			{
				_dartSelectLeftBtn = new MightyButton(_dartSelectLeftBtnImg, false);
				if (DartsGlobals.instance.playerProfile.skins.length > 1)
				{
					_dartSelectLeftBtn.pause(false);
					_dartSelectLeftBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPickLeftClicked, false, 0, true);
				}
				else
				{
					_dartSelectLeftBtnImg.visible = false;
				}
				
			}
			else
			{
				throw new Error("MultiplayerGameConfirmScreen::buildFrom(): _dartSelectLeftBtnImg=" + _dartSelectLeftBtnImg);
			}
			
			if (_dartSelectRightBtnImg)
			{
				_dartSelectRightBtn = new MightyButton(_dartSelectRightBtnImg, false);
				if (DartsGlobals.instance.playerProfile.skins.length > 1)
				{
					_dartSelectRightBtn.pause(false);
					_dartSelectRightBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPickRightClicked, false, 0, true);
				}
				else
				{
					_dartSelectRightBtnImg.visible = false;
				}
			}
			else
			{
				throw new Error("MultiplayerGameConfirmScreen::buildFrom(): _dartSelectRightBtnImg=" + _dartSelectRightBtnImg);
			}
			
			if (_dartIcon)
			{	
				_skinIndex = 0;
				
				_skinBitmap = new Bitmap();
				_skinBitmap.bitmapData = ImageFactory.getBitmapDataByQualifiedName("storeskin_" + DartsGlobals.instance.playerProfile.skins[_skinIndex].skinid, 270, 103);
				_skinBitmap.smoothing = true;
				_dartIcon.addChild(_skinBitmap);
			}
			else
			{
				throw new Error("MultiplayerGameConfirmScreen::buildFrom(): _dartIcon=" + _dartIcon);
			}
			
			if (_playerName)
			{
				_playerName.text = DartsGlobals.instance.localPlayer.playerName;
			}
			else
			{
				throw new Error("MultiplayerGameConfirmScreen::buildFrom(): _playerName=" + _playerName);
			}
			
			if (_playerPortrait)
			{					
				_playerPortraitChangeWatcher = ChangeWatcher.watch(DartsGlobals.instance.localPlayer, "portrait", updateUsers);				
				
				var playerPortrait:Bitmap = new Bitmap(DartsGlobals.instance.localPlayer.portrait);
				playerPortrait.smoothing = true;
				playerPortrait.width = 75;
				playerPortrait.height = 75;
				
				_playerPortrait.addChild(playerPortrait);
			}
			else
			{
				throw new Error("MultiplayerGameConfirmScreen::buildFrom(): _playerPortrait=" + _playerPortrait);
			}
			
			if (_playerReadyCheck)
			{
				_playerReadyCheck.gotoAndStop("NOT_READY");
			}
			
			if (_opponentName)
			{
				_opponentName.text = DartsGlobals.instance.opponentProfile.name;
			}
			else
			{
				throw new Error("MultiplayerGameConfirmScreen::buildFrom(): _opponentName=" + _opponentName);
			}
			
			if (_opponentPortrait)
			{
				_opponentPortraitChangeWatcher = ChangeWatcher.watch(DartsGlobals.instance.opponentPlayer, "portrait", updateUsers);
				
				var opponentPortrait:Bitmap = new Bitmap(DartsGlobals.instance.opponentPlayer.portrait);
				opponentPortrait.smoothing = true;
				opponentPortrait.width = 75;
				opponentPortrait.height = 75;
				
				_opponentPortrait.addChild(opponentPortrait);
			}
			else
			{
				throw new Error("MultiplayerGameConfirmScreen::buildFrom(): _opponentPortrait=" + _opponentPortrait);
			}
			
			if (_opponentReadyCheck)
			{
				_opponentReadyCheck.gotoAndStop("NOT_READY");
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
		
		public function setPlayerReady():void
		{
			_playerReadyCheck.gotoAndStop("READY");
		}//end setPlayerReady()
		
		public function setOpponentReady():void
		{
			_opponentReadyCheck.gotoAndStop("READY");
		}//end setOpponentReady()
		
		public function updateUsers(...args):void
		{
			DartsGlobals.addWarning("MultiplayerGameConfirmScreen::updatePortraits()");
			
			_playerName.text = DartsGlobals.instance.localPlayer.playerName;
			_opponentName.text = DartsGlobals.instance.opponentProfile.name;
			
			if (_playerPortrait.numChildren > 0) _playerPortrait.removeChildAt(0);
			
			var playerPortrait:Bitmap = new Bitmap(DartsGlobals.instance.localPlayer.portrait);
			playerPortrait.smoothing = true;
			playerPortrait.width = 75;
			playerPortrait.height = 75;
			
			_playerPortrait.addChild(playerPortrait);
			
			if (_opponentPortrait.numChildren > 0) _opponentPortrait.removeChildAt(0);
			
			var opponentPortrait:Bitmap = new Bitmap(DartsGlobals.instance.opponentPlayer.portrait);
			opponentPortrait.smoothing = true;
			opponentPortrait.width = 75;
			opponentPortrait.height = 75;
			
			_opponentPortrait.addChild(opponentPortrait);
		}//end updatePortraits()
		
		private function onPickLeftClicked(a_evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("dartselect_sound");
			
			_skinIndex--;
			if (_skinIndex < 0) {
				_skinIndex = DartsGlobals.instance.playerProfile.skins.length - 1;
			}
			
			_skinBitmap.bitmapData = ImageFactory.getBitmapDataByQualifiedName("storeskin_" + DartsGlobals.instance.playerProfile.skins[_skinIndex].skinid, 270, 103);
			_skinBitmap.smoothing = true;
		}//end onPickLeftClicked()
		
		private function onPickRightClicked(a_evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("dartselect_sound");
			
			_skinIndex++;
			if (_skinIndex >= DartsGlobals.instance.playerProfile.skins.length) {
				_skinIndex = 0;
			}
			
			//_dartIcon.removeChild(_skinBitmap);
			_skinBitmap.bitmapData = ImageFactory.getBitmapDataByQualifiedName("storeskin_" + DartsGlobals.instance.playerProfile.skins[_skinIndex].skinid, 270, 103);
			_skinBitmap.smoothing = true;
			//_dartIcon.addChild(_skinBitmap);
		}//end onPickLeftClicked()
		
		private function onPlayClicked(a_evt:Event):void
		{
			_playBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPlayClicked);
			
			DartsGlobals.instance.localPlayer.setSkin(DartsGlobals.instance.playerProfile.skins[_skinIndex]);
			
			this.dispatchEvent(new Event(PLAY_CLICKED_EVT));
			
			//_backBtn.pause(true);
			_playBtn.pause(true);
			
			//TweenLite.to(this, 0.4, {alpha:0, onComplete:destroy} );
			
		}//end onPlayClicked()
		
		private function onBackClicked(a_evt:Event):void
		{
			_backBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onBackClicked);
			_playBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPlayClicked);
			
			this.dispatchEvent(new Event(BACK_CLICKED_EVT));
			
			TweenLite.to(this, 0.4, {alpha:0, onComplete:destroy} );
			
		}//end onBackClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();	
			
			_backBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onBackClicked);
			_playBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPlayClicked);
			
			_playerPortraitChangeWatcher.unwatch();
			_opponentPortraitChangeWatcher.unwatch();
				
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class MultiplayerGameConfirmScreen
	
}//end package com.bored.games.darts.ui 