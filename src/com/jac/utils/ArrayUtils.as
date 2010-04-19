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
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import com.jac.utils.ArraySearchObject;
	
	/**
	 * A utility class that contains methods to make arrays more convenient to use.
	 * <br/>Please be aware that these are under constant development and may not be fully tested.
	 */
	public class ArrayUtils 
	{//ArrayUtils Class
		
		/**
		 * Returns an ArraySearchObject of the fist occurance of <code>objToFind</code> in the specified array.
		 * 
		 * @param	array the list to seach through.
		 * @param	objToFind the object to search for in the list.
		 * @return	Returns a new ArraySearchObject with the index and object reference to the fist occurance of the <code>objToFind</code> in the specified array.  If there is nothing found, the index property is -1 and the objRef property is null.
		 */
		static public function findFirstInArray(array:Array, objToFind:Object):ArraySearchObject
		{//findFirstInArray
			var obj:Object = null;
			var result:ArraySearchObject;
			var count:int = -1;
			
			for (var i:int = 0; i < array.length; i++)
			{//find
				if (array[i] == objToFind) 
				{//found
					obj = array[i];
					count = i;
					break;
				}//found
			}//find
			
			if (obj == null)
			{//not found
				trace("Obj: " + objToFind + " not found in specified array");
			}//not found
			result = new ArraySearchObject(count, obj);
			
			return result;
		}//findFirstInArray
		
		/**
		 * Returns an array of ArraySearchObjects that reference occurances of <code>objToFind</code> in the specified list.
		 * @param	array the list to search through.
		 * @param	objToFind the object to search for in the list.
		 * @return	Returns a list of ArraySearchObjects with the index and object reference to each occurance of the <code>objToFind</code> in the specified array.  If the object is not found the returned list is of 0 length.
		 * 
		 * @see com.jac.utils.ArraySearchObject ArraySearchObject
		 */
		static public function findInArray(array:Array, objToFind:Object):Array
		{//findInArray
			var list:Array = new Array();
			
			for (var i:int = 0; i < array.length; i++)
			{//find
				if (array[i] == objToFind) 
				{//found
					list.push(new ArraySearchObject(i, array[i]));
				}//found
			}//find
			
			return list;
		}//findInArray
		
		/**
		 * Returns a list of ArraySearchObjects that contain references to objects with the specified property that equals <code>value</code>.
		 * @param	array list to search through.
		 * @param	property the name of the property to compare to <code>value</code>.
		 * @param	value the value of the property to find in the specified array.
		 * @return 	an array of ArraySearchObjects.  If none is found, an array with 0 length is returned.
		 *
		 * @see com.jac.utils.ArraySearchObject ArraySearchObject
		 */
		static public function findObjectsWithPropertyInArray(array:Array, property:String, value:Object):Array
		{//findObjectWithProperty
		
			var list:Array = new Array();
			var result:ArraySearchObject;
			
			for (var i:int = 0; i < array.length; i++)
			{//find
				if (array[i][property])
				{//check
					if (array[i][property] == value)
					{//found
						list.push(new ArraySearchObject(i, array[i]));
					}//found
				}//check
			}//find
			
			return list;
		}//findObjectWithProperty
		
		/**
		 * Returns the first occurance of an object with the specified property that equals <code>value</code>.
		 * @param	array the list to search through.
		 * @param	property the name of the property to compare to <code>value</code>.
		 * @param	value the value to compare to the object's property value.
		 * @return	an ArraySearchObject that containes the index and object reference to the found item.  If no items are found the objectRef property is null and the index is set to -1.
		 */
		static public function findFirstObjectWithPropertyInArray(array:Array, property:String, value:Object):ArraySearchObject
		{//findFirstObjectWithPropertyInArray
		
			var obj:Object = null
			var result:ArraySearchObject;
			var count:int = -1;
			
			for (var i:int = 0; i < array.length; i++)
			{//find
				if (array[i][property])
				{//check
					if (array[i][property] == value)
					{//found
						obj = array[i];
						count = i;
						break;
					}//found
				}//check
			}//find
			
			return new ArraySearchObject(count, obj);
		}//findFirstObjectWithPropertyInArray
		
		/**
		 * Returns a list of ArraySearchObjects that contain the index and reference to objects that match the specfied class name.
		 * <br/>Please note that this only matches against direct types and not inherited types.
		 * 
		 * @param	array	the list to search through.
		 * @param	className a string that represents the name of the class to search for.
		 * @return	returns a list of ArraySearchObjects.  If no match is found, an array of 0 length will be returned.
		 */
		static public function findObjectsOfType(array:Array, className:String):Array
		{//findObjectsOfType
			var list:Array = new Array();
			
			for (var i:int = 0; i < array.length; i++)
			{//find
				if (getClassName(array[i]) == className)
				{//found
					list.push(new ArraySearchObject(i, array[i]));
					//list.push(array[i]);
				}//found
			}//find
			
			return list;
		}//findObjectsOfType
		
		/**
		 * Removes the first occurance of a matching object from the list. (Shortens the array)
		 * @param	array list to remove object from
		 * @param	objectToRemove the object to find and remove
		 * @return	returns <code>true</code> if the object was found and removed, <code>false</code> otherwise.
		 */
		static public function removeFirstFromArray(array:Array, objectToRemove:Object):Boolean
		{//removeFirstFromList
			for (var i:int = 0; i < array.length; i++)
			{//find
				if (array[i] == objectToRemove)
				{//remove
					array.splice(i, 1);
					return true;
				}//remove
			}//find
			
			return false;
		}//removeFirstFromList
		
		/**
		 * @private
		 * @param	array
		 * @param	objectToRemove
		 * @return
		 */
		static public function removeAllFromArray(array:Array, objectToRemove:Object):int
		{//removeAllFromArray
			//NYI
			return 0;
		}//removeallFromArray
		
		/**
		 * Counts the number of objects in an accociative array.
		 * @param	array list to count.
		 * @return  the length of the associative array.
		 */
		static public function countAssocArray(array:Array):int
		{//countAssocArray
			var count:int = 0;
			
			for each (var obj:* in array)
			{//count
				count++;
			}//count
			
			return count;
		}//countAssocArray
		
		/**
		 * Traces out each of the objects in the array and the value of the specified property.
		 * @param	array the list of objects to trace.
		 * @param	prop the name of the property to trace out.
		 * @param	startIndex the index to start the tracing at, defaults to 0.
		 * @param	endIndex the last index to trace out, defaults to -1 (which means last index in the list)
		 */
		static public function traceArray(array:Array, prop:String, startIndex:int = 0, endIndex:int = -1 ):void 
		{//traceArray
			var count:int = 0;
			
			for each (var obj:* in array)
			{//show each
				if (count >= startIndex)
				{//show it
					if (endIndex == -1 || count <= endIndex)
					{//trace
						try
						{//good?
							trace(obj + ": " + obj[prop]);
						}//good?
						catch (error:Error)
						{//bad
							trace("traceArray: Could not trace " + prop + " at index " + count);
						}//bad
					}//trace
				}//show it
				count++;
			
			}//show each
		}//traceArray
		
		/**
		 * Traces out all of the direct property names and values of each object in the specified array.
		 * <br/>Please note that this traces only the direct properties, not any of the inherited properties.
		 * See traceArrayAllProps() to trace out inherited properties as well.
		 * @param	array the list of objects to trace out.
		 * @param	startIndex the first index to start tracing.  Defaults to 0.
		 * @param	endIndex the last index to trace out.  Defaults to -1 which means the last index in the list.
		 * 
		 * @see #traceArrayAllProps()
		 */
		static public function traceArrayProps(array:Array, startIndex:int = 0, endIndex:int = -1 ):void
		{//traceArray
			var typeXMLList:XMLList;
			
			var count:int = 0;
			for each (var obj:* in array)
			{//show each
				if (count >= startIndex)
				{//show it
					if (endIndex == -1 || count <= endIndex)
					{//trace
						if (obj)
						{//show
							var fullClassName:String = getQualifiedClassName(obj);
							//get props
							typeXMLList = describeType(obj).accessor.(@declaredBy == fullClassName);
							
							//walk props list
							for each(var prop:XML in typeXMLList)
							{//walk props
								
								//do trace
								try
								{//try
									var propName:String = prop.@name;
									var propVal:* = obj[propName];
									trace("index:" + count +": " + obj + "." + propName + " = " + propVal);
								}//try
								catch (error:Error)
								{//error
									trace("traceArrayProps: Could not trace " + obj + "." + prop.@name);
								}//error
							}//walk props
						}//show
						else
						{//error
							trace("traceArrayDynamicProps: Bad Obj");
						}//error
					}//trace
				}//show it
				count++;
			
			}//show each
		}//traceArray
		
		/**
		 * Traces out all of the property names and values of each object in the specified array, including the inherited properties.
		 * 
		 * <br/>To trace only direct properties see traceArrayProps()
		 * 
		 * @param	array the list of objects to trace out.
		 * @param	startIndex the first index to start tracing.  Defaults to 0.
		 * @param	endIndex the last index to trace out.  Defaults to -1 which means the last index in the list.
		 * 
		 * @see #traceArrayProps()
		 */
		static public function traceArrayAllProps(array:Array, startIndex:int = 0, endIndex:int = -1 ):void
		{//traceArray
			var typeXMLList:XMLList;
			
			var count:int = 0;
			trace("Dyn Props");
			for each (var obj:* in array)
			{//show each
				if (count >= startIndex)
				{//show it
					if (endIndex == -1 || count <= endIndex)
					{//trace
						if (obj)
						{//show
							var fullClassName:String = getQualifiedClassName(obj);
							//get props
							typeXMLList = describeType(obj).accessor;
							
							//walk props list
							for each(var prop:XML in typeXMLList)
							{//walk props
								
								//do trace
								try
								{//try
									var propName:String = prop.@name;
									var propVal:* = obj[propName];
									trace("index:" + count +": " + obj + "." + propName + " = " + propVal);
								}//try
								catch (error:Error)
								{//error
									trace("traceArrayAllProps: Could not trace " + obj + "." + prop.@name);
								}//error
							}//walk props
						}//show
						else
						{//error
							trace("traceArrayDynamicProps: Bad Obj");
						}//error
					}//trace
				}//show it
				count++;
			
			}//show each
		}//traceArray
		
		/**
		 * @private
		 * @param	myObj
		 * @return
		 */
		static internal function getClassName(myObj:Object):String
		{//getClassName
			var tokens:Array;
			var fullClassName:String = getQualifiedClassName(myObj);
			tokens = fullClassName.split("::");
			return tokens[tokens.length - 1];
		}//getClassName
		
		
	}//ArrayUtils Class
	
}