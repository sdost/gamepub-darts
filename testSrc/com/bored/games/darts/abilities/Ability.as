package com.bored.games.darts.abilities 
{
	/**
	 * ...
	 * @author sam
	 */
	public class Ability
	{
		private var _ready:Boolean;
		private var _turnsToRefresh:int;
		private var _updateTurns:int;
		
		public function Ability(a_time:int = 0) 
		{
			_ready = true;
			
			_turnsToRefresh = 0;
			_updateTurns = 0;
		}//end constructor()
		
		public function engageAbility():void
		{
			_ready = false;
			_turnsToRefresh = _updateTurns;
		}//end engageAbility()
		
		public function updateRefreshTimer():void
		{
			_turnsToRefresh--;
			if (_turnsToRefresh == 0)
			{
				_ready = true;
			}
		}//end updateRefreshTimer()
		
		public function get ready():Boolean
		{
			return _ready;
		}//end ready()
			
	}//end Ability

}//end com.bored.games.darts.abilities