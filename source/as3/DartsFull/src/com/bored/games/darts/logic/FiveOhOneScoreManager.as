package com.bored.games.darts.logic 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AbstractScoreManager;
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundController;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class FiveOhOneScoreManager extends AbstractScoreManager
	{		
		private static var FIVE_OH_ONE:int = 501;
		
		private var _scoreboard:Object;
		
		private var _soundController:SoundController;
		
		private var _lastTurn:DartsTurn;
		private var _newTurn:Boolean;
		
		public function FiveOhOneScoreManager() 
		{
			_scoreboard = new Object();
		}//end constructor()
		
		override public function initPlayerStats(a_playerNum:int):void
		{
			_scoreboard[a_playerNum] = new Array();
		}//end initPlayerStats()
		
		override public function submitThrow(a_playerNum:int, a_section:uint, a_multiplier:uint = 1):Boolean
		{
			if ( _lastTurn && _lastTurn == DartsGlobals.instance.gameManager.currentTurn ) 
			{
				_newTurn = false;
			}
			else
			{
				_lastTurn = DartsGlobals.instance.gameManager.currentTurn;
				_newTurn = true;
			}
			
			var scoreList:Array = _scoreboard[a_playerNum];
			
			var score:int = 0;
			
			for each ( var s:int in scoreList )
			{
				score += s;
			}
			
			var temp:int = score + (a_section * a_multiplier);
			
			if ( temp < FIVE_OH_ONE ) 
			{
				DartsGlobals.addWarning("FiveOhOneScoreManager::submitThrow() -- scoring throw: " + temp);
				
				if ( _newTurn ) {
					scoreList.push(a_section * a_multiplier);
				} else {
					scoreList[scoreList.length-1] += (a_section * a_multiplier);
				}
				_scoreboard[a_playerNum] = scoreList;
				
				return true;
			}
			else if ( temp == FIVE_OH_ONE )
			{
				DartsGlobals.addWarning("FiveOhOneScoreManager::submitThrow() -- winning throw?: " + temp);
				
				if ( a_section > 1 && a_multiplier == 2 ) 
				{
					if ( _newTurn ) {
						scoreList.push(a_section * a_multiplier);
					} else {
						scoreList[scoreList.length-1] += (a_section * a_multiplier);
					}
					_scoreboard[a_playerNum] = scoreList;
					
					return true;
				}
				else if ( a_section == 1 && a_multiplier == 1 )
				{
					if ( _newTurn ) {
						scoreList.push(a_section * a_multiplier);
					} else {
						scoreList[scoreList.length-1] += (a_section * a_multiplier);
					}
					_scoreboard[a_playerNum] = scoreList;
					
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				DartsGlobals.addWarning("FiveOhOneScoreManager::submitThrow() -- busting throw: " + temp);
				
				return false;
			}
		}//end submitThrow()
		
		override public function revertLastThrow():void
		{
			//copyScoreboard(_previousScoreboard, _scoreboard);
		}//end revertLastThrow()
		
		private function copyScoreboard(a_source:Object, a_dest:Object):void
		{
		}//end copyScoreboard()
		
		override public function getPlayerStats(a_playerNum:int):Object
		{
			//DartsGlobals.addWarning("FiveOhOneScoreManager::getPlayerStats(" + a_playerNum + ") -- _scorboard[" + a_playerNum + "] = " + _scoreboard[a_playerNum]);
			
			return _scoreboard[a_playerNum];
		}//end getPlayerStats();
		
		override public function getAllPlayerStats():Object
		{
			return _scoreboard;
		}//end getAllPlayerStats();
		
		override public function getPlayerScore(a_playerNum:int):Number
		{
			var score:Number = 0;
			for each ( var s:int in _scoreboard[a_playerNum] ) {
				score += s;				
			}
			
			return score;
		}//end getPlayerScore()
		
		override public function setScores(a_scores:Object):void
		{			
			for ( var player:String in a_scores ) 
			{
				_scoreboard[player] = a_scores[player];
			}
		}
		
		override public function clearScoreBoard():void
		{
		}//end clearScoreBoard()
		
	}//end FiveOhOneScoreManager()

}//end com.bored.games.darts.logic