package com.bored.games.darts.statistics 
{
	/**
	 * ...
	 * @author sam
	 */
	public class GameRecord
	{
		private var _throws:int;
		private var _doubles:int;
		private var _triples:int;
		private var _win:Boolean;
		
		public function GameRecord() 
		{
			_throws = 0;
			_doubles = 0;
			_triples = 0;
			_win = false;
		}//end constructor()
		
		public function recordThrow(a_points:int, a_multiplier:int):void
		{
			_throws++;
			
			if (a_multiplier == 2) _doubles++;
			else if (a_multiplier == 3) _triples++;
		}//end logThrow()
		
		public function recordEndOfGame( a_win:Boolean ):void
		{
			_win = a_win;
		}//end recordEndOfGame()
		
		public function get throws():int
		{
			return _throws;
		}//end get throws()
		
		public function get doubles():int
		{
			return _doubles;
		}//end get doubles()
		
		public function get triples():int
		{
			return _triples;
		}//end get triples()
		
		public function wonGame():Boolean
		{
			return _win;
		}//end wonGame()
		
	}//end GameRecord

}//end com.bored.games.darts.statistics