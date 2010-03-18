package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.objects.BeeLineDart;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BeeLineAbility extends Ability
	{
		
		public function BeeLineAbility(a_time:int) 
		{
			super(a_time);
			
		}//end constructor()
		
		override public function useAbility():int
		{			
			DartsGlobals.instance.gameManager.upgradeDart(BeeLineDart);
			
			return super.useAbility();
		}//end useAbility()
		
	}//end BeeLineAbility

}//end com.bored.games.darts.abilities