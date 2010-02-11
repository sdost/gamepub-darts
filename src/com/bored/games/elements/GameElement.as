package com.bored.games.elements 
{
	import com.bored.games.math.CartesianCoord;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameElement
	{	
		private var _lastUpdateTime:Number;
		private var _position:CartesianCoord;
		
		public function GameElement() 
		{
			_position = new CartesianCoord();
		}//end constructor()
		
		public function update(t:Number = 0):void
		{
			_lastUpdateTime = t;
		}//end update()
		
		public function get position():CartesianCoord
		{
			return _position;
		}//end get position()
		
	}//end GameElement

}//end com.bored.games