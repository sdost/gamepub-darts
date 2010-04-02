package com.bored.games.darts.player 
{
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.darts.profiles.UserProfile;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LocalPlayer extends DartsPlayer
	{
		public function LocalPlayer(a_profile:UserProfile) 
		{
			super(a_profile.name);
		}//end construtor()
		
		override public function takeTheShot():void
		{
			this._game.playerAim();
		}//end takeTheShot()
		
	}//end LocalPlayer

}//end com.bored.games.darts.player