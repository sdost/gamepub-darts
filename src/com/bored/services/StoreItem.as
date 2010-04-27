package com.bored.services 
{
	/**
	 * ...
	 * @author sam
	 */
	public class StoreItem
	{
		private var _itemName:String;
		private var _itemID:String;
		private var _itemDescription:String;
		private var _itemPrice:int;
		private var _itemStoreIcon:String;
		
		public function StoreItem() { }
		
		public function set name(a_str:String):void
		{
			_itemName = a_str;
		}//end set name()
		
		public function set id(a_str:String):void
		{
			_itemID = a_str;
		}//end set id()
		
		public function set description(a_str:String):void
		{
			_itemDescription = a_str;
		}//end set description()
		
		public function set price(a_int:int):void
		{
			_itemPrice = a_int;
		}//end set price()
		
		public function set storeIcon(a_str:String):void
		{
			_itemStoreIcon = "storeskin_" + a_str;
		}//end set iconURL()
		
		public function get name():String
		{
			return _itemName;
		}//end get name()
		
		public function get id():String
		{
			return _itemID;
		}//end get id()
		
		public function get description():String
		{
			return _itemDescription;
		}//end get description()
		
		public function get price():int
		{
			return _itemPrice;
		}//end get price()
		
		public function get storeIcon():String
		{
			return _itemStoreIcon;
		}//end get iconURL()
		
		public function toString():String
		{
			return new String( "[" + _itemName + "] -> " + _itemDescription + ", " + _itemPrice + ", " + _itemStoreIcon );
		}//end toString()
		
	}//end StoreItem

}//end com.bored.services