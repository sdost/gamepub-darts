package com.bored.games.darts.states 
{
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.darts.logic.AbstractGameLogic;
	import com.bored.games.darts.logic.AIShotCandidate;
	import com.bored.games.darts.logic.AIShotManager;
	import com.bored.games.darts.logic.CricketScoreManager;
	import com.bored.games.darts.states.statemachines.AIOpponentFSM;
	import com.inassets.statemachines.Finite.State;
	import com.inassets.statemachines.interfaces.IStateMachine;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AIChooseShot extends State
	{
		private var _shotMgr:AIShotManager;
		
		public function AIChooseShot(a_name:String, a_mgr:AIShotManager, a_sm:IStateMachine) 
		{
			super(a_name, a_sm);	
			
			_shotMgr = a_mgr;
		}//end constructor()
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		override public function onEnter():void
		{
			var shotList:Vector.<AIShotCandidate> = new Vector.<AIShotCandidate>();
			
			var scores:Object = DartsGlobals.instance.logicManager.scoreManager.getScores(AbstractGameLogic.OPPONENT_TURN);
			
			for( var key:String in scores ) 
			{		
				if ( scores[key] < CricketScoreManager.CLOSED_OUT ) {
					_shotMgr.profile.populateShotList(shotList, Number(key));
				}
			} 
			
			var shot:AIShotCandidate = shotList[Math.floor(Math.random()*shotList.length)];
			
			_shotMgr.releasePoint.x = shot.point.x;
			_shotMgr.releasePoint.y = shot.point.y;
			_shotMgr.releasePoint.z = 0;
			
			_shotMgr.thrust = 11+Math.random()*3;
			
			(this.stateMachine as AIOpponentFSM).transitionToNextState();
		}//end onEnter()
		
		/**
		 * Handler for exiting this state.
		 */
		override public function onExit():void
		{

		}//end onExit()
		
	}//end AIChooseShot

}//end com.bored.games.darts.states