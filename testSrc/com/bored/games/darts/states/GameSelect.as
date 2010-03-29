package com.bored.games.darts.states 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.assets.OpponentSelectScreen_MC;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.player.ComputerPlayer;
	import com.bored.games.darts.player.LocalPlayer;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.OpponentSelectScreen;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
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
	public class GameSelect extends State
	{		
		private var _opponentSelectScreen:OpponentSelectScreen;
		
		public function GameSelect(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end GameSelect() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{			
			trace("GameSelect::onEnter()");
					
			var opponentSelectScreenImg:MovieClip;
			
			try
			{
				opponentSelectScreenImg = new OpponentSelectScreen_MC();
				_opponentSelectScreen = new OpponentSelectScreen(opponentSelectScreenImg, false, true);
				_opponentSelectScreen.addEventListener(OpponentSelectScreen.OPPONENT_CHOSEN_EVT, onOpponentChosen, false, 0, true);
				DartsGlobals.instance.screenSpace.addChild(_opponentSelectScreen);
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("Attract::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
		
		public function onOpponentChosen(a_evt:Event):void
		{
			_opponentSelectScreen.removeEventListener(OpponentSelectScreen.OPPONENT_CHOSEN_EVT, onOpponentChosen);
			
			var dartTexture_UJ:BitmapMaterial = new BitmapMaterial(ImageFactory.getBitmapDataByQualifiedName(AppSettings.instance.playerDartTexture, AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight));
			dartTexture_UJ.repeat = false;
			dartTexture_UJ.smooth = true;
			
			var dartTexture_JR:BitmapMaterial = new BitmapMaterial(ImageFactory.getBitmapDataByQualifiedName(AppSettings.instance.opponentDartTexture, AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight));
			dartTexture_JR.repeat = false;
			dartTexture_JR.smooth = true;
			
			var localPlayer:LocalPlayer = new LocalPlayer();
			localPlayer.setSkin(dartTexture_UJ);
			localPlayer.setAbilities(new BeeLineAbility(1), new ShieldAbility(1), new DoOverAbility(1));
			DartsGlobals.instance.gameManager.registerPlayer( localPlayer );
			
			/*
			var cpuPlayer1:ComputerPlayer = new ComputerPlayer();
			cpuPlayer1.setSkin(dartTexture_UJ);			
			DartsGlobals.instance.gameManager.registerPlayer( cpuPlayer1 );
			*/
			
			var cpuPlayer2:ComputerPlayer = new ComputerPlayer();
			cpuPlayer2.setSkin(dartTexture_JR);
			DartsGlobals.instance.gameManager.registerPlayer( cpuPlayer2 );
			
			this.finished();
		}//end pickOpponent()
		
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