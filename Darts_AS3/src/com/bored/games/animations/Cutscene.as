package com.bored.games.animations 
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author sam
	 */
	public class Cutscene extends Sprite
	{
		private var _sceneName:String;
		
		private var _currentShotInd:int;
		private var _currentShot:AnimatedShot;
		
		protected var _shotList:Vector.<AnimatedShot>;
		
		public function Cutscene(a_script:XML = null)
		{
			_sceneName = "";
			_shotList = new Vector.<AnimatedShot>();
			
			if ( a_script ) 
				parseScript(a_script);
		}//end construtor()
		
		public function set sceneName(a_str:String):void
		{
			_sceneName = a_str;
		}//end set sceneName()
		
		public function get sceneName():String
		{
			return _sceneName;
		}//end get sceneName()
		
		private function parseScript(a_xml:XML):void
		{
			this.sceneName = a_xml.@name;
			
			for each( var shot:XML in a_xml.children() )
			{
				addShot( new AnimatedShot(shot) );
			}
		}//end parseScript()
		
		public function addShot(a_shot:AnimatedShot):void
		{
			_shotList.push(a_shot);
		}//end addShot()
		
		public function startScene():void
		{
			_currentShotInd = 0;
			showShot(_currentShotInd);
		}//end startScene()
		
		public function showShot(a_ind:int):void
		{
			_currentShot = _shotList[a_ind];
			_currentShot.addEventListener(Event.COMPLETE, onShotComplete);
			addChild(_currentShot);
			_currentShot.startShot();
		}//end showShot()
		
		public function advanceDialogue():void
		{
			if( _currentShot ) _currentShot.advanceDialogue();
		}//end advanceDialogue()
		
		private function onShotComplete(a_evt:Event):void
		{
			removeChild(_currentShot);
			if ( ++_currentShotInd < _shotList.length )
			{
				showShot(_currentShotInd);
			} else {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}//end onShotComplete()
		
	}//end Cutscene

}//end com.bored.games.animations