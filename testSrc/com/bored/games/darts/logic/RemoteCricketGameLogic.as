﻿package com.bored.games.darts.logic 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.player.DartsPlayer;
	import com.bored.gs.game.GameClient;
	import com.bored.gs.game.ITurnBased;
	import com.bored.gs.game.TurnBasedGameClient;
	import com.sven.utils.AppSettings;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author sam
	 */
	public class RemoteCricketGameLogic extends DartsGameLogic
	{
		private var _serverResults:Object = null;
		
		public function RemoteCricketGameLogic()
		{
			_scoreManager = new CricketScoreManager();
			
			DartsGlobals.instance.multiplayerClient.addEventListener(GameClient.GAME_END, onGameEnd);
			
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.ROUND_START, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.ROUND_END, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.ROUND_RESULTS, handleStateChange);
			
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_START, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_WAIT, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_UPDATE, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_END, handleStateChange);
			DartsGlobals.instance.multiplayerClient.addEventListener(TurnBasedGameClient.TURN_RESULTS, handleStateChange);
		}//end constructor()
		
		private function onGameEnd(e:Event):void
		{
			// TODO: handle game ending...
		}//end onGameEnd()
		
		override public function playerThrow(a_x:Number, a_y:Number, a_z:Number, a_thrust:Number, a_lean:Number, a_stepScale:Number):void
		{			
			//_cursor.hide();
			_cursor.resetCursorImage();
			_inputController.pause = true;
			
			var thrust:Number;
			var lean:Number;
			var angle:Number;
			
			var version:int;
			
			if ( a_thrust < AppSettings.instance.dartSweetSpotMin ) 
			{
				version = Math.ceil(2 * Math.random());
				
				_soundController.play("throw_normal_" + version.toString());
				
				thrust = a_thrust;
				lean = a_lean;
				angle = AppSettings.instance.defaultAngle;
			}
			else if ( a_thrust > AppSettings.instance.dartSweetSpotMax ) 
			{
				version = Math.ceil(2 * Math.random());
				
				_soundController.play("throw_normal_" + version.toString());
								
				var scaler:Number = Math.log( AppSettings.instance.overthrowScale * (a_thrust - AppSettings.instance.dartSweetSpotThrust)
					/ (AppSettings.instance.dartMaxThrust - AppSettings.instance.dartSweetSpotThrust))
					/ Math.log(AppSettings.instance.overthrowExponent) + AppSettings.instance.overthrowOffset;
									
				thrust = a_thrust / scaler; // AppSettings.instance.dartSweetSpotThrust;
				lean = a_lean * scaler;
				angle = AppSettings.instance.defaultAngle * scaler;
			}
			else 
			{
				version = Math.ceil(2 * Math.random());
				
				_soundController.play("throw_fast_" + version.toString());
				
				thrust = AppSettings.instance.dartSweetSpotThrust;
				lean = a_lean;
				angle = AppSettings.instance.defaultAngle;
			}
			
			(DartsGlobals.instance.multiplayerClient as ITurnBased).sendTurnUpdate(
				{
					action: "p_t",
					x: a_x,
					y: a_y,
					z: a_z,
					thr: a_thrust,
					a: angle,
					g: AppSettings.instance.defaultGravity,
					lean: a_lean,
					zf: AppSettings.instance.dartboardPositionZ,
					step: a_stepScale
				} 
			);
			
			_currentDart.initThrowParams(a_x, a_y, a_z, thrust, angle, AppSettings.instance.defaultGravity, lean, AppSettings.instance.dartboardPositionZ, a_stepScale);
		}//end playerThrow()
		
		private function handleStateChange(e:Event):void
		{
			trace("State: " + e.type);
			
			var obj:Object;
			
			switch(e.type)
			{
				case TurnBasedGameClient.ROUND_START:
					break;
				case TurnBasedGameClient.ROUND_END:
					break;
				case TurnBasedGameClient.ROUND_RESULTS:
					break;
					
				case TurnBasedGameClient.TURN_START:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.TURN_START);
					_currentPlayer = obj.pid;
					startNewTurn();
					break;
				case TurnBasedGameClient.TURN_WAIT:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.TURN_WAIT);
					_currentPlayer = obj.pid;
					startNewTurn();
					break;
				case TurnBasedGameClient.TURN_UPDATE:
					obj = (DartsGlobals.instance.multiplayerClient as ITurnBased).getData(TurnBasedGameClient.TURN_UPDATE);
					if ( obj.action == "p_t" && obj.pid != DartsGlobals.instance.localPlayer.playerNum)
					{
						if( _currentDart ) _currentDart.initThrowParams(obj.x, obj.y, obj.z, obj.thr, obj.a, obj.g, obj.lean, obj.zf, obj.step);						
					} 
					else if ( obj.action == "p_r" ) 
					{
						_serverResults = obj;
					}
					break;
				case TurnBasedGameClient.TURN_END:
					break;
				case TurnBasedGameClient.TURN_RESULTS:
					break;
					
				default:
					break;
			}
		}//end handleStateChange()
		
		override public function endTurn():void
		{
			(DartsGlobals.instance.multiplayerClient as ITurnBased).sendTurnEnd();
			
			_cursor.hide();
			
			_currentDart = null;
		}//end endTurn()
		
		override public function get gameType():String
		{
			return "CRICKET";
		}//end get gameType()
		
		override protected function checkForWin():Boolean
		{
			var stats:Object = this.scoreManager.getPlayerStats(_currentPlayer);
					
			var win:Boolean = true;
			
			for ( var i:int = 15; i <= 20; i++ ) {
				if ( stats[i] < 3 ) win = false;
			}
			if ( stats[25] < 3 ) win = false;
			
			return win;
					
		}//end checkForWin()
		
		override public function update(a_time:Number = 0):void
		{	
			if (_paused) return;
			
			_dartboard.update(a_time);
			_cursor.update(a_time);
			
			for each ( var dart:Dart in _darts )
			{
				dart.update(a_time);
			}

			if ( _currentDart && ( _currentDart.position.z >= AppSettings.instance.dartboardPositionZ || _currentDart.position.y <= -10 ) )
			{	
				_currentDart.position.z = AppSettings.instance.dartboardPositionZ;
				
				_currentDart.finishThrow();	
				
				if ( !_dartboard.submitDartPositionUnscored(_currentDart.position.x, _currentDart.position.y, _currentDart.blockBoard, _serverResults) ) 
				{
					_currentDart.beginFalling();
				}
				
				_serverResults = null;
				
				_currentTurn.advanceThrows();
				
				if (_currentTurn.throwsRemaining == 0) 
				{
					_abilityManager.processTurn();
					_currentDart = null;
					//pause(true);
										
					_soundController.play("turn_switch_" + Math.ceil(Math.random() * 4).toString());
					
					DartsGlobals.instance.gameManager.resetDarts();
					DartsGlobals.instance.gameManager.endTurn();
				}
				else
				{
					nextDart();
				}
			}
		}//end update();
		
	}//end RemoteCricketGameLogic

}//end com.bored.games.darts.logic