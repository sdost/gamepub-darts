package com.bored.games.darts.ui 
{
	import caurina.transitions.Tweener;
	import com.bored.games.assets.DartboardCollision_BMP;
	import com.bored.games.assets.DartTexture_BMP;
	import com.bored.games.assets.WallTexture_BMP;
	import com.bored.games.assets.DartboardTexture_BMP;
	import com.bored.games.controllers.InputController;
	import com.bored.games.input.MouseManager;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.math.TrajectoryCalculator;
	import com.bored.games.threedee.Mesh3D;
	import com.bored.games.threedee.primitives.Cube;
	import com.bored.games.threedee.primitives.Quad;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.geom.Utils3D;
	import flash.geom.PerspectiveProjection;
	import flash.display.TriangleCulling;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Samuel Dost
	 */
	public class GameplayScreen extends ContentHolder
	{
		public static const CALCULATE_CLICKED_EVT:String = "CalculateClickedEvent";
		private static var _wallTexture:BitmapData;
		private static var _dartboardTexture:BitmapData;
		private static var _dartTexture:BitmapData;
		
		private static var _collisionMap:BitmapData;
		
		private var _wall:Mesh3D;
		private var _board:Mesh3D;
		private var _dart:Mesh3D;
		
		private var _background:Sprite;
		private var _buildBackground:Boolean = false;
		
		private var _calculateBtn:MightyButton;
		private var _calculateBtnImg:MovieClip;
		
		private var _releaseXField:TextField;
		private var _releaseYField:TextField;
		private var _releaseZField:TextField;
		
		private var _thrustField:TextField;
		private var _angleXField:TextField;
		private var _angleYField:TextField;
		private var _gravityField:TextField;
		private var _distanceField:TextField;
		
		private var _resultRangeField:TextField;
		private var _resultApexField:TextField;
		private var _resultHeightField:TextField;
		
		private var _viewPort:Sprite;
		private var _graphicsLayer:Sprite;
		
		private var _wallZ:Number = 12;
		
		private var _persp:PerspectiveProjection;
		private	var _mpersp:Matrix3D;
		private var _mtransform:Matrix3D = new Matrix3D();
		private var _dartPos:Vector3D = new Vector3D();
		private var _endPos:Vector3D = new Vector3D();
		
		private var _calc:TrajectoryCalculator = new TrajectoryCalculator();
		
		public function GameplayScreen(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true, a_buildBackground:Boolean = false) 
		{
			super(a_img, a_buildFromAllDescendants, a_bAddContents);
			
			_buildBackground = a_buildBackground;
			
			if (this.stage)
			{
				addedToStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			}
			
		}//end GameplayScreen() constructor.
		
		override protected function buildFrom(a_img:Sprite, a_buildFromAllDescendants:Boolean = true):Dictionary
		{
			var descendantsDict:Dictionary = super.buildFrom(a_img, a_buildFromAllDescendants);
			
			// now build ourselves from the descendantsDict.
			
			_calculateBtnImg = descendantsDict["calculateBtn_mc"] as MovieClip;
			
			_releaseXField = descendantsDict["x_0"] as TextField;
			_releaseYField = descendantsDict["y_0"] as TextField;
			_releaseZField = descendantsDict["z_0"] as TextField;
		
			_thrustField = descendantsDict["F"] as TextField;
			_angleXField = descendantsDict["theta_x"] as TextField;
			_angleYField = descendantsDict["theta_y"] as TextField;
			_gravityField = descendantsDict["g"] as TextField;
			_distanceField = descendantsDict["d"] as TextField;
			
			_viewPort = descendantsDict["viewPort_mc"] as Sprite;
			_graphicsLayer = _viewPort.getChildByName("anchor") as Sprite;
			
			if (_distanceField)
			{
				_distanceField.addEventListener(Event.CHANGE, onDistanceChanged, false, 0, true);
			}
			else
			{
				throw new Error("GameplayScreen::buildFrom(): _distanceField=" + _distanceField);
			}
			
			if(_buildBackground)
			{
				_background = new Sprite();
			}
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			// build our background.
			if (_background)
			{
				_background.graphics.beginFill(0xFFFFFF, .75);
				_background.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
				_background.graphics.endFill();
			}
			
			this.contentsMC.alpha = 1;
			
			this.alpha = 0;
			
			if(_background)
			{
				var contentIndex:int = this.getChildIndex(this.contents);
				this.addChildAt(_background, contentIndex);
			}
			
			this.contentsMC.x = (this.stage.stageWidth / 2) - (this.contentsMC.width / 2);
			this.contentsMC.y = (this.stage.stageHeight / 2) - (this.contentsMC.height / 2);
			
			_persp = new PerspectiveProjection();
			_persp.projectionCenter = new Point(0, 0);
			_persp.fieldOfView = 45;
			_persp.focalLength = 200;
			
			_mpersp = _persp.toMatrix3D();
			
			_wall = new Quad();
			_board = new Quad();
			_dart = new Quad();
			
			_wallTexture = new WallTexture_BMP(100, 100);
			_dartboardTexture = new DartboardTexture_BMP(50, 50);
			_dartTexture = new DartTexture_BMP(100, 100);
			
			_collisionMap = new DartboardCollision_BMP(50, 50);
			
			Tweener.addTween(this, {alpha:1, time:2 } );
			
		}//end addedToStage()
		
		public function render():void
		{	
			_graphicsLayer.graphics.clear();
		}//end render()
		
		private function onDistanceChanged(a_evt:Event):void
		{
			_wallZ = Number((a_evt.currentTarget as TextField).text);
		}//end onDistanceChanged()
		
		override public function destroy(...args):void
		{
			super.destroy();
						
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_background = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class GameplayScreen
	
}//end package com.bored.games.darts.ui 