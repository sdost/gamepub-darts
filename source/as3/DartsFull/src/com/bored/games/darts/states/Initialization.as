package com.bored.games.darts.states 
{
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.player.LocalPlayer;
	import com.bored.games.darts.profiles.UserProfile;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.hud.ControlPanel;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.sven.utils.AppSettings;
	import com.sven.factories.ImageFactory;
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
			DartsGlobals.addWarning("Initialization::onEnter()");
			
			//DartsGlobals.instance.gameManager = new CricketGameLogic();
			
			trace("GameManager: " + DartsGlobals.instance.gameManager);
			
			DartsGlobals.instance.playerProfile.name = "Player";
			DartsGlobals.instance.playerProfile.unlockSkin("basicplaid", "heart");
			
			DartsGlobals.instance.localPlayer = new LocalPlayer();
			DartsGlobals.instance.localPlayer.portrait = ImageFactory.getBitmapDataByQualifiedName(AppSettings.instance.defaultPlayerPic, 150, 150);
			
			DartsGlobals.instance.localPlayer.addAbilities(new ShieldAbility(10))
			DartsGlobals.instance.localPlayer.addAbilities(new BeeLineAbility(10))
			DartsGlobals.instance.localPlayer.addAbilities(new DoOverAbility(10));
						
			var providerCls:Class = getDefinitionByName(AppSettings.instance.externalServicesProvider) as Class;
			var ext:AbstractExternalService = new providerCls();
			ext.init( { rootContainer: DartsGlobals.instance.optionsInterfaceSpace } );
			DartsGlobals.instance.externalServices = ext;
			
			DartsGlobals.instance.externalServices.setData("gameCash", 500);
			DartsGlobals.instance.externalServices.setData("powerLevels", new Object());
			DartsGlobals.instance.externalServices.setData("ownedSkins", new Array());
			
			_infoLoaded = false;
			_dataLoaded = false;
			
			DartsGlobals.instance.externalServices.showLoginUI();
			
			finished();
		}//end onEnter()
		
		private function finished(...args):void
		{
			(this.stateMachine as GameFSM).transitionToNextState();
		}//end finished()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			DartsGlobals.addWarning("Initialization::onExit()");
			
		}//end onExit()
		
	}//end class Initialization
	
}//end package com.bored.games.darts.states
