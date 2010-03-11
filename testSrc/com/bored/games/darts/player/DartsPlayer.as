﻿package com.bored.games.darts.player 
{
	import com.bored.games.darts.logic.DartsGameLogic;
	/**
	 * ...
	 * @author sam
	 */
	public dynamic class DartsPlayer
	{		
		protected var _game:DartsGameLogic;
		protected var _name:String;
		
		public function DartsPlayer(a_name:String = "") 
		{
			_name = a_name;
		}
		
		public function set dartGame(a_game:DartsGameLogic):void
		{
			_game = a_game;
		}//end set dartGame()
		
		public function set playerName(a_name:String):void
		{
			_name = a_name;
		}//end set playerName()
		
		public function get playerName():String
		{
			return _name;
		}//end get playerName()
		
		public function takeTheShot():void
		{
			
		}//end takeTheShot()
		
	}//end DartsPlayer

}//com.bored.game.darts.player