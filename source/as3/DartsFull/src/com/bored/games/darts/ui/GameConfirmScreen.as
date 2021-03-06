﻿package com.bored.games.darts.ui 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartFlightHexagon;
	import com.bored.games.darts.models.dae_DartFlightModHex;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	import com.greensock.TweenLite;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.jac.soundManager.SMSound;
	import com.sven.factories.ImageFactory;
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
	import com.sven.utils.AppSettings;
	import mx.controls.Text;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class GameConfirmScreen extends ContentHolder
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
		
		private var _opponentDetails:TextField;
		private var _opponentBio:TextField;
		private var _opponentPortrait:MovieClip;
		
		private var _dartIcon:MovieClip;
		
		private var _abilityIconOne:MovieClip;
		private var _abilityIconTwo:MovieClip;
		private var _abilityIconThree:MovieClip;
		
		private var _abilityOnePowerGauge:MovieClip;
		private var _abilityTwoPowerGauge:MovieClip;
		private var _abilityThreePowerGauge:MovieClip;
		
		private var _abilityNameOne:TextField;
		private var _abilityNameTwo:TextField;
		private var _abilityNameThree:TextField;
		
		private var _opponentAbilityIconOne:MovieClip;
		private var _opponentAbilityIconTwo:MovieClip;
		private var _opponentAbilityIconThree:MovieClip;
		
		private var _opponentAbilityOnePowerGauge:MovieClip;
		private var _opponentAbilityTwoPowerGauge:MovieClip;
		private var _opponentAbilityThreePowerGauge:MovieClip;
		
		private var _skinIndex:int;
		private var _skinBitmap:Bitmap;
		
		private var _buildBackground:Boolean = false;
		
		public function GameConfirmScreen(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true, a_buildBackground:Boolean = false) 
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
			
			_storeBtnImg = descendantsDict["store_mc"] as MovieClip;
			
			_dartSelectLeftBtnImg = descendantsDict["dartSelectLeft_mc"] as MovieClip;
			_dartSelectRightBtnImg = descendantsDict["dartSelectRight_mc"] as MovieClip;
			
			_opponentDetails = descendantsDict["opponentDetails_text"] as TextField;
			_opponentBio = descendantsDict["opponentBio_text"] as TextField;
			_opponentPortrait = descendantsDict["opponentPortrait_mc"] as MovieClip;
			
			_dartIcon = descendantsDict["dartIcon_mc"] as MovieClip;
			
			_abilityIconOne = descendantsDict["abilityOne_mc"] as MovieClip;
			_abilityIconTwo = descendantsDict["abilityTwo_mc"] as MovieClip;
			_abilityIconThree = descendantsDict["abilityThree_mc"] as MovieClip;
			
			_abilityOnePowerGauge = descendantsDict["abilityOnePowerGauge_mc"] as MovieClip;
			_abilityTwoPowerGauge = descendantsDict["abilityTwoPowerGauge_mc"] as MovieClip;
			_abilityThreePowerGauge = descendantsDict["abilityThreePowerGauge_mc"] as MovieClip;
			
			_abilityNameOne = descendantsDict["abilityOne_text"] as TextField;
			_abilityNameTwo = descendantsDict["abilityTwo_text"] as TextField;
			_abilityNameThree = descendantsDict["abilityThree_text"] as TextField;
		
			//_opponentAbilityIconOne = descendantsDict["opponentAbilityOne_mc"] as MovieClip;
			//_opponentAbilityIconTwo = descendantsDict["opponentAbilityTwo_mc"] as MovieClip;
			//_opponentAbilityIconThree = descendantsDict["opponentAbilityThree_mc"] as MovieClip;
			
			//_opponentAbilityOnePowerGauge = descendantsDict["opponentAbilityOnePowerGauge_mc"] as MovieClip;
			//_opponentAbilityTwoPowerGauge = descendantsDict["opponentAbilityTwoPowerGauge_mc"] as MovieClip;
			//_opponentAbilityThreePowerGauge = descendantsDict["opponentAbilityThreePowerGauge_mc"] as MovieClip;
			
			if (_backBtnImg)
			{
				_backBtn = new MightyButton(_backBtnImg, false);
				_backBtn.pause(false);
				_backBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onBackClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _backBtnImg=" + _backBtnImg);
			}
			
			if (_playBtnImg)
			{
				_playBtn = new MightyButton(_playBtnImg, false);
				_playBtn.pause(false);
				_playBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPlayClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _playBtnImg=" + _playBtnImg);
			}
			
			if (_storeBtnImg)
			{
				_storeBtn = new MightyButton(_storeBtnImg, false);
				_storeBtn.pause(false);
				_storeBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onStoreClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _storeBtnImg=" + _storeBtnImg);
			}
			
			if (_dartSelectLeftBtnImg)
			{
				_dartSelectLeftBtn = new MightyButton(_dartSelectLeftBtnImg, false);
				_dartSelectLeftBtn.pause(false);
				_dartSelectLeftBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPickLeftClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _dartSelectLeftBtnImg=" + _dartSelectLeftBtnImg);
			}
			
			if (_dartSelectRightBtnImg)
			{
				_dartSelectRightBtn = new MightyButton(_dartSelectRightBtnImg, false);
				_dartSelectRightBtn.pause(false);
				_dartSelectRightBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPickRightClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _dartSelectRightBtnImg=" + _dartSelectRightBtnImg);
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
				throw new Error("GameConfirmScreen::buildFrom(): _dartIcon=" + _dartIcon);
			}
			
			if (_opponentDetails)
			{
				_opponentDetails.text = "Name: " + DartsGlobals.instance.opponentProfile.name + "\n";
				//_opponentDetails.appendText("Age: " + DartsGlobals.instance.opponentProfile.age + "\n");
				//_opponentDetails.appendText("Height: " + DartsGlobals.instance.opponentProfile.height + " cm\n");
				//_opponentDetails.appendText("Weight: " + DartsGlobals.instance.opponentProfile.weight + " kg");
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _opponentDetails=" + _opponentDetails);
			}
			
			if (_opponentBio)
			{
				_opponentBio.text = DartsGlobals.instance.opponentProfile.bio;
			}
			else
			{
				throw new Error("GameConfirmScreen::buildFrom(): _opponentBio=" + _opponentBio);
			}
			
			if (_opponentPortrait)
			{
				var portrait:Bitmap = new Bitmap(DartsGlobals.instance.opponentProfile.portrait);
				portrait.smoothing = true;
				portrait.width = 75;
				portrait.height = 75;
				
				_opponentPortrait.addChild(portrait);
			}
			else
			{
				//throw new Error("GameConfirmScreen::buildFrom(): _opponentPortrait=" + _opponentPortrait);
				DartsGlobals.addWarning("GameConfirmScreen::buildFrom(): _opponentPortrait=" + _opponentPortrait);
			}
			
			if (_abilityIconOne && _abilityNameOne && _abilityOnePowerGauge)
			{
				_abilityIconOne.addChild(DartsGlobals.instance.localPlayer.abilities[0].icon);
				_abilityNameOne.text = DartsGlobals.instance.localPlayer.abilities[0].name;
				_abilityOnePowerGauge.gotoAndStop(10 - DartsGlobals.instance.localPlayer.abilities[0].refreshTime + 1);
			}
			else
			{
				//throw new Error("GameConfirmScreen::buildFrom(): _abilityIconOne=" + _abilityIconOne);
				DartsGlobals.addWarning("GameConfirmScreen::buildFrom(): _abilityIconOne=" + _abilityIconOne);
			}
			
			if (_abilityIconTwo && _abilityNameTwo && _abilityTwoPowerGauge)
			{
				_abilityIconTwo.addChild(DartsGlobals.instance.localPlayer.abilities[1].icon);
				_abilityNameTwo.text = DartsGlobals.instance.localPlayer.abilities[1].name;
				_abilityTwoPowerGauge.gotoAndStop(10 - DartsGlobals.instance.localPlayer.abilities[1].refreshTime + 1);
			}
			else
			{
				//throw new Error("GameConfirmScreen::buildFrom(): _abilityIconTwo=" + _abilityIconTwo);
				DartsGlobals.addWarning("GameConfirmScreen::buildFrom(): _abilityIconTwo=" + _abilityIconTwo);
			}
			
			if (_abilityIconThree && _abilityNameThree && _abilityThreePowerGauge)
			{
				_abilityIconThree.addChild(DartsGlobals.instance.localPlayer.abilities[2].icon);
				_abilityNameThree.text = DartsGlobals.instance.localPlayer.abilities[2].name;
				_abilityThreePowerGauge.gotoAndStop(10 - DartsGlobals.instance.localPlayer.abilities[2].refreshTime + 1);
			}
			else
			{
				//throw new Error("GameConfirmScreen::buildFrom(): _abilityIconThree=" + _abilityIconThree);
				DartsGlobals.addWarning("GameConfirmScreen::buildFrom(): _abilityIconThree=" + _abilityIconThree);
			}
			
			/*
			if (_opponentAbilityIconOne && _opponentAbilityOnePowerGauge)
			{
				_opponentAbilityIconOne.addChild(DartsGlobals.instance.opponentPlayer.abilities[0].icon);
				DartsGlobals.instance.opponentPlayer.abilities[0].icon.width = 15;
				DartsGlobals.instance.opponentPlayer.abilities[0].icon.height = 15;
				_opponentAbilityOnePowerGauge.gotoAndStop(10 - DartsGlobals.instance.opponentPlayer.abilities[0].refreshTime + 1);
			}
			else
			{
				//throw new Error("GameConfirmScreen::buildFrom(): _opponentAbilityIconOne=" + _opponentAbilityIconOne);
				DartsGlobals.addWarning("GameConfirmScreen::buildFrom(): _opponentAbilityIconOne=" + _opponentAbilityIconOne);
			}
			
			if (_opponentAbilityIconTwo && _opponentAbilityTwoPowerGauge)
			{
				_opponentAbilityIconTwo.addChild(DartsGlobals.instance.opponentPlayer.abilities[1].icon);
				DartsGlobals.instance.opponentPlayer.abilities[1].icon.width = 15;
				DartsGlobals.instance.opponentPlayer.abilities[1].icon.height = 15;
				_opponentAbilityTwoPowerGauge.gotoAndStop(10 - DartsGlobals.instance.opponentPlayer.abilities[1].refreshTime + 1);
			}
			else
			{
				//throw new Error("GameConfirmScreen::buildFrom(): _opponentAbilityIconTwo=" + _opponentAbilityIconTwo);
				DartsGlobals.addWarning("GameConfirmScreen::buildFrom(): _opponentAbilityIconTwo=" + _opponentAbilityIconTwo);
			}
			
			if (_opponentAbilityIconThree && _opponentAbilityThreePowerGauge)
			{
				_opponentAbilityIconThree.addChild(DartsGlobals.instance.opponentPlayer.abilities[2].icon);
				DartsGlobals.instance.opponentPlayer.abilities[2].icon.width = 15;
				DartsGlobals.instance.opponentPlayer.abilities[2].icon.height = 15;
				_opponentAbilityThreePowerGauge.gotoAndStop(10 - DartsGlobals.instance.opponentPlayer.abilities[2].refreshTime + 1);
			}
			else
			{
				//throw new Error("GameConfirmScreen::buildFrom(): _opponentAbilityIconThree=" + _opponentAbilityIconThree);
				DartsGlobals.addWarning("GameConfirmScreen::buildFrom(): _opponentAbilityIconThree=" + _opponentAbilityIconThree);
			}
			*/
			
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
		
		private function onStoreClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(LAUNCH_STORE_EVT));
			
			TweenLite.to(this, 0.4, {alpha:0, onComplete:destroy} );
		}//end onUpgradeClicked()
		
		private function onPickLeftClicked(a_evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("dartselect_sound");
			
			_skinIndex--;
			if (_skinIndex < 0) {
				_skinIndex = DartsGlobals.instance.playerProfile.skins.length - 1;
			}
			
			//_dartIcon.removeChild(_skinBitmap);
			_skinBitmap.bitmapData = ImageFactory.getBitmapDataByQualifiedName("storeskin_" + DartsGlobals.instance.playerProfile.skins[_skinIndex].skinid, 270, 103);
			_skinBitmap.smoothing = true;
			//_dartIcon.addChild(_skinBitmap);
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
			_backBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onBackClicked);
			_playBtn.removeEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onPlayClicked);
			
			DartsGlobals.instance.localPlayer.setSkin(DartsGlobals.instance.playerProfile.skins[_skinIndex]);
			
			this.dispatchEvent(new Event(PLAY_CLICKED_EVT));
			
			TweenLite.to(this, 0.4, {alpha:0, onComplete:destroy} );
			
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
						
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_backBtnImg = null;
			_playBtnImg = null;
			
			_storeBtnImg = null;
			
			_dartSelectLeftBtnImg = null;
			_dartSelectRightBtnImg = null;
			
			_opponentDetails = null;
			_opponentBio = null;
			_opponentPortrait = null;
			
			_dartIcon = null;
			
			_abilityIconOne = null;
			_abilityIconTwo = null;
			_abilityIconThree = null;
			
			_abilityOnePowerGauge = null;
			_abilityTwoPowerGauge = null;
			_abilityThreePowerGauge = null;
			
			_abilityNameOne = null;
			_abilityNameTwo = null;
			_abilityNameThree = null;
		
			_opponentAbilityIconOne = null;
			_opponentAbilityIconTwo = null;
			_opponentAbilityIconThree = null;
			
			_opponentAbilityOnePowerGauge = null;
			_opponentAbilityTwoPowerGauge = null;
			_opponentAbilityThreePowerGauge = null;
			
			_backBtn = null;
			_playBtn = null;
			_storeBtn = null;
			_dartSelectLeftBtn = null;
			_dartSelectRightBtn = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class GameConfirmScreen
	
}//end package com.bored.games.darts.ui 