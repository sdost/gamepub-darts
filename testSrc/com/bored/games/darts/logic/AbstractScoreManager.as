package com.bored.games.darts.logic 
{
	import com.bored.games.darts.player.DartsPlayer;
	/**
	 * ...
	 * @author sam
	 */
	public class AbstractScoreManager
	{				
		public function AbstractScoreManager() 
		{
			
		}//end constructor()
		
		public function initPlayerStats(a_playerNum:int):void
		{
			
		}//end initPlayerStats()
		
		public function submitThrow(a_playerNum:int, a_section:uint, a_multiplier:uint = 1):void
		{
			
		}//end submitThrowHit()
		
		public function revertLastThrow():void
		{
			
		}//end revertLastThrow()
		
		public function getPlayerStats(a_playerNum:int):Object
		{
			return null;
		}//end getPlayerStats()
		
		public function getPlayerScore(a_playerNum:int):Number
		{
			return 0;
		}//end getPlayerScore()
		
	}//end AbstractScoreManager

}//end com.bored.games.darts.logic