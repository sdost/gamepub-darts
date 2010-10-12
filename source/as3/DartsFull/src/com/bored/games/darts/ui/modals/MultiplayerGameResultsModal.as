package com.bored.games.darts.ui.modals 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.logic.RemoteCricketGameLogic;
	import com.bored.games.GameUtils;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.sven.utils.AppSettings;
	import com.sven.factories.SpriteFactory;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author sam
	 */
	public class MultiplayerGameResultsModal extends ContentHolder
	{
		private var _lobbyBtn:MightyButton;
		private var _lobbyBtnImg:MovieClip;
		
		private var _playerOneName:TextField;
		private var _playerOneResults:TextField;
		private var _playerOneStats:TextField;
		
		private var _playerTwoName:TextField;
		private var _playerTwoResults:TextField;
		private var _playerTwoStats:TextField;
		
		private var _matchTime:TextField;
		
		public function MultiplayerGameResultsModal() 
		{
			super(SpriteFactory.getSpriteByQualifiedName(AppSettings.instance.multiplayerResultsModalSprite), false, true);
			
			if (this.stage) {
				addedToStage();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
		}//end constructor()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}//end addedToStage()
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
		
			var lobbyBtnImg:MovieClip = descendantsDict["lobbyBtn_mc"] as MovieClip;
			if (lobbyBtnImg)
			{
				_lobbyBtn = new MightyButton(lobbyBtnImg, false);
				_lobbyBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onLobbyClicked, false, 0, true);
				_lobbyBtn.pause(false);
			}
		
			_playerOneName = descendantsDict["playerOneName_text"] as TextField;
			_playerOneResults = descendantsDict["playerOneResults_text"] as TextField;
			_playerOneStats = descendantsDict["playerOneStats_text"] as TextField;
			
			if (_playerOneName)
			{
				_playerOneName.text = DartsGlobals.instance.localPlayer.playerName;
			}
			
			if (_playerOneResults)
			{
				_playerOneResults.text = DartsGlobals.instance.localPlayer.record.wonGame() ? "Winner" : "Loser";
			}
			
			if (_playerOneStats)
			{
				_playerOneStats.text = // "Accuracy: " + Math.ceil(100 * DartsGlobals.instance.localPlayer.record.scoringThrows / DartsGlobals.instance.localPlayer.record.throws) + "%\n"
				/*+*/ "Doubles: " + DartsGlobals.instance.localPlayer.record.doubles + "\n" 
				+ "Triples: " + DartsGlobals.instance.localPlayer.record.triples;
			}
		
			_playerTwoName = descendantsDict["playerTwoName_text"] as TextField;
			_playerTwoResults = descendantsDict["playerTwoResults_text"] as TextField;
			_playerTwoStats = descendantsDict["playerTwoStats_text"] as TextField;
			
			if (_playerTwoName)
			{
				_playerTwoName.text = DartsGlobals.instance.opponentPlayer.playerName;
			}
			
			if (_playerTwoResults)
			{
				_playerTwoResults.text = DartsGlobals.instance.opponentPlayer.record.wonGame() ? "Winner" : "Loser";
			}
			
			if (_playerTwoStats)
			{
				_playerTwoStats.text = // "Accuracy: " + Math.ceil(100 * DartsGlobals.instance.opponentPlayer.record.scoringThrows / DartsGlobals.instance.opponentPlayer.record.throws) + "%\n"
				/*+*/ "Doubles: " + DartsGlobals.instance.opponentPlayer.record.doubles + "\n" 
				+ "Triples: " + DartsGlobals.instance.opponentPlayer.record.triples;
			}
		
			_matchTime = descendantsDict["matchTime_text"] as TextField;			
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function onLobbyClicked(e:Event):void
		{
			DartsGlobals.instance.processModalQueue();
			
			DartsGlobals.instance.gameManager.resetDarts();
			DartsGlobals.instance.gameManager.endTurn();
			
			DartsGlobals.instance.gameManager.pause(false);
			
			DartsGlobals.instance.gameManager.dispatchEvent(new Event(RemoteCricketGameLogic.RETURN_TO_LOBBY));
		}//end onLobbyClicked()
		
		private function formatTime(a_ms:int):String
		{
			var min:int = Math.floor((a_ms / 1000) / 60);
			var sec:int = Math.floor((a_ms - min * 60 * 1000) % 60);
			
			return min + ":" + ((sec < 10) ? "0" : "") + sec;
		}//end formatTime()
		
		public function init(a_object:Object):void
		{
			// TODO: maybe nothing here?
		}//end init()
		
		override public function destroy(...args):void
		{
			super.destroy();	
			
			_lobbyBtn = null;
					
			_playerOneName = null;
			_playerOneResults = null;
			_playerOneStats = null;
		
			_playerTwoName = null;
			_playerTwoResults = null;
			_playerTwoStats = null;
		
			_matchTime = null;
						
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
		}//end destroy()
		
	}//end MultiplayerGameResultsModal

}//end com.bored.games.darts.ui.modals