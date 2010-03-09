package com.bored.games.darts.player 
{
	import com.bored.games.darts.player.DartsPlayer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LocalPlayer extends DartsPlayer
	{
		
		public function LocalPlayer() 
		{
			super();
		}//end construtor()
		
		override public function takeTheShot(a_dartsLeft:int)
		{
			this._game.playerAim();
		}//end takeTheShot()
		
	}//end LocalPlayer

}//end com.bored.games.darts.player