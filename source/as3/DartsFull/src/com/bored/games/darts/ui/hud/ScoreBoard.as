package com.bored.games.darts.ui.hud 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AbstractScoreManager;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.CricketScoreManager;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.greensock.TweenLite;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class ScoreBoard extends ContentHolder
	{		
		protected var _playerOnePortrait:MovieClip;
		protected var _playerTwoPortrait:MovieClip;
		
		protected var _playerOneTimer:MovieClip;
		protected var _playerTwoTimer:MovieClip;
		
		protected var _scoreMgr:AbstractScoreManager;
		
		public function ScoreBoard(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true) 
		{
			super(a_img, a_buildFromAllDescendants, a_bAddContents);
			
			if (this.stage)
			{
				addedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
			
		}//end GameReadyPopup() constructor.
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
						
			_playerOnePortrait = descendantsDict["playerOnePortrait_mc"] as MovieClip;
			_playerTwoPortrait = descendantsDict["playerTwoPortrait_mc"] as MovieClip;
			
			_playerOneTimer = descendantsDict["playerOneTimer_mc"] as MovieClip;
			_playerTwoTimer = descendantsDict["playerTwoTimer_mc"] as MovieClip;
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			this.contentsMC.alpha = 1;
			
			this.alpha = 0;
			
		}//end addedToStage()
		
		public function registerScoreManager(a_mgr:AbstractScoreManager):void
		{
			_scoreMgr = a_mgr;
			
			if (_playerOnePortrait) {
				var portraitOne:Bitmap = new Bitmap(DartsGlobals.instance.gameManager.players[DartsGlobals.instance.localPlayer.playerNum].portrait.bitmapData);
				portraitOne.smoothing = true;
				portraitOne.width = 40;
				portraitOne.height = 40;
				
				_playerOnePortrait.addChild(portraitOne);
			} else {
				throw new Error("ScoreBoard::registerScoreManager(): _playerOnePortrait=" + _playerOnePortrait);
			}
			
			if (_playerTwoPortrait) {
				var portraitTwo:Bitmap = new Bitmap(DartsGlobals.instance.gameManager.players[DartsGlobals.instance.opponentPlayer.playerNum].portrait.bitmapData);
				portraitTwo.smoothing = true;
				portraitTwo.width = 40;
				portraitTwo.height = 40;
				
				_playerTwoPortrait.addChild(portraitTwo);
			} else {
				throw new Error("ScoreBoard::registerScoreManager(): _playerTwoPortrait=" + _playerTwoPortrait);
			}
			
			_playerOneTimer.visible = false;
			_playerOneTimer.gotoAndStop(1);
			_playerTwoTimer.visible = false;
			_playerTwoTimer.gotoAndStop(1);
		}//end registerScoreManager()
		
		public function update():void
		{	
			if ( DartsGlobals.instance.localPlayer.turnTime >= 0 )
			{
				_playerOneTimer.visible = true;
				_playerOneTimer.gotoAndStop( Math.ceil(100 * (60 - DartsGlobals.instance.localPlayer.turnTime) / 60) );
			}
			else
			{
				_playerOneTimer.visible = false;
			}
				
			if ( DartsGlobals.instance.opponentPlayer.turnTime >= 0 )
			{
				_playerTwoTimer.visible = true;
				_playerTwoTimer.gotoAndStop( Math.ceil(100 * (60 - DartsGlobals.instance.opponentPlayer.turnTime) / 60) );
			}
			else
			{
				_playerTwoTimer.visible = false;
			}
		}//end update()
		
		public function show():void
		{
			TweenLite.to(this, 2, {alpha:1} );
		}//end show()
		
		public function hide():void
		{
			TweenLite.to(this, 2, {alpha:0} );
		}//end hide()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			_playerOnePortrait = null;
			_playerTwoPortrait = null;
			
			_playerOneTimer = null;
			_playerTwoTimer = null;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);		
		}//end destroy()
		
	}//end class AttractScreen
	
}//end package com.bored.games.darts.ui 