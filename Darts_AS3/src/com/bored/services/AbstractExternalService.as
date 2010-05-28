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
		public static const ACHIEVEMENT_EARNED:String = "achievementEarned";
		public static const USER_LOGIN:String = "userLogin";
		public static const USER_DATA_AVAILABLE:String = "userDataAvailable";
		public static const USER_INVENTORY_UPDATE:String = "userInventoryUpdate";
		
		public function AbstractExternalService()
		{
			_userDataSO = SharedObject.getLocal("localUserDataStore");
		}//end constructor()
		
		public function get loggedIn():Boolean
		{
			return false;
		}//end loggedIn()
		
		public function init( a_params:Object = null ):void
		{
		}//end init()
		
		public function getUserInfo():void
		{
		}//end getUserInfo()
		
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
		
		public function bestowAchievement(a_id:String):void
		{
		}//end bestowAchievement()
		
		public function getData(a_str:String):*
		{
			return _userDataSO.data[a_str];
		}//end getData()
		
		public function setData(a_str:String, a_data:*):void
		{
			_userDataSO.data[a_str] = a_data;
			_userDataSO.flush();
			
			for ( var key:String in _userDataSO.data )
			{
				trace("userData.data[" + key + "] -> " + _userDataSO.data[key]);
			}
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