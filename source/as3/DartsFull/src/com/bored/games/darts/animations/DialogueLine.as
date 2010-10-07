package com.bored.games.darts.animations 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author sam
	 */
	public class DialogueLine
	{
		private var _actor:String;
		private var _frame:String;
		private var _position:Point;
		private var _lineText:String;
		
		public function DialogueLine(a_actorName:String, a_frame:String, a_xpos:Number, a_ypos:Number, a_text:String = "") 
		{
			_actor = a_actorName;
			_frame = a_frame;
			_position = new Point(a_xpos, a_ypos);
			
			_lineText = a_text;
		}//end construtor()
		
		public function get actor():String
		{
			return _actor;
		}//end get actor()
		
		public function get frame():String
		{
			return _frame;
		}//end get frame()
		
		public function get position():Point
		{
			return _position;
		}//end get position()
		
		public function get lineText():String
		{
			return _lineText;
		}//end get lineText()
		
	}//end DialogueLine

}//end com.bored.games.animation