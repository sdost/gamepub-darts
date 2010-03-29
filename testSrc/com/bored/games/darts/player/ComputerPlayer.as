package com.bored.games.darts.player 
{
	import com.bored.games.darts.logic.AIProfile;
	import com.bored.games.darts.logic.AIShotCandidate;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.player.DartsPlayer;
	import com.sven.utils.AppSettings;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ComputerPlayer extends DartsPlayer
	{
		private var _profile:AIProfile;
		
		public function ComputerPlayer() 
		{
			super("COMPUTER");
			
			_profile = new AIProfile();
			
		}//end constructor()
		
		public function set profile(a_profile:AIProfile):void
		{
			_profile = a_profile;
			//this.playerName = _profile.name;
		}//end set difficulty()
		
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
			
			this._game.playerThrow(
				finalShot.point.x,
				finalShot.point.y,
				0,
				AppSettings.instance.aiOptimumThrust + (Math.random() * AppSettings.instance.aiThrustErrorRange * 2) - AppSettings.instance.aiThrustErrorRange,
				(Math.random() * AppSettings.instance.aiLeanRange * 2) - AppSettings.instance.aiLeanRange
			);
		}//end takeTheShot()
		
	}//end ComputerPlayer

}//end com.bored.games.darts.player