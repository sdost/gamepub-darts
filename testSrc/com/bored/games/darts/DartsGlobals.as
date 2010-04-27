package com.bored.games.darts
{
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.jac.soundManager.SoundController;
	import com.sven.utils.AppSettings;
	import flash.media.SoundChannel;
	import flash.sampler.NewObjectSample;
	import flash.utils.getDefinitionByName;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.profiles.UserProfile;
	import com.bored.games.darts.ui.hud.ControlPanel;
	import com.bored.services.AbstractExternalService;
	import com.sven.managers.ModalDisplayManager;
	import com.jac.soundManager.SoundManager;
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
		public static const EASY:int = 0;
		public static const HARD:int = 1;
		
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

		private var _externalService:AbstractExternalService;
		
		private var _gameManager:DartsGameLogic;
		
		private var _modalDisplayManager:ModalDisplayManager;
		
		private var _playerProfile:UserProfile;
		
		private var _localPlayer:DartsPlayer;
		
		private var _enemyProfile:EnemyProfile;
		
		private var _cpuPlayer:DartsPlayer;
		
		private var _soundManager:SoundManager;
		
		private var _controlPanel:ControlPanel;
		
		private var _stateMachine:IStateMachine;
		
		private var _gameMode:int;
		
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
		
		public function set stateMachine(a_fsm:IStateMachine):void
		{
			_stateMachine = a_fsm;
		}//end set stateMachine()
		
		public function get stateMachine():IStateMachine
		{
			return _stateMachine;
		}//end get stateMachine()	
		
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
		
		public function set gameMode(a_mode:int):void
		{
			_gameMode = a_mode;
		}//end set gameMode()
		
		public function get gameMode():int
		{
			return _gameMode;
		}//end set gameMode()
		
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
		
		public function set gameManager(a_manager:DartsGameLogic):void
		{
			_gameManager = a_manager;
		}//end set gameManager()
		
		public function get gameManager():DartsGameLogic
		{
			return _gameManager;
		}//end get gameManager()
		
		public function get soundManager():SoundManager
		{
			if (!_soundManager) 
			{
				_soundManager = SoundManager.getInstance();
			}
			
			return _soundManager;
		}//end get soundManager()
		
		public function set externalServices(a_ext:AbstractExternalService):void
		{
			_externalService = a_ext;
			_externalService.addEventListener(AbstractExternalService.USER_INVENTORY_UPDATE, onInventoryUpdate, false, 0, true);
		}//end set externalServices()
		
		public function get externalServices():AbstractExternalService
		{
			return _externalService;
		}//end get externalServices()
		
		private function onInventoryUpdate(evt:Event):void
		{
			for each( var obj:Object in _externalService.getData("ownedItems") ) 
			{		
				if (obj.properties.skinid && obj.properties.flightid) 
				{
					_playerProfile.unlockSkin(obj.properties.skinid, obj.properties.flightid);
				}
			}
		}//end onInventoryUpdate()
		
		public function set localPlayer(a_player:DartsPlayer):void
		{
			_localPlayer = a_player;
		}//end set localPlayer()
		
		public function get localPlayer():DartsPlayer
		{
			return _localPlayer;
		}//end get localPlayer()
		
		public function set playerProfile(a_profile:UserProfile):void
		{
			_playerProfile = a_profile;
		}//end set playerProfile()
		
		public function get playerProfile():UserProfile
		{
			return _playerProfile;
		}//end get playerProfile()
		
		public function set enemyProfile(a_profile:EnemyProfile):void
		{
			_enemyProfile = a_profile;
		}//end set enemyProfile()
		
		public function get enemyProfile():EnemyProfile
		{
			return _enemyProfile;
		}//end get enemyProfile()
		
		public function set cpuPlayer(a_player:DartsPlayer):void
		{
			_cpuPlayer = a_player;
		}//end set cpuPlayer()
		
		public function get cpuPlayer():DartsPlayer
		{
			return _cpuPlayer;
		}//end get cpuPlayer()
		
		public function get isDebugBuild():Boolean
		{
			return _debugBuild;
			
		}//end get isDebugBuild()
		
		public function setupControlPanel():void
		{
			var cls:Class = getDefinitionByName(AppSettings.instance.controlPanelMovie) as Class;
			_controlPanel = new ControlPanel(new cls());
			DartsGlobals.instance.optionsInterfaceSpace.addChild(_controlPanel);
			_controlPanel.x = AppSettings.instance.controlPanelPositionX;
			_controlPanel.y = AppSettings.instance.controlPanelPositionY;
			_controlPanel.registerSoundManager(DartsGlobals.instance.soundManager);
			_controlPanel.show();
			
			_gameManager.addEventListener(DartsGameLogic.QUIT_TO_TITLE, onQuitToTitle, false, 0, true);			
		}//end setupControlPanel()
		
		private function onQuitToTitle(a_evt:Event):void
		{
			_gameManager.removeEventListener(DartsGameLogic.QUIT_TO_TITLE, onQuitToTitle);
			
			DartsGlobals.instance.gameManager.cleanup();
			
			_controlPanel.hide();
			
			(this.stateMachine as GameFSM).transitionToStateNamed("Attract");
		}//end onGameEnd()
		
		public function showModalPopup(a_content:Class = null, a_prompt:Object = null):void
		{
			_modalDisplayManager = ModalDisplayManager.createModalDisplay(_popupSpace, a_content, a_prompt);
		}//end showModalPopup()
		
		public function processModalQueue():void
		{
			if (_modalDisplayManager) _modalDisplayManager.manageQueue();
		}//end processModalQueue()
		
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