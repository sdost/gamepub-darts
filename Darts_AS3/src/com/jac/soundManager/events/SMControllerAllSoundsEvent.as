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
	import com.jac.soundManager.SoundController;
	import flash.events.Event;
	
	public class SMControllerAllSoundsEvent extends Event 
	{
		
		static public const PAUSE_ALL:String = "smControllerAllSoundsEventPauseAll";
		static public const RESUME_ALL:String = "smControllerAllSoundsEventResumeAll";
		static public const PLAY_ALL:String = "smControllerAllSoundsEventPlayAll";
		static public const STOP_ALL:String = "smControllerAllSoundsEventStopAll";
		static public const MUTE_ALL:String = "smControllerAllSoundsEventMuteAll";
		static public const UNMUTE_ALL:String = "smControllerAllSoundsEventUnMuteAll";
		
		
		public var soundController:SoundController;
		
		public function SMControllerAllSoundsEvent(type:String, soundControllerObj:SoundController, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			soundController = soundControllerObj;
			
		} 
		
		public override function clone():Event 
		{ 
			return new SMControllerAllSoundsEvent(type, soundController, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SMControllerAllSoundsEvent", "type", "soundController", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}