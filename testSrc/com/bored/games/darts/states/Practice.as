package com.bored.games.darts.states 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.assets.OpponentSelectScreen_MC;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.assets.icons.Protagonist_Portrait_BMP;
	import com.bored.games.darts.assets.icons.Simon_Portrait_BMP;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.models.dae_DartFlightModHex;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.player.ComputerPlayer;
	import com.bored.games.darts.player.LocalPlayer;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.skins.DartSkin;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.OpponentSelectScreen;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
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
	public class Practice extends State
	{		
		private var _opponentSelectScreen:OpponentSelectScreen;
		
		public function Practice(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
		}//end Practice() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{			
			trace("Practice::onEnter()");
			
			DartsGlobals.instance.setupControlPanel();
			
			DartsGlobals.instance.localPlayer.setSkin(DartsGlobals.instance.playerProfile.skins[0]);
			
			DartsGlobals.instance.enemyProfile = new EnemyProfile("Computer");
			DartsGlobals.instance.enemyProfile.accuracy = 0.7;
			DartsGlobals.instance.enemyProfile.stepScale = 0.05;
			DartsGlobals.instance.enemyProfile.dartSkin = new DartSkin( ImageFactory.getBitmapDataByQualifiedName("dartuv_techno", 512, 512), dae_DartShaft.data, dae_DartFlightModHex.data );
					
			DartsGlobals.instance.cpuPlayer = new ComputerPlayer(DartsGlobals.instance.enemyProfile);
			DartsGlobals.instance.cpuPlayer.setPortrait(DartsGlobals.instance.enemyProfile.portrait);
			//DartsGlobals.instance.cpuPlayer.setAbilities(new BeeLineAbility(5), new ShieldAbility(5), new DoOverAbility(5));			
			DartsGlobals.instance.cpuPlayer.setSkin(DartsGlobals.instance.enemyProfile.dartSkin);
			
			DartsGlobals.instance.gameManager.registerPlayer( DartsGlobals.instance.localPlayer );
			DartsGlobals.instance.gameManager.registerPlayer( DartsGlobals.instance.cpuPlayer );
			
			finished();	
		}//end onEnter()
				
		private function finished(...args):void
		{
			(this.stateMachine as GameFSM).transitionToStateNamed("Gameplay");			
		}//end finished()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
		}//end onExit()
		
	}//end class Practice
	
}//end package com.bored.games.darts.states