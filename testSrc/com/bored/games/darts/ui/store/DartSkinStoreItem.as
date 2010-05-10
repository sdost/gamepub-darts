package com.bored.games.darts.ui.store 
{
	import com.bored.services.StoreItem;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class DartSkinStoreItem extends StoreItem
	{
		public function DartSkinStoreItem( a_iconClass:Class, a_id:String, a_price:int) 
		{
			super();
			
			this.storeIcon = new a_iconClass();
			
			this.id = a_id;
			this.price = a_price;
		}//end constructor
		
	}//end DartSkinStoreItem

}//end package