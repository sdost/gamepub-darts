package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.objects.ShieldDart;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ShieldAbility extends Ability
	{
		public function ShieldAbility(a_time:int) 
		{
			super(a_time);
		}//end constructor()
		
		override public function useAbility():int
		{						
			return super.useAbility();
		}//end useAbility()
		
	}//end ShieldAbility

}//end com.bored.games.darts.abilities