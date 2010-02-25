package com.bored.games.input 
{
	import com.bored.games.controllers.MouseInputController;
	import com.bored.games.events.InputStateEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author sam
	 */
	public class MouseStroke
	{
		private var _startPosition:Point;
		private var _lastPosition:Point;
		private var _lastTimeStamp:Number;
		private var _velocity:Point;
		
		public function MouseStroke(inputController:MouseInputController, startX:Number = 0, startY:Number = 0, startTime:Number = 0) 
		{
			_startPosition = new Point(startX, startY);
			
			trace("Start: " + _startPosition);
			
			_lastPosition = _startPosition.clone();
			_velocity = new Point();
			_lastTimeStamp = startTime;
			inputController.addEventListener(InputStateEvent.UPDATE, onMouseUpdate);
		}//end constructor()
		
		private function onMouseUpdate(a_evt:InputStateEvent):void
		{			
			var elapsed:Number = a_evt.timestamp - _lastTimeStamp;			
			
			_velocity.x = (a_evt.x - _lastPosition.x) / elapsed;
			_velocity.y = (a_evt.y - _lastPosition.y) / elapsed;
			
			_lastPosition.x = a_evt.x;
			_lastPosition.y = a_evt.y;
			_lastTimeStamp = a_evt.timestamp;
		}//end onMouseUpdate()
		
		public function get vel():Point
		{
			return _velocity;
		}//end get vel()
		
		public function get pos():Point
		{
			return _lastPosition;
		}//end get pos()
		
		public function get vector():Point
		{
			return new Point(_lastPosition.x - _startPosition.x, _lastPosition.y - _startPosition.y);
		}//end get distance()
		
	}//end MouseStroke

}//end com.bored.games.input