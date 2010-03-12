package com.bored.games.darts.ui.hud 
{
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.Tweener;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.input.ThrowController;
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
	public class ThrowIndicator extends ContentHolder
	{
		private var _trackingBall:MovieClip;
		
		private var _throwController:ThrowController;
		
		public function ThrowIndicator(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
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
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = false):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_trackingBall = descendantsDict["trackingBall_mc"] as MovieClip;
			
			if (_trackingBall)
			{
				_trackingBall.gotoAndStop("RED");
			}
			else
			{
				throw new Error("ThrowIndicator::buildFrom(): _trackingBall=" + _trackingBall);
			}
			
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
		
		public function update():void
		{			
			_trackingBall.x = _throwController.lean * 8;
			_trackingBall.y = 119 - _throwController.thrust * 8;
		}//end update()
		
		
		
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
			
			_trackingBall = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 