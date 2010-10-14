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
	import com.bored.games.darts.logic.RemoteCricketGameLogic;
	import com.bored.games.darts.logic.RemoteFiveOhOneGameLogic;
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
	import com.bored.services.client.ChatClient;
	import com.bored.services.client.GameClient;
	import com.bored.services.client.GameServices;
	import com.bored.services.client.TurnBasedGameClient;
	import com.bored.services.AbstractExternalService;
	import com.bored.services.BoredServices;
	import com.bored.services.events.ObjectEvent;
	import com.inassets.FileLoader;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.inassets.utils.debug.WarningManager;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.sven.factories.ImageFactory;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import mx.binding.utils.ChangeWatcher;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class Multiplayer extends State
	{		
		public function Multiplayer(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
		}//end Multiplayer() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{			
			DartsGlobals.addWarning("Multiplayer::onEnter()");
			
			DartsGlobals.instance.hideControlPanel();
			
			BoredServices.addEventListener(ObjectEvent.MULTPLAYER_GAME_FAIL_EVT, onFail);
			BoredServices.addEventListener(ObjectEvent.MULTPLAYER_GAME_START_EVT, onMPGameReady);
			
			BoredServices.showGameLobby(AppSettings.instance.multiplayerGameId);
		}//end onEnter()
		
		private function onFail(e:Event):void
		{
			DartsGlobals.addWarning("Multiplayer::onFail()");
			
			BoredServices.removeEventListener(ObjectEvent.MULTPLAYER_GAME_FAIL_EVT, onFail);
			BoredServices.removeEventListener(ObjectEvent.MULTPLAYER_GAME_START_EVT, onMPGameReady);
			
			(this.stateMachine as GameFSM).transitionToStateNamed("Attract");
		}//end onFail()
		
		private function onMPGameReady(e:ObjectEvent):void
		{
			DartsGlobals.addWarning("Multiplayer::onMPGameReady(" + e.obj + ")");
			
			BoredServices.removeEventListener(ObjectEvent.MULTPLAYER_GAME_FAIL_EVT, onFail);
			BoredServices.removeEventListener(ObjectEvent.MULTPLAYER_GAME_START_EVT, onMPGameReady);
			
			DartsGlobals.instance.multiplayerClient = e.obj;
			
			if ( DartsGlobals.instance.gameType == DartsGlobals.TYPE_CRICKET ) 
			{
				DartsGlobals.instance.gameManager = new RemoteCricketGameLogic();
			} 
			else if ( DartsGlobals.instance.gameType == DartsGlobals.TYPE_FIVEOHONE ) 
			{
				DartsGlobals.instance.gameManager = new RemoteFiveOhOneGameLogic();
			}
			
			DartsGlobals.instance.multiplayerClient.addEventListener(ChatClient.ROOM_JOIN, onRoomJoin);
			DartsGlobals.instance.multiplayerClient.addEventListener(ChatClient.USER_IN, onUserIn);
		}
		
		private function onRoomJoin(e:Event):void
		{
			DartsGlobals.addWarning("Multiplayer::onRoomJoin()");
			
			
					
			for each( var user:Object in DartsGlobals.instance.multiplayerClient.users )
			{
				if ( DartsGlobals.instance.multiplayerClient.account.id == user.id )
				{
					DartsGlobals.instance.localPlayer.playerName = user.name;
									
					DartsGlobals.instance.localPlayer.portrait = ImageFactory.getBitmapDataByQualifiedName(AppSettings.instance.defaultMultiplayerPic, 150, 150);
					DartsGlobals.instance.localPlayer.playerNum = user.pid;
					
					BoredServices.addEventListener(ObjectEvent.USER_INFO_READY_EVT, onPlayerProfile, false, 0, true);
					BoredServices.getUserProfileByName(user.name);
				}
				else
				{
					DartsGlobals.instance.opponentProfile = new UserProfile();
					DartsGlobals.instance.opponentProfile.name = user.name;
					
					DartsGlobals.instance.opponentProfile.unlockSkin("basicplaid", "heart");					
			
					DartsGlobals.instance.opponentPlayer = new RemotePlayer(DartsGlobals.instance.opponentProfile);
					
					DartsGlobals.instance.opponentPlayer.portrait = ImageFactory.getBitmapDataByQualifiedName(AppSettings.instance.defaultMultiplayerPic, 150, 150);
					DartsGlobals.instance.opponentPlayer.setSkin(DartsGlobals.instance.opponentProfile.skins[0]);
					DartsGlobals.instance.opponentPlayer.playerNum = user.pid;
			
					DartsGlobals.instance.opponentPlayer.addAbilities(new ShieldAbility(10));
					DartsGlobals.instance.opponentPlayer.addAbilities(new BeeLineAbility(10));
					DartsGlobals.instance.opponentPlayer.addAbilities(new DoOverAbility(10));
					
					BoredServices.addEventListener(ObjectEvent.USER_INFO_READY_EVT, onOpponentProfile, false, 0, true);
					BoredServices.getUserProfileByName(user.name);
				}
			}
			
			if ( DartsGlobals.instance.opponentPlayer ) 
			{
				this.finished();
			}
		}//end onRoomJoin()
		
		private function onPlayerProfile(e:Event):void
		{
			DartsGlobals.addWarning("Multiplayer::onPlayerProfile()");
			
			if (!(e as Object).obj) return;
			
			if ((e as Object).obj.valueOf("screen_name") != DartsGlobals.instance.localPlayer.playerName) return;
			
			BoredServices.removeEventListener(ObjectEvent.USER_INFO_READY_EVT, onPlayerProfile);
			
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, playerImageLoadComplete);
			ldr.load( new URLRequest((e as Object).obj.valueOf("avatar_url")) );
		}
		
		private function playerImageLoadComplete(e:Event):void
		{
			var loader:Loader = Loader(e.target.loader);
			var bmp:Bitmap = Bitmap(loader.content);
			
			DartsGlobals.addWarning("Multiplayer::playerImageLoadComplete() -> bmp = " + bmp);
			
			DartsGlobals.instance.localPlayer.portrait = bmp.bitmapData;
		}//end playerImageLoadComplete()
		
		private function onOpponentProfile(e:Event):void
		{
			DartsGlobals.addWarning("Multiplayer::onOpponentProfile()");
			
			if (!(e as Object).obj) return;
			
			if ((e as Object).obj.valueOf("screen_name") != DartsGlobals.instance.opponentPlayer.playerName) return;
			
			BoredServices.removeEventListener(ObjectEvent.USER_INFO_READY_EVT, onOpponentProfile);
			
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, opponentImageLoadComplete);
			ldr.load( new URLRequest((e as Object).obj.valueOf("avatar_url")) );
		}
		
		private function opponentImageLoadComplete(e:Event):void
		{
			var loader:Loader = Loader(e.target.loader);
			var bmp:Bitmap = Bitmap(loader.content);
			
			DartsGlobals.addWarning("Multiplayer::opponentImageLoadComplete() -> bmp = " + bmp);
			
			DartsGlobals.instance.opponentPlayer.portrait = bmp.bitmapData;
		}//end opponentImageLoadComplete()
		
		private function onUserIn(e:Event):void
		{
			DartsGlobals.addWarning("Multiplayer::onUserIn()");
			
			for each( var user:Object in DartsGlobals.instance.multiplayerClient.users )
			{
				if ( DartsGlobals.instance.multiplayerClient.account.id != user.id )
				{
					DartsGlobals.instance.opponentProfile = new UserProfile();
					DartsGlobals.instance.opponentProfile.name = user.name;
					DartsGlobals.instance.opponentProfile.unlockSkin("basicplaid", "heart");
					
					DartsGlobals.instance.opponentPlayer = new RemotePlayer(DartsGlobals.instance.opponentProfile);
					DartsGlobals.instance.opponentPlayer.portrait = ImageFactory.getBitmapDataByQualifiedName(AppSettings.instance.defaultMultiplayerPic, 150, 150);
					DartsGlobals.instance.opponentPlayer.setSkin(DartsGlobals.instance.opponentProfile.skins[0]);
					DartsGlobals.instance.opponentPlayer.playerNum = user.pid;
			
					DartsGlobals.instance.opponentPlayer.addAbilities(new ShieldAbility(10));
					DartsGlobals.instance.opponentPlayer.addAbilities(new BeeLineAbility(10));
					DartsGlobals.instance.opponentPlayer.addAbilities(new DoOverAbility(10));
					
					BoredServices.addEventListener(ObjectEvent.USER_INFO_READY_EVT, onOpponentProfile, false, 0, true);
					BoredServices.getUserProfileByName(user.name);
			
				}
			}
			
			this.finished();
		}//end onUserIn()
		
		private function finished():void
		{
			trace("Multiplayer::finished()");
			
			DartsGlobals.instance.multiplayerClient.removeEventListener(ChatClient.USER_IN, onUserIn);
			DartsGlobals.instance.multiplayerClient.removeEventListener(ChatClient.ROOM_JOIN, onRoomJoin);
			
			(this.stateMachine as GameFSM).transitionToStateNamed("MultiplayerGameConfirm");
		}
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			DartsGlobals.addWarning("Multiplayer::onExit()");
			
		}//end onExit()
		
	}//end class Multiplayer
	
}//end package com.bored.games.darts.states