package com.bored.games.darts.ui.store 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.services.StoreItem;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DartSkinStoreItem extends StoreItem
	{
		private var _flightId:String;
		
		public function DartSkinStoreItem( a_iconClass:Class, a_skinId:String, a_flightId:String, a_price:int) 
		{
			super();
			
			_itemStoreIcon = new Bitmap(new a_iconClass(270, 103));
			(_itemStoreIcon as Bitmap).smoothing = true;
			
			this.id = a_skinId;
			this.price = a_price;
			
			_flightId = a_flightId;
		}//end constructor
		
		public function get flightid():String
		{
			return _flightId;
		}//end get flightid()
		
		override public function doPurchase():Boolean
		{
			var arr:Array = DartsGlobals.instance.externalServices.getData("ownedSkins");
			if ( arr == null ) arr = new Array();
			arr.push( { skinid: this.id, flightid: this.flightid } );
			DartsGlobals.instance.externalServices.setData("ownedSkins", arr);
			
			DartsGlobals.instance.playerProfile.unlockSkin(this.id, _flightId);
			
			return true;
		}//end doPurchase()
		
	}//end DartSkinStoreItem

}//end package