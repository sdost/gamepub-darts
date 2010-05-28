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
	import com.jac.soundManager.events.*;
	import flash.events.EventDispatcher;
	import com.jac.utils.ClassUtils;
	import com.jac.utils.ArrayUtils;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	
	/**
	* Dispatched from this SoundController when a managed sound has finished playing the current repeat loop.
	* 
	* @eventType com.jac.soundManager.events.SMSoundCompleteEvent.SOUND_COMPLETE
	* 
	* @see #handleSoundComplete()
	*/
	[Event("SOUND_COMPLETE", type = "com.jac.soundManager.events.SMSoundCompleteEvent")]
	
	/**
	* Dispatched from this SoundController when a managed sound has finished playing all repeat loops.
	* 
	* @eventType com.jac.soundManager.events.SMSoundCompleteEvent.SOUND_LOOPS_COMPLETE
	* 
	* @see #handleSoundLoopsComplete()
	*/
	[Event("SOUND_LOOPS_COMPLETE", type="com.jac.soundManager.events.SMSoundCompleteEvent")]
	
	/**
	* Dispatched when play() is called on this SoundController.
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController.</p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.PLAY
	* 
	* @see #play()
	*/
	[Event("PLAY", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when stop() is called on this SoundController.
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController.</p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.STOP
	* 
	* @see #stop()
	*/
	[Event("STOP", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when pause() is called on this SoundController.
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController.</p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.PAUSE
	* 
	* @see #pause()
	*/
	[Event("PAUSE", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when resume() is called on this SoundController.
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController.</p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.RESUME
	* 
	* @see #resume()
	*/
	[Event("RESUME", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when mute() is called on this SoundController.
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController.</p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.MUTE
	* 
	* @see #mute()
	*/
	[Event("MUTE", type = "com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when unMute() is called on this SoundController.
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController. </p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.UNMUTE
	* 
	* @see #unMute()
	*/
	[Event("UNMUTE", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when playAllSounds() is called on this SoundController.
	* 
	* @eventType com.jac.soundManager.events.SMControllerAllSoundsEvent.PLAY_ALL
	* 
	* @see #playAllSounds()
	*/
	[Event("PLAY_ALL", type = "com.jac.soundManager.events.SMControllerAllSoundsEvent")]
	
	/**
	* Dispatched when pauseAllSounds() is called on this SoundController.
	* 
	* @eventType com.jac.soundManager.events.SMControllerAllSoundsEvent.PAUSE_ALL
	* 
	* @see #pauseAllSounds()
	*/
	[Event("PAUSE_ALL", type = "com.jac.soundManager.events.SMControllerAllSoundsEvent")]
	
	/**
	* Dispatched when resumeAllSounds() is called on this SoundController.
	* 
	* @eventType com.jac.soundManager.events.SMControllerAllSoundsEvent.RESUME_ALL
	* 
	* @see #resumeAllSounds()
	*/
	[Event("RESUME_ALL", type = "com.jac.soundManager.events.SMControllerAllSoundsEvent")]
	
	/**
	* Dispatched when stopAllSounds() is called on this SoundController.
	* 
	* @eventType com.jac.soundManager.events.SMControllerAllSoundsEvent.STOP_ALL
	* 
	* @see #stopAllSounds()
	*/
	[Event("STOP_ALL", type = "com.jac.soundManager.events.SMControllerAllSoundsEvent")]
	
	/**
	* Dispatched when muteAllSounds() is called on this SoundController.
	* 
	* @eventType com.jac.soundManager.events.SMControllerAllSoundsEvent.MUTE_ALL
	* 
	* @see #muteAllSounds()
	*/
	[Event("MUTE_ALL", type = "com.jac.soundManager.events.SMControllerAllSoundsEvent")]
	
	/**
	* Dispatched when unMuteAllSounds() is called on this SoundController.
	* 
	* @eventType com.jac.soundManager.events.SMControllerAllSoundsEvent.UNMUTE_ALL
	* 
	* @see #unMuteAllSounds()
	*/
	[Event("UNMUTE_ALL", type="com.jac.soundManager.events.SMControllerAllSoundsEvent")]
	
	/**
	* Dispatched when setVolume(), forceVolume(), checkVolume(), or forceAllVolume() is called on this SoundController
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController.</p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundVolumeEvent.VOLUME_CHANGE
	* 
	* @see #setVolume()
	* @see #forceVolume()
	* @see #checkVolume()
	* @see #forceAllVolume()
	*/
	[Event("VOLUME_CHANGE", type="com.jac.soundManager.events.SMSoundVolumeEvent")]
	
	
	/**
	* Dispatched when fadeVolume() is called on this SoundController.
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController. </p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundFadeEvent.VOLUME_FADE_START
	* 
	* @see #fadeVolume()
	* @see #fadeVolumeStart()
	*/
	[Event("VOLUME_FADE_START", type = "com.jac.soundManager.events.SMSoundFadeEvent")]
	
	/**
	* Dispatched when volumeFadeUpdate() is called on this SoundController.
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController. </p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundFadeEvent.VOLUME_FADE_UPDATE
	* 
	* @see #volumeFadeUpdate()
	*/
	[Event("VOLUME_FADE_UPDATE", type="com.jac.soundManager.events.SMSoundFadeEvent")]
	
	/**
	* Dispatched when volumeFadeComplete() is called on this SoundController.
	* <p>It should be noted that if the sound is accessed directly and not through this SoundController the event will only be dispatched from the
	* sound and not from this SoundController. </p>
	* 
	* @eventType com.jac.soundManager.events.SMSoundFadeEvent.VOLUME_FADE_COMPLETE
	* 
	* @see #volumeFadeComplete()
	*/
	[Event("VOLUME_FADE_COMPLETE", type = "com.jac.soundManager.events.SMSoundFadeEvent")]
	
	/**
	* Dispatched when fadeAllVolume() is called.
	* 
	* @eventType com.jac.soundManager.events.SMSoundFadeEvent.VOLUME_FADE_START_ALL
	* 
	* @see #allVolumeFadeStart()
	* @see #fadeAllVolume()
	*/
	[Event("VOLUME_FADE_START_ALL", type = "com.jac.soundManager.events.SMSoundFadeEvent")]
	
	/**
	* Dispatched when allVolumeFadeUpdate() is called on this SoundController.
	* 
	* @eventType com.jac.soundManager.events.SMSoundFadeEvent.VOLUME_FADE_UPDATE_ALL
	* 
	* @see #allVolumeFadeUpdate()
	*/
	[Event("VOLUME_FADE_UPDATE_ALL", type="com.jac.soundManager.events.SMSoundFadeEvent")]
	
	/**
	* Dispatched when allVolumeFadeComplete() is called on this SoundController.
	* 
	* @eventType com.jac.soundManager.events.SMSoundFadeEvent.VOLUME_FADE_COMPLETE_ALL
	* 
	* @see #allVolumeFadeComplete()
	*/
	[Event("VOLUME_FADE_COMPLETE_ALL", type = "com.jac.soundManager.events.SMSoundFadeEvent")]
	
	/**
	 * <p>A SoundController is intended to manipulate individual SMSounds or groups of SMSounds.
	 * Each SoundController contains a list of SMSound objects that can be controlled.  It is recommended that 
	 * all SMSound objects be controlled through a SoundController.  However SMSound objects can function on their
	 * own in a limited capacity.</p>
	 * 
	 */
	public class SoundController extends EventDispatcher
	{//SoundController Class
	
		/**
		 * Enumerated value used to set automatic looping when playing a sound.
		 * @see #play() 
		 */
		static public const AUTO_LOOP:int = -2;
		
		/**
		 * Enumerated value used to NOT change the current loops settings of a sound when starting to play
		 * @see #play() 
		 */
		static public const NO_LOOP_CHANGE:int = -1;
		
		/**
		 * Constant: NO_VOLUME_CHANGE
		 * Enumerated value used to NOT change the current volume settings of a sound when starting to play
		 * @see #play() 
		 */
		static public const NO_VOLUME_CHANGE:int = -1;
		
		private var _soundList:Array;
		private var _id:String;
		private var _volume:Number = 1;
		private var _soundManager:SoundManager = null;
		private var _soundManagerVolume:Number = 1;
		private var _isMuted:Boolean = false;
		private var _isPaused:Boolean = false;
		
		/**
		 * This will create a new SoundController Object with an ID of the passed in string.
		 * @param	id A string used reference the controller when controlled by a SoundManager. Although duplicate ID's can be used, it is not recommended.
		 */
		public function SoundController(id:String="") 
		{//SoundController
				_soundList = new Array();
				_id = id;
		}//SoundController
		
		/**
		 * <p>This will add a SMSound object to the list of sounds this SoundController manages.  If a sound with the same ID exists, 
		 * a warning is traced out and no sound is added.</p>
		 * 
		 * @param	newSound a reference to a ISMSound compliant sound object.
		 * @return A reference to the added ISMSound compliant sound object. Returns null if the new ISMSound's ID is already in the list.
		 * 
		 * @see #removeSoundByID
		 */
		public function addSound(newSound:ISMSound):ISMSound
		{//addSound
			if (ArrayUtils.findObjectsWithPropertyInArray(_soundList, "id", newSound.id).length == 0)
			{//add
				trace("Adding: " + newSound.id + " to sound list");
				_soundList.push(newSound);
				newSound.addEventListener(SMSoundCompleteEvent.SMSOUND_COMPLETE, handleSoundComplete, false, 0, true);
				newSound.addEventListener(SMSoundCompleteEvent.SMSOUND_LOOPS_COMPLETE, handleLoopsComplete, false, 0, true);
				newSound.controller = this;
				return newSound;
			}//add
			else
			{//already there
				trace("Sound already in list, not adding");
				return null;
			}//already there
		}//addSound
		
		/**
		 * Dispatches a <code>SMSoundCompleteEvent</code> when the sound completes.
		 * @param	e
		 */
		protected function handleSoundComplete(e:SMSoundCompleteEvent):void 
		{//handleSoundComplete
			dispatchEvent(e);
		}//handleSoundComplete
		
		/**
		 * Dispatches a <code>SMSoundCompleteEvent</code> when all loops of the sound completes.
		 * @param	e
		 */
		protected function handleLoopsComplete(e:SMSoundCompleteEvent):void
		{//handleLoopsComplete
			dispatchEvent(e);
		}//handleLoopsComplete
		
		 /**
		  * <p>This will remove a sound object from the list of managed sounds.
		  * This also calls the remove() method on the sound that is about to be removed.</p>
		  * 
		  * @param	soundID the ID of the sound to remove.
		  * @return Returns TRUE if the sound was found and removed, FALSE otherwise.
		  * 
		  * @see #addSound()
		  */
		public function removeSoundByID(soundID:String):Boolean
		{//removeSound
			var wasRemoved:Boolean = false;
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//stop and clean up
				TweenLite.killTweensOf(sound, false);
				sound.removeEventListener(SMSoundCompleteEvent.SMSOUND_COMPLETE, handleSoundComplete, false);
				sound.removeEventListener(SMSoundCompleteEvent.SMSOUND_LOOPS_COMPLETE, handleLoopsComplete, false);
				sound.remove();
				wasRemoved = ArrayUtils.removeFirstFromArray(_soundList, sound);
			}//stop and clean up
			
			return wasRemoved;
		}//removeSound
		
		/**
		 * Plays the sound specified by the soundID.  This will also kill any tweens/fades previously applied to this sound object
		 * <p>Dispatches a <code>SMSoundEvent.PLAY</code> event when called.</p>
		 * 
		 * @param	soundID the unique ID of the ISMSound compliant object.
		 * @param	volume the volume to play the sound at.  This volume is limited by the SoundController's volume as well as the SoundManager's volume. If set to NO_VOLUME_CHANGE, the sounds current volume setting will be used.
		 * @param	startTimeInMS how many milliseconds into the sound to start from.
		 * @param	loops the number of times to play the sound in a row.  if set to NO_LOOP_CHANGE, the sounds current loop setting will be used.
		 * @return The sound object that was affected. Returns null if the soundID was not found in the list.
		 * 
		 * @see #stop()
		 * @see #pause()
		 * @see #resume()
		 * @see #togglePause()
		 */
		public function play(soundID:String, volume:Number = NO_VOLUME_CHANGE, startTimeInMS:Number = 0, loops:int = NO_LOOP_CHANGE):ISMSound
		{//play
			var sound:ISMSound = getSoundByID(soundID);
			_isPaused = false;
			
			if (sound)
			{//good sound
				TweenLite.killTweensOf(sound, false);
				sound.playSound(volume, startTimeInMS, loops);
				dispatchEvent(new SMSoundEvent(SMSoundEvent.PLAY, sound));
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:Play:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//play
		
		/**
		 * Stops the sound specified by the soundID.  This will also kill any tweens/fades previously applied to this sound object
		 * <p>Dispatches a <code>SMSoundEvent.STOP</code> event when called.</p>
		 * 
		 * @param	soundID the unique ID of the sound to stop.
		 * @return A reference to the affected ISMSound compliant object.  Will return null if the ID was not found in the list.
		 * 
		 * @see #play()
		 * @see #pause()
		 * @see #resume()
		 * @see #togglePause()
		 */
		public function stop(soundID:String):ISMSound
		{//stop
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//good sound
				TweenLite.killTweensOf(sound, false);
				sound.stopSound();
				dispatchEvent(new SMSoundEvent(SMSoundEvent.STOP, sound));
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:Stop:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//stop
		
		/**
		 * Pauses the sound specified by the soundID. This will also kill any tweens/fades previously applied to this sound object.
		 * <p>Dispatches a <code>SMSoundEvent.PAUSE</code> event when called.</p>
		 * 
		 * @param	soundID the unique ID of the sound to pause.
		 * @return A reference to the affected ISMSound compliant object.  Will return null if the ID was not found in the list.
		 * 
		 * @see #play()
		 * @see #stop()
		 * @see #resume()
		 * @see #togglePause()
		 */
		public function pause(soundID:String):ISMSound
		{//pause
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//good sound
				TweenLite.killTweensOf(sound, false);
				sound.pauseSound();
				dispatchEvent(new SMSoundEvent(SMSoundEvent.PAUSE, sound));
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:Pause:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//pause
		
		/**
		 * Resumes a sound specified by the soundID, that has been previously paused. This will also kill any tweens/fades previously applied to this sound object.
		 * <p>Dispatches a <code>SMSoundEvent.RESUME</code> event when called.</p>
		 * 
		 * @param	soundID the unique ID of the sound to resume.
		 * @return A reference to the affected ISMSound compliant object.  Will return null if the ID was not found in the list.
		 * 
		 * @see #play()
		 * @see #stop()
		 * @see #pause()
		 * @see #togglePause()
		 */
		public function resume(soundID:String):ISMSound
		{//resume
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//good sound
				TweenLite.killTweensOf(sound, false);
				sound.resumeSound();
				dispatchEvent(new SMSoundEvent(SMSoundEvent.RESUME, sound));
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:Resume:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//resume
		
		/**
		 * Toggles the pause state of the sound specified by soundID. This will also kill any tweens/fades previously applied to this sound object.
		 * 
		 * @param	soundID the unique ID of the sound to toggle the pause state of.
		 * @return reference to the affected ISMSound compliant object.  Will return null if the ID was not found in the list.
		 * 
		 * @see #play()
		 * @see #resume()
		 * @see #stop()
		 * @see #pause()
		 */
		public function togglePause(soundID:String):ISMSound
		{//togglePause
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//good sound
				//trace("SoundController:togglePause:Good Sound to togglePause.");
				TweenLite.killTweensOf(sound, false);
				
				if (sound.playState == SMSound.PLAY_STATE_PAUSED)
				{//resume
					resume(sound.id);
					return sound;
				}//resume
				else if (sound.playState == SMSound.PLAY_STATE_PLAYING)
				{//pause
					pause(sound.id);
					return sound;
				}//pause
				
				return null;
			}//good sound
			else
			{//bad sound
				trace("SoundController:togglePause:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//togglePause
		
		/**
		 * Mutes the sound object specified by the soundID.
		 * <p>Dispatches a <code>SMSoundEvent.MUTE</code> event when called.</p>
		 * 
		 * @param	soundID the unique ID of the sound to mute.
		 * @return reference to the affected ISMSound compliant object.  Will return null if the ID was not found in the list.
		 * 
		 * @see #unMute()
		 * @see #toggleMute()
		 */
		public function mute(soundID:String):ISMSound
		{//mute
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//good sound
				sound.muteSound();
				dispatchEvent(new SMSoundEvent(SMSoundEvent.MUTE, sound));
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:Mute:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//mute
		
		/**
		 * UnMutes the sound object specified by the soundID.
		 * <p>Dispatches a <code>SMSoundEvent.UNMUTE</code> event when called.</p>
		 * 
		 * @param	soundID the unique ID of the sound to UnMute.
		 * @return reference to the affected ISMSound compliant object.  Will return null if the ID was not found in the list.
		 * 
		 * @see #mute()
		 * @see #toggleMute()
		 */
		public function unMute(soundID:String):ISMSound 
		{//unMute
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//good sound
				sound.unMuteSound();
				dispatchEvent(new SMSoundEvent(SMSoundEvent.UNMUTE, sound));
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:unMute:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//unMute
		
		/**
		 * Toggles the mute state of the sound object specified by the soundID.
		 * 
		 * @param	soundID the unique ID of the sound to toggle the mute of.
		 * @return reference to the affected ISMSound compliant object.  Will return null if the ID was not found in the list.
		 * 
		 * @see mute()
		 * @see unMute()
		 */
		public function toggleMute(soundID:String):ISMSound
		{//toggleMute
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//good sound
				sound.toggleMute();
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:unMute:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//toggleMute
		
		/**
		 * <p>Plays all of the sounds in the SoundController's list of registered sounds.
		 * The sounds are played from the beginning (0 milliseconds in) with no change to the sounds's volume or loop settings.</p>
		 * 
		 * <p>Dispatches a <code>SMControllerAllSoundsEvent.PLAY_ALL</code> event when called.</p>
		 * 
		 * @see #stopAllSounds()
		 * @see #pauseAllSounds()
		 * @see #resumeAllSounds()
		 */
		public function playAllSounds():void 
		{//playAllSounds
			_isPaused = false;
			for each (var sndObj:ISMSound in _soundList)
			{//play
				play(sndObj.id, SMSound.NO_VOL_CHANGE, 0, SMSound.NO_LOOP_CHANGE);
			}//play
			
			dispatchEvent(new SMControllerAllSoundsEvent(SMControllerAllSoundsEvent.PLAY_ALL, this));
		}//playAllSounds
		
		/**
		 * Stops all of the sounds in this SoundController's list of registered sounds.
		 * <p>Dispatches a <code>SMControllerAllSoundsEvent.STOP_ALL</code> event when called.</p>
		 * 
		 * @see #playAllSounds()
		 * @see #pauseAllSounds()
		 * @see #resumeAllSounds()
		 */
		public function stopAllSounds():void
		{//stopAllSounds
			for each (var sndObj:ISMSound in _soundList)
			{//stop
				stop(sndObj.id);
			}//stop
			dispatchEvent(new SMControllerAllSoundsEvent(SMControllerAllSoundsEvent.STOP_ALL, this));
		}//stopAllSounds
		
		/**
		 * Pauses all of the sounds in the SoundController's list of registered sounds.
		 * <p>Dispatches a <code>SMControllerAllSoundsEvent.PAUSE_ALL</code> event when called.</p>
		 * 
		 * @see #resumeAllSounds()
		 * @see #togglePauseAllSounds()
		 */
		public function pauseAllSounds():void 
		{//pauseAllSounds
			_isPaused = true;
			
			for each(var sndObj:ISMSound in _soundList)
			{//pause
				pause(sndObj.id);
			}//pause
			dispatchEvent(new SMControllerAllSoundsEvent(SMControllerAllSoundsEvent.PAUSE_ALL, this));
		}//pauseAllSounds
		
		/**
		 * Resumes all previously paused sounds in this SoundController's list of registered sounds
		 * <p>Dispatches a <code>SMControllerAllSoundsEvent.RESUME_ALL</code> event when called.</p>
		 * 
		 * @see #pauseAllSounds
		 * @see #togglePauseAllSounds
		 */
		public function resumeAllSounds():void 
		{//playAllSounds
			_isPaused = false;
			for each (var sndObj:ISMSound in _soundList)
			{//mute
				resume(sndObj.id);
			}//mute
			dispatchEvent(new SMControllerAllSoundsEvent(SMControllerAllSoundsEvent.RESUME_ALL, this));
		}//playAllSounds
			
		/**
		 * Toggles the pause state of all sounds in this SoundController's list of registered sounds
		 * 
		 * @see #pauseAllSounds
		 * @see #resumeAllSounds
		 */
		public function togglePauseAllSounds():void
		{//togglePauseAllSounds
			for each(var sndObj:ISMSound in _soundList)
			{//pause
				togglePause(sndObj.id);
			}//pause
		}//togglePauseAllSounds
	
		/**
		 * <p>This is an updater function that is only meant to be used from a SoundManager.  This will call SMSound.checkMute() on each of the
		 * registered sound objects.</p>
		 * 
		 * @see #checkVolume()
		 * @see com.jac.soundManager.SMSound#checkMute() checkMute()
		 */
		public function checkMute():void
		{//checkMute
			for (var i:int = 0; i < _soundList.length; i++)
			{//mute
				_soundList[i].checkMute();
			}//mute
		}//checkMute
		
		/**
		 * Mutes all registered sounds.
		 * (sets _isMuted to true, and forces a checkMute() on all registered sounds.
		 * 
		 * <p>Dispatches a <code>SMControllerAllSoundsEvent.MUTE_ALL</code> event when called.</p>
		 * 
		 * @param	mutePercent NOT FULLY SUPPORTED.. just leave as default for now.
		 * 
		 * @see #unMuteAllSounds()
		 * @see #toggleMuteAllSounds()
		 * @see com.jac.soundManager.SMSound#checkMute() checkMute
		 */
		public function muteAllSounds(mutePercent:Number = 1):void
		{//muteAllSounds
			_isMuted = true;
		
			for (var i:int = 0; i < _soundList.length; i++)
			{//mute
				_soundList[i].checkMute();
			}//mute
			
			dispatchEvent(new SMControllerAllSoundsEvent(SMControllerAllSoundsEvent.MUTE_ALL, this));
		}//muteAllSounds
		
		/**
		 * unMutes all registered sounds.
		 * (sets _isMuted to false, and forces a checkMute() on all registered sounds.
		 * <p>Dispatches a <code>SMControllerAllSoundsEvent.UNMUTE_ALL</code> event when called.</p>
		 * 
		 * @see #muteAllSounds()
		 * @see #toggleMuteAllSounds()
		 * @see com.jac.soundManager.SMSound#checkMute() checkMute
		 */
		public function unMuteAllSounds():void
		{//unMuteAllSounds
			_isMuted = false;
			for (var i:int = 0; i < _soundList.length; i++)
				{//mute
					_soundList[i].checkMute();
				}//mute
			dispatchEvent(new SMControllerAllSoundsEvent(SMControllerAllSoundsEvent.UNMUTE_ALL, this));
		}//unMuteAllSounds
		
		/**
		 * Toggles the mute state on all registered sounds.
		 * 
		 * @return The mute state of this SoundController.  TRUE if muted after the toggle, FALSE otherwise.
		 * 
		 * @see #muteAllSounds()
		 * @see #unMuteAllSounds()
		 */
		public function toggleMuteAllSounds():Boolean
		{//toggleMuteAllSounds
			if (_isMuted)
			{//unmute
				unMuteAllSounds();
			}//unmute
			else
			{//mute
				muteAllSounds();
			}//mute
			
			return _isMuted;
		}//toggleMuteAllSounds
		
		/**
		 * Sets the volume of the sound specified by the soundID.
		 * <p>Dispatches a <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event when called.</p>
		 * 
		 * @param	soundID the unique ID of the sound to set the volume of.
		 * @param	vol A volume to force all sounds to, 0-1.  This number is not clamped at this level, however it may be clamped further down the chain.
		 * @return  A reference to the affected ISMSound compliant object.  Will return null if the ID was not found in the list.
		 * 
		 * @see #forceVolume()
		 */
		public function setVolume(soundID:String, vol:Number):ISMSound
		{//setVolume
		
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//good sound
				TweenLite.killTweensOf(sound, false);
				sound.setVolume(vol);
				dispatchEvent(new SMSoundVolumeEvent(SMSoundVolumeEvent.VOLUME_CHANGE, sound, sound.volume));
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:unMute:Bad Sound: " + soundID);
				return null;
			}//bad sound
			
		}//setVolume
		
		/**
		 * This will force the volume of sound specified by soundID.
		 * Please note that this will override any other volume modifications currently applied to the objects.
		 * This will also stop any tweens from a fadeVolume on this ISMSound before the volume is set.
		 * <p>Chances are pretty good that you want to use setVolume() in most cases.</p>
		 * 
		 * <p>Dispatches a <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event when called.</p>
		 * 
		 * @param	soundID soundID the unique ID of the sound to set the volume of.
		 * @param	vol A volume to force all sounds to, 0-1.  This number is not clamped at this level, however it may be clamped further down the chain.
		 * @return  A reference to the affected ISMSound compliant object.  Will return null if the ID was not found in the list.
		 * 
		 * @see #setVolume()
		 */
		public function forceVolume(soundID:String, vol:Number):ISMSound
		{//forceVolume
			var sound:ISMSound = getSoundByID(soundID);
			
			if (sound)
			{//good sound
				TweenLite.killTweensOf(sound, false);
				sound.volume = vol;
				dispatchEvent(new SMSoundVolumeEvent(SMSoundVolumeEvent.VOLUME_CHANGE, sound, sound.volume));
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:unMute:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//forceVolume
		
		/**
		 * This is an updater function that is only meant to be used from a SoundManager.  This will call SMSound.checkVolume() on each of the
		 * registered sound objects.
		 * 
		 * <p>Dispatches a <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event when called.</p>
		 * 
		 * @see #checkMute()
		 * @see com.jac.soundManager.SMSound#checkVolume() checkVolume
		 */
		public function checkVolume():void
		{//checkVolume
			for (var i:int = 0; i < _soundList.length; i++)
			{//set vol
				TweenLite.killTweensOf(_soundList[i], false);
				//setVolume(_soundList[i].id, _soundList[i].volume);
				_soundList[i].checkVolume();
			}//set vol
			
			dispatchEvent(new SMSoundVolumeEvent(SMSoundVolumeEvent.VOLUME_CHANGE, this, _volume));
		}//checkVolume
		
		/**
		 * Changes the volume of this SoundController, and calls checkVolume to update the sounds.
		 * 
		 * <p>Dispatches a <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event when called.</p>
		 * 
		 * @param	vol the controller's desired volume. (0-1 range)
		 * 
		 * @see #forceAllVolume()
		 */
		public function setAllVolume(vol:Number):void
		{//setAllVolume
			_volume = vol;
			checkVolume();
		}//setAllVolume
		
		/**
		 * This will force the volume of all registered sound objects
		 * Please note that this will override any other volume modifications currently applied to the objects.
		 * This will also stop any tweens from a fadeVolume() on this ISMSound before the volume is set.
		 * 
		 * <p>Dispatches a <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event when called.</p>
		 * 
		 * <p>Chances are pretty good that you want to use setVolume in most cases.</p>
		 * @param	vol A volume to force all sounds to, 0-1.  This number is not clamped at this level, however it may be clamped further down the chain.
		 * 
		 * @see #setAllVolume()
		 * @see #setVolume()
		 */
		public function forceAllVolume(vol:Number):void
		{//forceAllVolume
			for (var i:int = 0; i < _soundList.length; i++)
			{//set vol
				TweenLite.killTweensOf(_soundList[i], false);
				setVolume(_soundList[i].id, vol);
			}//set vol
			dispatchEvent(new SMSoundVolumeEvent(SMSoundVolumeEvent.VOLUME_CHANGE, this, vol));
		}//forceAllVolume
		
		/**
		 * Fades the volume of all registered sound objects over time.
		 * 
		 * <p>Calls allVolumeFadeStart(), when the fade begins.</p>
		 * <p>Calls allVolumeFadeComplete(), when the fade ends.</p>
		 * <p>Calls allVolumeFadeUpdate(), on every tween update.</p>
		 * 
		 * @param	endPercent The final volume to fade to (0-1 range)
		 * @param	duration Length of time in seconds the fade should happen over.
		 * @param	curve A TweenLite/TweenMax curve def, to pass to the tween engine.
		 * 
		 * @see #fadeVolume()
		 * @see #allVolumeFadeStart()
		 * @see #allVolumeFadeComplete()
		 * @see #allVolumeFadeUpdate()
		 */
		public function fadeAllVolume(endPercent:Number, duration:Number, curve:*= null):void
		{//fadeAllVolume
			if (!curve)
			{//set default
				curve = Linear.easeOut;
			}//set default
			
			TweenLite.to(this, duration, { volume:endPercent, ease:curve, 
												onStart:allVolumeFadeStart,
												onUpdate:allVolumeFadeUpdate,
												onComplete:allVolumeFadeComplete} );
			
			
			
		}//fadeAllVolume
		
		/**
		 * Fades the volume of the sound specified by the soundID, over time.
		 * <ul>
		 * <li>Calls volumeFadeStart() when the fade begins.</li>
		 * <li>Calls volumeFadeComplete() when the fade finishes.</li>
		 * <li>Calls volumeFadeUpdate() on each update of the tween.</li>
		 * </ul>
		 * @param	soundID Unique ID of the registered sound to fade the volume of.
		 * @param	endVolume Final volume of the sound when the fade completes.
		 * @param	duration Time in seconds the fade should take.
		 * @param	curve TweenLite/TweenMax curve definition to control the fade easing.
		 * @return A reference to the affected ISMSound compliant sound object
		 * 
		 * @see #volumeFadeStart()
		 * @see #volumeFadeComplete()
		 * @see #volumeFadeUpdate()
		 */
		public function fadeVolume(soundID:String, endVolume:Number, duration:Number, curve:*=null):ISMSound
		{//fadeVolume
			if (!curve)
			{//set default
				curve = Linear.easeOut;
			}//set default
			
			var sound:ISMSound = getSoundByID(soundID);
			if (sound)
			{//good sound
				
				TweenLite.to(sound, duration, { volume:endVolume, ease:curve, 
												onStart:volumeFadeStart, onStartParams:[sound], 
												onUpdate:volumeFadeUpdate, onUpdateParams:[sound],
												onComplete:volumeFadeComplete, onCompleteParams:[sound] } );
				return sound;
			}//good sound
			else
			{//bad sound
				trace("SoundController:fadeVolume:Bad Sound: " + soundID);
				return null;
			}//bad sound
		}//faceVolume
		
		/**
		 * Called when an allVolumeFade() starts.  This is designed to be overridden when subclassed.
		 * 
		 * <p>Dispatches a <code>SMSoundFadeEvent.VOLUME_FADE_START_ALL</code> event when called.</p>
		 */
		protected function allVolumeFadeStart():void
		{//allvolumeFadeStart
			dispatchEvent(new SMSoundFadeEvent(SMSoundFadeEvent.VOLUME_FADE_START_ALL, null));
		}//allvolumeFadeStart
		
		/**
		 * Called when an allVolumeFade() finishes.  This is designed to be overridden when subclassed.
		 * 
		 * <p>Dispatches a <code>SMSoundFadeEvent.VOLUME_FADE_COMPLETE_ALL</code> event when called.</p>
		 */
		protected function allVolumeFadeComplete():void
		{//allvolumeFadeComplete
			dispatchEvent(new SMSoundFadeEvent(SMSoundFadeEvent.VOLUME_FADE_COMPLETE_ALL, null));
		}//allvolumeFadeComplete
		
		/**
		 * Called when an allVolumeFade() udpates.  This is designed to be overridden when subclassed.
		 * 
		 * <p>Dispatches a <code>SMSoundFadeEvent.VOLUME_FADE_UPDATE_ALL</code> event when called.</p>
		 */
		protected function allVolumeFadeUpdate():void
		{//volumeFadeUpdate
			dispatchEvent(new SMSoundFadeEvent(SMSoundFadeEvent.VOLUME_FADE_UPDATE_ALL, null));
		}//volumeFadeUpdate
		
		/**
		 * Called when a volume fade starts on this SoundController
		 * <p>Dispatches a <code>SMSoundFadeEvent.VOLUME_FADE_START</code> event.</p>
		 * 
		 * @param	soundObj reference to the fading sound object.
		 */
		protected function volumeFadeStart(soundObj:ISMSound):void
		{//volumeFadeStart
			dispatchEvent(new SMSoundFadeEvent(SMSoundFadeEvent.VOLUME_FADE_START, soundObj));
		}//volumeFadeStart
		
		/**
		 * Called when a volume fade has completed on this SoundController.
		 * <p>Dispatches a <code>SMSoundFadeEvent.VOLUME_FADE_COMPLETE</code> event.</p>
		 * @param	soundObj reference to the fading sound object.
		 */
		protected function volumeFadeComplete(soundObj:ISMSound):void
		{//volumeFadeComplete
			dispatchEvent(new SMSoundFadeEvent(SMSoundFadeEvent.VOLUME_FADE_COMPLETE, soundObj));
		}//volumeFadeComplete
		
		/**
		 * Called when a volume fade update happens on this SoundController.
		 * <p>Dispatches a <code>SMSoundFadeEvent.VOLUME_FADE_UPDATE</code> event.</p>
		 * @param	soundObj reference to the fading sound object.
		 */
		protected function volumeFadeUpdate(soundObj:ISMSound):void
		{//volumeFadeUpdate
			dispatchEvent(new SMSoundFadeEvent(SMSoundFadeEvent.VOLUME_FADE_UPDATE, soundObj));
		}//volumeFadeUpdate
		
		////////////// GETTERS / SETTERS //////////////////
		
		/**
		 * Returns a reference to the ISMSound compliant object associated with soundID.
		 * @param	soundID Unique ID of a sound object in the registered sound list.
		 * @return A reference to the ISMSound compliant object associted with the soundID. Returns null if the ID is not found in the list.
		 */
		public function getSoundByID(soundID:String):ISMSound
		{//getSoundByID
			var soundIndex:int = ArrayUtils.findFirstObjectWithPropertyInArray(_soundList, "id", soundID).index;
			
			if (soundIndex != -1)
			{//good sound
				return _soundList[soundIndex];
			}//good sound
			else
			{//bad sound
				return null;
			}//bad sound
		}//getSoundByID
		
		/**
		 * Returns the unique ID of this SoundController specified at instantiation.
		 */
		public function get id():String { return _id; }
		
		/**
		 * @private
		 */
		public function get volume():Number { return _volume; }
		
		/**
		 * Returns the current volume of this SoundController.
		 * <p>Sets the current volume of this SoundController through the setAllVolume method, which in turn calls checkVolume()
		 * which dispatches the <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event.</p>
		 * 
		 * @see #setAllVolume()
		 * @see #setVolume()
		 */
		public function set volume(value:Number):void 
		{//set volume
			setAllVolume(value);
		}//set volume
		
		/**
		 * @private
		 */
		public function get soundManager():SoundManager { return _soundManager; }
		
		/**
		 * Returns a reference to the SoundController's SoundManager if it has one.
		 * 
		 * <p>Assigns a SoundManager to this SoundController.
		 * This is only intended to be called from a SoundManager</p>
		 */
		public function set soundManager(value:SoundManager):void 
		{//set soundManager
			_soundManager = value;
			_soundManagerVolume = _soundManager.volume;
		}//set soundManager
		
		/**
		 * A convenience function to get the volume of an associated SoundManager.
		 */
		public function get soundManagerVolume():Number 
		{//get soundManagerVolume 
			if (_soundManager)
			{//good manager
				return _soundManager.volume;
			}//good manager
			else
			{//no manager
				return 1;
			}//no manager
		}//get soundManagerVolume
		
		/**
		 * Returns the current mute state of the SoundController.  TRUE if muted, and FALSE otherwise.
		 */
		public function get isMuted():Boolean { return _isMuted; }
		
		/**
		 * Returns the current pause state of the SoundController.  TRUE if paused, and FALSE otherwise.
		 */
		public function get isPaused():Boolean { return _isPaused; }
	}//SoundController Class
	
}