package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DoOverAbility extends Ability
	{
		
		public function DoOverAbility(a_time:int) 
		{
			super(a_time);	
		}//end constructor()
		
		override public function useAbility():int
		{			
			DartsGlobals.instance.gameManager.resetDart();
			DartsGlobals.instance.gameManager.scoreManager.revertLastThrow();
			
			return super.useAbility();
		}//end useAbility()
		
	}//end DoOverAbility

}//end com.bored.games.darts.abilities