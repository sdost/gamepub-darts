package com.bored.games.darts.profiles 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.abilities.DoOverAbility;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AIProfile;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.player.ComputerPlayer;
	import com.bored.games.darts.skins.DartSkin;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author sam
	 */
	public class EnemyProfile extends AIProfile
	{		
		private var _dartSkin:DartSkin;
		private var _abilities:Vector.<Ability>;
		
		public var portrait:BitmapData;
		
		public var age:int;
		public var height:int;
		public var weight:int;
		public var bio:String;
		
		public var firstMatch:String;
		public var rematch:String;
		
		public var winMatch:String;
		public var lossMatch:String;
		
		public function EnemyProfile(a_name:String = "") 
		{
			super(a_name);
		}//end constructor()
		
		public function setDartSkin(a_skin:DartSkin):void
		{
			_dartSkin = a_skin;
		}//end set dartSkin()
		
		public function get dartSkin():DartSkin
		{
			return _dartSkin;
		}//end get dartSkin()
		
		public function addAbility(a_ability:Ability):void
		{
			_abilities.push(a_ability);
		}//end addAbility()
		
		public function clearAbilities():void
		{
			_abilities = new Vector.<Ability>();
		}//end clearAbilities()
		
		public function get abilities():Vector.<Ability>
		{
			return _abilities;
		}//end get abilities()
		
		public function useDoOver(evt:Event):void
		{
			DartsGlobals.instance.gameManager.removeEventListener(DartsGameLogic.THROW_END, useDoOver);
			
			(DartsGlobals.instance.cpuPlayer as ComputerPlayer).cancelShot();
			
			//TweenMax.killAll();
			
			for each( var ability:Ability in DartsGlobals.instance.cpuPlayer.abilities )
			{
				if ( ability.name == DoOverAbility.NAME ) 
				{
					DartsGlobals.instance.gameManager.abilityManager.activateAbility(ability);
				}
			}
		}//end performDoOver()
		
	}//end EnemyProfile

}//end com.bored.games.darts.profiles