package com.bored.games.darts.objects 
{
	import away3dlite.core.base.Object3D;
	import away3dlite.materials.MovieMaterial;
	import away3dlite.primitives.Plane;
	import com.bored.games.objects.GameElement;
	import flash.display.Sprite;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Dartboard extends GameElement
	{
		private var _boardModel:Plane;
		private var _boardMaterial:MovieMaterial;
		
		private var _sprite:Sprite;
		
		public function Dartboard(a_img:Sprite) 
		{
			super();
			
			_sprite = a_img;
		}//end constructor()
		
		public function initModels():void
		{
			_boardMaterial = new BitmapMaterial(_sprite);
			
			_boardModel = new Plane();
			_boardModel.width = AppSettings.instance.boardTextureWidth;
			_boardModel.height = AppSettings.instance.boardTextureHeight;
			_boardModel.material = _boardMaterial;
			_boardModel.yUp = false;
			_boardModel.bothsides = true;
			_boardModel.mouseEnabled = false;
		}//end initModels()
		
		override public function update(a_time:Number = 0):void
		{
			super.update(a_time);
			
			if ( _boardModel ) {
				_boardModel.x = this.position.x * AppSettings.instance.away3dEngineScale;
				_boardModel.y = -(this.position.y * AppSettings.instance.away3dEngineScale);
				_boardModel.z = this.position.z * AppSettings.instance.away3dEngineScale;
			}
		}//end update()
		
		public function get model():Object3D
		{
			return _boardModel;
		}//end get model()
		
		public function get boardSprite():Sprite
		{
			return _sprite;
		}//end get boardSprite()
		
	}//end Dartboard

}//end com.bored.games.darts.objects