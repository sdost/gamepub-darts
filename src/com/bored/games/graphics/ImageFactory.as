package com.bored.games.graphics 
{
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ImageFactory
	{
		public static function getBitmapDataByQualifiedName(a_str:String, a_width:uint, a_height:uint):BitmapData
		{
			var bmp:BitmapData = null;
			
			try {
				var cls:Class = getDefinitionByName(a_str) as Class;
				bmp = new cls(a_width, a_height);
			} catch ( e:Error ) {
				trace("ImageFactory::getBitmapDataByQualifiedName(): " + e.message);
			}
			
			return bmp;
		}//end getBitmapDataByQualifiedName()
		
	}//end ImageFactory

}//end com.bored.games.graphics