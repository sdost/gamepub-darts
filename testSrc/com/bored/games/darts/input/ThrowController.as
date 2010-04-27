﻿package com.bored.games.darts.input 
{
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.events.InputStateEvent;
	import com.bored.games.input.InputController;
	/**
	 * ...
	 * @author sam
	 */
	public class ThrowController
	{		
		protected var _thrust:Number = 0;
		protected var _lean:Number = 0;
		
		public function startThrow(a_inputController:InputController):void
		{
			a_inputController.pause = false;
		}//end startThrow()
		
		public function onInputUpdate(a_evt:InputStateEvent):void
		{
			
		}//end onInputUpdate()
		
		public function get thrust():Number
		{
			return _thrust;
		}//end get thrust()
		
		public function get lean():Number
		{
			return _lean;
		}//end get lean()
		
	}//end ThrowController

}//end com.bored.games.darts.input