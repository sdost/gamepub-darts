package com.bored.games.darts.states 
{
	import com.bored.games.config.ConfigManager;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
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
	 * @author Bo Landsman
	 */
	public class Initialization extends State
	{		
		public function Initialization(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end Initialization() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{	
			var servicesConfig:XML = ConfigManager.getConfigNamespace("externalServices");
			
			trace(servicesConfig.provider);
			
			//var ServicesClass:Class = getDefinitionByName(servicesConfig.provider) as Class;
			
			//trace("ServicesClass: " + ServicesClass);
			
			//var ext:AbstractExternalService = new ServicesClass();
			
			//ext.init(servicesConfig.gameId, DartsGlobals.instance.optionsInterfaceSpace);
			
			//DartsGlobals.instance.externalServices = ext;
			
			//trace("Initialization::onEnter()");
			this.finished();
			
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
			
			
		}//end onExit()
		
	}//end class Initialization
	
}//end package com.bored.games.darts.states
