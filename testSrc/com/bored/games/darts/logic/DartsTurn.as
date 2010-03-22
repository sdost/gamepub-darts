package com.bored.games.darts.logic 
{
	/**
	 * ...
	 * @author sam
	 */
	public class DartsTurn
	{
		private var _gameManager:DartsGameLogic;
		private var _maxThrows:uint;
		private var _throwsRemaining:uint;
				
		private var _roundScore:Number;

		public function DartsTurn(a_gameManager:DartsGameLogic, a_maxThrows:uint = 3)
		{
			_gameManager = a_gameManager;
			_maxThrows =_throwsRemaining = a_maxThrows;
			
			_roundScore = 0;
		}//end constructor()
		
		public function advanceThrows():int
		{
			return _maxThrows - (--_throwsRemaining);
		}//end advanceThrows()
		
		public function redoThrow():void
		{
			_throwsRemaining++;
			
			if (_throwsRemaining > _maxThrows) _throwsRemaining = _maxThrows;
		}//end redoThrow()
		
		public function get throwsRemaining():int
		{
			return _throwsRemaining;
		}//end throwsRemaining()
		
	}//end DartsTurn

}//end com.bored.games.darts.logic