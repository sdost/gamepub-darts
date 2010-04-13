package com.bored.services 
{
	/**
	 * ...
	 * @author sam
	 */
	public class StoreItem
	{
		private var _itemName:String;
		private var _itemDescription:String;
		private var _itemPrice:int;
		private var _itemIconURL:String;
		
		public function StoreItem() { }
		
		public function set name(a_str:String):void
		{
			_itemName = a_str;
		}//end set name()
		
		public function set description(a_str:String):void
		{
			_itemDescription = a_str;
		}//end set description()
		
		public function set price(a_int:int):void
		{
			_itemPrice = a_int;
		}//end set price()
		
		public function set iconURL(a_str:String):void
		{
			_itemIconURL = a_str;
		}//end set iconURL()
		
		public function get name():String
		{
			return _itemName;
		}//end get name()
		
		public function get description():String
		{
			return _itemDescription;
		}//end get description()
		
		public function get price():int
		{
			return _itemPrice;
		}//end get price()
		
		public function get iconURL():String
		{
			return _itemIconURL;
		}//end get iconURL()
		
		public function toString():String
		{
			return new String( "[" + _itemName + "] -> " + _itemDescription + ", " + _itemPrice + ", " + _itemIconURL );
		}//end toString()
		
	}//end StoreItem

}//end com.bored.services