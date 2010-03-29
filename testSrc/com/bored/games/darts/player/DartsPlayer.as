package com.bored.games.darts.player 
{
	import away3dlite.materials.Material;
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.logic.DartsGameLogic;
	import com.bored.games.darts.objects.Dart;
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
		
		protected var _skin:Material;
		
		private var _abilityStock:Array;
		
		public function DartsPlayer(a_name:String = "") 
		{
			_name = a_name;
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
		
		public function setSkin(a_material:Material):void
		{
			_skin = a_material;
		}//end setSkin()
		
		public function setAbilities(...args):void
		{
			_abilityStock = new Array(args.length);
			
			var i:int = 0;
			
			for each( var ability:Ability in args )
			{
				ability.owner = this;
				_abilityStock[i++] = ability;
			}
		}//end setAbility()
		
		public function get abilities():Array
		{
			return _abilityStock;
		}//end get abilities()
		
		public function get darts():Vector.<Dart>
		{
			return _darts;
		}//end getDart()
		
		public function takeTheShot():void
		{
			
		}//end takeTheShot()
		
	}//end DartsPlayer

}//com.bored.game.darts.player