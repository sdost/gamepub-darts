package com.bored.games.darts.player 
{
	import away3dlite.materials.Material;
	import away3dlite.primitives.AbstractPrimitive;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.objects.Dart;
	import com.bored.games.darts.skins.DartSkin;
	import com.bored.games.darts.statistics.GameRecord;
	import com.bored.games.darts.statistics.TurnRecord;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author sam
	 */
	public dynamic class DartsPlayer
	{		
		protected var _game:DartsGameLogic;
		protected var _name:String;
		protected var _num:int;
		protected var _darts:Vector.<Dart>;
		
		protected var _gameRecord:GameRecord;
		protected var _turnRecord:TurnRecord;
		
		protected var _skin:DartSkin;
		
		protected var _portrait:BitmapData;
		
		private var _abilityStock:Vector.<Ability>;
		private var _activeAbilities:Array;
		
		private var _turnTime:Number;
		
		public function DartsPlayer(a_name:String = "") 
		{
			_name = a_name;
			_abilityStock = new Vector.<Ability>();
			_activeAbilities = new Array(3);
			
			_turnTime = -1;
		}//end constructor()
		
		public function set dartGame(a_game:DartsGameLogic):void
		{
			_game = a_game;
			_darts = new Vector.<Dart>(_game.throwsPerTurn, true);
			for ( var i:int = 0; i < _darts.length; i++ )
			{
				_darts[i] = new Dart(_skin);
			}
		}//end set dartGame()
		
		public function set playerName(a_name:String):void
		{
			_name = a_name;
		}//end set playerName()
		
		public function get playerName():String
		{
			return _name;
		}//end get playerName()
		
		public function set playerNum(a_num:int):void
		{
			_num = a_num;
		}//end set playerNum()
		
		public function get playerNum():int
		{
			return _num;
		}//end get playerNum()
		
		public function set portrait(a_bmd:BitmapData):void
		{
			_portrait = a_bmd;
		}//end set portrait()
		
		[Bindable]
		public function get portrait():BitmapData
		{
			return _portrait;
		}//end get portrait()
		
		public function setSkin(a_skin:DartSkin):void
		{
			_skin = a_skin;
		}//end setSkin()
		
		public function get skin():DartSkin
		{
			return _skin;
		}//end get skin()
		
		public function set turnTime(a_time:Number):void
		{
			_turnTime = a_time;
		}//end set turnTime()
		
		public function get turnTime():Number
		{
			return _turnTime;
		}//end get turnTime()
		
		public function addAbilities(a_ability:Ability):void
		{
			a_ability.owner = this;
			_abilityStock.push(a_ability);
		}//end addAbilities()
		
		public function setAbilitiesSlot(a_slot:int, a_abilityInd:int):void
		{
			_activeAbilities[a_slot] = _abilityStock[a_abilityInd];
		}//end setAbility()
		
		public function get abilities():Vector.<Ability>
		{
			return _abilityStock;
		}//end get abilities()
		
		public function getAbilityByName(a_name:String):Ability
		{
			for ( var i:int = 0; i < _abilityStock.length; i++ )
			{
				if ( _abilityStock[i].name == a_name ) return _abilityStock[i];
			}
			return null;
		}//end get abilities()
		
		public function get activeAbilities():Array
		{
			return _activeAbilities;
		}//end get activeAbilities()
	
		public function hasAbility(a_name:String):Boolean
		{
			var hasAbility:Boolean = false;
			
			for each( var ability:Ability in _activeAbilities )
			{
				if ( a_name == ability.name && ability.ready ) 
				{
					hasAbility = true;
				}
			}
			
			return hasAbility;
		}//end hasAbility()
		
		public function get darts():Vector.<Dart>
		{
			return _darts;
		}//end getDart()
		
		public function takeTheShot(a_dartsRemaining:int):void
		{
			
		}//end takeTheShot()
		
		public function processShotResult(a_points:int, a_multiplier:int, a_scoring:Boolean):void
		{
			trace("processShotResults(" + a_points + ", " + a_multiplier + ", " + a_scoring + ")");
			
			_gameRecord.recordThrow(a_points, a_multiplier, a_scoring);	
			_turnRecord.recordThrow(a_points, a_multiplier);
		}//end processShotResult()
		
		public function get record():GameRecord
		{
			return _gameRecord;
		}//end recordThrow()
		
		public function initGameRecord():void
		{
			_gameRecord = new GameRecord();
			
			_turnTime = -1;
		}//end initGameRecord()
		
		public function clearTurnRecord():void
		{
			_turnRecord = new TurnRecord();
		}//end clearTurnRecord()
		
	}//end DartsPlayer

}//com.bored.game.darts.player