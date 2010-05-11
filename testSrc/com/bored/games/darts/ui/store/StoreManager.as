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
			
			_storeContents.push( new DartSkinStoreItem( storeskin_blackpearl, "blackpearl", "oval", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_blue, "blue", "hex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_brazil, "brazil", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_canada, "canada", "hex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_france, "france", "thin", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_germany, "germany", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_green, "green", "modhex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_india, "india", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_indigo, "indigo", "pincer", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_japan, "japan", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_japanimperial, "japanimperial", "pincer", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_jollyroger, "jollyroger", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_oldglory, "oldglory", "modhex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_orange, "orange", "thin", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_pearl, "pearl", "oval", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_red, "red", "pincer", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_russia, "russia", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_skorea, "skorea", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_techno, "techno", "modhex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_unionjack, "unionjack", "hex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_violet, "violet", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( storeskin_yellow, "yellow", "thin", 2500 ) );
		}//end generateDartList()
		
		public static function generatePowerList():void
		{
			_storeContents = new Vector.<StoreItem>();
			
			_storeContents.push( new PowerStoreItem( ShieldIcon_MC, "Shield", DartsGlobals.instance.localPlayer.getAbilityByName("Shield"), "shield", 450 ) );
			_storeContents.push( new PowerStoreItem( BeelineIcon_MC, "Beeline", DartsGlobals.instance.localPlayer.getAbilityByName("Beeline"), "beeline", 450 ) );
			_storeContents.push( new PowerStoreItem( DoOverIcon_MC, "Do-Over", DartsGlobals.instance.localPlayer.getAbilityByName("Do-Over"), "doover", 450 ) );
		}//end generatePowerList()
		
		public static function get storeContents():Vector.<StoreItem>
		{
			return _storeContents;
		}
		
	}//end StoreManager

}//end package