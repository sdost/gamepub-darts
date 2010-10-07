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
	/**
	 * A result object for array searches used in the ArrayUtils class.
	 * 
	 * @see com.jac.utils.ArrayUtils ArrayUtils
	 */
	public class ArraySearchObject extends Object
	{//ArraySearchObject class
	
		private var _index:int;
		private var _objRef:Object;
	
		/**
		 * Constructor for creating a new ArraySearchObject.
		 * @param	index	the index of the located object.
		 * @param	objRef	a reference to the located object.
		 * 
		 * @see com.jac.utils.ArrayUtils ArrayUtils
		 */
		public function ArraySearchObject(index:int, objRef:Object) 
		{//ArraySearchObject
			_index = index;
			_objRef = objRef;
		}//ArraySearchObject
		
		/**
		 * Index of the located object.
		 */
		public function get index():int { return _index; }
		
		/**
		 * Reference to the located object.
		 */
		public function get objRef():Object { return _objRef; }
		
	}//ArraySearchObject

}