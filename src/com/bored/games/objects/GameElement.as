package com.bored.games.objects 
{
	import flash.display.DisplayObject;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameElement
	{	
		private var _lastUpdateTime:Number;
		private var _position:Vector3D;
		
		public function GameElement() 
		{
			_position = new Vector3D();
		}//end constructor()
		
		public function update(t:Number = 0):void
		{
			_lastUpdateTime = t;
		}//end update()
		
		public function get position():Vector3D
		{
			return _position;
		}//end get position()
		
	}//end GameElement

}//end com.bored.games