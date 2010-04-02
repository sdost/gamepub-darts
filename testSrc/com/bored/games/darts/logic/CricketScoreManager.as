﻿package com.bored.games.darts.logic 
{
	import com.bored.games.darts.logic.AbstractScoreManager;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class CricketScoreManager extends AbstractScoreManager
	{		
		public static const EMPTY:uint 			= 0
		public static const STROKE_LEFT:uint 	= 1;
		public static const STROKE_RIGHT:uint 	= 2;
		public static const CLOSED_OUT:uint 	= 3;
		
		private var _previousScoreboard:Object;
		private var _scoreboard:Object;
		
		public function CricketScoreManager() 
		{
			_scoreboard = new Object();
			_previousScoreboard = new Object();
		}//end constructor()
		
		override public function initPlayerStats(a_playerNum:int):void
		{
			_scoreboard[a_playerNum] = new Object();
			_scoreboard[a_playerNum][15] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][16] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][17] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][18] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][19] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][20] = CricketScoreManager.EMPTY;
			_scoreboard[a_playerNum][25] = CricketScoreManager.EMPTY;
			
			_previousScoreboard[a_playerNum] = new Object();
			_previousScoreboard[a_playerNum][15] = CricketScoreManager.EMPTY;
			_previousScoreboard[a_playerNum][16] = CricketScoreManager.EMPTY;
			_previousScoreboard[a_playerNum][17] = CricketScoreManager.EMPTY;
			_previousScoreboard[a_playerNum][18] = CricketScoreManager.EMPTY;
			_previousScoreboard[a_playerNum][19] = CricketScoreManager.EMPTY;
			_previousScoreboard[a_playerNum][20] = CricketScoreManager.EMPTY;
			_previousScoreboard[a_playerNum][25] = CricketScoreManager.EMPTY;			
		}//end initPlayerStats()
		
		override public function submitThrow(a_playerNum:int, a_section:uint, a_multiplier:uint = 1):void
		{
			copyScoreboard(_scoreboard, _previousScoreboard);
			
			if (a_section < 15) return;
			
			var score:uint = _scoreboard[a_playerNum][a_section];
			
			if ( score < CLOSED_OUT ) 
			{
				score += a_multiplier;
				if (score > CLOSED_OUT) score = CLOSED_OUT;
				
				_scoreboard[a_playerNum][a_section] = score;
			}
		}//end submitThrow()
		
		override public function revertLastThrow():void
		{
			copyScoreboard(_previousScoreboard, _scoreboard);
		}//end revertLastThrow()
		
		private function copyScoreboard(a_source:Object, a_dest:Object):void
		{
			for( var player:String in a_source ) {
				a_dest[player][15] = a_source[player][15];
				a_dest[player][16] = a_source[player][16];
				a_dest[player][17] = a_source[player][17];
				a_dest[player][18] = a_source[player][18];
				a_dest[player][19] = a_source[player][19];
				a_dest[player][20] = a_source[player][20];
				a_dest[player][25] = a_source[player][25];
			}
		}//end copyScoreboard()
		
		override public function getPlayerStats(a_playerNum:int):Object
		{
			return _scoreboard[a_playerNum];
		}//end getPlayerStats();
		
		override public function getPlayerScore(a_playerNum:int):Number
		{
			var score:Number = 0;
			for ( var key:String in _scoreboard[a_playerNum] ) {
				score += Number(key) * _scoreboard[a_playerNum][key];				
			}
			
			return score;
		}//end getPlayerScore()
		
		override public function clearScoreBoard():void
		{
			var player:String = null;
			
			for( player in _scoreboard ) {
				_scoreboard[player][15] = CricketScoreManager.EMPTY;
				_scoreboard[player][16] = CricketScoreManager.EMPTY;
				_scoreboard[player][17] = CricketScoreManager.EMPTY;
				_scoreboard[player][18] = CricketScoreManager.EMPTY;
				_scoreboard[player][19] = CricketScoreManager.EMPTY;
				_scoreboard[player][20] = CricketScoreManager.EMPTY;
				_scoreboard[player][25] = CricketScoreManager.EMPTY;
			}
			
			for( player in _previousScoreboard ) {			
				_previousScoreboard[player][15] = CricketScoreManager.EMPTY;
				_previousScoreboard[player][16] = CricketScoreManager.EMPTY;
				_previousScoreboard[player][17] = CricketScoreManager.EMPTY;
				_previousScoreboard[player][18] = CricketScoreManager.EMPTY;
				_previousScoreboard[player][19] = CricketScoreManager.EMPTY;
				_previousScoreboard[player][20] = CricketScoreManager.EMPTY;
				_previousScoreboard[player][25] = CricketScoreManager.EMPTY;
			}
		}//end clearScoreBoard()
		
	}//end CricketScoreManager()

}//end com.bored.games.darts.logic