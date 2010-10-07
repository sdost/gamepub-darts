package com.bored.games.darts.animations 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author sam
	 */
	public class CutsceneManager
	{
		private static var _instance:CutsceneManager;
		
		private var _cutscenes:Dictionary;
		
		public function CutsceneManager(enforcer:CutsceneManagerSingletonEnforcer = null) 
		{
			if (!enforcer)
				throw new Error("Unable to instantiate a singleton class using constructor. Use instance property.");
				
			_cutscenes = new Dictionary(false);
		}//end constructor()
		
		public static function get instance():CutsceneManager
		{
			if (_instance == null) {
				_instance = new CutsceneManager(new CutsceneManagerSingletonEnforcer());
			}
			return _instance;
		}//end get instance()
		
		public function loadScript(a_file:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadScript);
			loader.load( new URLRequest(a_file) );
		}//end loadScript()
		
		private function onLoadScript(a_evt:Event):void
		{
			var xml:XML = new XML(a_evt.target.data);			
			addScene( new Cutscene(xml) );
		}//end onLoadScript()
		
		public function addScene(a_script:Cutscene):void
		{
			_cutscenes[a_script.sceneName] = a_script;
		}//end addScene()
		
		public function getScene(a_name:String):Cutscene
		{
			return _cutscenes[a_name] as Cutscene;
		}//end getScene()
		
	}//end CutsceneManager

}//end com.bored.games.animations

class CutsceneManagerSingletonEnforcer {}