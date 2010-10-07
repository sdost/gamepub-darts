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
	public class CricketScoreBoard extends ScoreBoard
	{
		private var _playerSlots:Object;
		private var _opponentSlots:Object;
		
		public function CricketScoreBoard(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
		{
			super(a_img, a_buildFromAllDescendants, a_bAddContents);
			
		}//end GameReadyPopup() constructor.
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var slot:Object;
			
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			_playerSlots = { };
			
			_playerSlots[20] = descendantsDict["player_twenty"] as MovieClip;
			_playerSlots[19] = descendantsDict["player_nineteen"] as MovieClip;
			_playerSlots[18] = descendantsDict["player_eighteen"] as MovieClip;
			_playerSlots[17] = descendantsDict["player_seventeen"] as MovieClip;
			_playerSlots[16] = descendantsDict["player_sixteen"] as MovieClip;
			_playerSlots[15] = descendantsDict["player_fifteen"] as MovieClip;
			_playerSlots[25] = descendantsDict["player_bull"] as MovieClip;
			
			for each( slot in _playerSlots )
			{
				if ( slot )
				{
					(slot as MovieClip).gotoAndStop(1);
				}
			}
			
			_opponentSlots = { };
			
			_opponentSlots[20] = descendantsDict["opponent_twenty"] as MovieClip;
			_opponentSlots[19] = descendantsDict["opponent_nineteen"] as MovieClip;
			_opponentSlots[18] = descendantsDict["opponent_eighteen"] as MovieClip;
			_opponentSlots[17] = descendantsDict["opponent_seventeen"] as MovieClip;
			_opponentSlots[16] = descendantsDict["opponent_sixteen"] as MovieClip;
			_opponentSlots[15] = descendantsDict["opponent_fifteen"] as MovieClip;
			_opponentSlots[25] = descendantsDict["opponent_bull"] as MovieClip;
			
			for each( slot in _opponentSlots )
			{
				if ( slot )
				{
					(slot as MovieClip).gotoAndStop(1);
				}
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		override public function update():void
		{
			var playerScores:Object = _scoreMgr.getPlayerStats(DartsGlobals.instance.localPlayer.playerNum);
			
			(_playerSlots[20] as MovieClip).gotoAndStop(playerScores[20]+1);
			(_playerSlots[19] as MovieClip).gotoAndStop(playerScores[19]+1);
			(_playerSlots[18] as MovieClip).gotoAndStop(playerScores[18]+1);
			(_playerSlots[17] as MovieClip).gotoAndStop(playerScores[17]+1);
			(_playerSlots[16] as MovieClip).gotoAndStop(playerScores[16]+1);
			(_playerSlots[15] as MovieClip).gotoAndStop(playerScores[15]+1);
			(_playerSlots[25] as MovieClip).gotoAndStop(playerScores[25]+1);
				
			var opponentScores:Object = _scoreMgr.getPlayerStats(DartsGlobals.instance.opponentPlayer.playerNum);	

			(_opponentSlots[20] as MovieClip).gotoAndStop(opponentScores[20]+1);
			(_opponentSlots[19] as MovieClip).gotoAndStop(opponentScores[19]+1);
			(_opponentSlots[18] as MovieClip).gotoAndStop(opponentScores[18]+1);
			(_opponentSlots[17] as MovieClip).gotoAndStop(opponentScores[17]+1);
			(_opponentSlots[16] as MovieClip).gotoAndStop(opponentScores[16]+1);
			(_opponentSlots[15] as MovieClip).gotoAndStop(opponentScores[15]+1);
			(_opponentSlots[25] as MovieClip).gotoAndStop(opponentScores[25] + 1);	
			
			super.update();
		}//end update()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			_playerSlots = null;
			_opponentSlots = null;			
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 