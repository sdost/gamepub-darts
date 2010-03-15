package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.abilities.Ability;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BeeLineAbility extends Ability
	{
		private static var BEE_LINE_TIMER:int = 2;
		
		public function BeeLineAbility() 
		{
			super(BEE_LINE_TIMER);
		}//end constructor()
		
		override public function engageAbility():void
		{	
			super.engageAbility();
			
			
		}//end engageAbility()
		
	}//end BeeLineAbility

}//end com.bored.games.darts.abilities