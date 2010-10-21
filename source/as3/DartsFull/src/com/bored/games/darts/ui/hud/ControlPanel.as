package com.bored.games.darts.ui.hud 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.ui.buttons.ToggleButton;
	import com.bored.games.darts.ui.modals.AchievementsModal;
	import com.bored.games.darts.ui.modals.HelpModal;
	import com.bored.games.darts.ui.modals.MultiplayerQuitModal;
	import com.bored.games.darts.ui.modals.QuitModal;
	import com.greensock.TweenLite;
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
	public class ControlPanel extends ContentHolder
	{
		private var _soundBtn:ToggleButton;
		private var _soundBtnImg:MovieClip;
		
		private var _musicBtn:ToggleButton;
		private var _musicBtnImg:MovieClip;
		
		private var _helpBtn:ToggleButton;
		private var _helpBtnImg:MovieClip;
		
		private var _trophyBtn:ToggleButton;
		private var _trophyBtnImg:MovieClip;
		
		private var _quitBtn:MightyButton;
		private var _quitBtnImg:MovieClip;
		
		private var _soundManager:SoundManager;
		
		private var _muteSound:Boolean = false;
		private var _muteMusic:Boolean = false;
		
		public function ControlPanel(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
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
			
			_soundBtnImg = descendantsDict["soundBtn_mc"] as MovieClip;
			_musicBtnImg = descendantsDict["musicBtn_mc"] as MovieClip;
			_helpBtnImg = descendantsDict["helpBtn_mc"] as MovieClip;
			_trophyBtnImg = descendantsDict["trophyBtn_mc"] as MovieClip;
			_quitBtnImg = descendantsDict["quitBtn_mc"] as MovieClip;
			
			if (_soundBtnImg)
			{
				_soundBtn = new ToggleButton(_soundBtnImg, false);
				_soundBtn.pause(false);
				_soundBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				//_soundBtn.buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_soundBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onSoundButtonClick, false, 0, true);
			}
			else
			{
				throw new Error("ControlPanel::buildFrom(): _soundBtnImg=" + _soundBtnImg);
			}
			
			if (_musicBtnImg)
			{
				_musicBtn = new ToggleButton(_musicBtnImg, false);
				_musicBtn.buttonContents.visible = false;
				//_musicBtn.pause(false);
				//_musicBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				//_musicBtn.buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				//_musicBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onMusicButtonClick, false, 0, true);
			}
			else
			{
				throw new Error("ControlPanel::buildFrom(): _musicBtnImg=" + _musicBtnImg);
			}
			
			if (_helpBtnImg)
			{
				_helpBtn = new ToggleButton(_helpBtnImg, false);
				_helpBtn.pause(false);
				_helpBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				//_helpBtn.buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_helpBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onHelpButtonClick, false, 0, true);
			}
			else
			{
				throw new Error("ControlPanel::buildFrom(): _helpBtnImg=" + _helpBtnImg);
			}
			
			if (_trophyBtnImg)
			{
				_trophyBtn = new ToggleButton(_trophyBtnImg, false);
				_trophyBtn.pause(false);
				_trophyBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				//_trophyBtn.buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_trophyBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onTrophyButtonClick, false, 0, true);
			}
			else
			{
				throw new Error("ControlPanel::buildFrom(): _trophyBtnImg=" + _trophyBtnImg);
			}
			
			if (_quitBtnImg)
			{
				_quitBtn = new MightyButton(_quitBtnImg, false);
				_quitBtn.pause(false);
				_quitBtn.buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				//_quitBtn.buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_quitBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onQuitButtonClick, false, 0, true);
			}
			else
			{
				throw new Error("ControlPanel::buildFrom(): _quitBtnImg=" + _quitBtnImg);
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
		
		public function registerSoundManager(a_soundMgr:SoundManager):void
		{
			_soundManager = a_soundMgr;
			
			_soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("trophy_sound", "button_achievements_mp3") );
			_soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("help_sound", "button_help_mp3") );
			_soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("quit_sound", "button_x_mp3") );
			
			_soundBtn.toggleOn = _soundManager.isMuted;			
		}//end registerSoundManager()
		
		private function onMouseOver(a_evt:MouseEvent):void
		{
			Mouse.show();
		}//end onMouseOver()
		
		public function show():void
		{
			this.alpha = 1;
			//TweenLite.to(this, 2, {alpha:1} );
		}//end show()
		
		public function hide():void
		{
			this.alpha = 0;
			//TweenLite.to(this, 2, {alpha:0} );
		}//end hide()
		
		private function onSoundButtonClick(a_evt:Event):void
		{
			_soundManager.toggleMute();
			_soundBtn.toggleOn = _soundManager.isMuted;
		}//end onSoundButtonClick()
		
		private function onMusicButtonClick(a_evt:Event):void
		{
			//TODO: handle music toggle
		}//end onMusicButtonClick()
		
		private function onHelpButtonClick(a_evt:Event):void
		{			
			DartsGlobals.instance.gameManager.pause(true);
			
			DartsGlobals.instance.showModalPopup(HelpModal);
			
			_soundManager.getSoundControllerByID("buttonSoundController").play("help_sound");
			
			Mouse.show();
		}//end onHelpButtonClick()
		
		private function onTrophyButtonClick(a_evt:Event):void
		{			
			DartsGlobals.instance.externalServices.showAchievementUI();
			
			_soundManager.getSoundControllerByID("buttonSoundController").play("trophy_sound");
			
			Mouse.show();
		}//end onTrophyButtonClick()
		
		private function onQuitButtonClick(a_evt:Event):void
		{			
			DartsGlobals.instance.gameManager.pause(true);
			
			if ( DartsGlobals.instance.gameMode == DartsGlobals.GAME_MULTIPLAYER )
			{
				DartsGlobals.instance.showModalPopup(MultiplayerQuitModal);
			}
			else
			{
				DartsGlobals.instance.showModalPopup(QuitModal);
			}
			
			_soundManager.getSoundControllerByID("buttonSoundController").play("quit_sound");
			
			Mouse.show();
		}//end onQuitButtonClick()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			_soundBtnImg = null;
			_musicBtnImg = null;
			_helpBtnImg = null;
			_trophyBtnImg = null;
			_quitBtnImg = null;
			
			_soundBtn = null;
			_musicBtn = null;
			_helpBtn = null;
			_trophyBtn = null;
			_quitBtn = null;
			_soundManager = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}//end destroy()
		
	}//end ControlPanel

}//end com.bored.games.darts.ui.hud