package com.bored.games.darts.ui 
{
	import caurina.transitions.Tweener;
	import com.bored.games.assets.DartboardCollision_BMP;
	import com.bored.games.assets.DartTexture_BMP;
	import com.bored.games.assets.WallTexture_BMP;
	import com.bored.games.assets.DartboardTexture_BMP;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.math.TrajectoryCalculator;
	import com.bored.games.darts.threedee.Mesh3D;
	import com.bored.games.darts.threedee.primitives.Cube;
	import com.bored.games.darts.threedee.primitives.Quad;
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
		
		private var _persp:PerspectiveProjection;
		private	var _mpersp:Matrix3D;
		private var _mtransform:Matrix3D = new Matrix3D();
		private var _wallZ:Number = 12;
		private var _dartPos:Vector3D = new Vector3D(0, -.6, 2);
		private var _endPos:Vector3D = _dartPos.clone();
		
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
			_releaseXField.text = _dartPos.x.toString();
			_releaseYField = descendantsDict["y_0"] as TextField;
			_releaseYField.text = _dartPos.y.toString();
			_releaseZField = descendantsDict["z_0"] as TextField;
			_releaseZField.text = _dartPos.z.toString();
		
			_thrustField = descendantsDict["F"] as TextField;
			_thrustField.text = Number(20).toString();
			_angleXField = descendantsDict["theta_x"] as TextField;
			_angleXField.text = Number(3).toString();
			_angleYField = descendantsDict["theta_y"] as TextField;
			_angleYField.text = Number(0).toString();
			_gravityField = descendantsDict["g"] as TextField;
			_gravityField.text = Number(9.8).toString();
			_distanceField = descendantsDict["d"] as TextField;
			_distanceField.text = Number(20).toString();
			
			_viewPort = descendantsDict["viewPort_mc"] as Sprite;
			
			if (_distanceField)
			{
				_distanceField.addEventListener(Event.CHANGE, onDistanceChanged, false, 0, true);
			}
			else
			{
				throw new Error("GameplayScreen::buildFrom(): _distanceField=" + _distanceField);
			}
			
			if (_calculateBtnImg)
			{
				_calculateBtn = new MightyButton(_calculateBtnImg, false);
				_calculateBtn.pause(false);
				_calculateBtn.addEventListener(ButtonEvent.MIGHTYBUTTON_CLICK_EVT, onCalculateClicked, false, 0, true);
			}
			else
			{
				throw new Error("GameplayScreen::buildFrom(): _calculateBtnImg=" + _calculateBtnImg);
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
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			Tweener.addTween(this, {alpha:1, time:2 } );
			
		}//end addedToStage()
		
		private function onEnterFrame(e:Event):void
		{	
			_viewPort.graphics.clear();
			
			var ez:Number = (_endPos.z - _dartPos.z) / 10;
						
			_dartPos.z += ez;
			_dartPos.y = _calc.calculateHeightAtPos(_dartPos.z);
			
			_mtransform.identity();
			_mtransform.appendScale(10, 10, 10);
			_mtransform.appendTranslation(0, 0, _wallZ);
			
			_mtransform.transformVectors(_wall.vertices3D, _wall.vertices3D2);
			
			Utils3D.projectVectors(_mpersp, _wall.vertices3D2, _wall.vertices2D, _wall.uvtData);
			
			_viewPort.graphics.beginBitmapFill(_wallTexture);
			_viewPort.graphics.drawTriangles(_wall.vertices2D, _wall.indices, _wall.uvtData, TriangleCulling.NONE);
			_viewPort.graphics.endFill();
			
			_mtransform.identity();
			_mtransform.appendScale(5, 5, 5);
			_mtransform.appendTranslation(0, -2, _wallZ);
			
			_mtransform.transformVectors(_board.vertices3D, _board.vertices3D2);
			
			Utils3D.projectVectors(_mpersp, _board.vertices3D2, _board.vertices2D, _board.uvtData);
			
			_viewPort.graphics.beginBitmapFill(_dartboardTexture);
			_viewPort.graphics.drawTriangles(_board.vertices2D, _board.indices, _board.uvtData, TriangleCulling.NONE);
			_viewPort.graphics.endFill();
			
			_mtransform.identity();
			_mtransform.appendTranslation(_dartPos.x, _dartPos.y, _dartPos.z);
			
			_mtransform.transformVectors(_dart.vertices3D, _dart.vertices3D2);
			
			Utils3D.projectVectors(_mpersp, _dart.vertices3D2, _dart.vertices2D, _dart.uvtData);
		
			_viewPort.graphics.beginBitmapFill(_dartTexture);
			_viewPort.graphics.drawTriangles(_dart.vertices2D, _dart.indices, _dart.uvtData, TriangleCulling.NONE);
			_viewPort.graphics.endFill();
		}//end onEnterFrame()
		
		private function onDistanceChanged(a_evt:Event):void
		{
			_wallZ = Number((a_evt.currentTarget as TextField).text);
		}//end onDistanceChanged()
		
		private function onCalculateClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(CALCULATE_CLICKED_EVT));
			
			var releasePos:Vector3D = new Vector3D( Number(_releaseXField.text), Number(_releaseYField.text), Number(_releaseZField.text) );
			var thrust:Number = Number(_thrustField.text);
			var angleX:Number = Number(_angleXField.text);
			var angleY:Number = Number(_angleYField.text);
			var grav:Number = Number(_gravityField.text);
			var dist:Number = Number(_distanceField.text);
			
			_dartPos.x = releasePos.x;
			_dartPos.y = releasePos.y;
			_dartPos.z = releasePos.z;
			
			_calc.setReleasePosition(releasePos.x, releasePos.y, releasePos.z);
			_calc.thrust = thrust;
			_calc.theta_x = Math.PI / 180 * angleX;
			_calc.theta_y = Math.PI / 180 * angleY;
			_calc.gravity = grav;
			
			_endPos.x = releasePos.x;
			_endPos.y = _calc.calculateHeightAtPos(dist);
			_endPos.z = dist;
			
			trace("Color @ (" + _endPos.x + ", " + _endPos.y + "): " + _collisionMap.getPixel(_endPos.x, _endPos.y));
		}//end onCalculateClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
			if (_distanceField)
			{
				_distanceField.removeEventListener(Event.CHANGE, onDistanceChanged);
			}
			
			if(_calculateBtn)
			{
				_calculateBtn.removeEventListener(MouseEvent.CLICK, onCalculateClicked);
			}
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			_calculateBtn = null;
			_background = null;
			
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}//end destroy()
		
	}//end class GameplayScreen
	
}//end package com.bored.games.darts.ui 