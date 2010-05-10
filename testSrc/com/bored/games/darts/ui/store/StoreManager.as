package com.bored.games.darts.ui.store 
{
	import com.bored.games.darts.assets.icons.BeelineIcon_MC;
	import com.bored.games.darts.assets.icons.DoOverIcon_MC;
	import com.bored.games.darts.assets.icons.ShieldIcon_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.services.StoreItem;
	/**
	 * ...
	 * @author sam
	 */
	public class StoreManager
	{
		private static var _storeContents:Vector.<StoreItem>;
		
		public static function generateDartList():void
		{
			_storeContents = new Vector.<StoreItem>();
			
			
			
		}//end generateDartList()
		
		public static function generatePowerList():void
		{
			_storeContents = new Vector.<StoreItem>();
			
			_storeContents.push( new PowerStoreItem( ShieldIcon_MC, "Shield", DartsGlobals.instance.localPlayer.abilities[0], "shield", 450 ) );
			_storeContents.push( new PowerStoreItem( BeelineIcon_MC, "Beeline", DartsGlobals.instance.localPlayer.abilities[1], "beeline", 450 ) );
			_storeContents.push( new PowerStoreItem( DoOverIcon_MC, "Do-Over", DartsGlobals.instance.localPlayer.abilities[2], "doover", 450 ) );
		}//end generatePowerList()
		
	}//end StoreManager

}//end package