package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.player.DartsPlayer;
	/**
	 * ...
	 * @author sam
	 */
	public class Ability
	{		
		private var _armed:Boolean;
		
		private var _player:DartsPlayer;
		private var _refreshTime:int;
		
		public function Ability(a_time:int) 
		{
			_refreshTime = a_time;
			_armed = true;
		}//end constructor()
		
		public function set owner(a_player:DartsPlayer):void
		{
			_player = a_player;
		}//end set owner()
		
		public function get owner():DartsPlayer
		{
			return _player;
		}//end get owner()
		
		public function get ready():Boolean
		{
			return _armed;
		}//end get ready()
		
		public function armAbility():void
		{
			_armed = true;
		}//end armAbility()
		
		public function useAbility():int
		{
			_armed = false;
			
			// TODO: activate...
			
			return _refreshTime;
		}//end useAbility()
		
	}//end Ability

}//end com.bored.games.darts.abilities