package com.bored.games.darts.logic 
{
	import com.bored.games.darts.objects.Board;
	/**
	 * ...
	 * @author sam
	 */
	public class DartsTurn
	{
		private var _logicManager:AbstractGameLogic;
		private var _turnOwner:String;
		private var _throwsRemaining:uint;
		
		public function DartsTurn(a_parent:AbstractGameLogic, a_owner:String, a_maxThrows:uint = 3)
		{
			_logicManager = a_parent;
			_turnOwner = a_owner;
			_throwsRemaining = a_maxThrows;
		}//end constructor()
		
		public function hasThrowsRemaining():Boolean
		{
			return (_throwsRemaining > 0);
		}//end hasThrowsRemaining()
		
		public function submitThrowResult(a_obj:Object):void
		{
			if ( a_obj && a_obj.section ) {
				_logicManager.scoreManager.submitThrowHit(_turnOwner, a_obj.section.points, a_obj.section.multiplier);
			} else {
				_logicManager.scoreManager.submitThrowMiss(_turnOwner);
			}
		}//end submitThrowResult()
		
		public function get owner():String
		{
			return _turnOwner;
		}//end get owner()
		
		public function advanceThrows():void
		{
			_throwsRemaining--;
		}//end advanceThrows()
		
	}//end DartsTurn

}//end com.bored.games.darts.logic