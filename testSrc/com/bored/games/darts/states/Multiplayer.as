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
	import com.bored.games.darts.logic.RemoteCricketGameLogic;
	import com.bored.games.darts.models.dae_DartFlightModHex;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.player.ComputerPlayer;
	import com.bored.games.darts.player.LocalPlayer;
	import com.bored.games.darts.player.RemotePlayer;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.profiles.UserProfile;
	import com.bored.games.darts.skins.DartSkin;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.OpponentSelectScreen;
	import com.bored.gs.chat.ChatClient;
	import com.bored.gs.chat.IChatClient;
	import com.bored.gs.chat.IPlayRequest;
	import com.bored.gs.game.GameClient;
	import com.bored.gs.game.IGameClient;
	import com.bored.gs.game.TurnBasedGameClient;
	import com.bored.gs.GameServices;
	import com.bored.services.AbstractExternalService;
	import com.inassets.FileLoader;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
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
	public class Multiplayer extends State
	{		
		private var _igs:IPlayRequest;
		//private var _multiplayerScreen:MultiplayerScreen;
		private var _fl:FileLoader;
		private var _fsm:Object;
		
		public function Multiplayer(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
		}//end Multiplayer() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{			
			trace("Multiplayer::onEnter()");
			
			_igs = new TurnBasedGameClient();
			
			_fl = new FileLoader();
			_fl.request("views.xml", "views", null, 0, onViewComplete);
		}//end onEnter()
		
		private function onViewComplete(k:String):void
		{
			trace("Multiplayer::onViewComplete " + k);
			
			_fl.request("PlayRequest.swf", "pr", null, 0, onPRComplete);
		}
		
		private function onPRComplete(k:String):void
		{
			trace("Multiplayer::onPRComplete " + k);
			
			var ied:IEventDispatcher = _fl.getIED(k);
			var li:LoaderInfo = ied as LoaderInfo;
			
			var fsmCls:Class = li.applicationDomain.getDefinition("chat.ChatFSM") as Class;
			_fl.cleanUp(k);
			
			_fsm = new fsmCls(new XML(_fl.getData("views")), _igs, 2, DartsGlobals.instance.stage);
			_fsm.addEventListener("t_r", onFSMReady);
			
			_fl.cleanUp("views");
		}
		
		private function onFSMReady(e:Event = null):void
		{
			trace("Multiplayer::onFSMReady " + e);
			
			_fsm.removeEventListener("t_r", onFSMReady);
			
			_fsm.addEventListener("m_p", onMPGameReady);
			_fsm.start();
		}
		
		private function onMPGameReady(e:Event):void
		{
			trace("Multiplayer::onMPGameReady");
			_fsm.removeEventListener("m_p", onMPGameReady);
			
			DartsGlobals.instance.multiplayerClient = _igs as IGameClient;
			
			DartsGlobals.instance.gameManager = new RemoteCricketGameLogic();
			
			_fsm.hide();
			
			this.finished();
		}
		
		private function finished():void
		{
			trace("Multiplayer::finished()");
			
			for each( var user:Object in (DartsGlobals.instance.multiplayerClient as IChatClient).users )
			{
				if ( (DartsGlobals.instance.multiplayerClient as IChatClient).account.id != user.id )
				{
					DartsGlobals.instance.opponentProfile = new UserProfile();
					DartsGlobals.instance.opponentProfile.name = user.name;
					DartsGlobals.instance.opponentProfile.unlockSkin("basicplaid", "heart");
			
					DartsGlobals.instance.opponentPlayer = new RemotePlayer(DartsGlobals.instance.opponentProfile);
					DartsGlobals.instance.opponentPlayer.setPortrait(new Protagonist_Portrait_BMP(150, 150));
					DartsGlobals.instance.opponentPlayer.setSkin(DartsGlobals.instance.opponentProfile.skins[0]);
			
					DartsGlobals.instance.opponentPlayer.addAbilities(new ShieldAbility(10))
					DartsGlobals.instance.opponentPlayer.addAbilities(new BeeLineAbility(10))
					DartsGlobals.instance.opponentPlayer.addAbilities(new DoOverAbility(10));
				}
			}
			
			(this.stateMachine as GameFSM).transitionToStateNamed("GameConfirm");
		}
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
		}//end onExit()
		
	}//end class Multiplayer
	
}//end package com.bored.games.darts.states