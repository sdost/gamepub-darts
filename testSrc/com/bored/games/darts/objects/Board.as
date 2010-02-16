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
		
		public function checkForCollision(a_pos:Vector3D, a_radius:int):Boolean
		{
			if (a_pos.z >= this.position.z)
			{
				var tip:Rectangle = new Rectangle(Math.floor(a_radius / 2), Math.floor(a_radius / 2), a_radius, a_radius);
				
				// 350 x 350
				// 0,1 x 0,1
				// -5,5 x -5,5
				
				if ( a_pos.x < -5 || a_pos.y < -5 || a_pos.x > 5 || a_pos.y > 5 ) return false;
				
				var x:Number = int((a_pos.x / 10.0 + 0.5) * _collMap.width);
				var y:Number = int((a_pos.y / 10.0 + 0.5) * _collMap.height);
				
				tip.offsetPoint(new Point(x, y));
				
				trace("Tip: " + tip.toString());
				
				var samples:ByteArray = _collMap.getPixels(tip);
				samples.position = 0;
				
				trace("Sample: " + samples.toString());
				
				var color:Number = 0x00000000;
				
				trace("Bytes Available: " + samples.bytesAvailable);
				
				while(samples.bytesAvailable) {
					color += samples.readUnsignedInt();	
				}
				
				trace("Length: " + samples.length);
						
				var avg:uint = color / (a_radius * a_radius);
				
				trace("Averaged Color (from sample): " + avg.toString(16));
				
				trace("AND: " + (avg & 0xFF000000));
				
				return uint(avg & 0xFF000000);
			} 
			else return false;
		}//end checkForCollision()
		
	}//end Board

}//end com.bored.games.darts.objects