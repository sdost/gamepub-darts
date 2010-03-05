package com.bored.games.darts
{
	import com.bored.games.config.ConfigManager;
	import com.bored.games.controllers.InputController;
	import com.bored.games.controllers.MouseInputController;
	import com.bored.games.darts.logic.AbstractGameLogic;
	import com.bored.services.AbstractExternalService;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class DartsGlobals extends EventDispatcher
	{
		// protected var _optionsInterface:Sprite;  ??
		
		protected var _flashVars:Object;
		
		// the stage, referenceable globally.
		private var _stage:Stage;
		
		/**
		 * the global layers, below:
		 */
		
		private var _optionsInterfaceSpace:Sprite;
		
		// space for any top-level pop-ups.
		private var _popupSpace:Sprite;
		
		// space for any advertisements.
		private var _adSpace:Sprite;
		
		// space for the loaded game.
		private var _screenSpace:Sprite;
		
		private static var _warningTmr:Timer;
		private static var _warningArr:Array;
		
		private static var _instance:DartsGlobals;
		private var _constructed:Boolean = false;
		
		private var _debugBuild:Boolean = false;
		
		private var _config:XML;
		
		private var _externalService:AbstractExternalService;
		
		private var _logicManager:AbstractGameLogic;
		
		public function DartsGlobals(a_singletonEnforcer:DartsGlobals_SingletonEnforcer) 
		{
			super();
			
			if (!a_singletonEnforcer)
			{
				throw new Error("DartsGlobals::DartsGlobals(): This is a singleton, use .instance, instead.");
			}
			
			construct();
			
		}//end DartsGlobals() constructor.
		
		public static function get instance():DartsGlobals
		{
			if (!_instance)
			{
				_instance = new DartsGlobals(new DartsGlobals_SingletonEnforcer());
			}
			
			return _instance;
			
		}//end get instance()
		
		private function construct():void
		{
			if (_constructed)
				return;
			
			// do any initialization, here:
			
			COMPILEVAR::DEBUG
			{
				_debugBuild = true;
			}
			
			_constructed = true;
			
		}//end construct()
		
		public function set stage(a_stage:Stage):void
		{
			_stage = a_stage;
			
			if (!_optionsInterfaceSpace)
			{
				_optionsInterfaceSpace = new Sprite();
			}
			
			if (!_popupSpace)
			{
				_popupSpace = new Sprite();
			}
			
			if(!_adSpace)
			{
				_adSpace = new Sprite();
			}
					
			if(!_screenSpace)
			{
				_screenSpace = new Sprite();
			}
			
			if (_screenSpace.parent)
				_screenSpace.parent.removeChild(_screenSpace);
			
			if (_adSpace.parent)
				_adSpace.parent.removeChild(_adSpace);
			
			if (_popupSpace.parent)
				_popupSpace.parent.removeChild(_popupSpace);
			
			if (_optionsInterfaceSpace.parent)
				_optionsInterfaceSpace.parent.removeChild(_optionsInterfaceSpace);
			
			_stage.addChild(_screenSpace); // bottom
			_stage.addChild(_adSpace);
			_stage.addChild(_popupSpace); 
			_stage.addChild(_optionsInterfaceSpace); // top
			
		}//end set stage()
		
		public function get stage():Stage
		{
			return _stage;
			
		}//end set stage()
		
		public function get screenSpace():Sprite
		{
			return _screenSpace;
			
		}//end set screenSpace()
		
		public function get adSpace():Sprite
		{
			return _adSpace;
			
		}//end set adSpace()
		
		public function get popupSpace():Sprite
		{
			return _popupSpace;
			
		}//end set popupSpace()
		
		public function get optionsInterfaceSpace():Sprite
		{
			return _optionsInterfaceSpace;
			
		}//end set optionsInterfaceSpace()
		
		public function set flashVars(a_obj:Object):void
		{
			_flashVars = a_obj;
			
		}//end set flashVars()
		
		public function get flashVars():Object
		{
			return _flashVars;
			
		}//end get flashVars()
		
		public function set config(a_xml:String):void 
		{
			ConfigManager.loadConfig(a_xml);
		}//end set config()
		
		public function set logicManager(a_manager:AbstractGameLogic):void
		{
			_logicManager = a_manager;
		}//end set logicManager()
		
		public function get logicManager():AbstractGameLogic
		{
			return _logicManager;
		}//end get logicManager()
		
		public function set externalServices(a_ext:AbstractExternalService):void
		{
			_externalService = a_ext;
		}//end set externalServices()
		
		public function get externalServices():AbstractExternalService
		{
			return _externalService;
		}//end get externalServices()
		
		public function get isDebugBuild():Boolean
		{
			return _debugBuild;
			
		}//end get isDebugBuild()
		
		/*****************************
		 * 
		 * WARNING CODE BLOCK, BELOW:
		 * 
		 *****************************/
		
		public static function addWarning(a_str:String):void
		{
			if (!_warningArr)
			{
				_warningArr = new Array();
				_warningTmr = new Timer(1000, 0);
				_warningTmr.addEventListener(TimerEvent.TIMER, onWarning, false, 0, true);
			}
			
			_warningArr.push(a_str);
			
			if (!_warningTmr.running)
			{
				_warningTmr.start();
			}
			
		}//end addWarning()
		
		private static function onWarning(a_evt:TimerEvent):void
		{
			var warningStr:String;
			
			if (_warningArr && _warningArr.length)
			{
				warningStr = _warningArr.shift();
				
				if(!_warningArr.length)
				{
					_warningTmr.stop();
				}
			}
			else
			{
				_warningTmr.stop();
			}
			
			if (warningStr)
			{
				throw new Error(warningStr);
			}
			
		}//end onWarning()
		
	}//end class DartsGlobals
	
}//end package com.bored.games.darts

internal class DartsGlobals_SingletonEnforcer{}