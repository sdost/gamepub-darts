package com.bored.games.darts.logic 
{
	import com.bored.games.controllers.AIController;
	import com.bored.games.darts.states.AIChooseShot;
	import com.bored.games.darts.states.AIMoveToShot;
	import com.bored.games.darts.states.AIPerformShot;
	import com.bored.games.darts.states.statemachines.AIOpponentFSM;
	import com.sven.utils.AppSettings;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author sam
	 */
	public class AIShotManager
	{
		private var _controller:AIController;
		
		private var _fsm:AIOpponentFSM;
		
		private var _currentShot:ShotDetails;
		
		public function AIShotManager(a_name:String, a_controller:AIController) 
		{
			_controller = a_controller;
			
			_fsm = new AIOpponentFSM(a_name);
			
			setupStates();			
		}//end constructor()
		
		private function setupStates():void
		{
			_fsm.addState(new AIChooseShot( "AIChooseShot", this, _fsm ));
			_fsm.addState(new AIMoveToShot( "AIMoveToShot", this, _fsm ));
			_fsm.addState(new AIPerformShot( "AIPerformShot", this, _fsm ));
		}//end setupStates()
		
		public function beginShot(a_idx:Number):void
		{
			if (_fsm) {
				_currentShot = new ShotDetails();
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
		
		public function get releasePoint():Vector3D
		{
			return _currentShot.releasePoint;
		}//end get releasePoint()
		
		public function get destPoint():Vector3D
		{
			return _currentShot.destPoint;
		}//end get destPoint()
		
		public function get thrust():Number 
		{
			return _currentShot.thrust;
		}//end get thrust()
		
		public function set thrust(a_number:Number):void
		{
			_currentShot.thrust = a_number;
		}//end set thrust()
		
	}//end AITurnManager

}//end com.bored.game.darts.logic

internal class ShotDetails {
		public var releasePoint:flash.geom.Vector3D = new flash.geom.Vector3D();
		public var destPoint:flash.geom.Vector3D = new flash.geom.Vector3D();
		public var thrust:Number = 0;
}//end internal ShotDetails