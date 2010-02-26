package com.bored.games.darts.ui 
{
	import away3dlite.cameras.Camera3D;
	import away3dlite.cameras.HoverCamera3D;
	import away3dlite.cameras.TargetCamera3D;
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	import away3dlite.core.base.Mesh;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.clip.Clipping;
	import away3dlite.core.render.FastRenderer;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.data.MaterialData;
	import away3dlite.loaders.data.MeshMaterialData;
	import away3dlite.loaders.Loader3D;
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.materials.BitmapMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.primitives.Plane;
	import caurina.transitions.Tweener;
	import com.bored.games.assets.hud.ThrowIndicator_MC;
	import com.bored.games.assets.VectorDartboard_MC;
	import com.bored.games.config.ConfigManager;
	import com.bored.games.controllers.InputController;
	import com.bored.games.darts.objects.Board;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.ui.hud.ThrowIndicator;
	import com.bored.games.graphics.ImageFactory;
	import com.bored.games.input.MouseManager;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.math.TrajectoryCalculator;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.geom.Utils3D;
	import flash.geom.PerspectiveProjection;
	import flash.display.TriangleCulling;
	import flash.geom.Vector3D;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class GameplayScreen extends Sprite //ContentHolder
	{
		private static var _dartboardMC:BitmapMaterial;
		private static var _dartTexture_UJ:BitmapMaterial;
		private static var _dartTexture_JR:BitmapMaterial;
		private static var _wallTexture:BitmapMaterial;
		private static var _dartOutline:WireframeMaterial;
		
		//private var _background:Sprite;
		//private var _buildBackground:Boolean = false;
		
		//private var _viewPort:Sprite;
		//private var _graphicsLayer:Sprite;
		
		//engine variables
		private var _scene:Scene3D;
		
		private var _camera:Camera3D;
		
		private var _view:View3D;
		
		private var _renderer:FastRenderer;
		
		private var _engineScale:Number;
		
		private var _stats:Stats;
		
		private var _throwIndicator:ThrowIndicator;
		
		//private var _persp:PerspectiveProjection;
		//private var _mtransform:Matrix3D = new Matrix3D();
		//private var _dartPos:Vector3D = new Vector3D();
		//private var _endPos:Vector3D = new Vector3D();
		
		private var _collada:Collada;
		private var _loader:Loader3D;
		
		private var _dartTemplate:Object3D;
		private var _dartModels:Vector.<Object3D>;
		private var _boardBillboard:Plane;
		private var _wallBillboard:Plane;
		
		private var _dartRefs:Vector.<Dart>;
		private var _boardRef:Board;
		
		private var _wallPosition:Vector3D;
		
		private var _wallScale:Number;
		private var _boardScale:Number;
		private var _dartScale:Number;
		
		public function GameplayScreen(/*a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true, a_buildBackground:Boolean = false*/) 
		{
			//super(a_img, a_buildFromAllDescendants, a_bAddContents);
			
			//_buildBackground = a_buildBackground;
			
			init();
			
			_dartRefs = new Vector.<Dart>();
			_dartModels = new Vector.<Object3D>();
			
			_throwIndicator = new ThrowIndicator(new ThrowIndicator_MC());
			DartsGlobals.instance.optionsInterfaceSpace.addChild(_throwIndicator);
			
			if (this.stage)
			{
				addedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			
		}//end GameplayScreen() constructor.
		
		/*
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
						
			_viewPort = descendantsDict["viewPort_mc"] as Sprite;
			_graphicsLayer = _viewPort.getChildByName("anchor") as Sprite;			
			
			if(_buildBackground)
			{
				_background = new Sprite();
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		*/
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			/*
			// build our background.
			if (_background)
			{
				_background.graphics.beginFill(0xFFFFFF, .75);
				_background.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
				_background.graphics.endFill();
			}
			*/
			
			//this.contentsMC.alpha = 1;
			
			this.alpha = 0;
			
			/*
			if(_background)
			{
				var contentIndex:int = this.getChildIndex(this.contents);
				this.addChildAt(_background, contentIndex);
			}
			*/
			
			//this.contentsMC.x = (this.stage.stageWidth / 2) - (this.contentsMC.width / 2);
			//this.contentsMC.y = (this.stage.stageHeight / 2) - (this.contentsMC.height / 2);
			
			_view.x = (this.stage.stageWidth / 2);
			_view.y = (this.stage.stageHeight / 2);
			
			this.stage.quality = StageQuality.MEDIUM;
			
			_engineScale = ConfigManager.config.engineScale;
			
			trace("Engine Scale: " + _engineScale);
			
			Tweener.addTween(this, { alpha:1, time:2 } );
			
		}//end addedToStage()
		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			initEngine();
			initMaterials();
			initObjects();
		}//end init()
		
		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			_scene = new Scene3D();
			
			_camera = new Camera3D();
			_camera.z = -100;
			
			//_renderer = new FastRenderer();
			
			_view = new View3D();
			_view.scene = _scene;
			_view.camera = _camera;
			//_view.renderer = _renderer;
			
			addChild(_view);
			
			_stats = new Stats();
            
            addChild(_stats);
		}//end initEngine()
		
		/**
		 * Initialise the materials
		 */
		private function initMaterials():void
		{
			var textureConfig:XML = ConfigManager.getConfigNamespace("textures");
			
			_wallTexture = new BitmapMaterial(ImageFactory.getBitmapDataByQualifiedName(textureConfig.wall.bitmap, textureConfig.wall.width, textureConfig.wall.height));
			_wallTexture.repeat = false;
			_wallTexture.smooth = true;

			_dartboardMC = new BitmapMaterial(ImageFactory.getBitmapDataByQualifiedName(textureConfig.board.bitmap, textureConfig.board.width, textureConfig.board.height));
			_dartboardMC.repeat = false;
			_dartboardMC.smooth = true;
			
			_dartTexture_UJ = new BitmapMaterial(ImageFactory.getBitmapDataByQualifiedName(textureConfig.dart.bitmap.children()[0], textureConfig.dart.width, textureConfig.dart.height));
			_dartTexture_UJ.repeat = false;
			_dartTexture_UJ.smooth = true;
			
			_dartTexture_JR = new BitmapMaterial(ImageFactory.getBitmapDataByQualifiedName(textureConfig.dart.bitmap.children()[1], textureConfig.dart.width, textureConfig.dart.height));
			_dartTexture_JR.repeat = false;
			_dartTexture_JR.smooth = true;
			
		}//end initMaterial()
		
		private function onSuccess(a_evt:Loader3DEvent):void
		{
			_dartTemplate = _loader.handle;			
			_dartTemplate.mouseEnabled = false;
			_dartTemplate.materialLibrary.getMaterial("dart_skin").material = _dartTexture_UJ;
			
			for ( var i:int = 0; i < 3; i++ ) {
				var newDart:Object3D = _dartTemplate.clone();			
				_dartModels.push(newDart);
				_scene.addChild(newDart);
			}
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		}//end onSuccess()
		
		private function onKey(a_evt:KeyboardEvent):void
		{
			trace("Key Code [" + a_evt.keyCode + "]");
			
			if ( a_evt.keyCode == Keyboard.NUMPAD_1 ) {
				_dartTemplate.materialLibrary.getMaterial("dart_skin").material = _dartTexture_UJ;
				for ( var i:int = 0; i < _dartRefs.length; i++ ) {
					_dartModels[i] = _dartTemplate.clone();
				}
			} else if (a_evt.keyCode == Keyboard.NUMPAD_2 ) {
				_dartTemplate.materialLibrary.getMaterial("dart_skin").material = _dartTexture_JR;
				for ( var i:int = 0; i < _dartRefs.length; i++ ) {
					_dartModels[i] = _dartTemplate.clone();
				}
			}
		}//end onKey()
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			Debug.active = true;
			
			var textureConfig:XML = ConfigManager.getConfigNamespace("textures");
			
			_wallBillboard = new Plane();
			_wallBillboard.z = 200;
			_wallBillboard.scaleX = _wallBillboard.scaleY = 1.54;
			_wallBillboard.material = _wallTexture;
			_wallBillboard.width = textureConfig.wall.width;
			_wallBillboard.height = textureConfig.wall.height;
			_wallBillboard.yUp = false;
			_wallBillboard.bothsides = true;
			_wallBillboard.mouseEnabled = false;
			_scene.addChild(_wallBillboard);
			
			_boardBillboard = new Plane();
			_boardBillboard.z = 200;
			_boardBillboard.scaleX = _boardBillboard.scaleY = 1.54;
			_boardBillboard.material = _dartboardMC;
			_boardBillboard.width = textureConfig.board.width;
			_boardBillboard.height = textureConfig.board.height;
			_boardBillboard.yUp = false;
			_boardBillboard.bothsides = true;
			_boardBillboard.mouseEnabled = false;
			_scene.addChild(_boardBillboard);
			
			_collada = new Collada();
			_collada.scaling = 2;
			_collada.centerMeshes = true;
			
			_loader = new Loader3D();
			_loader.autoLoadTextures = false;
			_loader.loadGeometry("dart01_reduced.dae", _collada);
			_loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
		}//end initObjects()
		
		public function setDartReferences(a_darts:Vector.<Dart>):void
		{
			_dartRefs = a_darts;
		}//end setDartReferences()
		
		public function setBoardReference(a_board:Board):void
		{
			_boardRef = a_board;
		}//end setBoardReference()
		
		public function showThrowIndicatorAt(a_x:Number, a_y:Number):void
		{
			_throwIndicator.x = a_x;
			_throwIndicator.y = a_y;
			_throwIndicator.show();
		}//end showThrowIndicatorAt()
		
		public function hideThrowIndicator():void
		{
			_throwIndicator.hide();
		}//end hideThrowIndicator()
		
		public function setThrowIndicator(a_x:Number, a_y:Number):void
		{
			_throwIndicator.moveBallTo(a_x, a_y);
		}//end setThrowIndicator()
		
		public function render():void
		{	
			_wallBillboard.lookAt(_camera.position, new Vector3D(0, 1, 0));
			
			if ( _boardRef ) {
				_boardBillboard.x = _boardRef.position.x * _engineScale;
				_boardBillboard.y = _boardRef.position.y * _engineScale;
				_boardBillboard.z = _boardRef.position.z * _engineScale;
			}
			
			_boardBillboard.lookAt(_camera.position, new Vector3D(0, 1, 0));
			
			if ( _dartTemplate ) {		
				
				var followCam:Boolean = false;
				
				for ( var i:int = 0; i < _dartRefs.length; i++ ) {
					_dartModels[i].rotationX = _dartRefs[i].angle;
					
					_dartModels[i].x = _dartRefs[i].position.x * _engineScale;
					_dartModels[i].y = -(_dartRefs[i].position.y * _engineScale);
					_dartModels[i].z = _dartRefs[i].position.z * _engineScale;
				}
			}
			
			_view.render();
		}//end render()
		
		public function destroy(...args):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_dartRefs = null;
			_dartModels = null;
			
			removeChild(_view);
			removeChild(_stats);
			
			_view = null;
			_scene = null;
			_camera = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class GameplayScreen
	
}//end package com.bored.games.darts.ui 