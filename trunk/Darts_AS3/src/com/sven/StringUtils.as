package com.sven 
{
	/**
	 * ...
	 * @author sam
	 */
	public class StringUtils
	{
		public static function walkObj(a_obj:Object, a_spacer:String = "--"):void
		{
			for(var str:String in a_obj)
			{
				var output:String = a_spacer + " " + str + " = " + a_obj[str];
				trace(output);
				
				if(a_obj[str] is Object)
				{
					walkObj(a_obj[str], a_spacer + "--");
				}
			}
		}
		
	}

}