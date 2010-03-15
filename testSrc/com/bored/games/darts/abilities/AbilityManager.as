package com.bored.games.darts.abilities 
{
	/**
	 * ...
	 * @author sam
	 */
	public class AbilityManager
	{
		private var _abilities:Vector.<Ability>;
		
		public function AbilityManager() 
		{
			_abilities = new Vector.<Ability>();
		}//end constructor()
		
		public function registerAbility(a_ability:Ability):void
		{
			_abilities.push(a_ability);
		}//end registerAbility()
		
		public function updateTurnTimers():void
		{
			for ( var i:int = 0; i < _abilities.length; i++ )
			{
				if(!_abilities[i].ready)
					_abilities[i].updateRefreshTimer();
			}
		}//end updateTurnTimers()
		
		public function activateAbility(a_ind:int):void
		{
			_abilities[i].engageAbility();
		}//end activateAbility()
		
		public function get abilities():Vector.<Ability>
		{
			return _abilities;
		}//end get abilities()
		
	}//end AbilityManager

}//end com.bored.games.darts.abilities