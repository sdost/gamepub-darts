package com.bored.games.darts.states 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.BeeLineAbility;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.abilities.ShieldAbility;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.RemoteCricketGameLogic;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartFlightHexagon;
	import com.bored.games.darts.models.dae_DartFlightModHex;
	import com.bored.games.darts.models.dae_DartFlightOval;
	import com.bored.games.darts.models.dae_DartFlightPincer;
	import com.bored.games.darts.models.dae_DartFlightThin;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.player.ComputerPlayer;
	import com.bored.games.darts.player.LocalPlayer;
	import com.bored.games.darts.player.RemotePlayer;
	import com.bored.games.darts.profiles.UserProfile;
	import com.bored.games.darts.skins.DartSkin;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.GameConfirmScreen;
	import com.bored.games.darts.ui.modals.OpponentQuitModal;
	import com.bored.games.darts.ui.MultiplayerGameConfirmScreen;
	import com.bored.services.BoredServices;
	import com.bored.services.client.ChatClient;
	import com.bored.services.client.GameClient;
	import com.bored.services.client.GameServices;
	import com.bored.services.client.TurnBasedGameClient;
	import com.bored.services.AbstractExternalService;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.jac.soundManager.SMSound;
	import com.sven.utils.AppSettings;
	import com.sven.factories.ImageFactory;
	import com.sven.factories.SpriteFactory;
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
	public class MultiplayerGameConfirm extends State
	{		
		private var _gameConfirmScreen:MultiplayerGameConfirmScreen;
		
		public function MultiplayerGameConfirm(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end MultiplayerGameConfirm() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			DartsGlobals.addWarning("MultiplayerGameConfirm::onEnter()");
			
			var gameConfirmScreenImg:Sprite;
			
			DartsGlobals.instance.setupControlPanel();
				DartsGlobals.instance.showControlPanel();
			
			try
			{
				trace("Confirm Screen Sprite Name: " + AppSettings.instance.multiplayerConfirmScreenSprite);
				
				gameConfirmScreenImg = SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.multiplayerConfirmScreenSprite);
				_gameConfirmScreen = new MultiplayerGameConfirmScreen(gameConfirmScreenImg, false, true);
				_gameConfirmScreen.addEventListener(GameConfirmScreen.PLAY_CLICKED_EVT, onPlay, false, 0, true);
				_gameConfirmScreen.addEventListener(GameConfirmScreen.BACK_CLICKED_EVT, onBack, false, 0, true);
				DartsGlobals.instance.screenSpace.addChild(_gameConfirmScreen);
				
				DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("store_sound", "button_getdarts_mp3") );
				DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("play_sound", "button_play_mp3") );
				DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").addSound( new SMSound("back_sound", "button_back_mp3") );
				
				DartsGlobals.instance.gameManager.addEventListener(RemoteCricketGameLogic.RETURN_TO_LOBBY, returnToLobby, false, 0, true);
				DartsGlobals.instance.multiplayerClient.addEventListener(ChatClient.LOBBY_ROOM, returnToLobby, false, 0, true);
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("MultiplayerGameConfirm::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
		
		public function onPlay(a_evt:Event):void
		{
			DartsGlobals.addWarning("MultiplayerGameConfirm::onPlay()");
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("play_sound");
			
			DartsGlobals.instance.localPlayer.setAbilitiesSlot(0, 0);
			DartsGlobals.instance.localPlayer.setAbilitiesSlot(1, 1);
			DartsGlobals.instance.localPlayer.setAbilitiesSlot(2, 2);
			
			DartsGlobals.instance.opponentPlayer.setAbilitiesSlot(0, 0);
			DartsGlobals.instance.opponentPlayer.setAbilitiesSlot(1, 1);
			DartsGlobals.instance.opponentPlayer.setAbilitiesSlot(2, 2);
			
			DartsGlobals.instance.gameManager.registerPlayer( DartsGlobals.instance.localPlayer );			
			
			if ( DartsGlobals.instance.multiplayerClient )
			{
				DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_START, onReady);
				DartsGlobals.instance.multiplayerClient.sendReady( { "skinid": DartsGlobals.instance.localPlayer.skin.skinid, "flightid":DartsGlobals.instance.localPlayer.skin.flightid } );
			}
			else
			{
				onReady();
			}
		}//end onPlay()
		
		private function returnToLobby(e:Event):void
		{
			DartsGlobals.addWarning("MultiplayerGameConfirm::returnToLobby()");
			
			DartsGlobals.instance.gameManager.removeEventListener(RemoteCricketGameLogic.RETURN_TO_LOBBY, returnToLobby);
			DartsGlobals.instance.multiplayerClient.removeEventListener(ChatClient.LOBBY_ROOM, returnToLobby);
			
			BoredServices.hideChatUI();
			
			(this.stateMachine as GameFSM).transitionToStateNamed("Multiplayer");
		}//end returnToLobby()
		
		private function onReady(a_evt:Event = null):void
		{
			DartsGlobals.addWarning("MultiplayerGameConfirm::onReady()");

			DartsGlobals.instance.gameManager.removeEventListener(RemoteCricketGameLogic.RETURN_TO_LOBBY, returnToLobby);
			DartsGlobals.instance.multiplayerClient.removeEventListener(ChatClient.LOBBY_ROOM, returnToLobby);
			
			if( a_evt ) {
				var obj:Object = DartsGlobals.instance.multiplayerClient.getData(GameClient.GAME_START);
				
				if( obj ) {
					var flightXML:XML = null;
					
					switch( obj["playerSkin"+DartsGlobals.instance.opponentPlayer.playerNum].flightid )
					{
						case "heart":
							flightXML = dae_DartFlightHeart.data;
							break;
						case "hex":
							flightXML = dae_DartFlightHexagon.data;
							break;
						case "modhex":
							flightXML = dae_DartFlightModHex.data;
							break;
						case "oval":
							flightXML = dae_DartFlightOval.data;
							break;
						case "pincer":
							flightXML = dae_DartFlightPincer.data;
							break;
						case "thin":
							flightXML = dae_DartFlightThin.data;
							break;
						default:
							break;
					}
					
					var skin:DartSkin = new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_" + obj["playerSkin"+DartsGlobals.instance.opponentPlayer.playerNum].skinid, AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, flightXML );
					skin.skinid = obj["playerSkin"+DartsGlobals.instance.opponentPlayer.playerNum].skinid;
					skin.flightid = obj["playerSkin"+DartsGlobals.instance.opponentPlayer.playerNum].flightid;
					
					DartsGlobals.instance.opponentPlayer.setSkin(skin);
				}
			}
			
			DartsGlobals.instance.gameManager.registerPlayer( DartsGlobals.instance.opponentPlayer );		
			
			(this.stateMachine as GameFSM).transitionToStateNamed("Gameplay");
			
		}//end onReady()
		
		private function onBack(a_evt:Event):void
		{
			DartsGlobals.addWarning("MultiplayerGameConfirm::onBack()");
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("buttonSoundController").play("back_sound");
			
			DartsGlobals.instance.gameManager.removeEventListener(RemoteCricketGameLogic.RETURN_TO_LOBBY, returnToLobby);
			DartsGlobals.instance.multiplayerClient.removeEventListener(ChatClient.LOBBY_ROOM, returnToLobby);
			
			BoredServices.hideChatUI();
			
			(this.stateMachine as GameFSM).transitionToStateNamed("Multiplayer");
		}//end onBack()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{
			DartsGlobals.addWarning("MultiplayerGameConfirm::onExit()");
			
			_gameConfirmScreen.removeEventListener(GameConfirmScreen.BACK_CLICKED_EVT, onBack);
			_gameConfirmScreen.removeEventListener(GameConfirmScreen.PLAY_CLICKED_EVT, onPlay);
			
			_gameConfirmScreen.destroy();
			
			_gameConfirmScreen = null;
			
		}//end onExit()
		
	}//end class Initialization
	
}//end package com.bored.games.darts.states