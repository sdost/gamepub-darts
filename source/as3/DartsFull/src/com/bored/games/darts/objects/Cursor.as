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
	import com.sven.utils.AppSettings;
	import away3dlite.core.base.Object3D;
	import com.bored.games.objects.GameElement;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Cursor extends GameElement
	{
		private var _cursor:Sprite;
		private var _cursorSprite:Sprite3D;
		private var _cursorMaterial:MovieMaterial;
		private var _hidden:Boolean;
		
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
			
			if ( _cursorSprite ) {
				_cursorSprite.x = this.position.x * AppSettings.instance.away3dEngineScale;
				_cursorSprite.y = -(this.position.y * AppSettings.instance.away3dEngineScale);
				_cursorSprite.z = this.position.z * AppSettings.instance.away3dEngineScale;
			}
		}//end update()
		
		public function setCursorImage(a_spr:Sprite):void
		{
			_cursorMaterial.movie = a_spr;
			
			if ( _hidden ) 
				_cursor.alpha = 0;
			
		}//end setCursorImage()
		
		public function resetCursorImage():void
		{
			_cursorMaterial.movie = _cursor;
		}//end resetCursorImage()
		
		public function show():void
		{
			_hidden = false;
			_cursor.alpha = 1;
		}//end show()
		
		public function hide():void
		{
			_hidden = true;
			_cursor.alpha = 0;
		}//end hide()
		
		public function get sprite():Sprite3D
		{
			return _cursorSprite;
		}//end get model()
				
	}//end Cursor

}//end com.bored.games.darts.objects