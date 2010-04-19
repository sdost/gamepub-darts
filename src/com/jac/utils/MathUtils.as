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
	 * A utility class to make common math functions more convenient.
	 */
	public class MathUtils 
	{//MathUtils class
		
		/**
		 * Determines if <code>value</code> is within a certain range around <code>targetNum</code>
		 * 
		 * @param	value		the value to check the range of.
		 * @param	targetNum	the number that <code>value</code> needs to be in range of.
		 * @param	threshold	how far from <code>targetNum</code> <code>value</code> can be and still be within range.
		 * 
		 * @return	return <code>true</code> if within range, <code>false</code> otherwise.
		 */
		static public function isWithinThreshold(value:Number, targetNum:Number, threshold:Number):Boolean
		{//isWithinThreshold
			if (Math.abs(value - targetNum) <= threshold)
			{//true
				return true;
			}//true
			else
			{//false
				return false;
			}//false
		}//isWithinThreshold
		
		/**
		 * Clamps <code>value</code> to be within <code>minVla</code> and <code>maxVal</code>.
		 * @param	minVal the lowest <code>value</code> can be.
		 * @param	maxVal the highest <code>value</code> can be.
		 * @param	value  the value to clamp.
		 *
		 * @return	Returns <code>minVal</code> if <code>value</code> is lower than <code>minVal</code>.  Returns <code>maxVal</code> if <code>value</code> is higher than <code>maxVal</code>.  Returns <code>value</code> otherwise.
		 */
		static public function clamp(minVal:Number, maxVal:Number, value:Number):Number
		{//clamp
			if (value > maxVal)
			{//max
				return maxVal;
			}//max
			else if (value < minVal)
			{//min
				return minVal;
			}//min
			else
			{//value
				return value;
			}//value
		}//clamp
		
		/**
		 * Clamps the value based on <code>value</code>'s absolute value, and then the sign is re-applied after the clamping.
		 * So if <code>minVal</code> is 5 and <code>maxVal</code> is 10 and <code>value</code> is -13 the returned value is -10;
		 * If <code>value</code> was -4, -4 is returned.  If <code>value</code> was 6, 6 is returned.
		 * @param	minVal the lowest <code>value</code> can be.
		 * @param	maxVal the highest <code>value</code> can be.
		 * @param	value  the value to clamp.
		 * 
		 * @return 	returns the clamped value with the sign re-applied.
		 */
		static public function clampUnsignedCompare(minVal:Number, maxVal:Number, value:Number):Number
		{//clampNoSign
			var sign:int;
			var val:Number = Math.abs(value);
			
			//get sign
			if (value < 0)
			{//negative
				sign = -1;
			}//negative
			else
			{//positive
				sign = 1;
			}//positive
			
			if (val > maxVal)
			{//max
				return maxVal * sign;
			}//max
			else if (val < minVal)
			{//min
				return minVal * sign;
			}//min
			else
			{//value
				return value;
			}//value
		}//clampNoSign
	}//MathUtils Class
	
}