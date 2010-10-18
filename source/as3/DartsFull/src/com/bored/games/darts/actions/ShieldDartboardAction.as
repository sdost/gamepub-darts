package com.bored.games.darts.actions 
{
	import com.bored.games.actions.Action;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.objects.Dartboard;
	import com.bored.games.objects.GameElement;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author sam
	 */
	public class ShieldDartboardAction extends Action
	{
		private static const NAME:String = "com.bored.games.darts.actions.ShieldDartboardAction";
		private var _section:int;
		private var _turnsRemaining:int;
		
		private var _timers:Array;
		
		public function ShieldDartboardAction(a_gameElement:GameElement, a_params:Object = null) 
		{
			super(NAME, a_gameElement, a_params);
			
			_timers = new Array();
		}//end constructor()
		
		override public function initParams(a_params:Object):void
		{
			_turnsRemaining = a_params.turns;
		}//end initParams()
		
		override public function startAction():void
		{
			super.startAction();
			
			DartsGlobals.instance.gameManager.addEventListener(DartsGameLogic.TURN_END, onTurnEnd, false, 0, true);
		}//end startAction()
		
		public function startBlocking(a_section:String):void
		{
			_timers[a_section] = _turnsRemaining;
			(_gameElement as Dartboard).blockSection(int(a_section));
		}//end startBlocking()
		
		private function onTurnEnd(evt:Event):void
		{
			trace("ShieldDartboardAction::onTurnEnd()");		
			
			var visitedKeys:Array = [];
			
			for ( var key:String in _timers ) 
			{
				if( _timers[key] > 0 && visitedKeys.indexOf(key) < 0 ) {
					_timers[key]--;
				}
				
				visitedKeys.push(key);
			}
			
			visitedKeys = null;
		}//end onTurnEnd()
	
		override public function update(a_time:Number):void
		{
			for ( var key:String in _timers )
			{
				if ( _timers[key] == 0 ) {
					_timers[key] = null;
					(_gameElement as Dartboard).unblockSection(int(key));
				}
			}
		}//end update()
		
	}//end ShieldDartboardAction

}//end com.bored.games.darts.actions