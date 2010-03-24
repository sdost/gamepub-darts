package com.bored.games.actions 
{
	import com.bored.games.objects.GameElement;
	/**
	 * ...
	 * @author sam
	 */
	public class Action
	{
		protected var _actionName:String;
		protected var _gameElement:GameElement;
		protected var _finished:Boolean;
		
		/**
		 * The action class compartmentalizes a set of functionalities to be performed on a GameElement. The action 
		 * should generally perform its function and then be removed. This allows for rapid transitioning of functionality
		 * and robustness of these small repeatable Actions.
		 * 
		 * @param	a_name The unique name of this action.
		 * @param	a_gameElement A reference to the GameElement instance this Action is affecting.
		 * @param	a_params An optional parameter to initilize the Action. This can be done later. @see initParams.
		 */
		public function Action(a_name:String, a_gameElement:GameElement, a_params:Object = null)
		{
			_actionName = a_name;
			_gameElement = a_gameElement;
			
			_finished = true;
			
			if ( a_params ) 
			{
				initParams(a_params);
			}
		}//end construtor()
		
		/**
		 * Accessor function for the actions name.
		 * @return actionName Name String
		 */
		public function get actionName():String
		{
			return _actionName;
		}//end get actionName()
		
		/**
		 * Initialization function for this action to be overridden in child classes.
		 * @param	a_params
		 */
		public function initParams(a_params:Object):void
		{
			// TODO: handle params...
		}//end initParams()
		
		/**
		 * Starts the action and in child classes can be overridden to reinitialize the action's state.
		 */
		public function startAction():void
		{
			_finished = false;
		}//end startAction()
		
		/**
		 * Updates the action's state and performs most of the work of this class. This should be overridden in child classes.
		 * @param	a_time
		 */
		public function update(a_time:Number):void
		{
			// TODO: handle updatable portion...
		}//end update
		
		/**
		 * Accessor to force the setting of the action's finished state.
		 */
		public function set finished(a_finished:Boolean):void
		{
			_finished = a_finished;
		}//end set finished()
		
		/**
		 * Accessor to get the action's finished state.
		 */
		public function get finished():Boolean
		{
			return _finished;
		}//end finished()
		
	}//end Action

}//end com.bored.games.actions