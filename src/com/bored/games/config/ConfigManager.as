package com.bored.games.config 
{
	import com.adobe.webapis.URLLoaderBase;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import laan.xml.PlistParser;
	/**
	 * ...
	 * @author sam
	 */
	public class ConfigManager
	{
		public static const CONFIG_READY:String = "configReady";
		
		private static var _configXML:XML;
		private static var _parsedConfigXML:XML;
		
		public static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public static function loadConfig(a_string:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoadComplete, false, 0, true);
			loader.load(new URLRequest(a_string));
		}//end loadConfig()
		
		private static function xmlLoadComplete(a_evt:Event):void
		{
			_configXML = new XML(a_evt.target.data);
			_parsedConfigXML = PlistParser.parsePlist(_configXML);
			dispatcher.dispatchEvent(new Event(ConfigManager.CONFIG_READY));
		}//end xmlLoadComplete()
		
		public static function getConfigNamespace(a_name:String):XML
		{
			return _parsedConfigXML.child(a_name)[0];
		}//end getConfigNamespace()
		
		public static function get config():XML
		{
			return _parsedConfigXML;
		}//end get config()
		
	}//end ConfigManager

}//end com.bored.games.config