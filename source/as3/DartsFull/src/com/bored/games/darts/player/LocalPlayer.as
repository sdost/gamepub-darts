package com.bored.games.darts.player 
{
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.darts.profiles.Profile;
	
	/**
	 * ...
	 * @author sam
	 */
	public class LocalPlayer extends DartsPlayer
	{		
		public function LocalPlayer(a_profile:Profile = null) 
		{			
			super(a_profile ? a_profile.name : "Player");
			
			_localPlayer = true;
		}//end construtor()
		
		override public function takeTheShot(a_dartsRemaining:int):void
		{
			this._game.playerAim();
		}//end takeTheShot()
		
	}//end LocalPlayer

}//end com.bored.games.darts.player