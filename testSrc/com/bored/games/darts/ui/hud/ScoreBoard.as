package com.bored.games.darts.ui.hud 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AbstractScoreManager;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.CricketScoreManager;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
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
	public class ScoreBoard extends ContentHolder
	{
		private var _playerSlots:Object;
		private var _opponentSlots:Object;
		
		private var _scoreMgr:AbstractScoreManager;
		
		public function ScoreBoard(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
		{
			super(a_img, a_buildFromAllDescendants, a_bAddContents);
			
			if (this.stage)
			{
				addedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
			
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
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			this.contentsMC.alpha = 1;
			
			this.alpha = 0;
			
		}//end addedToStage()
		
		public function registerScoreManager(a_mgr:AbstractScoreManager):void
		{
			_scoreMgr = a_mgr;
		}//end registerScoreManager()
		
		public function update():void
		{
			var playerScores:Object = _scoreMgr.getPlayerStats(CricketGameLogic.PLAYER_ONE);
			
			(_playerSlots[20] as MovieClip).gotoAndStop(playerScores[20] + 1);
			(_playerSlots[19] as MovieClip).gotoAndStop(playerScores[19] + 1);
			(_playerSlots[18] as MovieClip).gotoAndStop(playerScores[18] + 1);
			(_playerSlots[17] as MovieClip).gotoAndStop(playerScores[17] + 1);
			(_playerSlots[16] as MovieClip).gotoAndStop(playerScores[16] + 1);
			(_playerSlots[15] as MovieClip).gotoAndStop(playerScores[15] + 1);
			(_playerSlots[25] as MovieClip).gotoAndStop(playerScores[25] + 1);
				
			var opponentScores:Object = _scoreMgr.getPlayerStats(CricketGameLogic.PLAYER_TWO);	

			(_opponentSlots[20] as MovieClip).gotoAndStop(opponentScores[20] + 1);
			(_opponentSlots[19] as MovieClip).gotoAndStop(opponentScores[19] + 1);
			(_opponentSlots[18] as MovieClip).gotoAndStop(opponentScores[18] + 1);
			(_opponentSlots[17] as MovieClip).gotoAndStop(opponentScores[17] + 1);
			(_opponentSlots[16] as MovieClip).gotoAndStop(opponentScores[16] + 1);
			(_opponentSlots[15] as MovieClip).gotoAndStop(opponentScores[15] + 1);
			(_opponentSlots[25] as MovieClip).gotoAndStop(opponentScores[25] + 1);				
		}//end update()
		
		public function show():void
		{
			Tweener.addTween(this, {alpha:1, time:2 } );
		}//end show()
		
		public function hide():void
		{
			Tweener.addTween(this, {alpha:0, time:2 } );
		}//end hide()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_playerSlots = null;
			_opponentSlots = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 