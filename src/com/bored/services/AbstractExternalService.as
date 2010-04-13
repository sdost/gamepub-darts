package com.bored.services 
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author sam
	 */
	public class AbstractExternalService extends EventDispatcher
	{
		public static const STORE_HIDDEN:String = "storeHidden";
		public static const STORE_ITEMS_AVAILABLE:String = "storeItemsAvailable";
		
		public function AbstractExternalService()
		{
		}//end constructor()
		
		public function init( a_gameId:String, a_parentClip:Object ):void
		{
		}//end init()
		
		public function loadGameData(a_callback:Function):void
		{
		}//end loadeGameData()
		
		public function saveGameData(a_callback:Function, a_data:Object):void
		{
		}//end saveGameData()
		
		public function initializeStore():void
		{
		}//end initializeStore()
		
		public function showStore():void
		{
		}//end showStore()
		
	}//end AbstractExternalService

}//end com.bored.services