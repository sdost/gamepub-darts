﻿package com.bored.services 
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
	public class ExternalService_BoredAPI extends AbstractExternalService
	{		
        private var _storeItems:Object;
		private var _userData:Object;
        private var _item:String;

        private var _loginEvent:Object;	
		
		public function ExternalService_BoredAPI() 
		{
			super();
		}//end constructor()
		
		override public function get loggedIn():Boolean
		{
			return BoredServices.isLoggedIn;
		}//end get loggedIn()
		
		override public function init( a_params:Object = null ):void 
		{
			BoredServices.addEventListener(BoredServices.SAVED_DATA_RECEIVED_EVT, onUserData);
			BoredServices.addEventListener(BoredServices.LOGGED_IN_EVENT, onLoggedIn);
			//MochiCoins.addEventListener(MochiCoins.ITEM_OWNED, registerItem);
			//MochiCoins.addEventListener(MochiCoins.ITEM_NEW, newItem);
			//MochiCoins.addEventListener(MochiCoins.STORE_ITEMS, storeItems);
		}//end init()
		
		override public function showLoginUI():void
		{			
			BoredServices.showLoginUI( {
				x: AppSettings.instance.mochiDockPositionX,
				y: AppSettings.instance.mochiDockPositionY 
			} );
		}//end showLoginUI()
		
		override public function hideLoginUI():void
		{
			BoredServices.hideLoginUI();
		}//end hideLoginUI()
		
		private function onLoggedIn( event:Object ):void
		{
			dispatchEvent(new Event(USER_LOGIN));
		}//end onLoggedIn()
		
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
			// MochiCoins.getStoreItems();
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
			// MochiCoins.showItem({ x:150, y: 150, item: a_itemID });
		}//end initiatePurchase()
		
		override public function pullUserData():void
		{
			BoredServices.getData("user_data");
		}//end pullUserData()
		
		override public function pushUserData():void
		{
			BoredServices.setData("user_data", _userDataSO.data);
		}//end pushUserData()
		
		private function onUserData(arg:Object):void
		{
			_userData = arg.data;
			for( var key:String in _userData )
			{
				trace("_userData[" + key + "] -> " + _userData[key]);
				
				_userDataSO.data[key] = _userData[key];
			}
			
			_userDataSO.flush();
			
			this.dispatchEvent(new Event(USER_DATA_AVAILABLE));
		}//end onUserData()
		
		override public function showStore():void
		{
			// MochiCoins.showStore();
		}//end showStore()
		
		private function onStoreHide(event:Object):void
		{
			this.dispatchEvent(new Event(STORE_HIDDEN));
		}//end onStoreHide()
		
	}//end ExternalService_BoredAPI

}//end com.bored.services