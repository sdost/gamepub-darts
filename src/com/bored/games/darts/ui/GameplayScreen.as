package com.bored.games.darts.ui 
{
	import caurina.transitions.Tweener;
	import com.bored.games.assets.Texture_BMP;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.math.TrajectoryCalculator;
	import com.bored.games.darts.threedee.primitives.Cube;
	import com.inassets.ui.buttons.events.ButtonEvent;
	import com.inassets.ui.buttons.MightyButton;
	import com.inassets.ui.contentholders.ContentHolder;
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
		
		private var _cube:Cube = new Cube();
		
		private var _background:Sprite;
		private var _foreground:Sprite;
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
		
		private var pp:PerspectiveProjection = new PerspectiveProjection();
		
		private	var m:Matrix3D;
		
		private var m2:Matrix3D = new Matrix3D();
		
		private var transZ:Number = 12;
		
		public function GameplayScreen(a_img:Sprite, a_buildFromAllDescendants:Boolean = false, a_bAddContents:Boolean = true, a_buildBackground:Boolean = false) 
		{
			super(a_img, a_buildFromAllDescendants, a_bAddContents);
				
			pp.projectionCenter = new Point(0,0);
			pp.fieldOfView = 45;
			
			m = pp.toMatrix3D();
			
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
			
			_resultRangeField = descendantsDict["res_R"] as TextField;
			_resultApexField = descendantsDict["res_H"] as TextField;
			_resultHeightField = descendantsDict["res_h"] as TextField;
			
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
			
			_foreground = new Sprite();
			_foreground.x = 100;
			_foreground.y = 100;
			
			return descendantsDict;
			
		}//end buildFrom()
		
		private function addedToStage(a_evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
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
			
			this.contentsMC.addChild(_foreground);
			
			Tweener.addTween(this, {alpha:1, time:2 } );
			
		}//end addedToStage()
		
		private function onEnterFrame(e:Event):void
		{							
			m2.identity();
			m2.prependTranslation(0, 0, transZ);
			m2.prependRotation(30, Vector3D.Y_AXIS);
			m2.prependRotation(30, Vector3D.X_AXIS);

			m2.transformVectors(_cube.vertices3D, _cube.vertices3D2);
		
			Utils3D.projectVectors(m, _cube.vertices3D2, _cube.vertices2D, _cube.uvtData);
			
			var bmpData:BitmapData = new Texture_BMP(100, 100);
			
			_foreground.graphics.clear();
			//_foreground.graphics.beginFill(0xBBBBBB, 1);
			//_foreground.graphics.lineStyle(1,0xFFFFFF, 1);
			_foreground.graphics.beginBitmapFill(bmpData);
			_foreground.graphics.drawTriangles(_cube.vertices2D, _cube.indices, null, TriangleCulling.NEGATIVE);
			_foreground.graphics.drawTriangles(_cube.vertices2D, _cube.indices, null, TriangleCulling.POSITIVE);
			//_foreground.graphics.drawCircle(0, 0, 20);
			_foreground.graphics.endFill();
		}//end onEnterFrame()
		
		private function onCalculateClicked(a_evt:Event):void
		{
			this.dispatchEvent(new Event(CALCULATE_CLICKED_EVT));
			
			var calc:TrajectoryCalculator = new TrajectoryCalculator();
			calc.setReleasePosition(Number(_releaseXField.text), Number(_releaseYField.text), Number(_releaseZField.text));
			calc.thrust = Number(_thrustField.text);
			calc.theta_x = Math.PI / 180 * Number(_angleXField.text);
			calc.theta_y = Math.PI / 180 * Number(_angleYField.text);
			calc.gravity = Number(_gravityField.text);
			
			_resultRangeField.text = calc.calculateRange().toString();
			_resultApexField.text = calc.calculateApex().toString();
			_resultHeightField.text = calc.calculateHeightAtPos(Number(_distanceField.text)).toString();
			
		}//end onCalculateClicked()
		
		override public function destroy(...args):void
		{
			super.destroy();
			
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