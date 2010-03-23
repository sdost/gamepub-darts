﻿package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.sven.utils.SpriteFactory;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ShieldAbility extends Ability
	{
		public function ShieldAbility(a_time:int) 
		{
			var icon:Sprite = SpriteFactory.getSpriteByQualifiedName("com.bored.games.darts.assets.icons.ShieldIcon_MC");
			super(icon, a_time);
		}//end constructor()
		
		override public function useAbility():int
		{						
			return super.useAbility();
		}//end useAbility()
		
	}//end ShieldAbility

}//end com.bored.games.darts.abilities