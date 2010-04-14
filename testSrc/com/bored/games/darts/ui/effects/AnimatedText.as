package com.bored.games.darts.ui.effects 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author sam
	 */
	public class AnimatedText extends MovieClip
	{
		private var _font:Font;
		private var _text:String;
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		private var _tween:TweenMax;
		
		public function AnimatedText(a_text:String, a_font:Font, a_tween:TweenMax) 
		{
			_text = a_text;
			_font = a_font;
			_tween = a_tween;
			
			_tween.pause();
			_tween.addEventListener(Event.COMPLETE, onComplete);
			_tween.target = this;
			
			_textFormat = new TextFormat();
			_textFormat.font = a_font.fontName;
			_textFormat.color = 0xFFFFFF;
			_textFormat.size = 18;
			
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.CENTER;
			_textField.text = a_text;
			_textField.setTextFormat(_textFormat);
			_textField.x = -_textField.width / 2;
			_textField.y = -_textField.height * 2;
			_textField.filters = [ new GlowFilter(0x000000, 1, 4, 4, 200, 3, false, false) ];
			
			addChild(_textField);
		}//end constructor()
				
		public function animate():void
		{
			_tween.restart(true, false);
		}//end animate()
		
		private function onComplete(evt:Event):void
		{
			_tween.removeEventListener(Event.COMPLETE, onComplete);
			
			this.parent.removeChild(this);
		}//end onComplete()		
		
	}//end AnimatedText

}//end com.bored.games.darts.ui.effect