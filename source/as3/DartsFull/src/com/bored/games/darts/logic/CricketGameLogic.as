package com.bored.games.darts.logic 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.ui.modals.TurnAnnounceModal;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CricketGameLogic extends DartsGameLogic
	{	
		
		public static const HUMAN_PLAYER:int = 1;
		public static const CPU_PLAYER:int = 2;	
		
		public function CricketGameLogic() 
		{
			_scoreManager = new CricketScoreManager();
		}//end constructor()
		
		override public function get gameType():String
		{
			return "CRICKET";
		}//end get gameType()
		
		override public function nextPlayer():void
		{
			_currentPlayer++;
			
			if (_currentPlayer > CPU_PLAYER) _currentPlayer = HUMAN_PLAYER;
			
			DartsGlobals.instance.showModalPopup(TurnAnnounceModal);
		}//end nextPlayer()
		
		override protected function checkForWin():Boolean
		{
			var stats:Object = this.scoreManager.getPlayerStats(_currentPlayer);
					
			var win:Boolean = true;
			
			for ( var i:int = 15; i <= 20; i++ ) {
				if ( stats[i] < 3 ) win = false;
			}
			if ( stats[25] < 3 ) win = false;
			
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
			}
		}//end endGame()
		
	}//end CricketGameLogic

}//end com.bored.games.darts.logic