﻿package com.bored.games.darts.logic 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.ui.modals.TurnAnnounceModal;
	import flash.sampler.NewObjectSample;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class FiveOhOneGameLogic extends DartsGameLogic
	{	
		
		public static const HUMAN_PLAYER:int = 1;
		public static const CPU_PLAYER:int = 2;	
		
		public function FiveOhOneGameLogic() 
		{
			_scoreManager = new FiveOhOneScoreManager();
		}//end constructor()
		
		override public function get gameType():String
		{
			return "501";
		}//end get gameType()
		
		override public function nextPlayer():void
		{
			_currentPlayer++;
			
			if (_currentPlayer > CPU_PLAYER) _currentPlayer = HUMAN_PLAYER;
			
			DartsGlobals.instance.showModalPopup(TurnAnnounceModal);
		}//end nextPlayer()
		
		override protected function checkForWin():Boolean
		{
			var score:int = this.scoreManager.getPlayerScore(_currentPlayer);
					
			var win:Boolean = true;
						
			if ( score < 501 ) 
			{
				win = false;
			}
			
			return win;
					
		}//end checkForWin()
		
		override public function endGame(a_winner:int):void
		{
			super.endGame(a_winner);
			
			if ( a_winner == DartsGlobals.instance.localPlayer.playerNum ) 
			{
				var cash:int = DartsGlobals.instance.externalServices.getData("gameCash");
				cash += (DartsGlobals.instance.opponentProfile as EnemyProfile).prize;
				DartsGlobals.instance.externalServices.setData("gameCash", cash);
				DartsGlobals.instance.externalServices.pushUserData();
			}
		}//end endGame()
		
	}//end FiveOhOneGameLogic

}//end com.bored.games.darts.logic