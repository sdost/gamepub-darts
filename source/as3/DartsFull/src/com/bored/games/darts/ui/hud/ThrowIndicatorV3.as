package com.bored.games.darts.ui.hud 
{
	import caurina.transitions.properties.CurveModifiers;
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
	public class ThrowIndicatorV3 extends ContentHolder
	{
		private var _terminus:MovieClip;
		private var _maskBar:MovieClip;
		private var _reticle:MovieClip;
		private var _harness:MovieClip;
		private var _trueThrust:MovieClip;
		private var _trueAngle:TextField;
		
		private var _throwController:ThrowController;
		
		public function ThrowIndicatorV3(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
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
			_maskBar = descendantsDict["maskBar_mc"] as MovieClip;
			_reticle = descendantsDict["reticle_mc"] as MovieClip;
			_harness = descendantsDict["harness_mc"] as MovieClip;
			_trueThrust = descendantsDict["trueThrust_mc"] as MovieClip;
			_trueAngle = descendantsDict["angle_text"] as TextField;
			
			if (_terminus)
			{
				_terminus.gotoAndStop("RED");
			}
			else
			{
				throw new Error("ThrowIndicatorV3::buildFrom(): _terminus=" + _terminus);
			}
			
			if (_maskBar)
			{
				_maskBar.height = 0;
			}
			else
			{
				throw new Error("ThrowIndicatorV3::buildFrom(): _maskBar=" + _maskBar);
			}
			
			if (_harness && _reticle)
			{
				_reticle.y = -((AppSettings.instance.dartMaxThrust - AppSettings.instance.dartMinThrust) / 2 + AppSettings.instance.dartMinThrust) * (200 / AppSettings.instance.dartMaxThrust);				
			}
			else
			{
				throw new Error("ThrowIndicatorV3::buildFrom(): _reticle=" + _reticle);
			}
			
			if (_trueThrust)
			{
				_trueThrust.height = 0;
			}
			else
			{
				throw new Error("ThrowIndicatorV3::buildFrom(): _trueThrust=" + _trueThrust);
			}
			
			if (_trueAngle)
			{
				_trueAngle.text = "";
			}
			else
			{
				throw new Error("ThrowIndicatorV3::buildFrom(): _trueAngle=" + _trueAngle);
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
			TweenLite.to(
				_terminus,
				0.05, 
				{
					x: _throwController.lean * 12,
					y: -_throwController.thrust * (206 / AppSettings.instance.dartMaxThrust)
				}
			);
			
			_maskBar.rotation = 0;
			_maskBar.height = -_terminus.y;
			//trace("rotation: " + Math.atan2( -_terminus.y, _terminus.x ));
			_maskBar.rotation = 180 / Math.PI * Math.atan2( _terminus.y, _terminus.x ) + 90;
			
			_trueThrust.height = 200 * (_throwController.trueThrust / AppSettings.instance.dartMaxThrust);
			
			_trueAngle.text = (Math.floor(_throwController.trueAngle * 100) / 100) + " degs";
		}//end update()		
		
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
			
			_terminus = null;
			_maskBar = null;
			_reticle = null;
			_harness = null;
			_trueThrust = null;
			_trueAngle = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			//_trackingBall = null;			
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 