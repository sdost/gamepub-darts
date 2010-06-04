package com.bored.games.darts.skins 
{
	import away3dlite.containers.ObjectContainer3D;
	import away3dlite.materials.BitmapMaterial;
	import away3dlite.materials.Material;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author sam
	 */
	public class DartSkin
	{
		public var skinid:String;
		public var flightid:String;
		
		protected var _dartMaterial:BitmapMaterial;
		protected var _shaftModelXML:XML;
		protected var _flightModelXML:XML;
		
		public function DartSkin(a_bitmapData:BitmapData, a_shaftXML:XML, a_flightXML:XML) 
		{			
			_dartMaterial = new BitmapMaterial(a_bitmapData);
			_dartMaterial.repeat = false;
			_dartMaterial.smooth = true;
			
			_shaftModelXML = a_shaftXML;
			
			_flightModelXML = a_flightXML;
		}//end constructor()
		
		public function get material():BitmapMaterial
		{
			return _dartMaterial;
		}//end get material()
		
		public function get shaft():XML
		{
			return _shaftModelXML;
		}//end get shaft()
		
		public function get flight():XML
		{
			return _flightModelXML;
		}//end get flight()
		
	}//end DartSkin

}//end com.bored.games.darts.skins