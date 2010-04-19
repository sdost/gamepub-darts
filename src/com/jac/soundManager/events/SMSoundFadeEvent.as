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
	
	public class SMSoundFadeEvent extends Event 
	{
		
		static public const VOLUME_FADE_START:String = "smSoundVolumeFadeStart";
		static public const VOLUME_FADE_UPDATE:String = "smSoundVolumeFadeUpdate";
		static public const VOLUME_FADE_COMPLETE:String = "smSoundVolumeFadeComplete";
		
		static public const VOLUME_FADE_START_ALL:String = "smSoundVolumeFadeStartAll";
		static public const VOLUME_FADE_UPDATE_ALL:String = "smSoundVolumeFadeUpdateAll";
		static public const VOLUME_FADE_COMPLETE_ALL:String = "smSoundVolumeFadeCompleteAll";
		
		
		static public const PAN_FADE_START:String = "smSoundPanFadeStart";
		static public const PAN_FADE_UPDATE:String = "smSoundPanFadeUpdate";
		static public const PAN_FADE_COMPLETE:String = "smSoundPanFadeComplete";
		
		public var sound:ISMSound;
		
		public function SMSoundFadeEvent(type:String, soundObj:ISMSound, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			sound = soundObj;
		} 
		
		public override function clone():Event 
		{ 
			return new SMSoundFadeEvent(type, sound, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SMSoundFadeEvent", "type", "sound", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}