package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BeeLineTrajectoryAction extends Action
	{
		private static const NAME:String = "com.bored.games.darts.actions.BeeLineTrajectoryAction";
		
		private var _stepScale:Number = 0;
		
		public function BeeLineTrajectoryAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);	
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			_stepScale = a_params.stepScale;
		}//end initParams()
		
		override public function startAction():void
		{
			super.startAction();
			
			_gameElement.roll = 0;
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds").stop("beelineLoop");
			DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds").play("beelineFire");
		}//end startAction()
		
		public function get minimumThrust():int
		{
			return 0;
		}//end get minimumThrust()
	
		override public function update(a_time:Number):void
		{
			_gameElement.roll += AppSettings.instance.dartRollSpeed;
			
			var z:Number = _gameElement.position.z + AppSettings.instance.beelineSpeed * _stepScale;
			_gameElement.position.z = z;	
		}//end update()
		
	}//end BeeLineTrajectoryAction

}//end com.bored.games.darts.actions