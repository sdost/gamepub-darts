package com.bored.games.darts.ui.store 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.services.StoreItem;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.MovieClipFactory;
	import com.sven.utils.SpriteFactory;
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
			
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_blackpearl", 270, 103), "blackpearl", "oval", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_blue", 270, 103), "blue", "hex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_brazil", 270, 103), "brazil", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_canada", 270, 103), "canada", "hex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_france", 270, 103), "france", "thin", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_germany", 270, 103), "germany", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_green", 270, 103), "green", "modhex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_india", 270, 103), "india", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_indigo", 270, 103), "indigo", "pincer", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_japan", 270, 103), "japan", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_japanimperial", 270, 103), "japanimperial", "pincer", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_jollyroger", 270, 103), "jollyroger", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_oldglory", 270, 103), "oldglory", "modhex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_orange", 270, 103), "orange", "thin", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_pearl", 270, 103), "pearl", "oval", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_red", 270, 103), "red", "pincer", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_russia", 270, 103), "russia", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_skorea", 270, 103), "skorea", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_techno", 270, 103), "techno", "modhex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_unionjack", 270, 103), "unionjack", "hex", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_violet", 270, 103), "violet", "heart", 2500 ) );
			_storeContents.push( new DartSkinStoreItem( ImageFactory.getBitmapDataByQualifiedName("storeskin_yellow", 270, 103), "yellow", "thin", 2500 ) );
		}//end generateDartList()
		
		public static function generatePowerList():void
		{
			_storeContents = new Vector.<StoreItem>();
			
			_storeContents.push( new PowerStoreItem( MovieClipFactory.getMovieClipByQualifiedName("com.bored.games.darts.assets.icons.ShieldIcon_MC"), "Shield", DartsGlobals.instance.localPlayer.getAbilityByName("Shield"), "shield", 450 ) );
			_storeContents.push( new PowerStoreItem( MovieClipFactory.getMovieClipByQualifiedName("com.bored.games.darts.assets.icons.BeelineIcon_MC"), "Beeline", DartsGlobals.instance.localPlayer.getAbilityByName("Beeline"), "beeline", 450 ) );
			_storeContents.push( new PowerStoreItem( MovieClipFactory.getMovieClipByQualifiedName("com.bored.games.darts.assets.icons.DoOverIcon_MC"), "Do-Over", DartsGlobals.instance.localPlayer.getAbilityByName("Do-Over"), "doover", 450 ) );
		}//end generatePowerList()
		
		public static function get storeContents():Vector.<StoreItem>
		{
			return _storeContents;
		}
		
	}//end StoreManager

}//end package