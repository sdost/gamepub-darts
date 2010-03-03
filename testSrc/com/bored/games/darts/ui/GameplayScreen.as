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
	import com.bored.games.assets.hud.Scoreboard_MC;
	import com.bored.games.assets.hud.ThrowIndicator_MC;
	import com.bored.games.config.ConfigManager;
	import com.bored.games.controllers.InputController;
	import com.bored.games.darts.objects.Board;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.ui.hud.ScoreBoard;
	import com.bored.games.darts.ui.hud.ThrowIndicator;
	import com.bored.games.graphics.ImageFactory;
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
		private var _wallClip:Bitmap;
		
		private static var _dartboardMC:BitmapMaterial;
		private static var _dartTexture_UJ:BitmapMaterial;
		private static var _dartTexture_JR:BitmapMaterial;
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
		private var _scoreBoard:ScoreBoard;
		
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
			var textureConfig:XML = ConfigManager.getConfigNamespace("textures");
			
			_wallClip = new Bitmap(ImageFactory.getBitmapDataByQualifiedName(textureConfig.wall.bitmap, textureConfig.wall.width, textureConfig.wall.height));
			
			addChild(_wallClip);
			
			init();
			
			_dartRefs = new Vector.<Dart>();
			_dartModels = new Vector.<Object3D>();
			
			_throwIndicator = new ThrowIndicator(new ThrowIndicator_MC());
			DartsGlobals.instance.optionsInterfaceSpace.addChild(_throwIndicator);
			_throwIndicator.x = 650;
			_throwIndicator.y = 400;
			_throwIndicator.show();
			
			_scoreBoard = new ScoreBoard(new Scoreboard_MC());
			DartsGlobals.instance.optionsInterfaceSpace.addChild(_scoreBoard);
			_scoreBoard.x = 50;
			_scoreBoard.y = 200;
			_scoreBoard.registerScoreManager(DartsGlobals.instance.logicManager.scoreManager);
			_scoreBoard.show();
			
			if (this.stage)
			{
				addedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}			
		}//end GameplayScreen() constructor.
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			this.alpha = 0;
			
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
			
			//_wallTexture = new BitmapMaterial(ImageFactory.getBitmapDataByQualifiedName(textureConfig.wall.bitmap, textureConfig.wall.width, textureConfig.wall.height));
			//_wallTexture.repeat = false;
			//_wallTexture.smooth = true;

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
			
			var i:int;
			
			if ( a_evt.keyCode == Keyboard.NUMPAD_1 ) {
				_dartTemplate.materialLibrary.getMaterial("dart_skin").material = _dartTexture_UJ;
				for ( i = 0; i < _dartRefs.length; i++ ) {
					_scene.removeChild(_dartModels[i]);
					_dartModels[i] = _dartTemplate.clone();
					_scene.addChild(_dartModels[i]);
				}
			} else if (a_evt.keyCode == Keyboard.NUMPAD_2 ) {
				_dartTemplate.materialLibrary.getMaterial("dart_skin").material = _dartTexture_JR;
				for ( i = 0; i < _dartRefs.length; i++ ) {
					_scene.removeChild(_dartModels[i]);
					_dartModels[i] = _dartTemplate.clone();
					_scene.addChild(_dartModels[i]);
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
			
			_boardBillboard = new Plane();
			//_boardBillboard.scaleX = _boardBillboard.scaleY = 2.0;
			_boardBillboard.material = _dartboardMC;
			_boardBillboard.width = textureConfig.board.width;
			_boardBillboard.height = textureConfig.board.height;
			_boardBillboard.yUp = false;
			_boardBillboard.bothsides = true;
			_boardBillboard.mouseEnabled = false;
			_scene.addChild(_boardBillboard);
			
			_collada = new Collada();
			_collada.scaling = 3;
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
		
		public function startThrow():void
		{
			_throwIndicator.armShot();
		}//end startThrow()
		
		public function updateThrowSpeed(a_spd:Number, a_xvel:Number = 0):void 
		{
			_throwIndicator.updateBall(a_xvel, a_spd);
		}//end updateThrowSpeed()
		
		public function finishThrow(a_name:String):void
		{
			_scoreBoard.updateScores(a_name);
		}//end finishThrow()
		
		public function resetThrow():void
		{
			_throwIndicator.resetShot();
		}//end resetThrow()
	
		public function render():void
		{	
			//_wallBillboard.lookAt(_camera.position, new Vector3D(0, 1, 0));
			
			if ( _boardRef ) {
				_boardBillboard.x = _boardRef.position.x * _engineScale;
				_boardBillboard.y = _boardRef.position.y * _engineScale;
				_boardBillboard.z = _boardRef.position.z * _engineScale;
			}
			
			_boardBillboard.lookAt(_camera.position, new Vector3D(0, 1, 0));
			
			if ( _dartTemplate ) {		
				
				var followCam:Boolean = false;
				
				for ( var i:int = 0; i < _dartRefs.length; i++ ) {
					if ( _dartModels[i] ) {
						_dartModels[i].rotationX = _dartRefs[i].angle;
						
						_dartModels[i].x = _dartRefs[i].position.x * _engineScale;
						_dartModels[i].y = -(_dartRefs[i].position.y * _engineScale);
						_dartModels[i].z = _dartRefs[i].position.z * _engineScale;
					}
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