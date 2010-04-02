﻿package com.bored.games.darts.player 
{
	import com.bored.games.darts.player.DartsPlayer;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LocalPlayer extends DartsPlayer
	{
		public function LocalPlayer(a_name:String = "Local Player") 
		{
			super(a_name);
		}//end construtor()
		
		override public function takeTheShot():void
		{
			this._game.playerAim();
		}//end takeTheShot()
		
	}//end LocalPlayer

}//end com.bored.games.darts.player