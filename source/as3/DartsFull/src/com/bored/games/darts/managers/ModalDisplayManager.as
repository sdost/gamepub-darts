/*
Copyright (c) 2008 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license

shinder modified
refer com.yahoo.astra.fl.managers.AlertManager

shinder.lin@gmail.com
http://qops.blogspot.com/
*/

package com.bored.games.darts.managers
{
	import com.bored.games.darts.DartsGlobals;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilter;

	public class ModalDisplayManager extends MovieClip
	{
		private static  var _alertQueue:Array = [];
		private static  var _alert:Sprite;
		private static  var _displayManager:ModalDisplayManager;
		private static  var _stage:Stage;
		public static  var overlayAlpha:Number = .16;
		public static  var modalBackgroundBlur:int = 3;
		private static  var _overlay:MovieClip;
		protected var container:DisplayObject;
		protected var parentFilters:Array;

		public function ModalDisplayManager(container:DisplayObject)
		{
			if (! _displayManager) {
				if (container != null) {
					_stage = container.stage;
				} else {
					trace("ModalDisplayManager: the 1st parameter cannot be null !");
				}
				if ( _stage.scaleMode != StageScaleMode.NO_SCALE ) {
					// trace("ModalDisplayManager prefers: stage.scaleMode = StageScaleMode.NO_SCALE !");
				}
				if ( _stage.align != StageAlign.TOP_LEFT ) {
					trace("ModalDisplayManager prefers: stage.align = StageAlign.TOP_LEFT !");
				}
				_stage.addChild(this);
				_stage.addEventListener(Event.RESIZE, stageResizeHandler);
				_stage.addEventListener(Event.FULLSCREEN, stageResizeHandler);
			}
		}

		public static function createModalDisplay(container:DisplayObject, content:Class = null, promp:Object = null):ModalDisplayManager
		{
			DartsGlobals.addWarning("ModalDisplayManager::createModalDisplay(" + container + ", " + content + ", " + promp + ")");
			
			if (! _displayManager) {
				_displayManager = new ModalDisplayManager(container);
			}
			_overlay = new MovieClip();
			var g:Graphics = _overlay.graphics as Graphics;
			g.beginFill(0x111111, overlayAlpha);
			g.moveTo(0,0);
			g.lineTo(100, 0);
			g.lineTo(100, 100);
			g.lineTo(0, 100);
			g.lineTo(0, 0);
			g.endFill();
			_displayManager.addChild(_overlay);

			_overlay.stageResizeHandler = function():void {
				this.width = _stage.stageWidth;
				this.height = _stage.stageHeight;
				
				if (this._alert != null ) {
					this._alert.x = (_stage.stageWidth - this._alert.width) / 2;
					this._alert.y = (_stage.stageHeight - this._alert.height) / 2;
				}
			};

			_alert = new content() as Sprite;
			
			DartsGlobals.addWarning("ModalDisplayManager::createModalDisplay() -- _alert = " + _alert);
			
			_overlay._alert = _alert;
			_overlay.stageResizeHandler();
			
			/*
			if (_alert.init) {
				_alert.init(promp);
			} else {
				// trace("ModalDisplayManager: the 2nd parameter should define a function named init(promp:Object) !");
			}
			*/
			
			_displayManager.addChild(_alert);
			_displayManager.container = container;
			var newFilters:Array = _displayManager.container.filters.concat();
			var oldFilters:Array = _displayManager.container.filters.concat();

			if(_alertQueue.length == 0) {
				newFilters.push(_displayManager.getBlurFilter());
				_displayManager.container.filters = newFilters;
			}
			for(var i:int=0; i < _alertQueue.length; i++) {
				_alertQueue[i]['_alert'].filters = [_displayManager.getBlurFilter()];
			}

			var alertParams:Object = {
				container:container,
				content:content,
				promp:promp,
				_overlay:_overlay,
				_alert:_alert,
				_filters:oldFilters
			};
			_alertQueue.push(alertParams);
			return _displayManager;
		}

		public function manageQueue():void
		{
			if(_alertQueue.length == 0){
				return;
			}
			var obj:Object = _alertQueue.pop();
			obj.container.filters = obj._filters;
			_displayManager.removeChild(obj._alert);
			_displayManager.removeChild(obj._overlay);
			if(_alertQueue.length>0) {
				_alertQueue[_alertQueue.length-1]['_alert'].filters = [];
			}
		}
		
		public function clearQueue():void
		{
			while (_alertQueue.length > 0)
			{
				manageQueue();
			}
		}

		public function getBlurFilter():BitmapFilter
		{
			var blurFilter:BlurFilter = new BlurFilter();
			blurFilter.blurX = modalBackgroundBlur;
			blurFilter.blurY = modalBackgroundBlur;
			blurFilter.quality = BitmapFilterQuality.HIGH;
			return blurFilter;
		}

		private function stageResizeHandler(evt:Event):void
		{
			for each(var o:Object in _alertQueue) {
				o._overlay.stageResizeHandler();
			}
		}
	}
}