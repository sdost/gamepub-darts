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
	
	public class SMSoundCompleteEvent extends Event 
	{
			
		static public const SMSOUND_COMPLETE:String = "smSoundComplete";
		static public const SMSOUND_LOOPS_COMPLETE:String = "smSoundLoopsComplete";
		
		public var sound:ISMSound;
		
		public function SMSoundCompleteEvent(type:String, soundObj:ISMSound, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			sound = soundObj;
			
		} 
		
		public override function clone():Event 
		{ 
			return new SMSoundCompleteEvent(type, sound, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SMSoundCompleteEvent", "type", "_sound", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}