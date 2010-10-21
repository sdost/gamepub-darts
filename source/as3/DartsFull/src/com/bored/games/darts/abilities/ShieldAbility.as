package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.jac.soundManager.SoundController;
	import com.sven.factories.SpriteFactory;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ShieldAbility extends Ability
	{
		public static const NAME:String = "Shield";
		
		public function ShieldAbility(a_time:int) 
		{
			var icon:Sprite = SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.icons.ShieldIcon_MC");
			super(NAME, "Block a section of the board to hinder your opponent.", icon, a_time);
		}//end constructor()
		
		override public function useAbility():int
		{	
			if ( DartsGlobals.instance.gameManager.currentDart )
			{
				DartsGlobals.instance.gameManager.currentDart.blockBoard = true;
			
				DartsGlobals.instance.gameManager.currentDart.addModifier(this);
			}
			
			return super.useAbility();
		}//end useAbility()
		
	}//end ShieldAbility

}//end com.bored.games.darts.abilities