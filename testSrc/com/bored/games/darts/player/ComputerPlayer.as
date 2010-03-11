package com.bored.games.darts.player 
{
	import com.bored.games.darts.logic.AIProfile;
	import com.bored.games.darts.logic.AIShotCandidate;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.player.DartsPlayer;
	import flash.display.MovieClip;
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
		}//end constructor()
		
		public function set profile(a_profile:AIProfile):void
		{
			_profile = a_profile;
			//this.playerName = _profile.name;
		}//end set difficulty()
		
		override public function takeTheShot():void
		{
			var _gameType:String = this._game.gameType;
			var _clipList:Vector.<MovieClip> = new Vector.<MovieClip>();
			if (_gameType == "CRICKET") {
				var player1Stats:Object = this._game.scoreManager.getPlayerStats(CricketGameLogic.PLAYER_ONE);
				var player2Stats:Object = this._game.scoreManager.getPlayerStats(CricketGameLogic.PLAYER_TWO);
				var points:int = 15;
				
				while ( points <= 20 ) {
					if ( player1Stats[points] >= 3 && player2Stats[points] < 3 )
					{
						_clipList.push(this._game.getDartboardClip(points, 3));
					}
					++points;
				}
				if ( player1Stats[25] >= 3 && player2Stats < 3 ) {
					_clipList.push(this._game.getDartboardClip(25, 2));
				}
				if ( this._game.scoreManager.getPlayerScore(CricketGameLogic.PLAYER_TWO) < this._game.scoreManager.getPlayerScore(CricketGameLogic.PLAYER_ONE) + 15 ) {
					points = 15;
					while ( points <= 20 ) {
						if ( player2Stats[points] >= 3 && player1Stats[points] < 3 )
						{
							_clipList.push(this._game.getDartboardClip(points, 3));
						}
						++points;
					}
					if ( player2Stats[25] >= 3 && player1Stats < 3 ) {
						_clipList.push(this._game.getDartboardClip(25, 2));
					}					
				}
				points = 15;
				while ( points <= 20 ) {
					if ( player2Stats[points] < 3 )
					{
						_clipList.push(this._game.getDartboardClip(points, 3));
					}
					++points;
				}
				if ( player2Stats[25] < 3 ) {
					_clipList.push(this._game.getDartboardClip(25, 2));
				}
			}
			
			var shotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			
			for ( var i:int = 0; i < _clipList.length; i++ ) {
				var clipScaledX:Number = (_clipList[i].x / this._game.dartboardClip.width);
				var clipScaledY:Number = (_clipList[i].y / this._game.dartboardClip.height);
				
				shotList.push( new AIShotCandidate(clipScaledX, clipScaledY) );
			}			
			
			var finalShot:AIShotCandidate = _profile.pickShot(shotList);
			
			this._game.playerThrow(finalShot.point.x, finalShot.point.y, 0, 14, (Math.random() - 0.5) );
		}//end takeTheShot()
		
	}//end ComputerPlayer

}//end com.bored.games.darts.player