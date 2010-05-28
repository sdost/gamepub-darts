package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartFlightHexagon;
	import com.bored.games.darts.models.dae_DartFlightModHex;
	import com.bored.games.darts.models.dae_DartFlightOval;
	import com.bored.games.darts.models.dae_DartFlightPincer;
	import com.bored.games.darts.models.dae_DartFlightThin;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	/**
	 * ...
	 * @author sam
	 */
	public dynamic class Profile
	{
		private var _name:String;
		
		public function Profile() 
		{
			_name = "";
		}//end constructor()
		
		public function get name():String
		{
			return _name;
		}//end get name()
		
		public function set name(a_name:String):void
		{
			_name = a_name;
		}//end set name()
		
	}//end Profile

}//end com.bored.games.darts.profiles