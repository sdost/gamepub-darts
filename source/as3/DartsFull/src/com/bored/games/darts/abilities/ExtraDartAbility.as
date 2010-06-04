package com.bored.games.darts.abilities 
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
	public class ExtraDartAbility extends Ability
	{
		public static const NAME:String = "Extra Dart";
		
		public function ExtraDartAbility(a_time:int) 
		{
			var icon:Sprite = SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.icons.DoOverIcon_MC");
			super(NAME, "Get a Mulligan on your last dart throw.", icon, a_time);
			
			var soundController:SoundController = DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds");
			soundController.addSound( new SMSound("extraDartActivate", "dartpower_extradart_mp3") );
		}//end constructor()
		
		override public function useAbility():int
		{			
			var soundController:SoundController = DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds");
			soundController.play("extraDartActivate");
			
			/**
			if( DartsGlobals.instance.gameManager.lastDart ) {
				var movie:MovieClip = MovieClipFactory.getMovieClipByQualifiedName("com.bored.games.darts.assets.effects.DoOverAnim_MC");
				movie.x = DartsGlobals.instance.gameManager.lastDart.position.x * 100 + 350;
				movie.y = DartsGlobals.instance.gameManager.lastDart.position.y * -100 + 275;
				DartsGlobals.instance.stage.addChild(movie);
			}
			/**/
			
			//DartsGlobals.instance.gameManager.addExtraDart();
			//DartsGlobals.instance.gameManager.scoreManager.revertLastThrow();
			
			return super.useAbility();
		}//end useAbility()
		
	}//end ExtraDartAbility

}//end com.bored.games.darts.abilities