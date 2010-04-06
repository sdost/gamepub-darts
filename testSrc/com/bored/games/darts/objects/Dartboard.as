package com.bored.games.darts.objects 
{
	import away3dlite.core.base.Object3D;
	import away3dlite.materials.MovieMaterial;
	import away3dlite.primitives.AbstractPrimitive;
	import away3dlite.primitives.Plane;
	import away3dlite.sprites.AlignmentType;
	import away3dlite.sprites.Sprite3D;
	import com.bored.games.darts.actions.ShieldDartboardAction;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.games.objects.GameElement;
	import flash.display.Sprite;
	import com.sven.utils.AppSettings;
	import flash.geom.Point;
	import flash.geom.Rectangle;
		
	/**
	 * ...
	 * @author sam
	 */
	public class Dartboard extends GameElement
	{
		private var _boardSprite:Sprite3D;
		private var _boardMaterial:MovieMaterial;
		
		private var _blockedSections:Object;
		
		private var _sprite:Sprite;
				
		private var _pattern:RegExp = /c_[0-9]+_[0-9]+_mc/;
		
		private var _shieldAction:ShieldDartboardAction;
		
		public function Dartboard(a_img:Sprite) 
		{
			super();
			
			_shieldAction = new ShieldDartboardAction(this, { turns: 2 } );
			this.addAction(_shieldAction);
			
			_sprite = a_img;
			
			resetBlockedSections();
		}//end constructor()
		
		public function initModels():void
		{
			_boardMaterial = new MovieMaterial(_sprite);
			_boardMaterial.smooth = true;
			
			_boardSprite = new Sprite3D(_boardMaterial, 130);
			_boardSprite.alignmentType = AlignmentType.VIEWPOINT;
			
			this.activateAction(_shieldAction.actionName);
		}//end initModels()
		
		override public function update(a_time:Number = 0):void
		{
			super.update(a_time);
			
			if ( _boardSprite ) {
				_boardSprite.x = this.position.x * AppSettings.instance.away3dEngineScale;
				_boardSprite.y = -(this.position.y * AppSettings.instance.away3dEngineScale);
				_boardSprite.z = this.position.z * AppSettings.instance.away3dEngineScale;
			}
		}//end update()
		
		public function getDartboardClip(a_points:int, a_multiple:int, a_nullIfBlocked:Boolean = false):Sprite
		{
			var name:String = "c_" + a_points + "_" + a_multiple + "_mc";
			
			if ( a_nullIfBlocked && _blockedSections[name] )
			{
				return null;
			}
			
			return this.boardSprite.getChildByName(name) as Sprite;
		}//end getDartboardClip()
		
		public function submitDartPosition(a_x:Number, a_y:Number, a_block:Boolean):Boolean
		{
			var p:Point = new Point( ( a_x / AppSettings.instance.dartboardScale ) * (_sprite.width/2), ( -a_y / AppSettings.instance.dartboardScale ) * (_sprite.height/2) );
				
			var objects:Array = _sprite.getObjectsUnderPoint(p);
			
			if (objects.length > 0) {
				if (_pattern.test(objects[0].parent.name) && !_blockedSections[objects[0].parent.name]) 
				{
					var arr:Array = objects[0].parent.name.split("_");
					DartsGlobals.instance.gameManager.scoreManager.submitThrow(DartsGlobals.instance.gameManager.currentPlayer, Number(arr[1]), Number(arr[2]));
					DartsGlobals.instance.gameManager.recordThrow(Number(arr[1]), Number(arr[2]));
					
					if (a_block)
					{
						_shieldAction.startBlocking(arr[1]);						
					}
					
					return true;
				}
			}
			
			DartsGlobals.instance.gameManager.recordThrow();
			
			return false;			
		}//end submitDartPosition()
		
		public function blockSection(a_section:int):void
		{
			_blockedSections["c_" + a_section + "_1_mc"] = true;
			_blockedSections["c_" + a_section + "_2_mc"] = true;
			
			if ( a_section != 25 ) _blockedSections["c_" + a_section + "_3_mc"] = true;
			
			try 
			{
				_sprite.getChildByName("c_" + a_section + "_1_shield_mc").visible = true;
				_sprite.getChildByName("c_" + a_section + "_2_shield_mc").visible = true;
				
				if( a_section != 25 ) _sprite.getChildByName("c_" + a_section + "_3_shield_mc").visible = true;
			}
			catch ( e:Error ) 
			{
				trace("nothing to shield");
			}
		}//end blockSection()
		
		public function unblockSection(a_section:int):void
		{
			_blockedSections["c_" + a_section + "_1_mc"] = false;
			_blockedSections["c_" + a_section + "_2_mc"] = false;
			
			if ( a_section != 25 ) _blockedSections["c_" + a_section + "_3_mc"] = false;
			
			try 
			{
				_sprite.getChildByName("c_" + a_section + "_1_shield_mc").visible = false;
				_sprite.getChildByName("c_" + a_section + "_2_shield_mc").visible = false;
				
				if( a_section != 25 ) _sprite.getChildByName("c_" + a_section + "_3_shield_mc").visible = false;
			}
			catch ( e:Error ) 
			{
				trace("nothing to shield");
			}
		}//end unblockSection()
		
		public function resetBlockedSections():void
		{
			_blockedSections = new Object();;
			
			for ( var i:int = 1; i <= 20; i++ )
			{
				_blockedSections["c_" + i + "_1_mc"] = false;
				_blockedSections["c_" + i + "_2_mc"] = false;
				_blockedSections["c_" + i + "_3_mc"] = false;
				
				_sprite.getChildByName("c_" + i + "_1_shield_mc").visible = false;
				_sprite.getChildByName("c_" + i + "_2_shield_mc").visible = false;
				_sprite.getChildByName("c_" + i + "_3_shield_mc").visible = false;
			}
			_blockedSections["c_25_1_mc"] = false;
			_blockedSections["c_25_2_mc"] = false;
			
			_sprite.getChildByName("c_25_1_shield_mc").visible = false;
			_sprite.getChildByName("c_25_2_shield_mc").visible = false;
		}//end resetBlockedSections()
		
		public function get sprite():Sprite3D
		{
			return _boardSprite;
		}//end get model()
		
		public function get boardSprite():Sprite
		{
			return _sprite;
		}//end get boardSprite()
		
	}//end Dartboard

}//end com.bored.games.darts.objects