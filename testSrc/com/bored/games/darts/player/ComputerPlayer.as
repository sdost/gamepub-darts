﻿package com.bored.games.darts.player 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.abilities.Ability;
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
		
		private var _finalShot:AIShotCandidate;
		
		public function ComputerPlayer(a_profile:AIProfile) 
		{
			super("COMPUTER");
			
			_profile = a_profile;
			
			_previousPosition = { x:0, y:0 };
			_currentPosition = { x:0, y:0 };
		}//end constructor()
		
		override public function takeTheShot():void
		{
			var myStats:Object = this._game.scoreManager.getPlayerStats(this.playerNum);
			var allStats:Object = this._game.scoreManager.getAllPlayerStats();
			
			var myShotList:Vector.<AIShotCandidate> = _profile.generateShotList(this._game.gameType, myStats, allStats);
			_finalShot = _profile.pickShot(myShotList);
			
			for each( var ability:Ability in this.abilities )
			{
				if ( ability.name == _finalShot.modifier ) {
					DartsGlobals.instance.gameManager.abilityManager.activateAbility(ability);
				}
			}
			
			DartsGlobals.instance.gameManager.currentDart.position.x = _previousPosition.x;
			DartsGlobals.instance.gameManager.currentDart.position.y = _previousPosition.y;
			
			TweenLite.to( DartsGlobals.instance.gameManager.currentDart.position, 2, { 
				x: _finalShot.point.x, 
				y: _finalShot.point.y,
				delay:1,
				onComplete: performThrow 
			} ); 
		}//end takeTheShot()
		
		override public function processShotResult(a_points:int, a_multiplier:int):void
		{
			super.processShotResult(a_points, a_multiplier);
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
			
			this._game.playerThrow(
				_finalShot.point.x,
				_finalShot.point.y,
				0,
				AppSettings.instance.aiOptimumThrust + (Math.random() * thrustErrorRange * 2) - thrustErrorRange,
				(Math.random() * leanErrorRange * 2) - leanErrorRange
			);
		}//end performThrow()
		
	}//end ComputerPlayer

}//end com.bored.games.darts.player