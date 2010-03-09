package com.bored.games.darts.player 
{
	import com.bored.games.controllers.AIController;
	import com.bored.games.darts.logic.AIOpponentProfile;
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
		private var _difficulty:int = 2;
		
		private var _controller:AIController;
		private var _profile:AIProfile;
		
		public function ComputerPlayer() 
		{
			super();
		}//end constructor()
		
		public function set difficulty(a_difficutly:int):void
		{
			
		}//end set difficulty()
		
		override public function get playerName():String
		{
			return "COMPUTER";
		}//end get playerName()
		
		override public function takeTheShot():void
		{
			var _gameType:String = this._game.gameType;
			var _clipList:Vector.<MovieClip> = new Vector.<MovieClip>();
			if (_gameType == "CRICKET") {
				var player1Scores:Object = this._game.scoreManager.getPlayerScores(CricketGameLogic.PLAYER_ONE);
				var player2Scores:Object = this._game.scoreManager.getPlayerScores(CricketGameLogic.PLAYER_TWO);
				var points:int = 15;
				
				while ( points <= 20 ) {
					if ( player1Scores[points] >= 3 && player2Scores[points] < 3 )
					{
						_clipList.push(this._game.getDartClip(points, 3));
					}
					++points;
				}
				if ( player1Scores[25] >= 3 && player2Scores < 3 ) {
					_clipList.push(this._game.getDartClip(25, 2));
				}
				if ( this._game.scoreManager.getPlayerScore(CricketGameLogic.PLAYER_TWO) < this._game.scoreManager.getPlayerScore(CricketGameLogic.PLAYER_ONE) + 15 ) {
					points = 15;
					while ( points <= 20 ) {
						if ( player2Scores[points] >= 3 && player1Scores[points] < 3 )
						{
							_clipList.push(this._game.getDartClip(points, 3));
						}
						++points;
					}
					if ( player2Scores[25] >= 3 && player1Scores < 3 ) {
						_clipList.push(this._game.getDartClip(25, 2));
					}					
				}
				points = 15;
				while ( points <= 20 ) {
					if ( player2Scores[points] < 3 )
					{
						_clipList.push(this._game.getDartClip(points, 3));
					}
					++points;
				}
				if ( player2Scores[25] < 3 ) {
					_clipList.push(this._game.getDartClip(25, 2));
				}
			}
			
			for ( var i:int = 0; i < _clipList.length; i++ ) {
				var clipScaledX:Number = (_clipList[i].x / this._game.dartboardClip.width);
				var clipScaledY:Number = (_clipList[i].y / this._game.dartboardClip.height);
				
			}			
		}//end takeTheShot()
		
	}//end ComputerPlayer

}//end com.bored.games.darts.player