﻿package com.bored.games.darts.abilities 
{
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundController;
	import com.sven.utils.AppSettings;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.sven.utils.MovieClipFactory;
	import com.sven.utils.SpriteFactory;
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
			var soundController:SoundController = DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds");
			soundController.play("dooverActivate");
			
			if( DartsGlobals.instance.gameManager.lastDart ) {
				var movie:MovieClip = MovieClipFactory.getMovieClipByQualifiedName("com.bored.games.darts.assets.effects.DoOverAnim_MC");
				movie.x = DartsGlobals.instance.gameManager.lastDart.position.x * 100 + 350;
				movie.y = DartsGlobals.instance.gameManager.lastDart.position.y * -100 + 275;
				DartsGlobals.instance.stage.addChild(movie);
			}
			
			DartsGlobals.instance.gameManager.redoDart();
			DartsGlobals.instance.gameManager.scoreManager.revertLastThrow();
			
			return super.useAbility();
		}//end useAbility()
		
	}//end DoOverAbility

}//end com.bored.games.darts.abilities