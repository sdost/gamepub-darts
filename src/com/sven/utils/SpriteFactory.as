package com.sven.utils 
{
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author sam
	 */
	public class SpriteFactory
	{
		public static function getSpriteByQualifiedName(a_str:String):Sprite
		{
			var spr:Sprite = null;
			
			try {
				var cls:Class = getDefinitionByName(a_str) as Class;
				spr = new cls();
			} catch ( e:Error ) {
				trace("SpriteFactory::getSpriteByQualifiedName(): " + e.message);
			}
			
			return spr;
		}//end getSpriteByQualifiedName()
		
	}//end ObjectFactory

}//end com.sven.utils