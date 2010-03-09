package com.bored.games.darts.logic 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author sam
	 */
	public class DartsGameLogic
	{		
		protected var _currentTurn:DartsTurn;
		protected var _scoreManager:AbstractScoreManager;
		
		protected var _dartboardClip:MovieClip;
		
		public function DartsGameLogic() 
		{
			_scoreManager = new AbstractScoreManager();
		}//end constructor()
		
		public function set dartboardClip(a_clip:MovieClip):void
		{
			_dartboardClip = a_clip;
		}//end set dartboardClip()
		
		public function get dartboardClip():MovieClip
		{
			return _dartboardClip;
		}//end dartboardClip()
		
		public function getDartboardClip(a_points:int, a_multiple:int):MovieClip
		{
			return _dartboardClip["c_" + a_points + "_" + a_multiple + "_mc"];
		}//end getDartboardClip()
		
		public function get gameType():String
		{
			
		}//end get gameType()
		
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