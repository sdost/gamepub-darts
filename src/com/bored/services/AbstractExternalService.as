package com.bored.services 
{
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author sam
	 */
	public class AbstractExternalService extends EventDispatcher
	{
		protected var _userDataSO:SharedObject;
		
		public static const STORE_HIDDEN:String = "storeHidden";
		public static const STORE_ITEMS_AVAILABLE:String = "storeItemsAvailable";
		public static const USER_DATA_AVAILABLE:String = "userDataAvailable";
		
		public function AbstractExternalService()
		{
			_userDataSO = SharedObject.getLocal("localUserDataStore");
		}//end constructor()
		
		public function init( a_gameId:String, a_parentClip:Object ):void
		{
		}//end init()
		
		public function showLoginUI():void
		{
		}//end showLoginUI()
		
		public function hideLoginUI():void
		{
		}//end hideLoginUI()
		
		public function pullUserData():void
		{
		}//end pullUserData()
		
		public function pushUserData():void
		{
		}//end pushUserData()
		
		public function get data():Object
		{
			return _userDataSO.data;
		}//end getData()
		
		public function initializeStore():void
		{
		}//end initializeStore()
		
		public function initiatePurchase(a_itemID:String):void
		{
		}//end initiatePurchase()
		
		public function showStore():void
		{
		}//end showStore()
		
	}//end AbstractExternalService

}//end com.bored.services