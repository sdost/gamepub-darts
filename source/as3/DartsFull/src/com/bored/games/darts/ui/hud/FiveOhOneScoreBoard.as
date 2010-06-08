package com.bored.games.darts.ui.hud 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AbstractScoreManager;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.CricketScoreManager;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class FiveOhOneScoreBoard extends ScoreBoard
	{	
		private var _playerList:Object;
		private var _opponentList:Object;
		
		private var _playerTotal:TextField;
		private var _opponentTotal:TextField;
		
		public function FiveOhOneScoreBoard(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
		{
			super(a_img, a_buildFromAllDescendants, a_bAddContents);
			
		}//end GameReadyPopup() constructor.
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var slot:Object;
			
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			_playerList = { };
			
			_playerList[1] = descendantsDict["playerLineOne_text"] as TextField;
			_playerList[2] = descendantsDict["playerLineTwo_text"] as TextField;
			_playerList[3] = descendantsDict["playerLineThree_text"] as TextField;
			_playerList[4] = descendantsDict["playerLineFour_text"] as TextField;
			_playerList[5] = descendantsDict["playerLineFive_text"] as TextField;
			_playerList[6] = descendantsDict["playerLineSix_text"] as TextField;
			
			for each( slot in _playerList )
			{
				if ( slot )
				{
					(slot as TextField).text = "";
				}
			}
			
			_playerTotal = descendantsDict["playerTotal_text"] as TextField;
			
			_opponentList = { };
			
			_opponentList[1] = descendantsDict["opponentLineOne_text"] as TextField;
			_opponentList[2] = descendantsDict["opponentLineTwo_text"] as TextField;
			_opponentList[3] = descendantsDict["opponentLineThree_text"] as TextField;
			_opponentList[4] = descendantsDict["opponentLineFour_text"] as TextField;
			_opponentList[5] = descendantsDict["opponentLineFive_text"] as TextField;
			_opponentList[6] = descendantsDict["opponentLineSix_text"] as TextField;
			
			for each( slot in _opponentList )
			{
				if ( slot )
				{
					(slot as TextField).text = "";
				}
			}
			
			_opponentTotal = descendantsDict["opponentTotal_text"] as TextField;
			
			return descendantsDict;
			
		}//end buildFrom()
		
		override public function update():void
		{
			var i:int;
			var score:int;
			
			var playerScores:Array = _scoreMgr.getPlayerStats(DartsGlobals.instance.localPlayer.playerNum) as Array;
			
			i = (playerScores.length - 6) >= 0 ? (playerScores.length - 6) : 0;
			score = 1;
			for ( ; i < playerScores.length; i++ ) 
			{
				(_playerList[score++] as TextField).text = playerScores[i];
			}
			
			_playerTotal.text = _scoreMgr.getPlayerScore(DartsGlobals.instance.localPlayer.playerNum).toString();
				
			var opponentScores:Array = _scoreMgr.getPlayerStats(DartsGlobals.instance.opponentPlayer.playerNum) as Array;
			
			i = (opponentScores.length - 6) >= 0 ? (opponentScores.length - 6) : 0;
			score = 1;
			for ( ; i < opponentScores.length; i++ ) 
			{
				(_opponentList[score++] as TextField).text = opponentScores[i];
			}
			
			_opponentTotal.text = _scoreMgr.getPlayerScore(DartsGlobals.instance.opponentPlayer.playerNum).toString();
		}//end update()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			_playerList = null;
			_opponentList = null;
			
			_playerTotal = null;
			_opponentTotal = null;
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 