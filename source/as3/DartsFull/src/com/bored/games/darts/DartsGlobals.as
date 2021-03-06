﻿package com.bored.games.darts
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.profiles.Profile;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.hud.CashPanel;
	import com.bored.services.BoredServices;
	import com.bored.services.client.GameClient;
	import com.bored.services.client.TurnBasedGameClient;
	import com.inassets.events.ObjectEvent;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.jac.soundManager.SoundController;
	import com.sven.utils.AppSettings;
	import flash.events.AsyncErrorEvent;
	import flash.events.StatusEvent;
	import flash.media.SoundChannel;
	import flash.net.LocalConnection;
	import flash.sampler.NewObjectSample;
	import flash.utils.getDefinitionByName;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.profiles.UserProfile;
	import com.bored.games.darts.ui.hud.ControlPanel;
	import com.bored.services.AbstractExternalService;
	import com.bored.games.darts.managers.ModalDisplayManager;
	import com.jac.soundManager.SoundManager;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import mx.utils.ObjectUtil;
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class DartsGlobals extends EventDispatcher
	{
		public static const TYPE_CRICKET:int = 0;
		public static const TYPE_FIVEOHONE:int = 1;
		
		public static const GAME_STORY:int = 0;
		public static const GAME_PRACTICE:int = 1;
		public static const GAME_MULTIPLAYER:int = 2;
		
		public static const THROW_BEGINNER:int = 0;
		public static const THROW_EXPERT:int = 1;
		
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
		private static var _debugLocalConn:LocalConnection;
		private static var _debugLcName:String = "_debugBridge";
		
		private static var _instance:DartsGlobals;
		private var _constructed:Boolean = false;
		
		private var _debugBuild:Boolean = false;

		private var _externalService:AbstractExternalService;
		
		private var _gameManager:DartsGameLogic;
		
		private var _modalDisplayManager:ModalDisplayManager;
		
		private var _playerProfile:Profile;
		
		private var _localPlayer:DartsPlayer;
		
		private var _opponentProfile:Profile;
		
		private var _opponentPlayer:DartsPlayer;
		
		private var _soundManager:SoundManager;
		
		private var _controlPanel:ControlPanel;
		
		private var _cashPanel:CashPanel;
		
		private var _stateMachine:IStateMachine;
		
		private var _gameType:int;
		
		private var _gameMode:int;
		
		private var _throwMode:int;
		
		private var _multiplayerGameId:int;
		
		private var _multiplayerGameClient:*;
		
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
		
		public function set gameType(a_type:int):void
		{
			_gameType = a_type;
		}//end set gameType()
		
		public function get gameType():int
		{
			return _gameType;
		}//end set gameType()
		
		public function set gameMode(a_mode:int):void
		{
			_gameMode = a_mode;
		}//end set gameMode()
		
		public function get gameMode():int
		{
			return _gameMode;
		}//end set gameMode()
		
		public function set throwMode(a_mode:int):void
		{
			_throwMode = a_mode;
		}//end set gameMode()
		
		public function get throwMode():int
		{
			return _throwMode;
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
				_soundManager.addSoundController(new SoundController("loopsController"));
				_soundManager.addSoundController(new SoundController("abilitySounds"));
				_soundManager.addSoundController(new SoundController("buttonSoundController"));
			}
			
			return _soundManager;
		}//end get soundManager()
		
		public function set externalServices(a_ext:AbstractExternalService):void
		{
			_externalService = a_ext;
			_externalService.addEventListener(AbstractExternalService.USER_LOGIN, onLogin, false, 0, true);
			_externalService.addEventListener(AbstractExternalService.USER_DATA_AVAILABLE, onUserData, false, 0, true);
			
		}//end set externalServices()
		
		public function get externalServices():AbstractExternalService
		{
			return _externalService;
		}//end get externalServices()
		
		public function set multiplayerGameId(a_id:int):void
		{
			_multiplayerGameId = a_id;
		}//end set multiplayerGameId()
		
		public function get multiplayerGameId():int
		{
			return _multiplayerGameId;
		}//end get multiplayerGameId()
		
		private function onLogin(evt:Event):void
		{
			_externalService.pullUserData();
		}//end onInventoryUpdate()
		
		public function onUserData(evt:Event = null):void
		{
			DartsGlobals.addWarning("DartsGlobals::onUserData()");
			
			var gameCash:int = _externalService.getData("gameCash");
			
			trace("Game Cash: " + gameCash);
			
			if (gameCash <= 0)
			{
				gameCash = 0;
				_externalService.setData("gameCash", gameCash);
			}
			
			var powerLevels:Object = _externalService.getData("powerLevels");
			
			for ( var key:String in powerLevels )
			{
				_localPlayer.getAbilityByName(powerLevels[key].name).refreshTime = powerLevels[key].refreshTime;
			}
			
			_playerProfile.clearUnlockedSkins();
			
			var ownedSkins:Object = _externalService.getData("ownedSkins");
			
			for each( var obj:Object in ownedSkins) 
			{		
				if (obj.skinid && obj.flightid) 
				{
					_playerProfile.unlockSkin(obj.skinid, obj.flightid);
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
		
		public function set playerProfile(a_profile:Profile):void
		{
			_playerProfile = a_profile;
		}//end set playerProfile()
		
		public function get playerProfile():Profile
		{
			return _playerProfile;
		}//end get playerProfile()
		
		public function set opponentProfile(a_profile:Profile):void
		{
			_opponentProfile = a_profile;
		}//end set opponentProfile()
		
		public function get opponentProfile():Profile
		{
			return _opponentProfile;
		}//end get enemyProfile()
		
		public function set opponentPlayer(a_player:DartsPlayer):void
		{
			_opponentPlayer = a_player;
		}//end set cpuPlayer()
		
		public function get opponentPlayer():DartsPlayer
		{
			return _opponentPlayer;
		}//end get cpuPlayer()
		
		public function set multiplayerClient(a_client:*):void
		{
			_multiplayerGameClient = a_client;
		}//end set multiplayerClient()
		
		public function get multiplayerClient():*
		{
			return _multiplayerGameClient;
		}//end get multiplayerClient()	
		
		public function get isDebugBuild():Boolean
		{
			return _debugBuild;
			
		}//end get isDebugBuild()
		
		public function setupControlPanel():void
		{
			DartsGlobals.addWarning("DartsGlobals::setupControlPanel()");
			
			if (!_controlPanel)
			{
				var cls:Class = getDefinitionByName(AppSettings.instance.controlPanelMovie) as Class;
				_controlPanel = new ControlPanel(new cls());
				DartsGlobals.instance.optionsInterfaceSpace.addChild(_controlPanel);
				_controlPanel.x = AppSettings.instance.controlPanelPositionX;
				_controlPanel.y = AppSettings.instance.controlPanelPositionY;
				_controlPanel.registerSoundManager(DartsGlobals.instance.soundManager);
			}
			
			if (!_cashPanel)
			{
				cls = getDefinitionByName(AppSettings.instance.cashPanelMovie) as Class;
				_cashPanel = new CashPanel(new cls());
				DartsGlobals.instance.optionsInterfaceSpace.addChild(_cashPanel);
				_cashPanel.x = AppSettings.instance.cashPanelPositionX;
				_cashPanel.y = AppSettings.instance.cashPanelPositionY;
			}
			
			_gameManager.addEventListener(DartsGameLogic.QUIT_TO_TITLE, onQuitToTitle, false, 0, true);			
		}//end setupControlPanel()
		
		public function showControlPanel():void
		{
			DartsGlobals.addWarning("DartsGlobals::showControlPanel()");
			
			if( _controlPanel ) _controlPanel.show();
			if ( _cashPanel && this._gameMode == DartsGlobals.GAME_STORY ) _cashPanel.show();
		}//end setupControlPanel()
		
		public function hideControlPanel():void
		{
			DartsGlobals.addWarning("DartsGlobals::hideControlPanel()");
			
			if( _controlPanel ) _controlPanel.hide();
			if( _cashPanel ) _cashPanel.hide();
		}//end setupControlPanel()
		
		private function onQuitToTitle(a_evt:Event):void
		{
			_gameManager.removeEventListener(DartsGameLogic.QUIT_TO_TITLE, onQuitToTitle);
			
			hideControlPanel();
			
			(this.stateMachine as GameFSM).transitionToStateNamed("Attract");
		}//end onGameEnd()
		
		public function showModalPopup(a_content:Class = null, a_prompt:Object = null):void
		{
			addWarning("DartsGlobals::showModalPopup() -- a_content = " + a_content);
			
			_modalDisplayManager = ModalDisplayManager.createModalDisplay(_popupSpace, a_content, a_prompt);
		}//end showModalPopup()
		
		public function processModalQueue():void
		{
			if (_modalDisplayManager) _modalDisplayManager.manageQueue();
		}//end processModalQueue()
		
		public function clearModalQueue():void
		{
			if (_modalDisplayManager) _modalDisplayManager.clearQueue();
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
				_warningTmr = new Timer(200, 0);
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
				trace(warningStr);
				
				COMPILEVAR::DEBUG
				{
					if (!_debugLocalConn && _debugLcName)
					{
						// Initialized our LocalConnection for the first and only time:
						
						var lcName:* = DartsGlobals.instance.stage.root.loaderInfo.parameters["debugLcName"];
						_debugLcName = lcName;
						
						if (!_debugLcName || !_debugLcName.length || _debugLcName == "" || _debugLcName.toLowerCase() == "null" || _debugLcName.toLowerCase() == "undefined")
						{
							trace("DartsGlobals::onWarning(): this.stage.root.loaderInfo.parameters[\"debugLcName\"]=" + lcName + ", using default=" + "_debugBridge");
							_debugLcName = null;
						}
						else
						{
							_debugLocalConn = new LocalConnection();
							_debugLocalConn.allowDomain("*", "localhost");
							_debugLocalConn.allowInsecureDomain("*", "localhost");
							_debugLocalConn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, DartsGlobals.onLcAsyncError, false, 0, true);
							_debugLocalConn.addEventListener(StatusEvent.STATUS, DartsGlobals.onLcStatus, false, 0, true);
						}
					}
					
					if (_debugLocalConn)
					{
						_debugLocalConn.send(_debugLcName, "debugMsg", warningStr);
					}
				}
			}
			
		}//end onWarning()
		
		public static function onWarningMngrWarning(a_objEvt:ObjectEvent):void
		{
			if (!_warningArr)
			{
				_warningArr = new Array();
				_warningTmr = new Timer(200, 0);
				_warningTmr.addEventListener(TimerEvent.TIMER, onWarning, false, 0, true);
			}
			
			var warningStr:String = String(a_objEvt.obj);
			
			_warningArr.push(warningStr);
			onWarning(null);
			
		}//end onWarningMngrWarning()
		
		COMPILEVAR::DEBUG
		private static function onLcAsyncError(a_asyncErrEvt:AsyncErrorEvent):void
		{
			DartsGlobals.addWarning("DartsGlobal::onLcAsyncError(): a_asyncErrEvt=" + a_asyncErrEvt);
			
		}//end onLcAsyncError()
		
		COMPILEVAR::DEBUG
		private static function onLcStatus(a_statusEvt:StatusEvent):void
		{
			//DartsGlobals.addWarning("DartsGlobal::onLcStatus(): a_statusEvt=" + a_statusEvt);
			
		}//end onLcStatus()
		
	}//end class DartsGlobals
	
}//end package com.bored.games.darts

internal class DartsGlobals_SingletonEnforcer{}