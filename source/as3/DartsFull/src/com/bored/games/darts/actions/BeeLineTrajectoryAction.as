package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.objects.GameElement;
	import com.bored.games.objects.GameElement3D;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BeeLineTrajectoryAction extends Action
	{
		private static const NAME:String = "com.bored.games.darts.actions.BeeLineTrajectoryAction";
		
		private var _stepScale:Number = 0;
		private var _finalZ:Number = 0;
		
		private var _lastUpdate:int = -1;
		
		public function BeeLineTrajectoryAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			_stepScale = a_params.stepScale;
			_finalZ = a_params.finalZ;
		}//end initParams()
		
		override public function startAction():void
		{
			super.startAction();
			
			(_gameElement as GameElement3D).roll = 0;
			
			DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds").stop("beelineLoop");
			DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds").play("beelineFire");
			
			_lastUpdate = -1;
		}//end startAction()
		
		public function get minimumThrust():int
		{
			return 0;
		}//end get minimumThrust()
	
		override public function update(a_time:Number):void
		{
			var adjust:Number = 0;
			
			if ( _lastUpdate < 0 ) 
			{
				_lastUpdate = a_time;
			}
			else
			{				
				var diff:int = a_time - _lastUpdate;
				
				_lastUpdate = a_time;
				
				adjust = Number( diff / 33 );
			}
			
			(_gameElement as GameElement3D).roll += AppSettings.instance.dartRollSpeed;
			
			var z:Number = (_gameElement as GameElement3D).position.z + AppSettings.instance.beelineSpeed * _stepScale;
			
			if ( z > _finalZ ) z = _finalZ;
			
			(_gameElement as GameElement3D).position.z = z;	
		}//end update()
		
	}//end BeeLineTrajectoryAction

}//end com.bored.games.darts.actions