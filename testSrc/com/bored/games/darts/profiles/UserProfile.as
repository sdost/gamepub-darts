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
	public class UserProfile extends Profile
	{
		private var _unlockedSkins:Vector.<DartSkin>;
		
		public function UserProfile() 
		{
			super();
			_unlockedSkins = new Vector.<DartSkin>();
		}//end constructor()
		
		public function unlockSkin(a_skinid:String, a_flightid:String):void
		{
			var flightXML:XML = null;
			
			if ( a_flightid == "heart" ) {
				flightXML = dae_DartFlightHeart.data;
			} else if ( a_flightid == "hex" ) {
				flightXML = dae_DartFlightHexagon.data;
			} else if ( a_flightid == "modhex" ) {
				flightXML = dae_DartFlightModHex.data;
			} else if ( a_flightid == "oval" ) {
				flightXML = dae_DartFlightOval.data;
			} else if ( a_flightid == "pincer" ) {
				flightXML = dae_DartFlightPincer.data;
			} else if ( a_flightid == "thin" ) {
				flightXML = dae_DartFlightThin.data;
			}
			
			var skin:DartSkin = new DartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_" + a_skinid, AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight), dae_DartShaft.data, flightXML );
			skin.skinid = a_skinid;
			skin.flightid = a_flightid;
			
			var skip:Boolean = false;
			for ( var i:int = 0; i < _unlockedSkins.length; i++ ) 
			{
				if ( a_skinid == _unlockedSkins[i].skinid ) 
				{
					skip = true;
					return;
				}
			}
			
			if(!skip) _unlockedSkins.push( skin );
		}//end unlockSkin()
		
		public function clearUnlockedSkins():void
		{
			_unlockedSkins = new Vector.<DartSkin>();
		}//end clearUnlockedSkins()
		
		public function get skins():Vector.<DartSkin>
		{
			return _unlockedSkins;
		}//end get skins()
		
	}//end UserProfile

}//end com.bored.games.darts.profiles