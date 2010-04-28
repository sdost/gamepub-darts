package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.actions.BeeLineTrajectoryAction;
	import com.bored.games.darts.DartsGlobals;
	import com.jac.soundManager.events.SMSoundCompleteEvent;
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundController;
	import com.sven.utils.SpriteFactory;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BeeLineAbility extends Ability
	{
		public static const NAME:String = "Beeline";
		
		public function BeeLineAbility(a_time:int) 
		{
			var icon:Sprite = SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.icons.BeelineIcon_MC");
			super(NAME, "Darts go straight to where you aim.", icon, a_time);
			
			var soundController:SoundController = DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds");
			soundController.addSound( new SMSound("beelineActivate", "dartpower_beelineloop_wav", true) );
		}//end constructor()
		
		override public function useAbility():int
		{		
			var soundController:SoundController = DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds");
			soundController.play("beelineActivate");
			
			DartsGlobals.instance.gameManager.cursor.setCursorImage(SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.hud.BeelineCursor_MC"));
			DartsGlobals.instance.gameManager.currentDart.setThrowAction(new BeeLineTrajectoryAction(DartsGlobals.instance.gameManager.currentDart));
			
			DartsGlobals.instance.gameManager.currentDart.addModifier(this);
			
			return super.useAbility();
		}//end useAbility()
		
	}//end BeeLineAbility

}//end com.bored.games.darts.abilities