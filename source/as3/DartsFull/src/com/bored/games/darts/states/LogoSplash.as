package com.bored.games.darts.states 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.states.statemachines.GameFSM;
	import com.bored.games.darts.ui.TitleScreen;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	import com.sven.utils.AppSettings;
	import com.sven.utils.MovieClipFactory;
	import com.sven.utils.SpriteFactory;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	/**
	 * ....
	 * @author Samuel Dost
	 */
	public class LogoSplash extends State
	{
		private var _monsterproofLogo:MovieClip;
		
		public function LogoSplash(a_name:String, a_stateMachine:IStateMachine)
		{
			super(a_name, a_stateMachine);
			
		}//end LogoSplash() constructor.
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			try
			{
				_monsterproofLogo = MovieClipFactory.getMovieClipByQualifiedName(AppSettings.instance.splashLogo);
				_monsterproofLogo.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
				DartsGlobals.instance.screenSpace.addChild(_monsterproofLogo);
			}
			catch (e:Error)
			{
				DartsGlobals.addWarning("LogoSplash::onEnter(): Caught error=" + e);
			}
			
		}//end onEnter()
		
		private function addedToStage(evt:Event):void
		{
			_monsterproofLogo.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			_monsterproofLogo.addEventListener(Event.ENTER_FRAME, runOnce, false, 0, true);
			_monsterproofLogo.gotoAndPlay(1);
		}//end addedToStage()
		
		private function runOnce(evt:Event):void
		{
			if ( _monsterproofLogo.currentFrame == _monsterproofLogo.totalFrames ) 
			{
				_monsterproofLogo.removeEventListener(Event.ENTER_FRAME, runOnce);
				(this.stateMachine as GameFSM).transitionToNextState();
				DartsGlobals.instance.screenSpace.removeChild(_monsterproofLogo);
			}
		}//end runOnce()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{			
		}//end onExit()
		
	}//end class LogoSplash
	
}//end package com.bored.games.darts.states