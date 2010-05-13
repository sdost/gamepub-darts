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
	import com.bored.gs.chat.ChatClient;
	import com.bored.gs.chat.IChatClient;
	import com.bored.gs.game.GameClient;
	import com.bored.gs.game.TurnBasedGameClient;
	import com.bored.gs.GameServices;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.sven.utils.ImageFactory;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
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
		//private var _multiplayerScreen:MultiplayerScreen;
		
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
			
			DartsGlobals.instance.setupControlPanel();
			
			DartsGlobals.instance.multiplayerClient = new TurnBasedGameClient();
			DartsGlobals.instance.multiplayerClient.addEventListener(GameServices.CONNECTED, onEvent);
			DartsGlobals.instance.multiplayerClient.addEventListener(GameServices.DISCONNECTED, onEvent);
			DartsGlobals.instance.multiplayerClient.addEventListener(GameServices.LOGOUT, onEvent);
			DartsGlobals.instance.multiplayerClient.addEventListener(GameServices.ERROR, onError);
			DartsGlobals.instance.multiplayerClient.addEventListener(GameServices.USER_ACCT, onAcct);
			
			DartsGlobals.instance.multiplayerClient.addEventListener(ChatClient.LOBBY_ROOM, onLobbyRoomJoin);
			DartsGlobals.instance.multiplayerClient.addEventListener(ChatClient.USER_IN, onUserIn);
			DartsGlobals.instance.multiplayerClient.addEventListener(ChatClient.USER_OUT, onUserOut);
			
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_ROOM, onGameRoomJoin);
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_START, onGameStart);
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_WAIT, onGameWait);
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_END, onGameEnd);
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_RESULTS, onGameResults);
			
			// Turn Based Events
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.ROUND_START, onRoundStart);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.ROUND_END, onRoundEnd);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.ROUND_RESULTS, onRoundResults);
			
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_START, onTurnStart);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_WAIT, onTurnWait);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_UPDATE, onTurnUpdate);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_END, onTurnEnd);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_RESULTS, onTurnResults);
			
			DartsGlobals.instance.multiplayerClient.login();
		}//end onEnter()
		
		private function onEvent(a_evt:Event):void
		{
			trace("Multiplayer::onEvent " + a_evt.type);
			
			switch(a_evt.type)
			{
				case GameServices.CONNECTED:
				{
					DartsGlobals.instance.multiplayerClient.login("", "");
					trace("Connected and logging in!\n");
				}
				break;
				
				case GameServices.DISCONNECTED:
				{
					trace("Disconnected :-(\nClick to reconnect and login.\n");
				}
				break;
				
				case GameServices.LOGOUT:
				{
					trace("Logged out\nClick to login.\n");
				}
				break;
			}
		}//end onEvent()
		
		private function onError(a_evt:ErrorEvent):void
		{
			trace("Multiplayer::onError " + a_evt.text);
		}//end onError()
		
		private function onAcct(a_evt:Event):void
		{
			walkObj(DartsGlobals.instance.multiplayerClient.account);
			
			DartsGlobals.instance.stage.doubleClickEnabled = true;
			DartsGlobals.instance.stage.addEventListener(MouseEvent.DOUBLE_CLICK, onRGM);
		}//end onAcct()
		
		private function onRGM(e:Event):void
		{
			DartsGlobals.instance.stage.doubleClickEnabled = false;
			DartsGlobals.instance.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, onRGM);
			
			trace("Requesting Rooms");
			
			DartsGlobals.instance.multiplayerClient.requestGameRooms(1);
		}
		
		private function onLobbyRoomJoin(a_evt:Event):void
		{
			trace("In Lobby Room!");
			
			DartsGlobals.instance.stage.doubleClickEnabled = true;
			DartsGlobals.instance.stage.addEventListener(MouseEvent.DOUBLE_CLICK, onRGM);
		}//end onLobbyRoomJoin()
		
		private function onUserIn(a_evt:Event):void
		{
			trace("New player(s) in Room!");
			walkObj(IChatClient(DartsGlobals.instance.multiplayerClient).users);
		}//end onUserIn()
		
		private function onUserOut(a_evt:Event):void
		{
			trace("Player left the Room!");
			walkObj(IChatClient(DartsGlobals.instance.multiplayerClient).lastOut);
			
			trace("Remaining users:");
			walkObj(IChatClient(DartsGlobals.instance.multiplayerClient).users);
		}//end onUserOut()
		
		private function onGameRoomJoin(a_evt:Event):void
		{
			trace("In Game Room!");
			trace("Checking for other player(s)!");
			
			if(IChatClient(DartsGlobals.instance.multiplayerClient).users.length > 1)
			{
				onUserIn(a_evt);
			}
		}//end onGameRoomJoin()
		
		private function onGameStart(a_evt:Event):void
		{
			
		}//end onGameStart()
		
		private function onGameWait(a_evt:Event):void
		{
			
		}//end onGameWait()
		
		private function onGameEnd(a_evt:Event):void
		{
			
		}//end onGameEnd()
		
		private function onGameResults(a_evt:Event):void
		{
			
		}//end onGameResults()
		
		private function onRoundStart(a_evt:Event):void
		{
			
		}//end onRoundStart()
		
		private function onRoundEnd(a_evt:Event):void
		{
			
		}//end onRoundEnd()
		
		private function onRoundResults(a_evt:Event):void
		{
			
		}//end onRoundResults()
		
		private function onTurnStart(a_evt:Event):void
		{
			
		}//end onTurnStart()
		
		private function onTurnWait(a_evt:Event):void
		{
			
		}//end onTurnWait()
		
		private function onTurnUpdate(a_evt:Event):void
		{
			
		}//end onTurnUpdate()
		
		private function onTurnEnd(a_evt:Event):void
		{
			
		}//end onTurnEnd()
		
		private function onTurnResults(a_evt:Event):void
		{
			
		}//end onTurnResults()
		
		protected function walkObj(a_obj:Object, a_spacer:String = "--"):void
		{
			for(var str:String in a_obj)
			{
				var output:String = a_spacer + " " + str + " = " + a_obj[str];
				trace(output);
				
				if(a_obj[str] is Object)
				{
					walkObj(a_obj[str], a_spacer + "--");
				}
			}
		}//end walkObj()
				
		private function finished(...args):void
		{
			(this.stateMachine as GameFSM).transitionToStateNamed("GameConfirm");			
		}//end finished()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
		}//end onExit()
		
	}//end class Multiplayer
	
}//end package com.bored.games.darts.states