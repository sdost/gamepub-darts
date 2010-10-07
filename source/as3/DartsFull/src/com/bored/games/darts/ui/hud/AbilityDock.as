package com.bored.games.darts.ui.hud 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AbilityManager;
	import com.greensock.TweenLite;
	import com.hybrid.ui.ToolTip;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.sven.factories.FontFactory;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AbilityDock extends ContentHolder
	{
		private var _abilityCountText:Vector.<TextField>;
		private var _abilityGraphic:Vector.<MovieClip>;
		private var _abilityBox:Vector.<MightyButton>;
		private var _abilityBurst:Vector.<MovieClip>;
		
		private var _abilityMgr:AbilityManager;
		
		private var _mouseHiddenState:Boolean = false;
		
		private var _cmFilter:ColorMatrixFilter;
		
		private var _reusableTip:ToolTip;
		
		public function AbilityDock(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true)
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
			
			// create an array to store your matrix values
			var matrix:Array = new Array(0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0.309, 0.609, 0.082, 0, 0, 0, 0, 0, 1, 0);
			// create a new colourmatrixfilter using the matrix array values
			_cmFilter = new ColorMatrixFilter(matrix);
			
			_abilityCountText = new Vector.<TextField>(3);
			_abilityGraphic = new Vector.<MovieClip>(3);
			_abilityBox = new Vector.<MightyButton>(3);
			_abilityBurst = new Vector.<MovieClip>(3);
			
			_abilityCountText[0] = descendantsDict["countOne_text"] as TextField;
			_abilityGraphic[0] = descendantsDict["box_1"] as MovieClip;
			_abilityBurst[0] = descendantsDict["burstOne_mc"] as MovieClip;
			
			var myFont:Font = FontFactory.getFontByQualifiedName("CooperStd");
			
			var titleFont:TextFormat = new TextFormat();
			titleFont.font = myFont.fontName;
			titleFont.size = 20;
			titleFont.bold = true;
			titleFont.color = 0x000000;
			
			var consoleFont:TextFormat = new TextFormat();
			consoleFont.font = myFont.fontName;
			consoleFont.size = 16;
			consoleFont.bold = false;
			consoleFont.color = 0x000000;
			
			_reusableTip = new ToolTip();
			_reusableTip.colors = [ 0xFFFFFF, 0xFFFFCD6 ];
			_reusableTip.tipHeight = 100;
			_reusableTip.cornerRadius = 20;
			_reusableTip.align = "center";
			_reusableTip.border = 0x000000;
			_reusableTip.borderSize = 1;
			_reusableTip.titleFormat = titleFont;
			_reusableTip.contentFormat = consoleFont;
			
			if ( _abilityGraphic[0] ) 
			{
				_abilityCountText[0].text = "";
				_abilityCountText[0].mouseEnabled = false;
				
				_abilityBox[0] = new MightyButton(_abilityGraphic[0], false);
				_abilityBox[0].buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				//_abilityBox[0].buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_abilityBox[0].addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onAbilityClicked, false, 0, true);
				
				_abilityBox[0].addEventListener(ButtonEvent.MIGHTYBUTTON_MOUSE_OVER_EVT, showToolTip, false, 0, true);
				
				_abilityBurst[0].gotoAndStop(1);
			}
			else
			{
				throw new Error("AbilityDock::buildFrom(): _abilityBox[0]=" + _abilityBox[0]);
			}
			
			_abilityCountText[1] = descendantsDict["countTwo_text"] as TextField;
			_abilityGraphic[1] = descendantsDict["box_2"] as MovieClip;
			_abilityBurst[1] = descendantsDict["burstTwo_mc"] as MovieClip;
			
			if ( _abilityGraphic[1] ) 
			{
				_abilityCountText[1].text = "";
				_abilityCountText[1].mouseEnabled = false;
				
				_abilityBox[1] = new MightyButton(_abilityGraphic[1], false);
				_abilityBox[1].buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				//_abilityBox[1].buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_abilityBox[1].addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onAbilityClicked, false, 0, true);
				
				_abilityBox[1].addEventListener(ButtonEvent.MIGHTYBUTTON_MOUSE_OVER_EVT, showToolTip, false, 0, true);
				
				_abilityBurst[1].gotoAndStop(1);
			}
			else
			{
				throw new Error("AbilityDock::buildFrom(): _abilityBox[1]=" + _abilityBox[1]);
			}
			
			_abilityCountText[2] = descendantsDict["countThree_text"] as TextField;
			_abilityGraphic[2] = descendantsDict["box_3"] as MovieClip;
			_abilityBurst[2] = descendantsDict["burstThree_mc"] as MovieClip;
			
			if ( _abilityGraphic[2] ) 
			{
				_abilityCountText[2].text = "";
				_abilityCountText[2].mouseEnabled = false;
				
				_abilityBox[2] = new MightyButton(_abilityGraphic[2], false);
				_abilityBox[2].buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				//_abilityBox[2].buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_abilityBox[2].addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onAbilityClicked, false, 0, true);
				
				_abilityBox[2].addEventListener(ButtonEvent.MIGHTYBUTTON_MOUSE_OVER_EVT, showToolTip, false, 0, true);
				
				_abilityBurst[2].gotoAndStop(1);
			}
			else
			{
				throw new Error("AbilityDock::buildFrom(): _abilityBox[2]=" + _abilityBox[2]);
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
		
		public function registerAbilityManager(a_mgr:AbilityManager):void
		{
			_abilityMgr = a_mgr;
		}//end registerScoreManager()
		
		public function update():void
		{
			for ( var i:int = 0; i < DartsGlobals.instance.localPlayer.abilities.length; i++ )
			{
				if ( DartsGlobals.instance.localPlayer.abilities[i] && DartsGlobals.instance.localPlayer.abilities[i].ready && _abilityBox[i].paused ) 
				{
					_abilityBox[i].pause(false);
					DartsGlobals.instance.localPlayer.abilities[i].icon.filters = [];
					((_abilityBox[i].buttonContents as Sprite).getChildByName("icon_holder") as MovieClip).addChild(DartsGlobals.instance.localPlayer.abilities[i].icon);
				}
				
				if ( DartsGlobals.instance.localPlayer.abilities[i].ready && _abilityBox[i].paused ) {
					_abilityBox[i].pause(false);
					DartsGlobals.instance.localPlayer.abilities[i].icon.filters = [];
				} else if ( !DartsGlobals.instance.localPlayer.abilities[i].ready &&  !_abilityBox[i].paused ) {
					_abilityBox[i].pause(true);
					DartsGlobals.instance.localPlayer.abilities[i].icon.filters = [_cmFilter];
				}
				
				var turnsLeft:int = DartsGlobals.instance.gameManager.abilityManager.turnsLeft(DartsGlobals.instance.localPlayer.abilities[i]);
				if ( turnsLeft > 0 ) 
				{
					_abilityCountText[i].text = turnsLeft.toString();
				}
				else 
				{
					_abilityCountText[i].text = "";
				}
			}
		}//end update()
		
		private function showToolTip(a_evt:ButtonEvent):void
		{
			for ( var i:int = 0; i < _abilityBox.length; i++ )
			{
				if ( _abilityBox[i] == a_evt.mightyButton ) 
				{	
					_reusableTip.show(_abilityBox[i].buttonContents, DartsGlobals.instance.localPlayer.abilities[i].name, DartsGlobals.instance.localPlayer.abilities[i].description);
				}
			}
		}//end showToolTip()
		
		private function onMouseOver(a_evt:MouseEvent):void
		{
			Mouse.show();
		}//end onMouseOver()
		
		private function onAbilityClicked(a_evt:ButtonEvent):void
		{
			if (DartsGlobals.instance.gameManager.currentPlayer != DartsGlobals.instance.localPlayer.playerNum) return;
			
			for ( var i:int = 0; i < _abilityBox.length; i++ )
			{
				if ( _abilityBox[i] == a_evt.mightyButton ) 
				{					
					_abilityMgr.activateAbility(DartsGlobals.instance.localPlayer.abilities[i]);
					_abilityBurst[i].gotoAndPlay(1);
				}
			}
		}//end onAbilityOneClicked()
		
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
			
			_cmFilter = null;
			
			_abilityCountText = null;
			_abilityGraphic = null;
			_abilityBox = null;
			_abilityBurst = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}//end destroy()
		
	}//end AbilityDock

}//end com.bored.games.darts.ui.hud