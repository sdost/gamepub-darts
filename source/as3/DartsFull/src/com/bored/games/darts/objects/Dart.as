package com.bored.games.darts.objects 
{
	import away3dlite.containers.ObjectContainer3D;
	import away3dlite.core.base.Object3D;
	import away3dlite.loaders.Collada;
	import away3dlite.materials.Material;
	import away3dlite.materials.MovieMaterial;
	import away3dlite.sprites.AlignmentType;
	import away3dlite.sprites.Sprite3D;
	import com.bored.games.actions.Action;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.actions.DartFallingAction;
	import com.bored.games.darts.actions.DartPullBackAction;
	import com.bored.games.darts.actions.DartTrajectoryAction;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.models.dae_DartFlightHeart;
	import com.bored.games.darts.models.dae_DartShaft;
	import com.bored.games.darts.skins.DartSkin;
	import com.bored.games.objects.GameElement;
	import com.sven.factories.MovieClipFactory;
	import com.bored.games.darts.utils.TrajectoryCalculator;
	import com.sven.utils.AppSettings;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Dart extends GameElement implements I3D
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
		
		private var _modifierList:Vector.<Ability>;
		private var _indicatorSprite:Sprite;
		private var _indicatorMaterial:MovieMaterial;
		private var _modifierIndicator:Sprite3D;
		
		private var _pitch:Number;
		private var _roll:Number;
		private var _yaw:Number;
		
		private var _myId:String;
		
		private static var _constructionCt:int = 0;
		
		public function Dart(a_skin:DartSkin, a_radius:int = 1) 
		{
			_myId = "Dart_" + _constructionCt++;
			
			_radius = a_radius;
			
			this.pitch = 90;
			
			_dartSkin = a_skin;
			
			initActions();
		}//end constructor()
		
		public function initModels():void
		{
			DartsGlobals.addWarning("Dart::initModels(): this=" + this);
			
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
			
			_indicatorSprite = new Sprite();
			
			_indicatorMaterial = new MovieMaterial(_indicatorSprite);
			_indicatorMaterial.smooth = true;
			
			_modifierIndicator = new Sprite3D(_indicatorMaterial, 1);
			_modifierIndicator.alignmentType = AlignmentType.VIEWPLANE;
			_modifierIndicator.x = 60;
			_modifierIndicator.z = -40;
			_modifierIndicator.y = -120;
			
			clearModifiers();
			
			_dartModel = new ObjectContainer3D(_shaft, _flight);
			
			_dartModel.addSprite(_modifierIndicator);
			
		}//end initModels()
		
		public function cleanupModels():void
		{
			DartsGlobals.addWarning("Dart::cleanupModels(): this=" + this);
			
			_dartModel.removeSprite(_modifierIndicator);
			_modifierIndicator = null;
			
			//_indicatorMaterial.bitmap.dispose();
			_indicatorMaterial = null;
			
			_indicatorSprite = null;
			
			_dartModel = null;
			_flight = null;
			_shaft = null;
			
			//_dartSkin.material.bitmap.dispose();
			_dartSkin = null;
		}//end cleanupModels()
		
		override public function update(a_time:Number = 0):void
		{
			super.update(a_time);
			
			if ( _dartModel ) {
				//_dartModel.rotationX = _dartModel.rotationY = _dartModel.rotationZ = 0;
				//_dartModel.rotationY = this.roll;
				_dartModel.rotationX = this.pitch;
				_dartModel.x = this.x * AppSettings.instance.away3dEngineScale;
				_dartModel.y = -(this.y * AppSettings.instance.away3dEngineScale);
				_dartModel.z = this.z * AppSettings.instance.away3dEngineScale;
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
		
		public function addModifier(a_ability:Ability):void
		{
			_modifierList.push(a_ability);
			
			_indicatorMaterial.movie = new Sprite();
			
			for ( var i:int = 0; i < _modifierList.length; i++ )
			{
				var mc:MovieClip = MovieClipFactory.getMovieClipByQualifiedName("com.bored.games.darts.hud.AbilityMedallion_MC");
				mc.x = i * 60 + 24;
				mc.y = 60;
				var cls:Class = Object(_modifierList[i].icon).constructor;
				(mc.getChildByName("icon_holder") as MovieClip).addChild(new cls());
				_indicatorMaterial.movie.addChild(mc);
			}			
		}//end addModifier()
		
		protected function clearModifiers():void
		{
			_modifierList = new Vector.<Ability>();
			
			if(_indicatorMaterial)
			{
				_indicatorMaterial.movie = new Sprite();
			}
			else
			{
				DartsGlobals.addWarning("Dart::clearModifiers(): this=" + this + ", _indicatorMaterial=" + _indicatorMaterial + ", WHY?");
			}
			
		}//end clearModifiers()
		
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
		
		public function get minThrust():int
		{
			return _throwAction.minimumThrust;
		}//end get minThrust()

		public function initThrowParams(releaseX:Number, releaseY:Number, releaseZ:Number, thrust:Number, angle:Number, grav:Number, lean:Number, finalZ:Number, stepScale:Number):void
		{
			DartsGlobals.addWarning("Dart::initThrowParams(): this=" + this);
			
			deactivateAction(_pullBackAction.actionName);
			
			clearModifiers();
			
			this.pitch = 90;
			this.roll = 0;
			this.yaw = 0;
			this.x = releaseX;
			this.y = releaseY;
			this.z = releaseZ;
			
			_throwAction.initParams({
				"thrust": thrust,
				"theta": Math.PI / 180 * angle,
				"gravity": grav,
				"lean": lean,
				"finalZ": finalZ,
				"stepScale": stepScale
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
			this.z = 0;
		}//end resetThrow()
		
		public function finishThrow():void
		{
			if ( !_throwAction.finished )
			{
				deactivateAction(_throwAction.actionName);
				
				trace("Final Position: [" + this.x + ", " + this.y + ", " + this.z + "]");
				
				resetThrowAction();
			}
		}//end finishThrow()
		
		public function pullBack():void
		{
			activateAction(_pullBackAction.actionName);
		}//end pullBack()
		
		public function beginFalling():void
		{
			activateAction(_fallingAction.actionName);
		}//end beginFalling()
		
		public function set pitch(a_num:Number):void
		{
			_pitch = a_num;
		}//end set pitch()
		
		public function get pitch():Number
		{
			return _pitch;
		}//end set pitch()
		
		public function set roll(a_num:Number):void
		{
			_roll = a_num;
		}//end set roll()
		
		public function get roll():Number
		{
			return _roll;
		}//end set roll()
		
		public function set yaw(a_num:Number):void
		{
			_yaw = a_num;
		}//end set yaw()
		
		public function get yaw():Number
		{
			return _yaw;
		}//end set yaw()
		
		override public function toString():String
		{
			return "[Dart _myId=" + _myId + " ]";
			
		}//end toString()
		
	}//end Dart

}//end com.bored.games.darts.object