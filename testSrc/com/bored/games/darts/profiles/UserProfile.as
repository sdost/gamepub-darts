package com.bored.games.darts.profiles 
{
	/**
	 * ...
	 * @author sam
	 */
	public class UserProfile
	{
		private var _name:String;
		private var _unlockedSkins:Array;
		
		public function UserProfile() 
		{
			_name = "";
			_unlockedSkins = new Array();
		}//end constructor()
		
		public function get name():String
		{
			return _name;
		}//end get name()
		
		public function set name(a_name:String):void
		{
			_name = a_name;
		}//end set name()
		
		public function fillProfile(a_profileData:Object):void
		{
			
		}//end fillProfile()
		
		public function unlockSkin(a_name:String):void
		{
			_unlockedSkins.push(a_name);
		}//end unlockSkin()
		
		public function get skins():Array
		{
			return _unlockedSkins;
		}//end get skins()
		
	}//end UserProfile

}//end com.bored.games.darts.profiles