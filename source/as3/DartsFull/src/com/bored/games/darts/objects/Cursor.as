package com.bored.games.darts.objects 
{
	import away3dlite.animators.MovieMesh;
	import away3dlite.core.clip.RectangleClipping;
	import away3dlite.materials.BitmapMaterial;
	import away3dlite.materials.Material;
	import away3dlite.materials.MovieMaterial;
	import away3dlite.primitives.Plane;
	import away3dlite.sprites.AlignmentType;
	import away3dlite.sprites.Sprite3D;
	import com.bored.games.darts.DartsGlobals;
	import com.sven.utils.AppSettings;
	import away3dlite.core.base.Object3D;
	import com.bored.games.objects.GameElement;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Cursor extends GameElement implements I3D
	{
		private var _cursor:Sprite;
		private var _cursorSprite:Sprite3D;
		private var _cursorMaterial:MovieMaterial;
		private var _hidden:Boolean;
		
		private var _pitch:Number;
		private var _roll:Number;
		private var _yaw:Number;
		
		public function Cursor(a_img:Sprite) 
		{
			super();	
			
			_cursor = a_img;
		}//end constructor()
		
		public function initModels():void
		{
			_cursorMaterial = new MovieMaterial(_cursor);
			_cursorMaterial.smooth = true;
			
			_cursorSprite = new Sprite3D(_cursorMaterial, 0.35);
			_cursorSprite.alignmentType = AlignmentType.VIEWPOINT;
		}//end initModels()
		
		public function cleanupModels():void
		{
			_cursorSprite = null;
			
			//_cursorMaterial.bitmap.dispose();
			_cursorMaterial = null;
		}//end initModels()
		
		override public function update(a_time:Number = 0):void
		{
			super.update(a_time);
			
			if ( _cursorMaterial )
			{
				_cursorMaterial.update();
			}
			
			if ( _cursorSprite ) 
			{				
				_cursorSprite.x = this.x * AppSettings.instance.away3dEngineScale;
				_cursorSprite.y = -(this.y * AppSettings.instance.away3dEngineScale);
				_cursorSprite.z = this.z * AppSettings.instance.away3dEngineScale;
			}
		}//end update()
		
		public function setCursorImage(a_spr:Sprite):void
		{
			if(_cursorMaterial) _cursorMaterial.movie = a_spr;
			
			if ( _hidden ) 
				_cursor.alpha = 0;
			
		}//end setCursorImage()
		
		public function setCursorScale(a_num:Number):void
		{
			if (_cursorSprite)
			{
				_cursorSprite.scale = a_num;
			}
			else
			{
				DartsGlobals.addWarning("Cursor::setCursorScale(" + a_num + "): _cursorSprite=" + _cursorSprite + ", IS THIS OKAY?");
			}
			
		}//end setCursorScale()
		
		public function resetCursorImage():void
		{
			if(_cursorMaterial) _cursorMaterial.movie = _cursor;
			if(_cursorSprite) _cursorSprite.scale = 0.35;
		}//end resetCursorImage()
		
		public function show():void
		{
			Mouse.hide();
			_hidden = false;
			_cursor.alpha = 1;
		}//end show()
		
		public function hide():void
		{
			Mouse.show();
			_hidden = true;
			_cursor.alpha = 0;
		}//end hide()
		
		public function get sprite():Sprite3D
		{
			return _cursorSprite;
		}//end get model()
				
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
		
	}//end Cursor

}//end com.bored.games.darts.objects