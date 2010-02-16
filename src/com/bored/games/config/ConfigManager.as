package com.bored.games.config 
{
	import com.adobe.webapis.URLLoaderBase;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import laan.xml.PlistParser;
	/**
	 * ...
	 * @author sam
	 */
	public class ConfigManager
	{
		private static var _configXML:XML;
		private static var _parsedConfigXML:XML;
		
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
		}//end xmlLoadComplete()
		
		public static function getConfigNamespace(a_name:String):XML
		{
			return _parsedConfigXML.child(a_name)[0];
		}//end getConfigNamespace()
		
	}//end ConfigManager

}//end com.bored.games.config