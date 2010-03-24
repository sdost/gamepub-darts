package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.actions.BeeLineTrajectoryAction;
	import com.bored.games.darts.DartsGlobals;
	import com.sven.utils.SpriteFactory;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BeeLineAbility extends Ability
	{
		
		public function BeeLineAbility(a_time:int) 
		{
			var icon:Sprite = SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.icons.BeelineIcon_MC");
			super(icon, a_time);			
		}//end constructor()
		
		override public function useAbility():int
		{		
			DartsGlobals.instance.gameManager.cursor.setCursorImage(SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.hud.BeelineCursor_MC"));
			DartsGlobals.instance.gameManager.currentDart.setThrowAction(new BeeLineTrajectoryAction(DartsGlobals.instance.gameManager.currentDart));
			
			return super.useAbility();
		}//end useAbility()
		
	}//end BeeLineAbility

}//end com.bored.games.darts.abilities