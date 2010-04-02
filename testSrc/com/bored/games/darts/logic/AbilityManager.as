﻿package com.bored.games.darts.logic 
{
	import com.bored.games.darts.abilities.Ability;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author sam
	 */
	public class AbilityManager
	{
		private var _abilities:Vector.<Ability>;
		private var _timers:Array;
		
		public function AbilityManager() 
		{
			initialize();
		}//end constructor()
		
		public function initialize():void
		{
			_abilities = new Vector.<Ability>();
			_timers = new Array();
		}//end initialize()
		
		public function registerAbility(a_ability:Ability):void
		{
			_abilities.push(a_ability);
		}//end registerAbility()
		
		
		public function activateAbility(a_ind:int):void
		{
			_timers[a_ind] = _abilities[a_ind].useAbility();
		}//end activateAbility()
		
		public function processTurn():void
		{
			for ( var i:int = 0; i < _timers.length; i++ )
			{
				var time:int = _timers[i];
				time--;
				_timers[i] = time;
				if ( time <= 0 )
				{
					time = 0;
					_abilities[i].armAbility();
				}
			}
		}//end processTurn()
		
		public function get abilities():Vector.<Ability>
		{
			return _abilities;
		}//end get abilities()
		
	}//end AbilityManager

}//end com.bored.games.darts.logic