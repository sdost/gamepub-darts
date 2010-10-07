package com.bored.games.darts.input 
{
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.events.InputStateEvent;
	import com.bored.games.darts.input.InputController;
	/**
	 * ...
	 * @author sam
	 */
	public class ThrowController
	{	
		protected var _show:Boolean = false;
		
		protected var _thrust:Number = 0;
		protected var _lean:Number = 0;
		
		protected var _trueThrust:Number = 0;
		protected var _trueAngle:Number = 0;
		
		public function startThrow(a_inputController:InputController):void
		{
			a_inputController.pause = false;
		}//end startThrow()
		
		public function onInputUpdate(a_evt:InputStateEvent):void
		{
			
		}//end onInputUpdate()
		
		public function resetThrowParams():void
		{
			_thrust = 0;
			_lean = 0;
		}//end resetThrowParams()
		
		public function get thrust():Number
		{
			return _thrust;
		}//end get thrust()
		
		public function get lean():Number
		{
			return _lean;
		}//end get lean()
		
		public function get trueThrust():Number
		{
			return _trueThrust;
		}//end get trueThrust()
		
		public function get trueAngle():Number
		{
			return _trueAngle;
		}//end get trueAngle()
		
		public function set show(a_bool:Boolean):void
		{
			_show = a_bool;
		}//end set show()
		
		public function get show():Boolean
		{
			return _show;
		}//end get show()
		
	}//end ThrowController

}//end com.bored.games.darts.input