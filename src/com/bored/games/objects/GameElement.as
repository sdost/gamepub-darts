package com.bored.games.objects 
{
	import com.bored.games.actions.Action;
	import flash.display.DisplayObject;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author sam
	 */
	public class GameElement
	{	
		protected var _actions:Vector.<Action>;
		protected var _actionsQueued:Vector.<Action>;
		protected var _actionsActive:Vector.<Action>;
		protected var _actionsFinished:Vector.<Action>;
		
		private var _lastUpdateTime:Number;
		private var _position:Vector3D;
		private var _orientation:Number;
		
		public function GameElement() 
		{
			_position = new Vector3D();
			
			_actions = new Vector.<Action>();
			_actionsQueued = new Vector.<Action>();
			_actionsActive = new Vector.<Action>();
			_actionsFinished = new Vector.<Action>();
		}//end constructor()
		
		public function addAction(a_action:Action):void
		{
			if ( !checkForActionNamed(a_action.actionName) ) 
			{
				_actions.push(a_action);
			}
		}//end addAction()
		
		public function checkForActionNamed(a_name:String):Boolean
		{
			for each ( var action:Action in _actions )
			{
				if (action.actionName == a_name) return true;
			}
			
			return false;
		}//end checkForActionNamed()
		
		public function activateAction(a_name:String):void
		{
			for each ( var action:Action in _actions ) 
			{
				if (action.actionName == a_name)
				{
					_actionsQueued.push(action);
					action.startAction();
				}
			}
		}//end activateAction()
		
		public function deactivateAction(a_name:String):void
		{
			for each ( var action:Action in _actionsActive ) 
			{
				if (action.actionName == a_name)
				{
					action.finished = true;
				}
			}
		}
		
		public function update(t:Number = 0):void
		{
			_lastUpdateTime = t;
			
			while ( _actionsQueued.length > 0 )
			{
				_actionsActive.push( _actionsQueued.pop() );
			}
			
			for each( var action:Action in _actionsActive ) 
			{
				action.update(t);
				
				if ( action.finished )
				{
					_actionsFinished.push(action);
				}
			}
			
			while ( _actionsFinished.length > 0 )
			{
				var finishedAction:Action = _actionsFinished.pop();
				var ind:int = _actionsActive.indexOf(finishedAction);
				_actionsActive.splice(ind, 1);
			}
		}//end update()
		
		public function get position():Vector3D
		{
			return _position;
		}//end get position()
		
		public function set orientation(a_ang:Number):void
		{
			_orientation = a_ang;
		}//end set orientation()
		
		public function get orientation():Number
		{
			return _orientation;
		}//end get orientation()
		
	}//end GameElement

}//end com.bored.games