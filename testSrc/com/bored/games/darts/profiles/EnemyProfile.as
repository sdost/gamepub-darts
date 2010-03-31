package com.bored.games.darts.profiles 
{
	import away3dlite.materials.BitmapMaterial;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.logic.AIProfile;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class EnemyProfile extends AIProfile
	{
		private var _portrait:BitmapData;
		
		private var _dartSkin:BitmapMaterial;
		
		private var _abilities:Vector.<Ability>;
		
		private var _age:int;
		private var _height:int;
		private var _weight:int;
		
		private var _bio:String;
		
		public function EnemyProfile(a_name:String = "") 
		{
			super(a_name);
		}//end constructor()
		
		public function setDartSkin(a_bmd:BitmapData):void
		{
			_dartSkin = new BitmapMaterial(a_bmd);
			_dartSkin.repeat = false;
			_dartSkin.smooth = true;
		}//end set dartSkin()
		
		public function get dartSkin():BitmapMaterial
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
		
		public function set portrait(a_portrait:BitmapData):void
		{
			_portrait = a_portrait;
		}//end set portrait()
		
		public function get portrait():BitmapData
		{
			return _portrait;
		}//end get portrait()
		
		public function set age(a_age:int):void
		{
			_age = a_age;
		}//end set age()
		
		public function get age():int
		{
			return _age;
		}//end get age()
		
		public function set height(a_height:int):void
		{
			_height = a_height;
		}//end set height()
		
		public function get height():int
		{
			return _height;
		}//end get height()
		
		public function set weight(a_weight:int):void
		{
			_weight = a_weight;
		}//end set weight()
		
		public function get weight():int
		{
			return _weight;
		}//end get weight()
		
		public function set bio(a_bio:String):void
		{
			_bio = a_bio;
		}//end set bio()
		
		public function get bio():String
		{
			return _bio;
		}//end get bio()
		
	}//end EnemyProfile

}//end com.bored.games.darts.profiles