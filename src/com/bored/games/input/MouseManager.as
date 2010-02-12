package com.bored.games.input 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author sam
	 */
	public class MouseManager
	{
		private static var _dragAnchor:Point;
		private static var _dragPosition:Point;
		
		public static function beginDrag(a_x:Number, a_y:Number):void
		{
			if (!_dragAnchor) _dragAnchor = new Point();
			
			_dragAnchor.x = a_x;
			_dragAnchor.y = a_y;
		}//end beginDrag()
		
		public static function updateDrag(a_x:Number, a_y:Number):void
		{
			if (!_dragPosition) _dragPosition = new Point();
			
			_dragPosition.x = a_x;
			_dragPosition.y = a_y;
		}//end updateDrag()
		
		public static function calculateDragAngle():Number
		{
			if(_dragAnchor && _dragPosition) {
				var angle:Number = Math.atan2((_dragAnchor.y - _dragPosition.y), (_dragPosition.x - _dragAnchor.x));
				return angle * 180/Math.PI;
			} 
			
			return 0;
		}//end calculateDragAngle()
		
		public static function get dragVector():Vector3D
		{
			return new Vector3D((_dragAnchor.x - _dragPosition.x), (_dragAnchor.y - _dragPosition.y), 0);
		}//end calculateDragLength()
		
	}//end MouseManager
	
}//end com.bored.games.input