package com.bored.games.darts.logic 
{
	import com.bored.games.darts.objects.Board;
	import com.bored.games.darts.objects.Dart;
	/**
	 * ...
	 * @author sam
	 */
	public class DartsTurn
	{
		private var _gameManager:DartsGameLogic;
		private var _throwsRemaining:uint;
				
		private var _roundScore:Number;

		public function DartsTurn(a_gameManager:DartsGameLogic, a_maxThrows:uint = 3)
		{
			_gameManager = a_gameManager;
			_throwsRemaining = a_maxThrows;
			
			_roundScore = 0;
			_dartHistory = new Vector.<Dart>();
		}//end constructor()
		
		public function advanceThrows():Boolean
		{
			_throwsRemaining--;
		}//end advanceThrows()
		
		public function get throwsRemaining():int
		{
			return _throwsRemaining;
		}//end throwsRemaining()
		
	}//end DartsTurn

}//end com.bored.games.darts.logic