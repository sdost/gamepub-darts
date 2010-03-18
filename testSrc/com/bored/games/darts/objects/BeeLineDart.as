package com.bored.games.darts.objects 
{
	import com.bored.games.darts.actions.BeeLineTrajectoryAction;
	import com.bored.games.darts.objects.Dart;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BeeLineDart extends Dart
	{
		private var _beeLineTrajectoryAction:BeeLineTrajectoryAction;
		
		public function BeeLineDart(a_radius:int = 1) 
		{
			super(a_radius);
			
		}//end constructor()
		
		override protected function initActions():void
		{
			super.initActions();
			
			_beeLineTrajectoryAction = new BeeLineTrajectoryAction(this);
			addAction(_beeLineTrajectoryAction);
		}//end initAction()

		override public function initThrowParams(releaseX:Number, releaseY:Number, releaseZ:Number, thrust:Number, angle:Number, grav:Number, lean:Number = 0):void
		{
			this.position.x = releaseX;
			this.position.y = releaseY;
			this.position.z = releaseZ;
			
			_beeLineTrajectoryAction.initParams({
				speed: thrust
			});
			
			activateAction(_beeLineTrajectoryAction.actionName);
		}//end initThrowParams()
		
		override public function finishThrow():void
		{
			deactivateAction(_beeLineTrajectoryAction.actionName);
		}//end finishThrow()
		
	}//end BeeLineDart

}//end com.bored.games.darts.objects