package com.bored.games.darts.states 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.player.ComputerPlayer;
	import com.bored.games.darts.player.LocalPlayer;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.OpponentSelectScreen;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.sven.factories.ImageFactory;
	import com.sven.factories.SpriteFactory;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
	public class CPUOpponentSelect extends State
	{		
		private var _opponentSelectScreen:OpponentSelectScreen;
		
		public function CPUOpponentSelect(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
		}//end GameSelect() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			DartsGlobals.addWarning("CPUOpponentSelect::onEnter()");
			
			DartsGlobals.instance.gameManager = new CricketGameLogic();
			
			DartsGlobals.instance.setupControlPanel();
			DartsGlobals.instance.showControlPanel();
					
			var opponentSelectScreenImg:Sprite;
			
			try
			{
				opponentSelectScreenImg = SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.opponentSelectScreenSprite);
				_opponentSelectScreen = new OpponentSelectScreen(opponentSelectScreenImg, false, true);
				_opponentSelectScreen.addEventListener(OpponentSelectScreen.OPPONENT_CHOSEN_EVT, onOpponentChosen, false, 0, true);
				_opponentSelectScreen.addEventListener(OpponentSelectScreen.SHOW_STORE_EVT, onShowStoreChosen, false, 0, true);
				DartsGlobals.instance.screenSpace.addChild(_opponentSelectScreen);
				
				DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("select_sound", "button_chrclick_mp3") );
				DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("store_sound", "button_getdarts_mp3") );
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("CPUOpponentSelect::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
		
		public function onOpponentChosen(a_evt:Event):void
		{
			DartsGlobals.addWarning("CPUOpponentSelect::onOpponentChosen()");
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("select_sound");
			
			_opponentSelectScreen.removeEventListener(OpponentSelectScreen.OPPONENT_CHOSEN_EVT, onOpponentChosen);
			
			DartsGlobals.instance.localPlayer.playerNum = CricketGameLogic.HUMAN_PLAYER;
			
			DartsGlobals.instance.opponentPlayer = new ComputerPlayer(DartsGlobals.instance.opponentProfile);
			DartsGlobals.instance.opponentPlayer.playerNum = CricketGameLogic.CPU_PLAYER;
			DartsGlobals.instance.opponentPlayer.portrait = DartsGlobals.instance.opponentProfile.portrait;
			DartsGlobals.instance.opponentPlayer.addAbilities(new BeeLineAbility(10));
			DartsGlobals.instance.opponentPlayer.addAbilities(new ShieldAbility(10));
			DartsGlobals.instance.opponentPlayer.addAbilities(new DoOverAbility(10));
			DartsGlobals.instance.opponentPlayer.setSkin(DartsGlobals.instance.opponentProfile.dartSkin);
			
			this.finished();
		}//end pickOpponent()
		
		public function onShowStoreChosen(a_evt:Event):void
		{
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("store_sound");
			
			(this.stateMachine as GameFSM).transitionToStateNamed("GameStore");
		}//end pickOpponent()
		
		private function finished(...args):void
		{
			DartsGlobals.addWarning("CPUOpponentSelect::finished()");
			
			(this.stateMachine as GameFSM).transitionToStateNamed("GameConfirm");			
		}//end finished()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			DartsGlobals.addWarning("CPUOpponentSelect::onExit()");
			
			_opponentSelectScreen.removeEventListener(OpponentSelectScreen.OPPONENT_CHOSEN_EVT, onOpponentChosen);
			_opponentSelectScreen.removeEventListener(OpponentSelectScreen.SHOW_STORE_EVT, onShowStoreChosen);
			
			_opponentSelectScreen.destroy();
			
			_opponentSelectScreen = null;
		}//end onExit()
		
	}//end class CPUOpponentSelect
	
}//end package com.bored.games.darts.states