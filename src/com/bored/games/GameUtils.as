package com.bored.games 
{
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameUtils
	{
		private static var _playStart:Number;
		private static var _score:Number;
		private static var _playTime:Number;
				
		public static function newGame():void
		{
			_playStart = getTimer();
		}//end newGame()
		
		public static function endGame():void
		{
			_playTime = getTimer() - _playStart;
		}//end endGame()
		
	}//end Game

}//end com.bored.games