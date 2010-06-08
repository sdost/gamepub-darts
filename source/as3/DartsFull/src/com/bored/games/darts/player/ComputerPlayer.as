package com.bored.games.darts.player 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AIShotCandidate;
	import com.bored.games.darts.logic.CricketGameLogic;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.bored.games.darts.profiles.Profile;
	import com.greensock.TweenMax;
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
		private var _profile:Profile;
		
		private var _previousPosition:Object;
		private var _currentPosition:Object;
		
		private var _finalShot:AIShotCandidate;
		
		private var _throwTween:TweenMax;
		
		public function ComputerPlayer(a_profile:Profile) 
		{
			super(a_profile.name);
			
			_profile = a_profile;
			
			_previousPosition = { x:0, y:0 };
			_currentPosition = { x:0, y:0 };
		}//end constructor()
		
		override public function takeTheShot(a_dartsRemaining:int):void
		{
			var myStats:Object = this._game.scoreManager.getPlayerStats(this.playerNum);
			var allStats:Object = this._game.scoreManager.getAllPlayerStats();
			
			var myShotList:Vector.<AIShotCandidate> = _profile.generateShotList(this._game.gameType, myStats, allStats);
			_finalShot = _profile.pickShot(a_dartsRemaining, myShotList);
			
			var version:int;
			
			if ( DartsGlobals.instance.gameMode == DartsGlobals.GAME_STORY ) 
			{
				for each( var ability:Ability in this.abilities )
				{
					if ( ability.name == _finalShot.modifier && DartsGlobals.instance.opponentPlayer.hasAbility(ability.name) ) {
						DartsGlobals.instance.gameManager.abilityManager.activateAbility(ability);
						
						version = Math.ceil( Math.random() * 2 );
						
						(_profile as EnemyProfile).playSound("generic_special" + version.toString());
					}
				}
			}
			
			DartsGlobals.instance.gameManager.currentDart.position.x = _previousPosition.x;
			DartsGlobals.instance.gameManager.currentDart.position.y = _previousPosition.y;
			
			version = Math.ceil( Math.random() * 2 );
						
			(_profile as EnemyProfile).playSound("generic_prethrow" + version.toString());
			
			_throwTween = TweenMax.to( DartsGlobals.instance.gameManager.currentDart.position, 1, { 
				x: _finalShot.point.x, 
				y: _finalShot.point.y,
				delay:2,
				onComplete: performThrow 
			} ); 
		}//end takeTheShot()
		
		public function cancelShot():void
		{
			_throwTween.kill();
		}//end cancelShot()
		
		override public function processShotResult(a_points:int, a_multiplier:int, a_scoring:Boolean):void
		{
			super.processShotResult(a_points, a_multiplier, a_scoring);
			_profile.handleShot(a_points, a_multiplier);
		}//end processShotResults()
		
		private function performThrow():void
		{
			var thrustErrorRange:Number = ((1.0 - _profile.accuracy) * (AppSettings.instance.aiThrustErrorRangeMax - AppSettings.instance.aiThrustErrorRangeMin)) + AppSettings.instance.aiThrustErrorRangeMin;
			var leanErrorRange:Number = ((1.0 - _profile.accuracy) * (AppSettings.instance.aiLeanRangeMax - AppSettings.instance.aiLeanRangeMin)) + AppSettings.instance.aiLeanRangeMin;
			
			if ( _finalShot.modifier == "boost" ) 
			{
				thrustErrorRange = 0;
				leanErrorRange = 0;
			}
			
			_previousPosition.x = _finalShot.point.x;
			_previousPosition.y = _finalShot.point.y;
			
			var version:int = Math.ceil( Math.random() * 2 );
						
			(_profile as EnemyProfile).playSound("generic_throw" + version.toString());
			
			this._game.playerThrow(
				_finalShot.point.x,
				_finalShot.point.y,
				0,
				AppSettings.instance.aiOptimumThrust + (Math.random() * thrustErrorRange * 2) - thrustErrorRange,
				(Math.random() * leanErrorRange * 2) - leanErrorRange,
				_profile.stepScale
			);
		}//end performThrow()
		
	}//end ComputerPlayer

}//end com.bored.games.darts.player