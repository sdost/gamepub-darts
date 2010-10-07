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
	public class ThrowIndicatorV5 extends ContentHolder
	{
		private var _terminus:MovieClip;
		
		private var _throwController:ThrowController;
		
		public function ThrowIndicatorV5(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
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
			
			_terminus = descendantsDict["terminus_mc"] as MovieClip;
			
			if (_terminus)
			{
				_terminus.gotoAndStop("RED");
			}
			else
			{
				throw new Error("ThrowIndicatorV5::buildFrom(): _terminus=" + _terminus);
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
			if (_throwController.show)
			{
				if ( this.alpha == 0 )
				{
					this.x = this.stage.mouseX;
					this.y = this.stage.mouseY + this._contents.height / 2;
					show();
				}
			}
			else
			{
				if ( this.alpha == 1 )
				{
					hide();
				}
			}
			
			TweenLite.to(
				_terminus,
				0.05, 
				{
					x: 0,
					y: -_throwController.thrust * (100 / AppSettings.instance.dartMaxThrust)
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
			
			_terminus = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			//_trackingBall = null;			
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 