package com.bored.games.darts.ui.hud 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.logic.AbilityManager;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AbilityDock extends ContentHolder
	{
		private var _abilityGraphic:Vector.<MovieClip>;
		private var _abilityBox:Vector.<MightyButton>;
		
		private var _abilityMgr:AbilityManager;
		
		private var _mouseHiddenState:Boolean = false;
		
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
			
			_abilityGraphic = new Vector.<MovieClip>(3);
			_abilityBox = new Vector.<MightyButton>(3);
			
			_abilityGraphic[0] = descendantsDict["box_1"] as MovieClip;
			
			if ( _abilityGraphic[0] ) 
			{
				
				_abilityBox[0] = new MightyButton(_abilityGraphic[0], false);
				_abilityBox[0].buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				_abilityBox[0].buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_abilityBox[0].addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onAbilityClicked, false, 0, true);
			}
			else
			{
				throw new Error("AbilityDock::buildFrom(): _abilityBox[0]=" + _abilityBox[0]);
			}
			
			_abilityGraphic[1] = descendantsDict["box_2"] as MovieClip;
			
			if ( _abilityGraphic[1] ) 
			{
				_abilityBox[1] = new MightyButton(_abilityGraphic[1], false);
				_abilityBox[1].buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				_abilityBox[1].buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_abilityBox[1].addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onAbilityClicked, false, 0, true);
			}
			else
			{
				throw new Error("AbilityDock::buildFrom(): _abilityBox[1]=" + _abilityBox[1]);
			}
			
			_abilityGraphic[2] = descendantsDict["box_3"] as MovieClip;
			
			if ( _abilityGraphic[2] ) 
			{
				_abilityBox[2] = new MightyButton(_abilityGraphic[2], false);
				_abilityBox[2].buttonContents.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
				_abilityBox[2].buttonContents.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
				_abilityBox[2].addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onAbilityClicked, false, 0, true);
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
			for ( var i:int = 0; i < _abilityMgr.abilities.length; i++ )
			{
				if ( _abilityMgr.abilities[i] && _abilityMgr.abilities[i].ready && _abilityBox[i].paused ) {
					_abilityBox[i].pause(false);
					((_abilityBox[i].buttonContents as Sprite).getChildByName("icon_holder") as MovieClip).addChild(_abilityMgr.abilities[i].icon);
				}
				
				if ( _abilityMgr.abilities[i].ready && _abilityBox[i].paused ) {
					_abilityBox[i].pause(false);
				} else if ( !_abilityMgr.abilities[i].ready &&  !_abilityBox[i].paused ) {
					_abilityBox[i].pause(true);
				}
			}
		}//end update()
		
		private function onMouseOver(a_evt:MouseEvent):void
		{
			Mouse.show();
		}//end onMouseOver()
		
		private function onMouseOut(a_evt:MouseEvent):void
		{
			Mouse.hide();
		}//end onMouseOut()
		
		private function onAbilityClicked(a_evt:ButtonEvent):void
		{
			for ( var i:int = 0; i < _abilityBox.length; i++ )
			{
				if ( _abilityBox[i] == a_evt.mightyButton )
					_abilityMgr.activateAbility(i);
			}
		}//end onAbilityOneClicked()
		
		public function show():void
		{
			Tweener.addTween(this, {alpha:1, time:2 } );
		}//end show()
		
		public function hide():void
		{
			Tweener.addTween(this, {alpha:0, time:2 } );
		}//end hide()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end AbilityDock

}//end com.bored.games.darts.ui.hud