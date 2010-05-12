package com.bored.services 
{
	import com.bored.services.events.DataReceivedEvent;
	import com.bored.services.events.ObjectEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class BoredServices
	{
		public static const SAVED_DATA_RECEIVED_EVT:String = "SavedDataReceivedEvent";
		public static const GAME_INFO_READY_EVT:String = "GameInfoReadyEvent";
		public static const SCORE_SUBMISSION_COMPLETE_EVT:String = "ScoreSubmissionCompleteEvent";
		public static const LOGGED_IN_EVENT:String = "LoggedInEvent";
		public static const NOT_LOGGED_IN_ERROR_EVT:String = "NotLoggedInErrorEvent";
		
		public static var _servicesObj:Object;
		
		private static var _proxyDispatcher:EventDispatcher;
		
		private static var _loggedIn:Boolean = false;
		
		public static function set servicesObj(a_obj:Object):void
		{
			if (!_servicesObj)
			{
				_servicesObj = a_obj;
				
				_loggedIn = _servicesObj.isLoggedIn;
				if(!_loggedIn)
				{
					_servicesObj.addEventListener(BoredServices.LOGGED_IN_EVENT, onLoggedIn, false, 0, true);
				}
				else
				{
					onLoggedIn();
				}
				
				_servicesObj.addEventListener(BoredServices.GAME_INFO_READY_EVT, onGameInfoReceived, false, 0, true);
				
				_servicesObj.addEventListener(BoredServices.NOT_LOGGED_IN_ERROR_EVT, redispatch, false, 0, true);
				_servicesObj.addEventListener(BoredServices.SCORE_SUBMISSION_COMPLETE_EVT, redispatch);
			}
			
		}//end set servicesObj()
		
		public static function setRootContainer(a_displayObjCont:DisplayObjectContainer):void
		{
			if (_servicesObj)
			{
				_servicesObj.rootContainer = a_displayObjCont;
			}
			else
			{
				trace("BoredServices::setRootContainer(" + a_displayObjCont + "): _servicesObj=" + _servicesObj);
			}
			
		}//end setRootContainer()
		
		private static function onLoggedIn(a_evt:Event = null):void
		{
			_loggedIn = true;
			BoredServices.dispatchEvent(new Event(BoredServices.LOGGED_IN_EVENT));
			
		}//end onLoggedIn()
		
		public static function showLoginUI(a_options:Object = null):void
		{
			if(_servicesObj)_servicesObj.showLoginUI(a_options);
			
		}//end showLoginUI()
		
		public static function showMainLoginUI():void
		{
			if (_servicesObj)_servicesObj.showMainLoginUI();
			
		}//end showMainLoginUI()
		
		public static function hideLoginUI():void
		{
			if (_servicesObj)_servicesObj.hideLoginUI();
			
		}//end hideLoginUI()
		
		public static function setData(a_key:String, a_data:*):void
		{
			if(_servicesObj)_servicesObj.setData(a_key, a_data);
			
		}//end setData()
		
		public static function getData(a_key:String):void
		{
			if (_servicesObj)
			{
				_servicesObj.addEventListener(BoredServices.SAVED_DATA_RECEIVED_EVT, onGetDataComplete, false, 0, true);
				_servicesObj.getData(a_key);
			}
			
		}//end getData()
		
		private static function onGetDataComplete(objEvt:*):void
		{
			var recdObj:Object = objEvt.obj;
			var keyRequest:String = recdObj ? recdObj.key : null;
			var dataAcquired:* = recdObj ? recdObj.data : null;
			
			BoredServices.dispatchEvent(new DataReceivedEvent(BoredServices.SAVED_DATA_RECEIVED_EVT, keyRequest, dataAcquired));
			
		}//end onGetDataComplete()
		
		public static function showAchievements():void
		{
			if (_servicesObj)
			{
				if (!BoredServices.isLoggedIn)
				{
					BoredServices.showMainLoginUI();
					return;
				}
				
				_servicesObj.showAchievements();
			}
			
		}//end showAchievements()
		
		public static function showLeaderboard():void
		{
			if (_servicesObj)
			{
				if (!BoredServices.isLoggedIn)
				{
					BoredServices.showMainLoginUI();
					return;
				}
				
				_servicesObj.showLeaderboard();
			}
			
		}//end showLeaderboard()
		
		public static function submitAchievementAcquired(a_achievementScoreCode:String = null, a_showNewAchievementsPopup:Boolean = false):void
		{
			if (_servicesObj)
			{
				if (!BoredServices.isLoggedIn)
				{
					BoredServices.showMainLoginUI();
					return;
				}
				
				if (a_showNewAchievementsPopup)
				{
					_servicesObj.addEventListener(BoredServices.SCORE_SUBMISSION_COMPLETE_EVT, showNewAchievementsOnScoreSubmission, false, 0, true);
				}
				
				_servicesObj.submitScore(1, a_achievementScoreCode);
			}
			
		}//end submitAchievementScore()
		
		public static function submitScore(a_score:*, a_showLeaderboardOnComplete:Boolean = true, a_scoreCode:String = null, a_showNewAchievementsPopup:Boolean = false):void
		{
			if (_servicesObj)
			{
				if (!BoredServices.isLoggedIn)
				{
					BoredServices.showMainLoginUI();
					return;
				}
				
				if (a_showLeaderboardOnComplete)
				{
					_servicesObj.addEventListener(BoredServices.SCORE_SUBMISSION_COMPLETE_EVT, showLeaderboardOnScoreSubmission, false, 0, true);
				}
				
				_servicesObj.submitScore(a_score, a_scoreCode);
			}
			
		}//end submitScore()
		
		/**
		 * 
		 * @param	a_evt:	<ObjectEvent> Event with property 'obj', which, if valid, is an Array of newly-awarded achievements based on the submission that this is a response to.
		 * 					Achievement objects have the following structure:
		 * 					{
		 * 						name:				<String>
		 * 						description:		<String>
		 * 						earned:				<Boolean>
		 * 						earnedImageUrl:		<String>
		 * 						unearnedImageUrl:	<String>
		 * 					}
		 */
		private static function showNewAchievementsOnScoreSubmission(a_evt:Event):void
		{
			if (_servicesObj)
			{
				_servicesObj.removeEventListener(BoredServices.SCORE_SUBMISSION_COMPLETE_EVT, showLeaderboardOnScoreSubmission);
				
				if (!BoredServices.isLoggedIn)
				{
					BoredServices.showMainLoginUI();
					return;
				}
				
				var achievementsArr:Array = (a_evt as Object).obj;
				
				if (achievementsArr && achievementsArr.length)
				{
					_servicesObj.showAchievements(achievementsArr);
				}
			}
			
		}//end showNewAchievementsOnScoreSubmission()
		
		private static function showLeaderboardOnScoreSubmission(a_evt:Event):void
		{
			if (_servicesObj)
			{
				_servicesObj.removeEventListener(BoredServices.SCORE_SUBMISSION_COMPLETE_EVT, showLeaderboardOnScoreSubmission);
			}
			
			showLeaderboard();
			
		}//end showLeaderboardOnScoreSubmission()
		
		public static function getGameInfo(a_callback:Function = null):void
		{
			if (!_servicesObj)
			{
				return;
			}
			
			if (null != a_callback)
			{
				//proxyDispatcher.addEventListener(BoredServices.SAVED_DATA_RECEIVED_EVT, a_callback);
				BoredServices.addEventListener(BoredServices.SAVED_DATA_RECEIVED_EVT, a_callback);
			}
			_servicesObj.addEventListener(BoredServices.GAME_INFO_READY_EVT, onGameInfoReceived, false, 0, true);
			_servicesObj.getGameInfo();
			
		}//end getGameInfo()
		
		private static function onGameInfoReceived(a_objEvt:*):void
		{
			var gameInfoObj:Object = a_objEvt.obj;
			
			//BoredServices.dispatchEvent(new ObjectEvent(BoredServices.SAVED_DATA_RECEIVED_EVT, gameInfoObj) );
			
		}//end onGameInfoReceived()
		
		public static function get isLoggedIn():Boolean
		{
			return _loggedIn;
			
		}//end isLoggedIn()
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			proxyDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
		}//end addEventListener()
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			proxyDispatcher.removeEventListener(type, listener, useCapture);
			
		}//end removeEventListener()
		
		public static function dispatchEvent(event:Event):Boolean
		{
			return proxyDispatcher.dispatchEvent(event);
			
		}//end dispatchEvent()

		// Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
		public function hasEventListener(type:String):Boolean
		{
			return proxyDispatcher.hasEventListener(type);
			
		}//end hasEventListener()
		
		public function willTrigger(type:String) : Boolean
		{
			return proxyDispatcher.willTrigger(type);
			
		}//end willTrigger()
		
		private static function get proxyDispatcher():EventDispatcher
		{
			if (!_proxyDispatcher)
			{
				_proxyDispatcher = new EventDispatcher();
			}
			
			return _proxyDispatcher;
			
		}//end get proxyDispatcher()
		
		private static function redispatch(a_evt:Event):void
		{
			BoredServices.dispatchEvent(a_evt);
			
		}//end redispatch()
		
	}//end class BoredServices
	
}//end package com.bored.services
