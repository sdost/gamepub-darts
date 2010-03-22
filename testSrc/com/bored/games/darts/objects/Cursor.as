package com.bored.games.darts.objects 
{
	import away3dlite.animators.MovieMesh;
	import away3dlite.core.clip.RectangleClipping;
	import away3dlite.materials.Material;
	import away3dlite.materials.MovieMaterial;
	import away3dlite.primitives.Plane;
	import com.sven.utils.AppSettings;
	import away3dlite.core.base.Object3D;
	import com.bored.games.objects.GameElement;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Cursor extends GameElement
	{
		private var _cursor:Sprite;
		private var _cursorModel:Plane;
		private var _cursorMaterial:MovieMaterial;
		
		public function Cursor(a_img:Sprite) 
		{
			super();	
			
			_cursor = a_img;
		}//end constructor()
		
		public function initModels():void
		{
			_cursorMaterial = new MovieMaterial(_cursor, new Rectangle(-30, -30, 60, 60), false, true);
			
			_cursorModel = new Plane();
			_cursorModel.width = 60;
			_cursorModel.height = 60;
			_cursorModel.material = _cursorMaterial;
			_cursorModel.yUp = false;
			_cursorModel.bothsides = true;
			_cursorModel.mouseEnabled = false;
		}//end initModels()
		
		override public function update(a_time:Number = 0):void
		{
			super.update(a_time);
			
			if(_cursorMaterial)	_cursorMaterial.update()
			
			if ( _cursorModel ) {
				_cursorModel.x = this.position.x * AppSettings.instance.away3dEngineScale;
				_cursorModel.y = -(this.position.y * AppSettings.instance.away3dEngineScale);
				_cursorModel.z = this.position.z * AppSettings.instance.away3dEngineScale;
			}
		}//end update()
		
		public function setCursorImage(a_spr:Sprite):void
		{
			_cursorMaterial.movie = a_spr;
		}//end setCursorImage()
		
		public function resetCursorImage():void
		{
			_cursorMaterial.movie = _cursor;
		}//end resetCursorImage()
		
		public function get model():Object3D
		{
			return _cursorModel;
		}//end get model()
				
	}//end Cursor

}//end com.bored.games.darts.objects