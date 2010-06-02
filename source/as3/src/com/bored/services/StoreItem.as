package com.bored.services 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author sam
	 */
	public class StoreItem
	{
		protected var _itemName:String;
		protected var _itemID:String;
		protected var _itemDescription:String;
		protected var _itemPrice:int;
		protected var _itemStoreIcon:DisplayObject;
		
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
		
		public function get storeIcon():DisplayObject
		{
			return _itemStoreIcon;
		}//end get storeIcon()
		
		public function doPurchase():Boolean
		{
			return false;
		}//end doPurchase()
		
		public function toString():String
		{
			return new String( "[" + _itemName + "] -> " + _itemDescription + ", " + _itemPrice );
		}//end toString()
		
	}//end StoreItem

}//end com.bored.services