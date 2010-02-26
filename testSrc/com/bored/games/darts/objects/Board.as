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
		public static const ONE:uint 		= 1;
		public static const TWO:uint 		= 2;
		public static const THREE:uint 		= 3;
		public static const FOUR:uint 		= 4;
		public static const FIVE:uint 		= 5;
		public static const SIX:uint 		= 6;
		public static const SEVEN:uint 		= 7;
		public static const EIGHT:uint 		= 8;
		public static const NINE:uint 		= 9;
		public static const TEN:uint 		= 10;
		public static const ELEVEN:uint 	= 11;
		public static const TWELVE:uint 	= 12;
		public static const THIRTEEN:uint 	= 13;
		public static const FOURTEEN:uint 	= 14;
		public static const FIFTEEN:uint 	= 15;
		public static const SIXTEEN:uint 	= 16;
		public static const SEVENTEEN:uint 	= 17;
		public static const EIGHTEEN:uint 	= 18;
		public static const NINETEEN:uint 	= 19;
		public static const TWENTY:uint 	= 20;
		public static const BULL:uint 		= 25;
		
		public static const SINGLE:uint 	= 1;
		public static const DOUBLE:uint 	= 2;
		public static const TRIPLE:uint		= 3;
		
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