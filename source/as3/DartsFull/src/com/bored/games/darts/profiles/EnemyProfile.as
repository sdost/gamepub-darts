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
	import com.jac.soundManager.SoundController;
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
		
		public var prize:int;
		
		protected var _voSoundController:SoundController;
		
		public function EnemyProfile(a_name:String = "") 
		{
			super();
			
			this.name = a_name;
			
			_voSoundController = new SoundController(a_name + "_SoundController");
		}//end constructor()
		
		public function setDartSkin(a_skin:DartSkin):void
		{
			_dartSkin = a_skin;
		}//end set dartSkin()
		
		public function set dartSkin(a_skin:DartSkin):void
		{
			_dartSkin = a_skin;
		}//end set dartSkin()
		
		public function get dartSkin():DartSkin
		{
			return _dartSkin;
		}//end get dartSkin()
		
		public function playSound(a_str:String):void
		{
			_voSoundController.play(a_str);
		}//end playSound()
		
		public function useDoOver(evt:Event):void
		{
			DartsGlobals.instance.gameManager.removeEventListener(DartsGameLogic.THROW_END, useDoOver);
			
			(DartsGlobals.instance.opponentPlayer as ComputerPlayer).cancelShot();
			
			DartsGlobals.instance.gameManager.abilityManager.activateAbility(DartsGlobals.instance.opponentPlayer.getAbilityByName(DoOverAbility.NAME));
		}//end performDoOver()
		
	}//end EnemyProfile

}//end com.bored.games.darts.profiles