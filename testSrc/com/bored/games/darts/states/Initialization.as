package com.bored.games.darts.states 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.profiles.UserProfile;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.hud.ControlPanel;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class Initialization extends State
	{			
		private var _infoLoaded:Boolean;
		private var _dataLoaded:Boolean;
		
		public function Initialization(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end Initialization() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{		
			trace("Initialization::onEnter()");
			
			DartsGlobals.instance.gameManager = new CricketGameLogic();
			
			trace("GameManager: " + DartsGlobals.instance.gameManager);
			
			var providerCls:Class = getDefinitionByName(AppSettings.instance.externalServicesProvider) as Class;
			var ext:AbstractExternalService = new providerCls();
			ext.init(AppSettings.instance.externalServicesGameId, DartsGlobals.instance.optionsInterfaceSpace);
			DartsGlobals.instance.externalServices = ext;
			
			_infoLoaded = false;
			_dataLoaded = false;
			
			DartsGlobals.instance.externalServices.showLoginUI();
			
			DartsGlobals.instance.externalServices.addEventListener(AbstractExternalService.USER_INFO_AVAILABLE, onUserInfo, false, 0, true);
			DartsGlobals.instance.externalServices.addEventListener(AbstractExternalService.USER_DATA_AVAILABLE, onUserData, false, 0, true);
			
			if (DartsGlobals.instance.externalServices.loggedIn) 
			{
				DartsGlobals.instance.externalServices.getUserInfo();
			}
			
			DartsGlobals.instance.externalServices.pullUserData();
		}//end onEnter()
		
		private function onUserInfo(a_evt:Event):void
		{
			var userInfo:Object = DartsGlobals.instance.externalServices.getData("userInfo");
			
			DartsGlobals.instance.playerProfile.name = userInfo.name;
			DartsGlobals.instance.playerProfile.unlockSkin("basicplaid", "heart");
			
			_infoLoaded = true;
			
			if( _infoLoaded && _dataLoaded ) this.finished();
		}//end onUserData()
		
		private function onUserData(a_evt:Event):void
		{
			var userInfo:Object = DartsGlobals.instance.externalServices.getData("userData");
			
			var gameCash:int = DartsGlobals.instance.externalServices.getData("gameCash");
			
			if (gameCash <= 0)
				DartsGlobals.instance.externalServices.setData("gameCash", 0);
			
			_dataLoaded = true;
			
			if( _infoLoaded && _dataLoaded ) this.finished();
		}//end onUserData()
		
		private function finished(...args):void
		{
			(this.stateMachine as GameFSM).transitionToNextState();
		}//end finished()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
		}//end onExit()
		
	}//end class Initialization
	
}//end package com.bored.games.darts.states
