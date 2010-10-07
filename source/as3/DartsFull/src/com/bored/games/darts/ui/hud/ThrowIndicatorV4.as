package com.bored.games.darts.ui.hud 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.input.ThrowController;
	import com.greensock.TweenLite;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.sven.utils.AppSettings;
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
	public class ThrowIndicatorV4 extends ContentHolder
	{
		private var _terminusX:MovieClip;
		private var _terminusY:MovieClip;
		
		private var _throwController:ThrowController;
		
		public function ThrowIndicatorV4(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
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
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_terminusX = descendantsDict["terminusX_mc"] as MovieClip;
			
			if (_terminusX)
			{
				_terminusX.gotoAndStop("RED");
			}
			else
			{
				throw new Error("ThrowIndicatorV4::buildFrom(): _terminusX=" + _terminusX);
			}
			
			_terminusY = descendantsDict["terminusY_mc"] as MovieClip;
			
			if (_terminusY)
			{
				_terminusY.gotoAndStop("RED");
			}
			else
			{
				throw new Error("ThrowIndicatorV4::buildFrom(): _terminusY=" + _terminusY);
			}
			
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			
			return descendantsDict;
			
		}//end buildFrom()
		
		public function registerThrowController(a_controller:ThrowController):void
		{
			_throwController = a_controller;
		}//end registerThrowController()		
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			this.contentsMC.alpha = 1;
			
			this.alpha = 0;
			
		}//end addedToStage()
		
		public function update(a_evt:Event = null):void
		{				
			TweenLite.to(
				_terminusY,
				0.05, 
				{
					x: 0,
					y: -_throwController.thrust * (100 / AppSettings.instance.dartMaxThrust) + 50
				}
			);
			
			TweenLite.to(
				_terminusX,
				0.05, 
				{
					x: _throwController.lean * (50/2.5),
					y: 0
				}
			);
		}//end update()		
		
		public function show():void
		{
			TweenLite.to(this, 1, {alpha:1} );
		}//end show()
		
		public function hide():void
		{
			TweenLite.to(this, 1, {alpha:0} );
		}//end hide()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			_terminusX = null;
			_terminusY = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			//_trackingBall = null;			
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 