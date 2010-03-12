package com.bored.games.animations 
{
	import com.sven.utils.MovieClipFactory;
	import com.sven.utils.SpriteFactory;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * ...
	 * @author sam
	 */
	public class AnimatedShot extends MovieClip
	{		
		private var _animations:Vector.<MovieClip>;
		private var _dialogueFrame:Sprite;	
		private var _dialogueList:Vector.<DialogueLine>;
		
		private var _dialogueInd:int;
		
		public function AnimatedShot(a_shot:XML = null)
		{
			_animations = new Vector.<MovieClip>();
			_dialogueList = new Vector.<DialogueLine>();
			
			if ( a_shot ) 
				parseShot(a_shot);
		}//end costructor()
		
		private function parseShot(a_xml:XML):void
		{
			for each( var image:XML in a_xml.descendants("image") )
			{
				addAnimation( MovieClipFactory.getMovieClipByQualifiedName(image.@src) );
			}
			
			for each( var line:XML in a_xml.dialogue.children() )
			{
				addDialogue( new DialogueLine( line.@actor, line.@frame, line.@x, line.@y, line.text() ) );
			}
		}//end parseShot()
		
		public function addAnimation(a_img:MovieClip):void
		{
			_animations.push(a_img);
			this.addChild(a_img);
			a_img.gotoAndStop(1);
		}//end addAnimations()
		
		public function addDialogue(a_line:DialogueLine):void
		{
			_dialogueList.push(a_line);
		}//end addDialogue()
		
		public function startShot():void
		{
			for ( var i:int = 0; i < _animations.length; i++ )
			{
				_animations[i].gotoAndPlay(1);
			}
			
			_dialogueInd = 0;
			
			advanceDialogue();
		}//end startShot()
		
		public function advanceDialogue():void
		{
			if ( _dialogueInd < _dialogueList.length ) 
			{
				try {
					removeChild(_dialogueFrame);
				} catch(e:Error) {}
				
				var dialogue:DialogueLine = _dialogueList[_dialogueInd];
				
				_dialogueFrame = MovieClipFactory.getMovieClipByQualifiedName(dialogue.frame);
				
				(_dialogueFrame.getChildByName("dialogue_text") as TextField).text = dialogue.lineText;
				
				_dialogueFrame.x = dialogue.position.x;
				_dialogueFrame.y = dialogue.position.y;
				
				addChild(_dialogueFrame);
				
				_dialogueInd++;
			} else {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}//end advanceDialogue()
		
	}//end AnimatedShot

}//end com.bored.games.animations