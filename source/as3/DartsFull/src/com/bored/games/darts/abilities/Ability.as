﻿package com.bored.games.darts.abilities 
{
	import com.bored.games.darts.player.DartsPlayer;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author sam
	 */
	public class Ability
	{	
		private var _name:String;
		private var _description:String;
		private var _armed:Boolean;
		private var _icon:Sprite;
		
		private var _player:DartsPlayer;
		private var _refreshTime:int;
		
		public function Ability(a_name:String, a_desc:String, a_icon:Sprite, a_time:int = 0) 
		{
			_name = a_name;
			_description = a_desc;
			_icon = a_icon;
			_refreshTime = a_time;
			_armed = true;
		}//end constructor()
		
		public function get name():String
		{
			return _name;
		}//end get name()
		
		public function get description():String
		{
			return _description;
		}//end get description()
		
		public function set owner(a_player:DartsPlayer):void
		{
			_player = a_player;
		}//end set owner()
		
		public function get owner():DartsPlayer
		{
			return _player;
		}//end get owner()
		
		public function get ready():Boolean
		{
			return _armed;
		}//end get ready()
		
		public function get icon():Sprite
		{
			return _icon;
		}//end get icon()
		
		public function get refreshTime():int
		{
			return _refreshTime;
		}//end get refreshTime()
		
		public function set refreshTime(a_time:int):void
		{
			_refreshTime = a_time;
		}//end set refreshTime()
		
		public function armAbility():void
		{
			_armed = true;
		}//end armAbility()
		
		public function useAbility():int
		{
			_armed = false;
			
			// TODO: activate...
			
			return _refreshTime * 2;
		}//end useAbility()
		
	}//end Ability

}//end com.bored.games.darts.abilities