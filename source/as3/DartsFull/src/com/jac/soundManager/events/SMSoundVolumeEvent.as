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
package com.jac.soundManager.events 
{
	import com.jac.soundManager.ISMSound;
	import flash.events.Event;
	
	public class SMSoundVolumeEvent extends Event 
	{
		
		static public const VOLUME_CHANGE:String = "smSoundVolumeChange";
		static public const ALL_VOLUME_PERCENT_CHANGE:String = "smSoundAllVolumePercentChange";
		
		public var volume:Number;
		public var soundObject:*;
		
		public function SMSoundVolumeEvent(type:String, soundObj:*, newVol:Number, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			volume = newVol;
			soundObject = soundObj;
		} 
		
		public override function clone():Event 
		{ 
			return new SMSoundVolumeEvent(type, soundObject, volume, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SMSoundVolumeEvent", "type", "soundObject", "volume", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}