package com.bored.games.darts.player 
{
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.darts.profiles.Profile;
	
	/**
	 * ...
	 * @author sam
	 */
	public class RemotePlayer extends DartsPlayer
	{
		public function RemotePlayer(a_profile:Profile = null) 
		{
			super(a_profile ? a_profile.name : "Player");
		}//end construtor()
		
		override public function takeTheShot(a_dartsRemaining:int):void
		{
			this._game.playerAim();
		}//end takeTheShot()
		
	}//end RemotePlayer

}//end com.bored.games.darts.player