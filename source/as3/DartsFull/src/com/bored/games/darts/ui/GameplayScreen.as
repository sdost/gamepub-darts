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
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.ui.hud.AbilityDock;
	import com.bored.games.darts.ui.hud.ControlPanel;
	import com.bored.games.darts.ui.hud.CricketScoreBoard;
	import com.bored.games.darts.ui.hud.DartDock;
	import com.bored.games.darts.ui.hud.FiveOhOneScoreBoard;
	import com.bored.games.darts.ui.hud.ScoreBoard;
	import com.bored.games.darts.ui.hud.ThrowIndicator;
	import com.bored.games.darts.ui.hud.ThrowIndicatorV2;
	import com.bored.games.darts.ui.hud.ThrowIndicatorV3;
	import com.bored.games.darts.events.InputStateEvent;
	import com.bored.games.darts.DartsGlobals;
	import com.greensock.TweenLite;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import com.sven.utils.AppSettings;
	import com.sven.factories.ImageFactory;
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
	import flash.system.System;
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
		
		//engine variables
		private var _scene:Scene3D;
		
		private var _camera:Camera3D;
		
		private var _view:View3D;
		
		private var _engineScale:Number;
		
		//private var _stats:Stats;
		
		private var _throwIndicator:ThrowIndicatorV3;
		private var _scoreBoard:ScoreBoard;
		private var _abilityDock:AbilityDock;
		private var _dartDock:DartDock;
		private var _controlPanel:ControlPanel;
		
		private var _turnTimer:MovieClip;
		
		public function GameplayScreen() 
		{
			_wallClip = new Bitmap(ImageFactory.getBitmapDataByQualifiedName(AppSettings.instance.wallTextureBitmap, AppSettings.instance.wallTextureWidth, AppSettings.instance.wallTextureHeight));
			
			addChild(_wallClip);
			
			_engineScale = AppSettings.instance.away3dEngineScale;
			
			init();
			
			var cls:Class;
			
			if ( DartsGlobals.instance.gameMode != DartsGlobals.GAME_MULTIPLAYER && DartsGlobals.instance.throwMode == DartsGlobals.THROW_EXPERT )
			{
				cls = getDefinitionByName(AppSettings.instance.throwIndicatorMovie) as Class;
				_throwIndicator = new ThrowIndicatorV3(new cls());
				DartsGlobals.instance.optionsInterfaceSpace.addChild(_throwIndicator);
				_throwIndicator.x = AppSettings.instance.throwIndicatorPositionX;
				_throwIndicator.y = AppSettings.instance.throwIndicatorPositionY;
				_throwIndicator.registerThrowController(DartsGlobals.instance.gameManager.throwController);
				_throwIndicator.show();
			}
			/*
			else
			{
				cls = getDefinitionByName(AppSettings.instance.multiplayerThrowIndicatorMovie) as Class;
				_multiplayerThrowIndicator = new ThrowIndicatorV4(new cls());
				DartsGlobals.instance.optionsInterfaceSpace.addChild(_multiplayerThrowIndicator);
				_multiplayerThrowIndicator.x = AppSettings.instance.throwIndicatorPositionX;
				_multiplayerThrowIndicator.y = AppSettings.instance.throwIndicatorPositionY;
				_multiplayerThrowIndicator.registerThrowController(DartsGlobals.instance.gameManager.throwController);
				//_multiplayerThrowIndicator.show();
			}
			*/
						
			
			if ( DartsGlobals.instance.gameType == DartsGlobals.TYPE_CRICKET ) 
			{
				cls = getDefinitionByName(AppSettings.instance.cricketScoreboardMovie) as Class;
				_scoreBoard = new CricketScoreBoard(new cls());
			}
			else if ( DartsGlobals.instance.gameType == DartsGlobals.TYPE_FIVEOHONE )
			{
				cls = getDefinitionByName(AppSettings.instance.fiveOhOneScoreboardMovie) as Class;
				_scoreBoard = new FiveOhOneScoreBoard(new cls());
			}
			DartsGlobals.instance.optionsInterfaceSpace.addChild(_scoreBoard);
			_scoreBoard.x = AppSettings.instance.scoreboardPositionX;
			_scoreBoard.y = AppSettings.instance.scoreboardPositionY;
			_scoreBoard.registerScoreManager(DartsGlobals.instance.gameManager.scoreManager);
			_scoreBoard.show();
			
			if ( DartsGlobals.instance.gameMode == DartsGlobals.GAME_STORY ) 
			{
				cls = getDefinitionByName(AppSettings.instance.abilityDockMovie) as Class;
				_abilityDock = new AbilityDock(new cls());
				DartsGlobals.instance.optionsInterfaceSpace.addChild(_abilityDock);
				_abilityDock.x = AppSettings.instance.abilityDockPositionX;
				_abilityDock.y = AppSettings.instance.abilityDockPositionY;
				_abilityDock.registerAbilityManager(DartsGlobals.instance.gameManager.abilityManager);
				_abilityDock.show();
			}
			
			cls = getDefinitionByName(AppSettings.instance.dartDockMovie) as Class;
			_dartDock = new DartDock(new cls());
			DartsGlobals.instance.optionsInterfaceSpace.addChild(_dartDock);
			_dartDock.x = AppSettings.instance.dartDockPositionX;
			_dartDock.y = AppSettings.instance.dartDockPositionY;
			_dartDock.show();
			
			/*
			_stats = new Stats();
			_stats.y = 50;
			DartsGlobals.instance.optionsInterfaceSpace.addChild(_stats);
			*/
			
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
			
			//this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			//this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			
			this.alpha = 0;
			
			_view.x = (this.stage.stageWidth / 2);
			_view.y = (this.stage.stageHeight / 2);
			
			TweenLite.to(this, 2, { alpha:1 } );			
		}//end addedToStage()
		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			initEngine();
			initObjects();
		}//end init()
		
		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{			
			_scene = new Scene3D();
			
			_camera = new Camera3D();
			_camera.x = AppSettings.instance.cameraPositionX * _engineScale;
			_camera.y = AppSettings.instance.cameraPositionY * _engineScale;
			_camera.z = AppSettings.instance.cameraPositionZ * _engineScale;
			
			_view = new View3D();
			_view.scene = _scene;
			_view.camera = _camera;
			
			addChild(_view);     
		}//end initEngine()
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{			
			DartsGlobals.instance.gameManager.dartboard.initModels();
			_scene.addSprite(DartsGlobals.instance.gameManager.dartboard.boardSprite);
			DartsGlobals.instance.gameManager.dartboard.x = AppSettings.instance.dartboardPositionX * _engineScale;
			DartsGlobals.instance.gameManager.dartboard.y = AppSettings.instance.dartboardPositionY * _engineScale;
			DartsGlobals.instance.gameManager.dartboard.z = AppSettings.instance.dartboardPositionZ * _engineScale;
			
			DartsGlobals.instance.gameManager.cursor.initModels();
			_scene.addSprite(DartsGlobals.instance.gameManager.cursor.sprite);
			
			for each( var dart:Dart in DartsGlobals.instance.gameManager.darts )
			{
				dart.initModels();
				_scene.addChild(dart.model);
			}
		}//end initObjects()
		
		public function cleanupObjects():void
		{			
			_scene.removeSprite(DartsGlobals.instance.gameManager.dartboard.boardSprite);
			DartsGlobals.instance.gameManager.dartboard.cleanupModels();
			
			_scene.removeSprite(DartsGlobals.instance.gameManager.cursor.sprite);
			DartsGlobals.instance.gameManager.cursor.cleanupModels();
			
			for each( var dart:Dart in DartsGlobals.instance.gameManager.darts )
			{
				_scene.removeChild(dart.model);
				dart.cleanupModels();
			}
		}//end cleanupObjects()
			
		public function render():void
		{	
			if (_scoreBoard) _scoreBoard.update();
			if (_throwIndicator) _throwIndicator.update();
			//if (_multiplayerThrowIndicator) _multiplayerThrowIndicator.update();
			if (_abilityDock) _abilityDock.update();
			if (_dartDock) _dartDock.update();
			
			if(_view) _view.render();
		}//end render()
		
		public function destroy(...args):void
		{			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			removeChild(_view);
			
			if (_throwIndicator) DartsGlobals.instance.optionsInterfaceSpace.removeChild(_throwIndicator);
			if (_scoreBoard) DartsGlobals.instance.optionsInterfaceSpace.removeChild(_scoreBoard);
			if (_abilityDock) DartsGlobals.instance.optionsInterfaceSpace.removeChild(_abilityDock);
			if (_dartDock) DartsGlobals.instance.optionsInterfaceSpace.removeChild(_dartDock);
			
			_throwIndicator = null;
			_scoreBoard = null;
			_abilityDock = null;
			_dartDock = null;
			
			_view.camera = null;
			_view.scene = null;
			_view = null;
			_scene = null;
			_camera = null;
			
			_wallClip = null;
		}//end destroy()
		
	}//end class GameplayScreen
	
}//end package com.bored.games.darts.ui 