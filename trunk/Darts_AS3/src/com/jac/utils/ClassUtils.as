/*
SoundManger Copyright 2009 Hook L.L.C.
For licensing questions contact hook: http://www.byhook.com

 This file is part of SoundManger.

SoundManger is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
at your option) any later version.

SoundManger is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SoundManger.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.jac.utils
{
	import flash.utils.*;
	
	/**
	 * Utility class to help deal with classes.
	 */
	public class ClassUtils
	{//GetClassName Class
		
		/**
		 * Returns the name of the class associated with the specified object.
		 * @param	myObj the object to retrieve the class name from.
		 * @return returns a string representing the name of the class of the specified object.
		 */
		static public function getClassName(myObj:Object):String
		{//getClassName
			var tokens:Array;
			var fullClassName:String = getQualifiedClassName(myObj);
			tokens = fullClassName.split("::");
			return tokens[tokens.length - 1];
		}//getClassName
	
	}//GetClassName Class
}