package com.bored.services 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.services.events.ObjectEvent;
	import com.bored.services.tools.uds.DataUpdatedEvent;
	import com.bored.services.tools.uds.UniversalDataStorageObject;
	import com.sven.utils.AppSettings;
	import com.bored.services.AbstractExternalService;
	import flash.events.Event;
	import mx.utils.ObjectUtil;
	
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
		
		private var _udsObj:UniversalDataStorageObject;
		
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
			BoredServices.setRootContainer( a_params.rootContainer );
			
			_udsObj = new UniversalDataStorageObject("user_data");
			_udsObj.addEventListener(DataUpdatedEvent.UDS_SYNC_EVENT, onDataDescrepancy, false, 0, true);
			_udsObj.addEventListener(DataUpdatedEvent.UDS_SERVER_UPDATE_EVENT, onServerUpdate, false, 0, true);
			
			// set any resolutions for handling data, here.
			//_udsObj.setResolutionFuncFor(
			
			BoredServices.addEventListener(ObjectEvent.LOGGED_IN_EVENT, onLoggedIn);
			//MochiCoins.addEventListener(MochiCoins.ITEM_OWNED, registerItem);
			//MochiCoins.addEventListener(MochiCoins.ITEM_NEW, newItem);
			//MochiCoins.addEventListener(MochiCoins.STORE_ITEMS, storeItems);
			
		}//end init()
		
		override public function setData(param0:String, param1:*):void 
		{
			_udsObj.setDataAt(param0, param1);
			
		}//end setData()
		
		override public function getData(param0:String):* 
		{
			return _udsObj.getDataAt(param0);
			
		}//end getData()
		
		private function onServerUpdate(a_dataUpdatedEvt:DataUpdatedEvent):void
		{
			var serverData:Object = a_dataUpdatedEvt.newVal;
			var serverDataDesc:String = ObjectUtil.toString(serverData);
			var udsDataDesc:String = ObjectUtil.toString(_udsObj.clientFSO.data);
			DartsGlobals.addWarning("ExternalService_BoredAPI::onServerUpdate(): serverData=\n" + serverDataDesc + "\n\n_udsObj.udsData=" + udsDataDesc);
			
		}//end onServerUpdate()
		
		private function onDataDescrepancy(a_dataUpdatedEvt:DataUpdatedEvent):void
		{
			DartsGlobals.addWarning("ExternalService_BoredAPI::onDataDescrepancy(): a_dataUpdatedEvt.key=" + a_dataUpdatedEvt.key 
									+ ", a_dataUpdatedEvt.oldVal=" + a_dataUpdatedEvt.oldVal + ", a_dataUpdatedEvt.newVal=" + a_dataUpdatedEvt.newVal);
			
			//DartsGlobals.instance.externalServices.setData("gameCash", 500);				// an integer amount of cash
			//DartsGlobals.instance.externalServices.setData("powerLevels", new Object());	// an object with id-keys and power-values. powerObj = {refreshTime: 10,name: this.abilityRef.name};
			//DartsGlobals.instance.externalServices.setData("ownedSkins", new Array());	// array of object(s) as follows: [ {skinid: this.id, flightid: this.flightid} ]
			//DartsGlobals.instance.externalServices.setData("seenThrowTutorial")			// boolean value
			
			this.dispatchEvent(new Event(USER_DATA_AVAILABLE));
			
		}//end onDataDescrepancy()
		
		override public function showLoginUI():void
		{			
			//BoredServices.showLoginUI( {x: AppSettings.instance.mochiDockPositionX, y: AppSettings.instance.mochiDockPositionY} );
			BoredServices.showLoginUI();
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
			var obj:Object = _udsObj.getDataAt("ownedItems");
			
			if (!obj)
			{
				obj = new Object();
			}
			
			obj[event.id] = event;
			
			_udsObj.setDataAt("ownedItems", obj);
			
			this.dispatchEvent(new Event(USER_INVENTORY_UPDATE));
			
		}//end registerItem()
		
		private function newItem( event:Object ):void
		{
			var obj:Object = _udsObj.getDataAt("ownedItems");
			
			if (!obj)
			{
				obj = new Object();
			}
			
			obj[event.id] = event;
			
			_udsObj.setDataAt("ownedItems", obj);
			
			this.dispatchEvent(new Event(USER_INVENTORY_UPDATE));
			
		}//end newItem()
		
		override public function pushUserData():void
		{
			
		}//end pushUserData()
		
		override public function showAchievementUI():void
		{
			BoredServices.showAchievements();
			
		}//end showAchievementUI()
		
		override public function bestowAchievement(a_id:String):void
		{
			BoredServices.submitAchievementAcquired(a_id, true);
			//BoredServices.addEventListener("ScoreSubmissionCompleteEvent", onAchievementEarned, false, 0, true);
		}//end bestowAchievement()
		
		/*
		private function onAchievementEarned(evt:*):void
		{			
			var achievementsArr:Array = (evt as Object).obj;
			this.dispatchEvent(new ObjectEvent(ACHIEVEMENT_EARNED, achievementsArr));
		}//end onAchievementEarned()
		*/
		
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