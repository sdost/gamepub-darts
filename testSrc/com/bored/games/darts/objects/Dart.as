package com.bored.games.darts.objects 
{
	import caurina.transitions.Tweener;
	import com.bored.games.darts.actions.FallingAction;
	import com.bored.games.darts.actions.TrajectoryAction;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.TrajectoryCalculator;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Dart extends GameElement
	{
		private var _trajectoryAction:TrajectoryAction;
		private var _fallingAction:FallingAction;
		
		private var _radius:int;
		
		private var _xVel:Number;
		
		private var _throwing:Boolean;
		
		public function Dart(a_radius:int = 1) 
		{
			_radius = a_radius;
			
			this.orientation = 90;	
			
			initActions();
		}//end constructor()
		
		private function initActions():void
		{
			_trajectoryAction = new TrajectoryAction(this);
			addAction(_trajectoryAction);
			_fallingAction = new FallingAction(this, { gravity: 9.8, yFloor: -10 });
			addAction(_fallingAction);
		}//end initAction()
		
		override public function update(t:Number = 0):void
		{
			super.update(t);
		}//end update()
		
		public function get radius():int
		{
			return _radius;
		}//end get radius()
		
		public function get angle():Number
		{
			return this.orientation;
		}//end get angle()

		public function initThrowParams(releaseX:Number, releaseY:Number, releaseZ:Number, thrust:Number, angle:Number, grav:Number, lean:Number = 0):void
		{
			this.position.x = releaseX;
			this.position.y = releaseY;
			this.position.z = releaseZ;
			
			_trajectoryAction.initParams({
				"thrust": thrust,
				"theta": Math.PI / 180 * angle,
				"gravity": grav,
				"lean": lean
			});
			
			activateAction(_trajectoryAction.actionName);
		}//end initThrowParams()
		
		public function finishThrow():void
		{
			deactivateAction(_trajectoryAction.actionName);
		}//end finishThrow()
		
		public function beginFalling():void
		{
			activateAction(_fallingAction.actionName);
		}//end beginFalling()
		
	}//end Dart

}//end com.bored.games.darts.object