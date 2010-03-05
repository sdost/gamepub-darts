package com.bored.games.darts.logic 
{
	import com.bored.games.controllers.AIController;
	import com.bored.games.darts.states.AIChooseShot;
	import com.bored.games.darts.states.AIMoveToShot;
	import com.bored.games.darts.states.AIPerformShot;
	import com.bored.games.darts.states.statemachines.AIOpponentFSM;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author sam
	 */
	public class AIShotManager
	{
		private var _config:XML;
		private var _controller:AIController;
		
		private var _fsm:AIOpponentFSM;
		
		private var _shotDetails:Vector.<ShotDetails>;
		
		public var currentShot:ShotDetails;
		
		public function AIShotManager(a_config:XML, a_controller:AIController) 
		{
			_config = a_config;
			_controller = a_controller;
			
			_fsm = new AIOpponentFSM(_config.opponentName);
			
			_shotDetails = new Vector.<ShotDetails>(3);
			
			setupStates();			
		}//end constructor()
		
		private function setupStates():void
		{
			_fsm.addState(new AIChooseShot( "AIChooseShot", this, _fsm ));
			_fsm.addState(new AIMoveToShot( "AIMoveToShot", this, _fsm ));
			_fsm.addState(new AIPerformShot( "AIPerformShot", this, _fsm ));
		}//end setupStates()
		
		public function beginShot():void
		{
			if (_fsm) {
				_fsm.start();
			}
		}//end beginTurn()
		
		public function endShot():void
		{
			if (_fsm) {
				_fsm.resetStates();
			}
		}//end endShot()
		
		public function get controller():AIController
		{
			return _controller;
		}//end get controller()
		
	}//end AITurnManager

}//end com.bored.game.darts.logic

internal class ShotDetails {
		public var releasePoint:flash.geom.Vector3D = new flash.geom.Vector3D();
		public var destPoint:flash.geom.Vector3D = new flash.geom.Vector3D();
		public var thrust:Number = 0;
}//end internal ShotDetails