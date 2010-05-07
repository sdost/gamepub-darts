package com.bored.services 
{
	import com.sven.utils.AppSettings;
	import com.bored.services.AbstractExternalService;
	import com.inassets.events.ObjectEvent;
	import flash.events.Event;
	import mochi.as3.MochiCoins;
	import mochi.as3.MochiEvents;
	import mochi.as3.MochiInventory;
	import mochi.as3.MochiServices;
	import mochi.as3.MochiSocial;
	import mochi.as3.MochiUserData;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ExternalService_MochiAPI extends AbstractExternalService
	{		
        private var _storeItems:Object;
		private var _userData:Object;
        private var _item:String;

        private var _loginEvent:Object;	
		
		public function ExternalService_MochiAPI() 
		{
			super();
		}//end constructor()
		
		override public function get loggedIn():Boolean
		{
			return MochiSocial.loggedIn;
		}//end get loggedIn()
		
		override public function init( a_params:Object = null ):void
		{
			MochiSocial.addEventListener(MochiSocial.USER_INFO, onUserInfo);
			MochiSocial.addEventListener(MochiSocial.LOGGED_IN, onLoggedIn);
			MochiCoins.addEventListener(MochiCoins.ITEM_OWNED, registerItem);
			MochiCoins.addEventListener(MochiCoins.ITEM_NEW, newItem);
			MochiCoins.addEventListener(MochiCoins.STORE_ITEMS, storeItems);
			
			MochiServices.connect(a_params.gameId, a_params.parentClip);
		}//end init()
		
		override public function showLoginUI():void
		{			
			MochiSocial.showLoginWidget( {
				x: AppSettings.instance.mochiDockPositionX,
				y: AppSettings.instance.mochiDockPositionY 
			} );
		}//end showLoginUI()
		
		override public function hideLoginUI():void
		{
			MochiSocial.hideLoginWidget();
		}//end hideLoginUI()
		
		private function onLoggedIn( event:Object ):void
		{
			_userDataSO.data.userInfo = event;			
			_userDataSO.flush();
			
			this.dispatchEvent(new Event(USER_INFO_AVAILABLE));
		}//end onLoggedIn()
		
		private function onUserInfo( event:Object ):void
		{
			_userDataSO.data.userInfo = event;			
			_userDataSO.flush();
			
			this.dispatchEvent(new Event(USER_INFO_AVAILABLE));
		}//end onUserInfo()
		
		override public function getUserInfo():void
		{
			MochiSocial.getUserInfo();
		}//end getUserInfo()
		
		private function registerItem( event:Object ):void
		{
			var obj:Object = _userDataSO.data.ownedItems;
			
			if (!obj) obj = new Object();
			
			obj[event.id] = event;
			_userDataSO.data.ownedItems = obj;			
			
			_userDataSO.flush();
			
			this.dispatchEvent(new Event(USER_INVENTORY_UPDATE))
		}//end registerItem()
		
		private function newItem( event:Object ):void
		{
			var obj:Object = _userDataSO.data.ownedItems;
			
			if (!obj) obj = new Object();
			
			obj[event.id] = event;
			_userDataSO.data.ownedItems = obj;
			
			_userDataSO.flush();
			
			this.dispatchEvent(new Event(USER_INVENTORY_UPDATE))
		}//end newItem()
		
		override public function initializeStore():void
		{
			MochiCoins.getStoreItems();
		}//end initializeStore()
		
		private function storeItems(arg:Object):void 
		{
			var items:Vector.<StoreItem> = new Vector.<StoreItem>();
			
			_storeItems = arg;
			for each( var storeItem:Object in _storeItems )
			{				
				var item:StoreItem = new StoreItem();
				item.name = storeItem.name;
				item.id = storeItem.id;
				item.description = storeItem.desc;
				item.price = int(storeItem.cost);
				item.storeIcon = storeItem.properties["skinid"];
				items.push(item);
			}
			this.dispatchEvent(new ObjectEvent(STORE_ITEMS_AVAILABLE, items));
        }//end storeItems()
		
		override public function initiatePurchase(a_itemID:String):void
		{
			MochiCoins.showItem({ x:150, y: 150, item: a_itemID });
		}//end initiatePurchase()
		
		override public function pullUserData():void
		{
			MochiUserData.get("user_data", onUserData);
		}//end pullUserData()
		
		override public function pushUserData():void
		{
			MochiUserData.put("user_data", _userDataSO.data, onUserData);
		}//end pushUserData()
		
		private function onUserData(arg:Object):void
		{
			_userData = arg.data;
			for( var key:String in _userData )
			{	
				_userDataSO.data[key] = _userData[key];
			}
			
			_userDataSO.flush();
			
			this.dispatchEvent(new Event(USER_DATA_AVAILABLE));
		}//end onUserData()
		
		override public function showStore():void
		{
			MochiCoins.showStore();
		}//end showStore()
		
		private function onStoreHide(event:Object):void
		{
			this.dispatchEvent(new Event(STORE_HIDDEN));
		}//end onStoreHide()
		
	}//end ExternalService_MochiAPI

}//end com.bored.services