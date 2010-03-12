package com.bored.games.darts.ui.hud 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AbstractScoreManager;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.CricketScoreManager;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.objects.Board;
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
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = false):Dictionary
		{
			var slot:Object;
			
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			_playerSlots = { };
			
			_playerSlots[Board.TWENTY] = descendantsDict["player_twenty"] as MovieClip;
			_playerSlots[Board.NINETEEN] = descendantsDict["player_nineteen"] as MovieClip;
			_playerSlots[Board.EIGHTEEN] = descendantsDict["player_eighteen"] as MovieClip;
			_playerSlots[Board.SEVENTEEN] = descendantsDict["player_seventeen"] as MovieClip;
			_playerSlots[Board.SIXTEEN] = descendantsDict["player_sixteen"] as MovieClip;
			_playerSlots[Board.FIFTEEN] = descendantsDict["player_fifteen"] as MovieClip;
			_playerSlots[Board.BULL] = descendantsDict["player_bull"] as MovieClip;
			
			for each( slot in _playerSlots )
			{
				if ( slot )
				{
					(slot as MovieClip).gotoAndStop(1);
				}
			}
			
			_opponentSlots = { };
			
			_opponentSlots[Board.TWENTY] = descendantsDict["opponent_twenty"] as MovieClip;
			_opponentSlots[Board.NINETEEN] = descendantsDict["opponent_nineteen"] as MovieClip;
			_opponentSlots[Board.EIGHTEEN] = descendantsDict["opponent_eighteen"] as MovieClip;
			_opponentSlots[Board.SEVENTEEN] = descendantsDict["opponent_seventeen"] as MovieClip;
			_opponentSlots[Board.SIXTEEN] = descendantsDict["opponent_sixteen"] as MovieClip;
			_opponentSlots[Board.FIFTEEN] = descendantsDict["opponent_fifteen"] as MovieClip;
			_opponentSlots[Board.BULL] = descendantsDict["opponent_bull"] as MovieClip;
			
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
			
			(_playerSlots[Board.TWENTY] as MovieClip).gotoAndStop(playerScores[Board.TWENTY] + 1);
			(_playerSlots[Board.NINETEEN] as MovieClip).gotoAndStop(playerScores[Board.NINETEEN] + 1);
			(_playerSlots[Board.EIGHTEEN] as MovieClip).gotoAndStop(playerScores[Board.EIGHTEEN] + 1);
			(_playerSlots[Board.SEVENTEEN] as MovieClip).gotoAndStop(playerScores[Board.SEVENTEEN] + 1);
			(_playerSlots[Board.SIXTEEN] as MovieClip).gotoAndStop(playerScores[Board.SIXTEEN] + 1);
			(_playerSlots[Board.FIFTEEN] as MovieClip).gotoAndStop(playerScores[Board.FIFTEEN] + 1);
			(_playerSlots[Board.BULL] as MovieClip).gotoAndStop(playerScores[Board.BULL] + 1);
				
			var opponentScores:Object = _scoreMgr.getPlayerStats(CricketGameLogic.PLAYER_TWO);	

			(_opponentSlots[Board.TWENTY] as MovieClip).gotoAndStop(opponentScores[Board.TWENTY] + 1);
			(_opponentSlots[Board.NINETEEN] as MovieClip).gotoAndStop(opponentScores[Board.NINETEEN] + 1);
			(_opponentSlots[Board.EIGHTEEN] as MovieClip).gotoAndStop(opponentScores[Board.EIGHTEEN] + 1);
			(_opponentSlots[Board.SEVENTEEN] as MovieClip).gotoAndStop(opponentScores[Board.SEVENTEEN] + 1);
			(_opponentSlots[Board.SIXTEEN] as MovieClip).gotoAndStop(opponentScores[Board.SIXTEEN] + 1);
			(_opponentSlots[Board.FIFTEEN] as MovieClip).gotoAndStop(opponentScores[Board.FIFTEEN] + 1);
			(_opponentSlots[Board.BULL] as MovieClip).gotoAndStop(opponentScores[Board.BULL] + 1);				
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