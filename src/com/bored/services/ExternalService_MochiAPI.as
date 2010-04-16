package com.bored.services 
{
	import com.sven.utils.AppSettings;
	import com.bored.services.AbstractExternalService;
	import com.inassets.events.ObjectEvent;
	import flash.events.Event;
	import mochi.as3.MochiCoins;
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
        private var _item:String;

        private var _loginEvent:Object;	
		
		public function ExternalService_MochiAPI() 
		{
			super();
		}//end constructor()
		
		override public function init( a_gameId:String, a_parentClip:Object ):void 
		{
			MochiServices.connect(a_gameId, a_parentClip);
			
			MochiSocial.addEventListener(MochiSocial.ERROR, coinsError);
            MochiSocial.addEventListener(MochiSocial.LOGGED_IN, onLogin);
            MochiSocial.addEventListener(MochiSocial.LOGGED_OUT, onLogout);
            MochiCoins.addEventListener(MochiCoins.ITEM_OWNED, coinsEvent);
			MochiCoins.addEventListener(MochiCoins.STORE_HIDE, onStoreHide);
			
            MochiSocial.showLoginWidget( {
				x: AppSettings.instance.mochiDockPositionX,
				y: AppSettings.instance.mochiDockPositionY 
			});

            MochiInventory.addEventListener(MochiInventory.READY, inventoryReady );
            MochiInventory.addEventListener(MochiInventory.WRITTEN, inventorySynced );
		}//end init()
		
		private function inventoryReady(status:Object):void 
		{
            // TODO: process inventory...
        }//end inventoryReady()

        private function inventorySynced(status:Object):void
        {
            // TODO: sync'd inventory...
        }//end inventorySynced()
		
		private function coinsError(error:Object):void 
		{
            trace("[GAME] [coinsError] " + error.type);
        }//end coinsError()

        private function coinsEvent(event:Object):void 
		{
            trace("[GAME] [coinsEvent] " + event);
        }//end coinsEvent()

        private function onLogin(event:Object):void 
		{
            loginEvent = event;
        }//end onLogin()

        private function onLogout(event:Object):void 
		{
            loginEvent = null;
        }//end onLogout()
		
		private function get loginEvent():Object 
		{
            return _loginEvent;
        }//end get loginEvent()

        private function set loginEvent(event:Object):void 
		{
            _loginEvent = event;
            var txt:String;
            if (_loginEvent) {
                // logged in
                txt = "name: " + _loginEvent.name;
            } else {
                // logged out
                txt = "not logged in";
            }
            try {
                //var s:Sprite = Sprite(body.getChildByName("MochiSocial.LOGGED_IN"));
                //var subtitle:TextField = TextField(s.getChildByName("subtitle"));
                //subtitle.text = txt;
            } catch (e:Error) {
                /* not initialized yet */
            }
        }//end set loginEvent()
		
		override public function initializeStore():void
		{
			MochiCoins.addEventListener(MochiCoins.STORE_ITEMS, storeItems);
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
				item.storeIcon = storeItem.properties["storeskin"];
				items.push(item);
			}
			this.dispatchEvent(new ObjectEvent(STORE_ITEMS_AVAILABLE, items));
        }//end storeItems()
		
		override public function initiatePurchase(a_itemID:String):void
		{
			MochiCoins.showItem({ x:150, y: 150, item: a_itemID });
		}//end initiatePurchase()
		
		override public function loadGameData(a_callback:Function):void
		{
			MochiUserData.get("game_state", a_callback);
		}//end loadeGameData()
		
		override public function saveGameData(a_callback:Function, a_data:Object):void
		{
			MochiUserData.put("game_state", a_data, a_callback);
		}//end saveGameData()
		
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