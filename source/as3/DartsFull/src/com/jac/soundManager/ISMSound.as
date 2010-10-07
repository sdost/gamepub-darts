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
	
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	
	/**
	 * An object that represents the actual sound object in the library.  This manages the states and access to the embedded sound object.
	 */
	public interface ISMSound extends IEventDispatcher
	{//ISMSound
		
		/**
		  * Plays the sound according to the passed in parameters.
		  * 
		  * <p>Dispatches a <code>SMSoundEvent.PLAY</code> event </p>
		  * 
		  * @param	volume the volume to set the sound to before playing. To leave the current volume pass in NO_VOL_CHANGE.
		  * @param	startTimeInMS how far in from the beginning of the sound to start playing, specified in milliseconds.
		  * @param	loops how many times to loop the sound over when it finishes.  To set to infinite pass in AUTO_LOOP. To leave the current settings pass in NO_LOOP_CHANGE.
		  * @param	currentLoop what loop count to start at.  Set to NO_CURRENT_LOOP_CHANGE to leave the current loop count as it is.
		  */
		function playSound(volume:Number = -1, startTimeInMS:Number = 0, loops:int = -1, currentLoop:int = 0):void;
		
		/**
		 * Pauses the sound if its not already paused or stopped.
		 * 
		 * <p>Dispatches a <code>SMSoundEvent.PAUSE</code> event </p>
		 */
		function pauseSound():void;
		
		/**
		 * Resumes a previously paused sound.  This will do nothing if the sound was not paused, or is stopped.
		 * 
		 * <p>Dispatches a <code>SMSoundEvent.RESUME</code> event </p>
		 */
		function resumeSound():void;
		
		/**
		 * Toggles the pause state of the sound.  Calls <code>resumeSound()</code> or <code>pauseSound()</code>
		 * 
		 * @see #resumeSound()
		 * @see #pauseSound()
		 */
		function togglePause():void;
		
		/**
		 * Stops the current sound, if <code>_isStopped</code> is true.
		 * 
		 * <p>Dispatches a <code>SMSoundEvent.STOP</code> event </p>
		 * 
		 * @param	resetLoops If TRUE, it will reset the played loop count to 0. If FALSE, it leaves the current loop count as is.
		 */
		function stopSound(resetLoops:Boolean=true):void;
		
		/**
		 * Mutes the sound by setting <code>_isMuted</code> to <code>true</code> and calling <code>codcheckMute</code> to do the actually mute.
		 * 
		 * <p>Dispatches a <code>SMSoundEvent.MUTE</code> event </p>
		 * 
		 */
		function muteSound():void;
		
		/**
		 * UnMutes the sound by setting _isMuted to false and calling checkMute().
		 * <p>Dispatches a <code>SMSoundEvent.UNMUTE</code> event </p>
		 * 
		 * @see #checkMute()
		 */
		function unMuteSound():void;
		
		/**
		 * Toggles the mute state of the sound.  Calls unMuteSound() or muteSound()
		 * 
		 * @see #unMuteSound()
		 * @see #muteSound()
		 */
		function toggleMute():void;
		
		/**
		 * Determines if the sound should be muted.  This takes into account a <code>codSoundController</code> if there is on, as well as the <code>SoundManager</code> if there is one.
		 * This will do nothing if the sound is stopped.
		 * 
		 * <p>This was designed to be called from itself, or a <code>coSoundController</code>.  Chances are pretty good it won't need to be called by hand.</p>
		 */
		function checkMute():void;
		
		/**
		 * Handles all sound cleanup before its removed from a SoundController.
		 * Additionally it stops the sound, and sets its volume to 0.
		 */
		function remove():void;
		
		/**
		  * Sets the volume of the sound by updating _volume and calling checkVolume().
		  * 
		  * <p>Dispatches a <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event </p>
		  * 
		  * @param	vol the desired volume of the sound.  This will be clamped to a 0-1 range.
		  * 
		  * @see #checkVolume()
		  */
		function setVolume(vol:Number):void;
		
		/**
		 * Physically sets the volume of the flash sound.
		 * This takes into account any SoundControllers or SoundManagers.
		 * 
		 * <p>Dispatches a <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event </p>
		 * 
		 * <p>This was designed to be called from itself, or a SoundController.  Chances are pretty good it won't need to be called by hand.</p>
		 *
		 * @see #setVolume()
		 */
		function checkVolume():void;
		
		/**
		 * returns a reference to the actual flash sound object.
		 */
		function get sound():Sound;
		
		
		function get id():String;
		
		/**
		 * @private
		 */
		function get volume():Number;
		/**
		 * Returns the current volume of this SMSound object.
		 * 
		 * <p>Sets the volume of this SMSound object by calling setVolume().  The value will be clamped to the 0-1 range.</p>
		 * 
		 * @see #setVolume()
		 */
		function set volume(value:Number):void;
		
		/**
		 * @private
		 */
		function get totalLoops():int;
		/**
		 * Returns the loop limit.  Might also return AUTO_LOOP if the sound is set to loop infinitly.
		 * <p>Sets the loop limit.  Can be set to AUTO_LOOP to loop infinitly.</p>
		 * 
		 * @see #AUTO_LOOP
		 */
		function set totalLoops(value:int):void;
		
		/**
		 * @private
		 */
		function get currentLoop():int;
		/**
		 * Returns the current loop count for this SMSound object. (how many times its played already)
		 * <p>Sets the current loop count for this SMSound object. (hay many times its played already)</p>
		 */
		function set currentLoop(value:int):void;
		
		/**
		 * the current position in the flash sound in milliseconds.
		 */
		function get position():Number;
		
		/**
		 * the length of the sound in seconds.
		 */
		function get duration():Number;
		
		/**
		 * returns the current playing state of the sound.  
		 * <ul>
		 * <li>PLAY_STATE_STOPPED </li>
		 * <li>PLAY_STATE_PAUSED </li>
		 * <li>PLAY_STATE_PLAYING </li>
		 * </ul>
		 */
		function get playState():String;
		
		/**
		 * returns the current mute state of the sound.  TRUE if muted, and FALSE otherwise.
		 */
		function get isMuted():Boolean;
		
		/**
		 * implemented for future functionality.  this percent is used internally to this sound object.
		 */
		function get mutePercent():Number;
		
		/**
		 * @private
		 */
		function get controller():SoundController;
		
		/**
		 * <p>Returns a reference to this sound's SoundController, if there is one.
		 * Returns null if there is not one.</p>
		 * 
		 * <p>Sets the SoundController that manages this sound.
		 * Sound only be used by the SoundController itself, during SoundController.addSound()</p>
		 * 
		 * @see com.jac.soundManager.SoundController.addSound() SoundController.addSound()
		 */
		function set controller(value:SoundController):void;
		
		/**
		 * returns the volume of the SoundController that is controlling this sound, if there is one.
		 * returns 1 if there is no SoundController
		 */
		function get controllerVol():Number;
		
		/**
		 * returns the volume of the SoundManager that controls this sound, through a SoundController, if there is one.
		 * returns 1, if there is no SoundManager
		 */
		function get managerVol():Number;
		
		/**
		 * returns <code>true</code> if the sound is currently paused, <code>false</code> otherwise.
		 */
		function get isPaused():Boolean;
	}//ISMSound
	
}