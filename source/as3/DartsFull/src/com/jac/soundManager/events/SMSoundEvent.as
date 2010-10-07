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
	
	public class SMSoundEvent extends Event 
	{
		static public const GLOBAL_PAUSE:String = "smSoundGlobalPause";
		static public const PAUSE:String = "smSoundPause";
		static public const GLOBAL_PLAY:String = "smSoundGlobalPlay";
		static public const PLAY:String = "smSoundPlay";
		static public const GLOBAL_RESUME:String = "smSoundGlobalResume";
		static public const RESUME:String = "smSoundResume";
		static public const GLOBAL_STOP:String = "smSoundGlobalStop";
		static public const STOP:String = "smSoundStop";
		static public const GLOBAL_MUTE:String = "smSoundGlobalMute";
		static public const MUTE:String = "smSoundMute";
		static public const GLOBAL_UNMUTE:String = "smSoundGlobalUnMute";
		static public const UNMUTE:String = "smSoundUnMute";
		
		public var soundObject:*;
		
		public function SMSoundEvent(type:String, soundObj:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			soundObject = soundObj;
		} 
		
		public override function clone():Event 
		{ 
			return new SMSoundEvent(type, soundObject, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SMSoundEvent", "type", "soundObject", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}