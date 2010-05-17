package com.bored.games.darts.logic 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.DartsGlobals;
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundController;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author sam
	 */
	public class AbilityManager
	{
		private var _abilities:Vector.<Ability>;
		private var _timers:Array;
		
		private var _abilitySoundController:SoundController;
		
		public function AbilityManager() 
		{
			initialize();
		}//end constructor()
		
		public function initialize():void
		{
			_abilities = new Vector.<Ability>();
			_timers = new Array();
			
			_abilitySoundController = DartsGlobals.instance.soundManager.getSoundControllerByID("abilitySounds");
			_abilitySoundController.addSound( new SMSound("player_activate", "dartpower_playeractivate_mp3") );
			_abilitySoundController.addSound( new SMSound("opponent_activate", "dartpower_opponentactivate_mp3") );
			
			DartsGlobals.instance.soundManager.addSoundController(_abilitySoundController);
		}//end initialize()
		
		public function registerAbility(a_ability:Ability):void
		{
			_abilities.push(a_ability);
		}//end registerAbility()
	
		public function activateAbility(a_ability:Ability):void
		{
			for ( var i:int = 0; i < _abilities.length; i++ )
			{
				if ( _abilities[i] == a_ability )
				{
					if (_abilities[i].owner.playerNum == DartsGlobals.instance.localPlayer.playerNum) 
					{
						_abilitySoundController.play("player_activate");
					}
					else
					{
						_abilitySoundController.play("opponent_activate");
					}
					
					_timers[i] = _abilities[i].useAbility();
				}
			}
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
		
		public function turnsLeft(a_ability:Ability):int
		{
			for ( var i:int = 0; i < _abilities.length; i++ )
			{
				if ( _abilities[i] == a_ability )
				{
					return Math.ceil(_timers[i] / 2);
				}
			}
			
			return 0;
		}//end turnsLeft()
		
		public function resetAbilties():void
		{
			for ( var i:int = 0; i < _abilities.length; i++ )
			{
				_abilities[i].armAbility();
			}
		}//end resetAbilities()
		
		public function get abilities():Vector.<Ability>
		{
			return _abilities;
		}//end get abilities()
		
	}//end AbilityManager

}//end com.bored.games.darts.logic