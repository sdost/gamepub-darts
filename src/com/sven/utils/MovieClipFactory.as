package com.sven.utils 
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author sam
	 */
	public class MovieClipFactory
	{
		public static function getMovieClipByQualifiedName(a_str:String):MovieClip
		{
			var mc:MovieClip = null;
			
			try {
				var cls:Class = getDefinitionByName(a_str) as Class;
				mc = new cls();
			} catch ( e:Error ) {
				trace("MovieClipFactory::getMovieClipByQualifiedName(): " + e.message);
			}
			
			return mc;
		}//end getMovieClipByQualifiedName()
		
	}//end ObjectFactory

}//end com.sven.utils