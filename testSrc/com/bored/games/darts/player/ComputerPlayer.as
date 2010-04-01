package com.bored.games.darts.player 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AIProfile;
	import com.bored.games.darts.logic.AIShotCandidate;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.player.DartsPlayer;
	import com.greensock.TweenLite;
	import com.sven.utils.AppSettings;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ComputerPlayer extends DartsPlayer
	{
		private var _profile:AIProfile;
		
		private var _previousPosition:Object;
		private var _currentPosition:Object;
		
		public function ComputerPlayer(a_profile:AIProfile) 
		{
			super("COMPUTER");
			
			_profile = a_profile;
			
			_previousPosition = { x:0, y:0 };
			_currentPosition = { x:0, y:0 };
		}//end constructor()
		
		override public function takeTheShot():void
		{
			var _gameType:String = this._game.gameType;
			var _myClipList:Vector.<Sprite> = new Vector.<Sprite>();
			if (_gameType == "CRICKET") {				
				var myStats:Object = this._game.scoreManager.getPlayerStats(this.playerNum);
				var points:int = 15;
				while ( points <= 20 ) {
					if ( myStats[points] < 3 )
					{
						_myClipList.push(this._game.getDartboardClip(points, 1));
						_myClipList.push(this._game.getDartboardClip(points, 2));
						_myClipList.push(this._game.getDartboardClip(points, 3));
					}
					++points;
				}
				if ( myStats[25] < 3 ) {
					_myClipList.push(this._game.getDartboardClip(25, 1));
					_myClipList.push(this._game.getDartboardClip(25, 2));
				}
			}
			
			var myShotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			
			for ( var i:int = 0; i < _myClipList.length; i++ ) {
				
				var clipScaledX:Number = (_myClipList[i].x / (this._game.dartboard.boardSprite.width/2)) * AppSettings.instance.dartboardScale;
				var clipScaledY:Number = (_myClipList[i].y / (this._game.dartboard.boardSprite.height/2)) * AppSettings.instance.dartboardScale;
				
				myShotList.push( new AIShotCandidate(clipScaledX, -clipScaledY) );
			}
			
			var finalShot:AIShotCandidate = _profile.pickShot(myShotList);
			
			DartsGlobals.instance.gameManager.currentDart.position.x = _previousPosition.x;
			DartsGlobals.instance.gameManager.currentDart.position.y = _previousPosition.y;
			
			TweenLite.to( DartsGlobals.instance.gameManager.currentDart.position, 2, { 
				x: finalShot.point.x, 
				y: finalShot.point.y,
				delay:1,
				onComplete: performThrow 
			} ); 
		}//end takeTheShot()
		
		private function performThrow():void
		{
			var thrustErrorRange:Number = ((1.0 - _profile.accuracy) * (AppSettings.instance.aiThrustErrorRangeMax - AppSettings.instance.aiThrustErrorRangeMin)) + AppSettings.instance.aiThrustErrorRangeMin;
			var leanErrorRange:Number = ((1.0 - _profile.accuracy) * (AppSettings.instance.aiLeanRangeMax - AppSettings.instance.aiLeanRangeMin)) + AppSettings.instance.aiLeanRangeMin;
			
			_previousPosition.x = DartsGlobals.instance.gameManager.currentDart.position.x;
			_previousPosition.y = DartsGlobals.instance.gameManager.currentDart.position.y;
			
			this._game.playerThrow(
				DartsGlobals.instance.gameManager.currentDart.position.x,
				DartsGlobals.instance.gameManager.currentDart.position.y,
				0,
				AppSettings.instance.aiOptimumThrust + (Math.random() * thrustErrorRange * 2) - thrustErrorRange,
				(Math.random() * leanErrorRange * 2) - leanErrorRange
			);
		}//end performThrow()
		
	}//end ComputerPlayer

}//end com.bored.games.darts.player