package com.sven.utils
{
	import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
    
	import flash.utils.Proxy;
    import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	
	import mx.events.PropertyChangeEvent;
    import mx.events.PropertyChangeEventKind;
		
	use namespace flash_proxy;
	
	/**
	 * The AppSettings class is a singleton that holds a set of configuration
	 * settings. Each setting consists of a key and a corresponding value.
	 * 
	 * The settings can be accessed (get and set) like properties of the
	 * AppSettings class.
	 * 
	 * To add a setting or change the value of an existing setting, simply
	 * define it as a property as follows:
	 * <pre>AppSettings.getInstance().mySetting = "myValue";</pre>
	 * 
	 * To get a setting, request it as a property:
	 * <pre>var result:String = AppSettings.getInstance().mySetting;</pre>
	 * 
	 * @author Samuel Dost (sam@inassets.com)
	 */
	[Bindable("propertyChange")]
	dynamic public class AppSettings extends Proxy implements IEventDispatcher
	{
		private static var _instance:AppSettings;
		
		private var _loader:URLLoader;
		
		private var _settings:Object;
		private var _dispatcher:EventDispatcher;
		
		/**
		 * Constructs a new instance of AppSettings. 
		 * 
		 * Since this class is a singleton, the constructor should
		 * never be called directly. (This is made impossible with the instance
		 * of the internal SingletonEnforcer class that needs to passed.)
		 * To instantiate this class, call the static getInstance() method.
		 * 
		 * @param enforcer An instance of the internal SingletonEnforcer class
		 * to enforce a singleton
		 * @throws Error when instantiating with a 'null' argument
		 */
		public function AppSettings(enforcer:AppSettingsSingletonEnforcer = null) 
		{
			if (!enforcer)
				throw new Error("Unable to instantiate a singleton class using constructor. Use instance property.");
			
			initAppSettings();
		}//end constructor()
		
		/**
		 * Property accessor method for the singleton instance of AppSettings.
		 * 
		 * @return instance The singleton instance of this class.
		 */
		public static function get instance():AppSettings {
			if (_instance == null) {
				_instance = new AppSettings(new AppSettingsSingletonEnforcer());
			}
			return _instance;
		}//end get instance()
		
		private function initAppSettings():void
		{
			_settings = { };
			_dispatcher = new EventDispatcher(this);
		}//end iniAppSettings()
		
		/**
		 * Loads an xml file or data containing the key/value pairs for the settings
		 * and fills the AppSettings. The settings loaded from the xml file are
		 * added to the existing settings and settings with the same key are
		 * replaced by the new settings in the xml file.
		 * 
		 * The xml file can have any name you like or could even be generated
		 * dynamically. The structure of the nodes should look as follows:
		 * <appsettings>
		 *   <add key="myFirstSetting" value="aValue"/>
		 *   <add key="mySecondSetting" value="anotherValue"/>
		 * </appsettings>
		 * 
		 * @param source The location of the xml file that contains the appsettings.
		 */
		public function load(source:*):void {
			if (source is String) {
				loadFromFile(source);
			}
			else if(source is XML) {
				parseSettingsFromXml(source);
			}
		}
		
		private function compileValue(type:String, val:*):*
		{
			switch(type) {
				case "int":
					return int(val);
				case "Number":
					return Number(val);
				case "String":
					return String(val);
				case "Class":
					return getDefinitionByName(val);
			}
		}
		
		//---------------------------------------------------------------------
		// IEventDispatcher implementation
		//---------------------------------------------------------------------
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference); 
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _dispatcher.dispatchEvent(event);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}
		//---------------------------------------------------------------------
		
		//---------------------------------------------------------------------
		// Proxy implementation
		//---------------------------------------------------------------------
		/**
		 * Returns the value that matches the setting with the given name.
		 * 
		 * @param name The name of the setting you want to receive.
		 * @returns The value of the setting with the given name. If the key
		 * does not exist, undefined is returned.
		 */
		flash_proxy override function getProperty(name:*):* 
		{
			return _settings[name];
		}
		
		/**
		 * Sets a property.
		 */
		flash_proxy override function setProperty(name:*, value:*):void 
		{
			var oldValue:* = _settings[name];
            _settings[name] = value;
            var kind:String = PropertyChangeEventKind.UPDATE;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, kind, name, oldValue, value, this));
		}
		
		//---------------------------------------------------------------------
		
		/**
		 * Loads settings from an external xml file.
		 * 
		 * @param url The location of the xml file that contains the settings.
		 */
		private function loadFromFile(url:String):void {
			var request:URLRequest = new URLRequest(url);
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, xmlLoader_Complete);
			_loader.load(request);
		}

		/**
		 * Handles the Complete event of the URLLoader instance that loads
		 * the XML data with the settings.
		 */
		private function xmlLoader_Complete(event:Event):void {
			parseSettingsFromXml(XML(_loader.data));
			dispatchEvent(new Event(Event.COMPLETE, true, true));
		}
		
		/**
		 * Parses the settings from the given XML instance.
		 * 
		 * @param xml The XML object that contains the settings.
		 */
		private function parseSettingsFromXml(xml:XML):void {
			for each(var i:XML in xml.add) {
				_settings[i.@key] = compileValue(i.@type, i.@value);
			}
		}
		
	}//end AppSettings
	
}//end com.sven.utils

class AppSettingsSingletonEnforcer {}