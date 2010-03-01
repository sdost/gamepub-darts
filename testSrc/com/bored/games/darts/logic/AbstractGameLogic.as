package com.bored.games.darts.logic 
{
	/**
	 * ...
	 * @author sam
	 */
	public class AbstractGameLogic
	{
		public static const PLAYER_TURN:String = "player";
		public static const OPPONENT_TURN:String = "opponent";	
		
		protected var _currentTurn:DartsTurn;
		protected var _scoreManager:AbstractScoreManager;
		
		public function AbstractGameLogic() 
		{
			_scoreManager = new AbstractScoreManager();
		}//end constructor()
		
		public function get scoreManager():AbstractScoreManager
		{
			return _scoreManager;
		}// end get scoreManager()
		
		public function startNewTurn(a_name:String):DartsTurn
		{
			trace( a_name + "'s Turn...");
			
			_currentTurn = new DartsTurn(this, a_name);
			return _currentTurn;
		}//end startNewTurn()
		
		public function checkForWinState():Boolean
		{
			return false;
		}//end checkForWinState()
		
	}//end AbstractGameLogic

}//end com.bored.games.darts.logic