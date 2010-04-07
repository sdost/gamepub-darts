package com.bored.games.darts.objects 
{
	import away3dlite.containers.ObjectContainer3D;
	import away3dlite.core.base.Object3D;
	import away3dlite.loaders.Collada;
	import away3dlite.materials.Material;
	import caurina.transitions.Tweener;
	import com.bored.games.actions.Action;
	import com.bored.games.darts.actions.DartFallingAction;
	import com.bored.games.darts.actions.DartPullBackAction;
	import com.bored.games.darts.actions.DartTrajectoryAction;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	import com.bored.games.objects.GameElement;
	import com.sven.utils.TrajectoryCalculator;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Dart extends GameElement
	{
		protected var _trajectoryAction:DartTrajectoryAction;
		protected var _pullBackAction:DartPullBackAction;
		protected var _fallingAction:DartFallingAction;
		
		protected var _throwAction:Action;
		
		private var _radius:int;
		
		private var _xVel:Number;
		
		private var _throwing:Boolean;
		
		private var _dartSkin:DartSkin;
		
		private var _dartModel:ObjectContainer3D;
		
		private var _shaft:Object3D;
		private var _flight:Object3D;
		
		private var _blockBoard:Boolean;
		
		public function Dart(a_skin:DartSkin, a_radius:int = 1) 
		{
			_radius = a_radius;
			
			this.pitch = 90;
			
			_dartSkin = a_skin;
			
			initActions();
		}//end constructor()
		
		public function initModels():void
		{			
			var colladaShaft:Collada = new Collada();
			colladaShaft.scaling = AppSettings.instance.dartModelScale;
			colladaShaft.centerMeshes = true;
			colladaShaft.materials = { "dart_skin": _dartSkin.material };
			
			_shaft = colladaShaft.parseGeometry(_dartSkin.shaft);
			_shaft.mouseEnabled = false;
			
			var colladaFlight:Collada = new Collada();
			colladaFlight.scaling = AppSettings.instance.dartModelScale;
			colladaFlight.centerMeshes = true;
			colladaFlight.materials = { "flight_skin": _dartSkin.material };
			
			_flight = colladaFlight.parseGeometry(_dartSkin.flight);
			_flight.mouseEnabled = false;
			
			_dartModel = new ObjectContainer3D(_shaft, _flight);
		}//end initModels()
		
		override public function update(a_time:Number = 0):void
		{
			super.update(a_time);
			
			if ( _dartModel ) {
				//_dartModel.rotationX = _dartModel.rotationY = _dartModel.rotationZ = 0;
				//_dartModel.rotationY = this.roll;
				_dartModel.rotationX = this.pitch;
				_dartModel.x = this.position.x * AppSettings.instance.away3dEngineScale;
				_dartModel.y = -(this.position.y * AppSettings.instance.away3dEngineScale);
				_dartModel.z = this.position.z * AppSettings.instance.away3dEngineScale;
			}
		}//end update()
		
		public function get model():Object3D
		{
			return _dartModel;
		}//end get shaft()
		
		protected function initActions():void
		{
			_trajectoryAction = new DartTrajectoryAction(this);
			setThrowAction(_trajectoryAction);
			_pullBackAction = new DartPullBackAction(this, { zPull: -0.5 });
			addAction(_pullBackAction);
			_fallingAction = new DartFallingAction(this, { gravity: 9.8, yFloor: -10, zBounceRange: 2 });
			addAction(_fallingAction);
		}//end initAction()
		
		public function setThrowAction(a_action:Action):void
		{
			if (!checkForActionNamed(a_action.actionName)) {
				addAction(a_action);
			}
			
			_throwAction = a_action;
		}//end setThrowAction()
		
		public function resetThrowAction():void
		{
			_throwAction = _trajectoryAction;
		}//end resetThrowAction()
		
		public function get radius():int
		{
			return _radius;
		}//end get radius()

		public function initThrowParams(releaseX:Number, releaseY:Number, releaseZ:Number, thrust:Number, angle:Number, grav:Number, lean:Number = 0):void
		{
			deactivateAction(_pullBackAction.actionName);
			
			this.pitch = 90;
			this.roll = 0;
			this.yaw = 0;
			this.position.x = releaseX;
			this.position.y = releaseY;
			this.position.z = releaseZ;
			
			_throwAction.initParams({
				"thrust": thrust,
				"theta": Math.PI / 180 * angle,
				"gravity": grav,
				"lean": lean
			});
			
			activateAction(_throwAction.actionName);
		}//end initThrowParams()
		
		public function set blockBoard(a_block:Boolean):void
		{
			_blockBoard = a_block;
		}//end set blockBoard()
		
		public function get blockBoard():Boolean
		{
			return _blockBoard;
		}//end get blockBoard()
		
		override public function reset():void
		{
			super.reset();
			this.roll = 0;
			this.pitch = 90;
			this.blockBoard = false;
		}//end reset()
		
		public function resetThrow():void
		{
			deactivateAction(_pullBackAction.actionName);
			this.position.z = 0;
		}//end resetThrow()
		
		public function finishThrow():void
		{
			deactivateAction(_throwAction.actionName);
			resetThrowAction();
		}//end finishThrow()
		
		public function pullBack():void
		{
			activateAction(_pullBackAction.actionName);
		}//end pullBack()
		
		public function beginFalling():void
		{
			activateAction(_fallingAction.actionName);
		}//end beginFalling()
		
	}//end Dart

}//end com.bored.games.darts.object