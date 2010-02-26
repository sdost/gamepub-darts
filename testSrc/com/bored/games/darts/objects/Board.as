package com.bored.games.darts.objects 
{
	import com.bored.games.elements.GameElement;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author sam
	 */
	public class Board extends GameElement
	{	
		private var _collMap:BitmapData;
		
		public function Board() 
		{
			super();
			
		}//end constructor()
		
		public function setCollisionMap(a_bmp:BitmapData):void 
		{
			_collMap = a_bmp;
		}//end setCollisionMap()
		
		public function checkForCollision(a_obj:GameElement, a_radius:int):int
		{
			var points:int = -1;
			
			if (a_obj.position.z >= this.position.z)
			{
				a_obj.position.z = this.position.z;
				
				/*
				var tip:Rectangle = new Rectangle(Math.floor(a_radius / 2), Math.floor(a_radius / 2), a_radius, a_radius);
				
				if ( a_obj.position.x > -5 || a_obj.position.y > -5 || a_obj.position.x < 5 || a_obj.position.y < 5 ) {				
					var x:Number = int((a_obj.position.x / 10.0 + 0.5) * _collMap.width);
					var y:Number = int((a_obj.position.y / 10.0 + 0.5) * _collMap.height);
					
					tip.offsetPoint(new Point(x, y));
					
					var samples:ByteArray = _collMap.getPixels(tip);
					samples.position = 0;
					
					var color:Number = 0x00000000;
					
					while(samples.bytesAvailable) {
						color += samples.readUnsignedInt();	
					}
												
					var avg:uint = color / (a_radius * a_radius);
					
					if (avg & 0xFF000000) {
						points = uint(avg & 0x0000FFFF);
					}
				}
				*/
				points = 1;
			} 
			
			return points;
		}//end checkForCollision()
		
	}//end Board

}//end com.bored.games.darts.objects