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
package com.jac.soundManager 
{
	import com.jac.soundManager.events.SMSoundEvent;
	import com.jac.soundManager.events.SMSoundCompleteEvent;
	import com.jac.soundManager.events.SMSoundVolumeEvent;
	import com.jac.utils.ClassUtils;
	import com.jac.utils.MathUtils;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	import com.jac.soundManager.ISMSound;
	
	/**
	* Dispatched when this sound has finished playing the current repeat loop.
	* 
	* @eventType com.jac.soundManager.events.SMSoundCompleteEvent.SOUND_COMPLETE
	*/
	[Event("SOUND_COMPLETE", type = "com.jac.soundManager.events.SMSoundCompleteEvent")]
	
	/**
	* Dispatched when this sound has finished playing all repeat loops.
	* 
	* @eventType com.jac.soundManager.events.SMSoundCompleteEvent.SOUND_LOOPS_COMPLETE
	*/
	[Event("SOUND_LOOPS_COMPLETE", type="com.jac.soundManager.events.SMSoundCompleteEvent")]
	
	/**
	* Dispatched when playSound() is called on this SMSound.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.PLAY
	* 
	* @see #playSound()
	*/
	[Event("PLAY", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when stopSound() is called on this SMSound.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.STOP
	* 
	* @see #stopSound()
	*/
	[Event("STOP", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when pauseSound() is called on this SMSound.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.PAUSE
	* 
	* @see #pauseSound()
	*/
	[Event("PAUSE", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when resumeSound() is called on this SMSound.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.RESUME
	* 
	* @see #resumeSound()
	*/
	[Event("RESUME", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when muteSound() is called on this SMSound.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.MUTE
	* 
	* @see #muteSound()
	*/
	[Event("MUTE", type = "com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when unMuteSound() is called on this SMSound.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.UNMUTE
	* 
	* @see #unMuteSound()
	*/
	[Event("UNMUTE", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when this sound's volume has changed via checkVolume() or forceVolume().
	* 
	* @eventType com.jac.soundManager.events.SMSoundVolumeEvent.VOLUME_CHANGE
	* 
	* @see #checkVolume()
	* @see #forceVolume()
	*/
	[Event("VOLUME_CHANGE", type = "com.jac.soundManager.events.SMSoundVolumeEvent")]
	
	/**
	 * An object that represents the actual sound object in the library.  This manages the states and access to the embedded sound object.
	 */
	public class SMSound extends Sound implements ISMSound
	{//SMSound Class
	
		/**
		 * this sound is currently stopped.
		 */
		static public const PLAY_STATE_STOPPED:String = "soundPlayStateStopped";
		
		/**
		 * this sound is currently playing.
		 */
		static public const PLAY_STATE_PLAYING:String = "soundPlayStatePlaying";
		
		/**
		 * this sound is currently paused, but not stopped.
		 */
		static public const PLAY_STATE_PAUSED:String = "soundPlayStatePaused";
		
		/**
		 * Enumerated value that is used to set the sound to loop indefinately when played.
		 */
		static public const AUTO_LOOP:int = -2;
		
		/**
		 * Enumerated value that is used to NOT change the current auto loop settings when played.
		 */
		static public const NO_LOOP_CHANGE:int = -1;
		
		/**
		 * Enumerated value that is used to NOT change the current volume settings when played.
		 */
		static public const NO_VOL_CHANGE:int = -1;
		
		/**
		 * Enumerated value that is used to NOT change the current loop count when played.
		 */
		static public const NO_CURRENT_LOOP_CHANGE:int = -1;
		
		protected var _sound:Sound;
		protected var _volume:Number;
		protected var _pan:Number = 0;
		protected var _position:Number = 0;
		protected var _soundChannel:SoundChannel;
		protected var _soundTransform:SoundTransform;
		protected var _mutePercent:Number = 0;
		protected var _duration:Number;
		
		protected var _state:String;
		protected var _isPaused:Boolean;
		protected var _isStopped:Boolean;
		protected var _isPlaying:Boolean;
		protected var _isMuted:Boolean;
		
		protected var _autoLoop:Boolean = false;
		protected var _currentLoop:int = 0;
		protected var _totalLoops:int = 0;
		
		protected var _id:String;
		
		protected var _controller:SoundController = null;
		
		 /**
		  * Creates a new SMSound object and sets all default settings (_id, _state, _volume, _isPaused, _isStopped, _isPlaying, _autoLoop, _isMuted, _soundTransform)
		  * 
		  * @param	soundID a unique ID that is used to reference the sound if managed by a SoundController.
		  * @param	className the name of the export identifier of the sound in the Flash IDE library
		  * @param	autoLoop sets infinite looping on or off. (this is a default setting, that can be changed at any point after creation.)
		  * 
		  * @see #playSound()
		  */
		public function SMSound(soundID:String, className:String, autoLoop:Boolean = false) 
		{//SMSound
			var newSoundClass:Class = getDefinitionByName(className) as Class;
			
			_sound = new newSoundClass();
			
			//set up default props
			_id = soundID;
			_state = PLAY_STATE_STOPPED;
			_volume = 1;
			_isPaused = false;
			_isStopped = true;
			_isPlaying = false;
			_autoLoop = autoLoop;
			_isMuted = false;
			_soundTransform = new SoundTransform(_volume * this.controllerVol * this.managerVol, _pan);
		}//SMSound
		
		/**
		 * @inheritDoc
		 */
		public function playSound(volume:Number = NO_VOL_CHANGE, startTimeInMS:Number = 0, loops:int = NO_LOOP_CHANGE, currentLoop:int=0):void
		{//play
			if (_isPlaying)
			{//stop
				stopSound();
			}//stop
			
			//set up loops
			if (loops == AUTO_LOOP)
			{//autoLoop
				_autoLoop = true;
			}//autoLoop
			else if (loops != NO_LOOP_CHANGE)
			{//set
				_autoLoop = false;
				_totalLoops = loops;
			}//set
			else
			{//no change
				//trace("Playing with no loop change: " + _autoLoop + " / " + _totalLoops);
			}//no change
			
			if (currentLoop != NO_CURRENT_LOOP_CHANGE)
			{//reset current loop
				_currentLoop = currentLoop;
			}//reset current loop
			
			if (volume != NO_VOL_CHANGE)
			{//set new volume
				_volume = volume;
			}//set new volume
			
			//play
			var newVol:Number = (_volume * this.controllerVol * this.managerVol) * (1-this.mutePercent);
			_soundTransform = new SoundTransform(newVol, _pan);
			_soundChannel = _sound.play(startTimeInMS, 0, _soundTransform);
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete, false);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete, false, 0, true);
			
			
			if (!_soundChannel)
			{//couldn't play
				trace(">>>>>>>>>>>> Couldn't play sound: " + ClassUtils.getClassName(_sound) + ". Possibly out of channels.");
				_state = PLAY_STATE_STOPPED;
				_isPlaying = false;
				_isStopped = true;
				_isPaused = false;
			}//couldn't play
			else
			{//good play
				_state = PLAY_STATE_PLAYING;
				_isPlaying = true;
				_isPaused = false;
				_isStopped = false;
				dispatchEvent(new SMSoundEvent(SMSoundEvent.PLAY, this));
			}//good play
			
		}//play
		
		/**
		 * @inheritDoc
		 */
		public function stopSound(resetLoops:Boolean=true):void
		{//stopSound
			if (!_isStopped)
			{//stop
				_soundChannel.stop();
				
				if (resetLoops)
				{//reset
					_currentLoop = 0;
				}//reset
				
				_isPlaying = false;
				_isStopped = true;
				
				dispatchEvent(new SMSoundEvent(SMSoundEvent.STOP, this));
			}//stop
			
		}//stopSound
		
		/**
		 * @inheritDoc
		 */
		public function pauseSound():void
		{//pauseSound
			if (!_isPaused && !_isStopped)
			{//pause
				_position = _soundChannel.position;
				_soundChannel.stop();
				_isPaused = true;
				_isPlaying = false;
				_isStopped = false;
				dispatchEvent(new SMSoundEvent(SMSoundEvent.PAUSE, this));
			}//pause
			else
			{//no pause
				trace("Cannot pause a stopped sound: " + _id);
			}//no pause
		}//pauseSound
		
		/**
		 * @inheritDoc
		 */
		public function resumeSound():void
		{//resumeSound
			if (_isPaused && !_isStopped)
			{//resume
				playSound(NO_VOL_CHANGE, _position, NO_LOOP_CHANGE, _currentLoop);
				_isPaused = false;
				_isPlaying = true;
				_isStopped = false;
				
				dispatchEvent(new SMSoundEvent(SMSoundEvent.RESUME, this));
			}//resume
			else
			{//no resume
				trace("Cannot resume a stopped sound: " + _id);
			}//no resume
		}//resumeSound
		
		/**
		 * @inheritDoc
		 */
		public function togglePause():void
		{//togglePause
			if (_isPaused)
			{//resume
				resumeSound();
			}//resume
			else
			{//pause
				pauseSound();
			}//pause
		}//togglePuase
		
		/**
		 * @inheritDoc
		 */
		public function muteSound():void
		{//muteSound
			_isMuted = true;
			checkMute();
		}//mutesound
		
		/**
		 * @inheritDoc
		 */
		public function checkMute():void
		{//checkMute
			if (!_isStopped)
			{//mute
				var newVol:Number = (_volume * this.controllerVol * this.managerVol)*(1-this.mutePercent);
				_soundTransform = new SoundTransform(newVol, _pan);
				_soundChannel.soundTransform = _soundTransform;
				dispatchEvent(new SMSoundEvent(SMSoundEvent.MUTE, this));
			}//mute
		}//checkMute
		
		/**
		 * @inheritDoc
		 */
		public function unMuteSound():void
		{//unMuteSound
			_isMuted = false;
			
			checkMute();
			
		}//unMuteSound
		
		/**
		 * @inheritDoc
		 */
		public function toggleMute():void
		{//toggleMute
			if (_isMuted)
			{//unmute
				unMuteSound();
			}//unmute
			else
			{//mute
				muteSound();
			}//mute
		}//toggleMute
		
		/**
		 * @inheritDoc
		 */
		public function remove():void
		{//remove
			if (_soundChannel)
			{//stop
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete, false);
			}//stop
			
			_isPlaying = false;
			_isStopped = true;
			_isPaused = false;
			_volume = 0;
			
		}//remove
		
		/**
		 * @inheritDoc
		 */
		public function checkVolume():void
		{//checkVolume
			if (!_isStopped)
			{//set volume
				_soundTransform = new SoundTransform(((_volume * this.controllerVol * this.managerVol) * (1 - this.mutePercent)), _pan);
				_soundChannel.soundTransform = _soundTransform;
			}//set volume
			
			dispatchEvent(new SMSoundVolumeEvent(SMSoundVolumeEvent.VOLUME_CHANGE, this, _soundTransform.volume));
		}//checkVolume
		
		/**
		 * @inheritDoc
		 */
		public function setVolume(vol:Number):void
		{//setVolume
			//_controllerVolPercent = MathUtils.clamp(0, 1, vol);
			
			_volume = MathUtils.clamp(0, 1, vol);
			checkVolume();
			
		}//setVolume
		
		 /**
		 * This will force the volume of this sound to be set to newVol.
		 * Doing this will disregard all other volume limits, including any SoundControllers or SoundManagers.
		 * Changes are pretty good that setVolume() should be used instead.
		 * 
		 * @param	newVol the desired volume of the sound.  This will be clamped to a 0-1 range.
		 * 
		 * @see #setVolume()
		 */
		protected function forceVolume(newVol:Number):void
		{//setVolume
			_volume = MathUtils.clamp(0, 1, newVol);
			
			if (!_isStopped)
			{//set volume
				_soundTransform = new SoundTransform(_volume * (1-this.mutePercent), _pan);
				_soundChannel.soundTransform = _soundTransform;
			}//set volume
			
			dispatchEvent(new SMSoundVolumeEvent(SMSoundVolumeEvent.VOLUME_CHANGE, this, _soundTransform.volume));
		}//setVolume
		
		////////////// EVENT HANDLERS /////////////////
		/**
		 * This is the event handler for when a sound finishes its current loop.
		 * If the sound has more loops to go, it is stopped and playSound() is called to start it again.
		 * 
		 * @param	e the event dispatched from the flash Sound class. (SOUND_COMPLETE)
		 * 
		 * @see #playSound()
		 */
		protected function handleSoundComplete(e:Event):void
		{//handleSoundComplete
			var loopsComplete:Boolean = false;
		
			_currentLoop++;
			
			//trace("Handle Sound Complete: " + _currentLoop + " / " + _totalLoops + " / " + _autoLoop);
			if (_currentLoop < _totalLoops || _autoLoop)
			{//play again
				_soundChannel.stop();
				playSound(_volume, 0, SMSound.NO_LOOP_CHANGE, _currentLoop);
			}//play again
			else
			{//done
				_soundChannel.stop();
				_isStopped = true;
				_isPlaying = false;
				loopsComplete = true;
			}//done
			dispatchEvent(new SMSoundCompleteEvent(SMSoundCompleteEvent.SMSOUND_COMPLETE,this));
			
			if (loopsComplete)
			{//notify of total complete
				dispatchEvent(new SMSoundCompleteEvent(SMSoundCompleteEvent.SMSOUND_LOOPS_COMPLETE,this));
			}//notify of total complete
		}//handleSoundComplete
		
		////////////// Getters / Setters /////////////////
		/**
		 * @inheritDoc
		 */
		public function get sound():Sound { return _sound; }
		
		/**
		 * returns the unique ID of this SMSound object.
		 */
		public function get id():String { return _id; }
		
		/**
		 * @inheritDoc
		 */
		public function get volume():Number { return _volume; }
		
		/**
		 * @inheritDoc
		 */
		public function set volume(value:Number):void 
		{//set volume
			var newVol:Number = MathUtils.clamp(0, 1, value);
			setVolume(newVol);
		}//set volume
		
		/**
		 * @inheritDoc
		 */
		public function get currentLoop():int { return _currentLoop; }
		
		/**
		 * @inheritDoc
		 */
		public function set currentLoop(value:int):void 
		{//set currentLoop
			_currentLoop = value;
		}//set currentLoop
		
		/**
		 * @inheritDoc
		 */
		public function get totalLoops():int { return _totalLoops; }
		
		/**
		 * @inheritDoc
		 */
		public function set totalLoops(value:int):void 
		{//totalLoops
			if (value == AUTO_LOOP)
			{//set auto loop
				_autoLoop = true;
			}//set auto loop
			else
			{//set new total loops
				_autoLoop = false;
				_totalLoops = value;
			}//set new total loops
		}//totalLoops
		
		/**
		 * @inheritDoc
		 */
		public function get position():Number 
		{//get position 
			if (!_isPaused)
			{//return sound channel info
				if (_soundChannel)
				{//
					return _soundChannel.position; 
				}//
				else
				{//0
					return 0;
				}//0
			}//return sound channel info
			else
			{//return internal position
				return _position;
			}//return internal position
		}//get position
		
		/**
		 * @inheritDoc
		 */
		public function get duration():Number 
		{//get duration
			return _sound.length;
		}//get duration
		
		/**
		 * returns TRUE if auto looping is on, and FALSE otherwise.
		 */
		public function get autoLoop():Boolean { return _autoLoop; }
		
		/**
		 * sets auto looping on(TRUE) or off(FALSE).
		 */
		public function set autoLoop(value:Boolean):void 
		{//set autoLoop
			_autoLoop = value;
		}//set autoLoop
		
		/**
		 * @inheritDoc
		 */
		public function get managerVol():Number
		{//get managerVol
			if (_controller)
			{//good Controller
				if (_controller.soundManager)
				{//good manager
					return _controller.soundManager.volume;
				}//good manager
				else
				{//no manager
					return 1;
				}//no manager
			}//good controller
			else
			{//no controller
				return 1;
			}//no controller 
		}//get managerVol
		
		/**
		 * @inheritDoc
		 */
		public function get controllerVol():Number 
		{//get controllerVol
			//return _controllerVolPercent; 
			
			if (_controller)
			{//
				return _controller.volume;
			}//
			else
			{//no controller force 1
				return 1;
			}//no controller force 1
			
		}//get controllerVol
		
		/**
		 * @inheritDoc
		 */
		public function get playState():String
		{//get state
			if (_isStopped)
			{//stopped
				return PLAY_STATE_STOPPED;
			}//stopped
			else if (_isPaused)
			{//paused
				return PLAY_STATE_PAUSED;
			}//paused
			else if(_isPlaying)
			{//playing
				return PLAY_STATE_PLAYING;
			}//playing
			else
			{//bad state
				trace(">>>>>>>>>>>>> BAD STATE IN SOUND " + _id);
				return ("bad state");
			}//bad state
			
		}//get state
		
		/**
		 * @inheritDoc
		 */
		public function get isMuted():Boolean { return _isMuted; }
		
		/**
		 * @inheritDoc
		 */
		public function get mutePercent():Number 
		{//get mutePercent
			if (_isMuted)
			{//mute
				_mutePercent = 1;
			}//mute
			else
			{//check controller
				if (_controller)
				{//muted?
					if (_controller.isMuted)
					{//
						_mutePercent = 1;
					}//
					else
					{//check manager
						if (_controller.soundManager)
						{//muted?
							if (_controller.soundManager.isMuted)
							{//
								_mutePercent = 1;
							}//
							else
							{
								_mutePercent = 0;
							}
						}//muted?
						else
						{
							_mutePercent = 0;
						}
					}//check manager
				}//muted?
				else
				{
					_mutePercent = 0;
				}
			}//check controller
			
			return _mutePercent; 
		}//get mutePercent
		
		/**
		 * @inheritDoc
		 */
		public function get controller():SoundController { return _controller; }
		
		/**
		 * @inheritDoc
		 */
		public function set controller(value:SoundController):void 
		{//set controller
			_controller = value;
		}//set controller
		
		/**
		 * @inheritDoc
		 */
		public function get isPaused():Boolean { return _isPaused; }
		
	}//SMSound Class
	
}