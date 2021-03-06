﻿package com.bored.games.darts.abilities 
{
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundController;
	import com.sven.utils.AppSettings;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.sven.factories.MovieClipFactory;
	import com.sven.factories.SpriteFactory;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DoOverAbility extends Ability
	{
		public static const NAME:String = "Do-Over";
		
		public function DoOverAbility(a_time:int) 
		{
			var icon:Sprite = SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.icons.DoOverIcon_MC");
			super(NAME, "Get a Mulligan on your last dart throw.", icon, a_time);	
			
			var soundController:SoundController = DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds");
			soundController.addSound( new SMSound("dooverActivate", "dartpower_doover_mp3") );
			
		}//end constructor()
		
		override public function useAbility():int
		{						
			DartsGlobals.addWarning("DoOverAbility::useAbility() -- DartsGlobals.instance.gameManager.lastDart = " + DartsGlobals.instance.gameManager.lastDart);
			
			if ( DartsGlobals.instance.gameManager.lastDart ) {
				var soundController:SoundController = DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds");
				soundController.play("dooverActivate");
				
				var movie:MovieClip = MovieClipFactory.getMovieClipByQualifiedName("com.bored.games.darts.assets.effects.DoOverAnim_MC");
				movie.x = DartsGlobals.instance.gameManager.lastDart.x * 100 + 350;
				movie.y = DartsGlobals.instance.gameManager.lastDart.y * -100 + 275;
				DartsGlobals.instance.stage.addChild(movie);
			}
			else return 0;
			
			DartsGlobals.instance.gameManager.redoDart();
			DartsGlobals.instance.gameManager.scoreManager.revertLastThrow();
			
			return super.useAbility();
		}//end useAbility()
		
	}//end DoOverAbility

}//end com.bored.games.darts.abilities