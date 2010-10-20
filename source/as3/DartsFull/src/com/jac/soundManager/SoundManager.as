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
	import com.greensock.easing.Linear;
	import com.jac.soundManager.events.SMSoundEvent;
	import com.jac.soundManager.events.SMSoundFadeEvent;
	import com.jac.soundManager.events.SMSoundVolumeEvent;
	import com.jac.soundManager.SoundController;
	import com.jac.utils.ArrayUtils;
	import com.jac.utils.MathUtils;
	import flash.events.EventDispatcher;
	import com.greensock.TweenLite;
	
	/**
	* Dispatched when play() is called on this SoundManager.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.PLAY
	* 
	* @see #play()
	*/
	[Event("PLAY", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when stop() is called on this SoundManager.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.STOP
	* 
	* @see #stop()
	*/
	[Event("STOP", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when pause() is called on this SoundManager.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.PAUSE
	* 
	* @see #pause()
	*/
	[Event("PAUSE", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when resume() is called on this SoundManager.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.RESUME
	* 
	* @see #resume()
	*/
	[Event("RESUME", type="com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when mute() is called on this SoundManager.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.MUTE
	* 
	* @see #mute()
	*/
	[Event("MUTE", type = "com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when unMute() is called on this SoundManager.
	* 
	* @eventType com.jac.soundManager.events.SMSoundEvent.UNMUTE
	* 
	* @see #unMute()
	*/
	[Event("UNMUTE", type = "com.jac.soundManager.events.SMSoundEvent")]
	
	/**
	* Dispatched when setVolume() or forceVolume() is called on this SoundManager.  This will also be dispatched on each volume update during a fadeVolume() call.
	* 
	* @eventType com.jac.soundManager.events.SMSoundVolumeEvent.VOLUME_CHANGE
	* 
	* @see #setVolume()
	* @see #forceVolume()
	* @see #fadeVolume()
	*/
	[Event("VOLUME_CHANGE", type="com.jac.soundManager.events.SMSoundVolumeEvent")]
	
	
	/**
	* Dispatched each time fadeVolume() is called on this SoundManager (once per call).
	* 
	* @eventType com.jac.events.soundManager.SMSoundFadeEvent.VOLUME_FADE_START
	* 
	* @see #fadeVolume()
	*/
	[Event("VOLUME_FADE_START", type = "com.jac.soundManager.events.SMSoundFadeEvent")]
	
	/**
	* Dispatched on each volume fade update.  Dispatched from the volumeFadeUpdate() call.
	* 
	* @eventType com.jac.events.soundManager.SMSoundFadeEvent.VOLUME_FADE_UPDATE
	* 
	* @see #volumeFadeUpdate()
	*/
	[Event("VOLUME_FADE_UPDATE", type="com.jac.soundManager.events.SMSoundFadeEvent")]
	
	/**
	* Dispatched when a volume fade has completed on this SoundManager.  Dispatched from the volumeFadeComplete() call.
	* 
	* @eventType com.jac.events.soundManager.SMSoundFadeEvent.VOLUME_FADE_COMPLETE
	* 
	* @see #volumeFadeComplete()
	*/
	[Event("VOLUME_FADE_COMPLETE", type = "com.jac.soundManager.events.SMSoundFadeEvent")]
	
	/**
	 * This object is used to manage a list of SoundController objects. Methods called on the SoundManager 
	 * will be applied to all of the contained SoundControllers.
	 * 
	 * There are three key objects to use this manager
	 * <ul>
	 * <li>SoundManager - the "global" controller that calls methods on its list of SoundControllers.</li>
	 * <li>SoundController - A controller for a group of SMSound objects.  The SoundController is used
	 * 						to manipulate individual SMSounds as well as groups of SMSounds.</li>
	 * <li>SMSound - The actual sound object.  This handles managing the sound, soundTransforms, soundChannels, and
	 * 				all other low level flash sound behaviours.  This should (but isn't required to) be controlled from
	 * 				a SoundController</li>
	 * </ul>
	 * 
	 * <p>All of these objects can work together or individually.  A SMSound can be created and used on its own.
	 * Likewise the SoundController does not need the SoundManager to function.
	 * To add/remove sound controllers please see addSoundController and removeSoundControllerByID</p>
	 * 
	 * <p>The SoundManager class is of the Singleton pattern.</p>
	 * 
	 * To get a reference to it, please use
	 * <p><code>var _soundManager:SoundManager = SoundManager.getInstance();</code></p>
	 * 
	 * <p>To create more than one sound manager, simply extends this class and create a new singleton.</p>
	 */
	public class SoundManager extends EventDispatcher
    {//SoundManager Class
        public static var _instance:SoundManager;
		
		protected var _soundControllerList:Array;
		protected var _isMuted:Boolean = false;
		protected var _isPaused:Boolean = false;
		protected var _volume:Number = 1;
		protected var _fadeVol:Object;	//Temp object used to store second volume var, for use with TweenLite.
		
		/**
		 * Returns a reference to the SoundManager singleton.
		 */
        public static function getInstance():SoundManager
        {//getInstance
            if( _instance == null ) _instance = new SoundManager( new SoundManagerEnforcer() );
            return _instance;
        }//getInstance
		
		/**
		 * Does the initial creation and init of the SoundManager
		 */
        public function SoundManager( pvt:SoundManagerEnforcer )
        {//SoundManager
            _soundControllerList = new Array();
			_fadeVol = new Object();
			_fadeVol.fadeVolume = 1;
        }//SoundManager
		
		/**
		 * Adds a SoundController to the list of controllers to be managed by this SoundManager
		 * 
		 * @param	controller the SoundController object you want to be managed by this SoundManager
		 * @return A reference to the added SoundController <p>Returns null if the ID already exists in the list if managed SoundControllers</p>
		 */
		public function addSoundController(controller:SoundController):SoundController
		{//addSoundController
			if (ArrayUtils.findObjectsWithPropertyInArray(_soundControllerList, "id", controller.id).length == 0)
			{//add
				_soundControllerList.push(controller);
				controller.soundManager = this;
				return controller;
			}//add
			else
			{//already exists
				trace(">>>>>> new controller not made, already exists in list: " + controller.id);
				return null;
			}//already exists
		}//addSoundController
		
		/**
		 * Removes a SoundController from this SoundManager
		 * 
		 * @param	soundControllerID the ID of the SoundController to be removed from the control of this SoundManager.
		 * @return TRUE if the SoundController was removed, FALSE otherwise.
		 */
		public function removeSoundControllerByID(soundControllerID:String):Boolean
		{//removeSoundControllerByID
			var wasRemoved:Boolean = false;
			var soundController:SoundController = getSoundControllerByID(soundControllerID);
			
			if (soundController)
			{//stop and clean up
				TweenLite.killTweensOf(soundController, false);
				wasRemoved = ArrayUtils.removeFirstFromArray(_soundControllerList, soundController);
			}//stop and clean up
			else
			{//couldn't find it
				trace(">>>>>>> Could not remove SoundController: " + soundControllerID);
			}//couldn't find it
			
			return wasRemoved;
		}//removeSoundControllerByID
		
		/**
		 * This will toggle the muted state of the SoundManager
		 * 
		 * @return The muted state after the toggle.  TRUE if it is not muted, FALSE, if no longer muted.
		 */
		public function toggleMute():Boolean
		{//toggleGlobalMute
			if (_isMuted)
			{//unmute
				unMute();
			}//unmute
			else
			{//mute
				mute();
			}//mute
			
			return _isMuted;
		}//toggleGlobalMute
		
		/**
		 * This will mute the SoundManager. (thus muting all SoundControllers)
		 * <p>Dispatches a <code>SMSoundEvent.MUTE</code> event.</p>
		 */
		public function mute():void
		{//globalMute
			_isMuted = true;
			
			for (var i:int = 0; i < _soundControllerList.length; i++)
			{//mute
				_soundControllerList[i].muteAllSounds();
				//_soundControllerList[i].checkMute();
			}//mute
			
			dispatchEvent(new SMSoundEvent(SMSoundEvent.MUTE, this,true, false));
		}//globalMute
		
		/**
		 * This will turn off the muting on this SoundManager and return the sound to the set volume.
		 * <p>Dispatches a <code>SMSoundEvent.UNMUTE</code> event.</p>
		 */
		public function unMute():void
		{//globalMute
			_isMuted = false;
			
			for (var i:int = 0; i < _soundControllerList.length; i++)
			{//mute
				_soundControllerList[i].unMuteAllSounds();
			}//mute
			
			dispatchEvent(new SMSoundEvent(SMSoundEvent.UNMUTE, this, false, false));
		}//globalMute
		
		/**
		 * This will call SoundController.playAllSounds() on each managed SoundController.
		 * The most likely result of this is playing all sounds in the app, at the same time.
		 * 
		 * <p>Dispatches a <code>SMSoundEvent.PLAY</code> event.</p>
		 */
		public function play():void
		{//globalPlay
			_isPaused = false;
			
			TweenLite.killTweensOf(this);
			for (var i:int = 0; i < _soundControllerList.length; i++)
			{//stop
				_soundControllerList[i].playAllSounds();
			}//stop
			
			dispatchEvent(new SMSoundEvent(SMSoundEvent.PLAY, null, false, false));
		}//globalPlay
		
		/**
		 * This will call SoundController.stopAllSounds() on each managed SoundController.
		 * The most likely result of this is stopping all sounds in the SoundController.
		 * <p>Dispatches a <code>SMSoundEvent.STOP</code> event.</p>
		 */
		public function stop():void
		{//globalStop
			TweenLite.killTweensOf(this);
			for (var i:int = 0; i < _soundControllerList.length; i++)
			{//stop
				_soundControllerList[i].stopAllSounds();
			}//stop
			
			dispatchEvent(new SMSoundEvent(SMSoundEvent.STOP, null, false, false));
		}//globalStop
		
		/**
		 * This will toggle the pause state of the SoundManager.
		 * 
		 * @return The state of pause after the toggle completes.  TRUE if now paused, FALSE if now not paused.
		 * 
		 * @see #pause()
		 * @see #resume()
		 */
		public function togglePause():Boolean
		{//toggleGlobalPause
			if (_isPaused)
			{//resume
				resume();
			}//resume
			else
			{//pause
				pause();
			}//pause
			
			return _isPaused;
		}//toggleGlobalPause
		
		/**
		 * This will call SoundController.pauseAllSounds() on each managed SoundController
		 * The most likely result of this is pausing all sounds in the SoundController.
		 * <p>Dispatches a <code>SMSoundEvent.PAUSE</code> event.</p>
		 * 
		 * @see com.jac.soundManager.SoundController#pauseAllSounds() pauseAllSounds()
		 * @see #togglePause()
		 * @see #resume()
		 */ 
		public function pause():void
		{//globalPause
			_isPaused = true;
			TweenLite.killTweensOf(this);
			
			for (var i:int = 0; i < _soundControllerList.length; i++)
			{//stop
				_soundControllerList[i].pauseAllSounds();
			}//stop
			
			_isPaused = true;
			
			dispatchEvent(new SMSoundEvent(SMSoundEvent.PAUSE, null,true, false));
		}//globalPause
		
		/**
		 * Function: resume
		 * This will call resumeAllSounds() on each managed SoundController
		 * The most likely result of this, is resuming any paused sound in the SoundController.
		 * <p>Dispatches a <code>SMSoundEvent.RESUME</code> event.</p>
		 * 
		 * @see #pause()
		 * @see #togglePause()
		 * @see com.jac.soundManager.SoundController#resumeAllSounds() resumeAllSounds()
		 */
		public function resume():void
		{//globalPause
			_isPaused = false;
			TweenLite.killTweensOf(this);
			
			for (var i:int = 0; i < _soundControllerList.length; i++)
			{//stop
				_soundControllerList[i].resumeAllSounds();
			}//stop
			
			_isPaused = false;
			
			dispatchEvent(new SMSoundEvent(SMSoundEvent.RESUME, null, true, false));
		}//globalPause
		
		/**
		 * Function getSoundControllerByID
		 * Returns a reference to a SoundController object that has the passed in ID
		 * 
		 * @param	controllerID the ID of a managed SoundController
		 * @return  A reference to the SoundController that has the passed in ID This will return null, if no controller is found.
		 * 
		 * @see com.jac.soundManager.SoundController SoundController
		 */
		public function getSoundControllerByID(controllerID:String):SoundController
		{//getSoundControllerByID
			var index:int = ArrayUtils.findFirstObjectWithPropertyInArray(_soundControllerList, "id", controllerID).index;
			
			if (index != -1)
			{//found it
				return _soundControllerList[index];
			}//found it
			else
			{//didn't find
				trace(">>>>>>>>>>> could not getSoundControllerByID for: " + controllerID +". Not in list");
				return null;
			}//didn't find
		}//getSoundControllerByID
		
		/**
		 * This is called on every update during a fadeVolume() call.
		 * It is used to notify the SoundControllers to check their volume.
		 * <p><b>You should not need to use this method directly.</b></p>
		 * 
		 * @param	vol the current volume of the fade.
		 */
		protected function setFadeVol(vol:Number):void
		{//setFadeVol
			_volume =  vol;
			
			for (var i:int = 0; i < _soundControllerList.length; i++)
			{//vol
				_soundControllerList[i].checkVolume();
			}//vol
			
		}//setFadeVol
		
		/**
		 * This will set the volume of the SoundManager.
		 * Lowering this 50% will essentially lower each SoundController 50% from their current volume, which in turn
		 * lowers the SMSound 50% of its current volume.
		 * This will also stop any tweens from a fadeVolume() on this SoundManager before the volume is set.
		 * 
		 * <p>Dispatches a <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event.</p>
		 * 
		 * @param	vol	A number from 0 - 1 that represents the new volume of the SoundManager. This number will be clamped to the 0-1 range.  If 1.5 is passed, the volume will be set to 1.
		 * 
		 * @see #fadeVolume()
		 * @see #forceVolume()
		 */
		public function setVolume(vol:Number):void
		{//setGlobalVolume
			TweenLite.killTweensOf(this, false);
			
			_volume = MathUtils.clamp(0, 1, vol);
			
			for (var i:int = 0; i < _soundControllerList.length; i++)
			{//vol
				//_soundControllerList[i].volume = _soundControllerList[i].volume;
				_soundControllerList[i].checkVolume();
			}//vol
			dispatchEvent(new SMSoundVolumeEvent(SMSoundVolumeEvent.VOLUME_CHANGE, this, _volume));
		}//setGlobalVolume
		
		/**
		 * This will force the volume of all managed SoundControllers and SMSounds to the passed in volume.
		 * Please note that this will override any other volume modifications currently applied to the objects.
		 * This will also stop any tweens from a fadeVolume() on this SoundManager before the volume is set.
		 * 
		 * <p><b>Chances are pretty good that you want to use setVolume() in most cases.</b></p>
		 * 
		 * <p>Dispatches a <code>SMSoundVolumeEvent.VOLUME_CHANGE</code> event.</p>
		 * 
		 * @param	vol	A volume to force all sounds to, 0-1.  This number is not clamped at this level, however it may be clamped further down the chain.
		 * 
		 * @see #setVolume()
		 */
		public function forceVolume(vol:Number):void
		{//forceGlobalVolume
			TweenLite.killTweensOf(this, false);
			
			for (var i:int = 0; i < _soundControllerList.length; i++)
			{//vol
				_soundControllerList[i].forceAllVolume(vol);
			}//vol
			dispatchEvent(new SMSoundVolumeEvent(SMSoundVolumeEvent.VOLUME_CHANGE, this, vol));
		}//forceGlobalVolume
		
		/**
		 * This will fade the volume of the SoundManager over a given time.
		 * This will also stop any tweens from a previous fadeVolume() on this SoundManager before the new fade is started.
		 * 
		 * @param	endPercent	The final volume the SoundManger should reach.
		 * @param	duration	The amount of time in seconds the fade should take to finish.
		 * @param	curve		A TweenLite/Max curve definition to tween the volume by.
		 */
		public function fadeVolume(endPercent:Number, duration:Number, curve:* = null):void
		{//fadeGlobalVolumeByPercent
			TweenLite.killTweensOf(this, false);
			
			if (!curve)
			{//set default
				curve = Linear.easeOut;
			}//set default
			
			//Maintain FadeVolume so as to not inadvertantly kill a tween.
			_fadeVol.fadeVolume = _volume;
			
			TweenLite.to(_fadeVol, duration, { fadeVolume:endPercent, ease:curve, 
												onStart:volumeFadeStart,
												onUpdate:volumeFadeUpdate,
												onComplete:volumeFadeComplete} );
		}//fadeGlobalVolumeByPercent
		
		/**
		 * Called when a volume fade starts.
		 * <p>Dispatches a <code>SMSoundFadeEvent.VOLUME_FADE_START</code> event.</p>
		 */
		protected function volumeFadeStart():void
		{//globalVolumePercentFadeStart
			dispatchEvent(new SMSoundFadeEvent(SMSoundFadeEvent.VOLUME_FADE_START, null));
		}//globalVolumePercentFadeStart
		
		/**
		 * Called when a volume fade finishes.
		 * <p>Dispatches a <code>SMSoundFadeEvent.VOLUME_FADE_COMPLETE</code> event.</p>
		 */
		protected function volumeFadeComplete():void
		{//globalVolumePercentFadeComplete
			dispatchEvent(new SMSoundFadeEvent(SMSoundFadeEvent.VOLUME_FADE_COMPLETE, null));
		}//globalVolumePercentFadeComplete
		
		/**
		 * Called on every update of a volume fade.
		 * <p>Dispatches a <code>SMSoundFadeEvent.VOLUME_FADE_UPDATE</code> event.</p>
		 */
		protected function volumeFadeUpdate():void
		{//fadeGlobalVolumeByPercentUpdate
			setFadeVol(_fadeVol.fadeVolume);
			dispatchEvent(new SMSoundVolumeEvent(SMSoundVolumeEvent.VOLUME_CHANGE, this, _volume));
			dispatchEvent(new SMSoundFadeEvent(SMSoundFadeEvent.VOLUME_FADE_UPDATE, null));
		}//fadeGlobalVolumeByPercentUpdate
		
		/////////////// GETTERS / SETTERS ////////////////
		
		/**
		 * @private
		 */
		public function get volume():Number { return _volume; }
		
		/**
		 * Returns the current volume of the SoundManager
		 * <p>Sets the volume of the SoundManager, by calling setVolume()</p>
		 */
		public function set volume(value:Number):void 
		{//set globalVolumePercent
			setVolume(value);
		}//set globalVolumePercent
		
		/**
		 * Returns the muted state of the SoundManager.  <code>TRUE</code> if muted, <code>FALSE</code>, if not.
		 */
		public function get isMuted():Boolean { return _isMuted; }
		
		/**
		 * Returns the pause state of the SoundManager. <code>TRUE</code> if paused, <code>FALSE</code>, if not.
		 */
		public function get isPaused():Boolean { return _isPaused; }
		
		
    }//SoundManager Class
}
 
internal class SoundManagerEnforcer{}
