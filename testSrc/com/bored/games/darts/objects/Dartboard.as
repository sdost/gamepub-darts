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
	import com.bored.games.darts.ui.effects.AnimatedText;
	import com.bored.games.objects.GameElement;
	import com.greensock.TweenMax;
	import com.jac.soundManager.SMSound;
	import com.jac.soundManager.SoundController;
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
		private var _sprite:Sprite;
		private var _boardSprite:Sprite3D;
		private var _boardMaterial:MovieMaterial;
		
		private var _blockedSections:Object;
				
		private var _pattern:RegExp = /c_[0-9]+_[0-9]+_mc/;
		
		private var _shieldAction:ShieldDartboardAction;
		
		private var _dartboardSoundController:SoundController;
		
		public function Dartboard(a_img:Sprite) 
		{
			super();
			
			_shieldAction = new ShieldDartboardAction(this, { turns: 2 } );
			this.addAction(_shieldAction);
			
			_sprite = a_img;
			
			initSounds();
			
			resetBlockedSections();
		}//end constructor()
		
		private function initSounds():void
		{
			_dartboardSoundController = new SoundController("dartboardSoundController");
			
			_dartboardSoundController.addSound( new SMSound( "noscore_1", "darthit_noscore1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "noscore_2", "darthit_noscore2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "noscore_3", "darthit_noscore3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "noscore_4", "darthit_noscore4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "opponent_single_1", "darthit_opponentsingle1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_single_2", "darthit_opponentsingle2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_single_3", "darthit_opponentsingle3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_single_4", "darthit_opponentsingle4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "opponent_double_1", "darthit_opponentdouble1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_double_2", "darthit_opponentdouble2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_double_3", "darthit_opponentdouble3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_double_4", "darthit_opponentdouble4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "opponent_triple_1", "darthit_opponenttriple1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_triple_2", "darthit_opponenttriple2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_triple_3", "darthit_opponenttriple3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_triple_4", "darthit_opponenttriple4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "opponent_bullring_1", "darthit_opponentbullring1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_bullring_2", "darthit_opponentbullring2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_bullring_3", "darthit_opponentbullring3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_bullring_4", "darthit_opponentbullring4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_1", "darthit_playerbullseye1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_2", "darthit_playerbullseye2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_3", "darthit_playerbullseye3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_4", "darthit_playerbullseye4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_single_1", "darthit_playersingle1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_single_2", "darthit_playersingle2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_single_3", "darthit_playersingle3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_single_4", "darthit_playersingle4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_double_1", "darthit_playerdouble1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_double_2", "darthit_playerdouble2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_double_3", "darthit_playerdouble3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_double_4", "darthit_playerdouble4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_triple_1", "darthit_playertriple1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_triple_2", "darthit_playertriple2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_triple_3", "darthit_playertriple3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_triple_4", "darthit_playertriple4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_bullring_1", "darthit_playerbullring1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullring_2", "darthit_playerbullring2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullring_3", "darthit_playerbullring3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullring_4", "darthit_playerbullring4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_1", "darthit_playerbullseye1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_2", "darthit_playerbullseye2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_3", "darthit_playerbullseye3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_4", "darthit_playerbullseye4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "noscore_critical_1", "darthit_noscore_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "noscore_critical_2", "darthit_noscore_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "noscore_critical_3", "darthit_noscore_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "noscore_critical_4", "darthit_noscore_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "opponent_single_critical_1", "darthit_opponentsingle_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_single_critical_2", "darthit_opponentsingle_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_single_critical_3", "darthit_opponentsingle_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_single_critical_4", "darthit_opponentsingle_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "opponent_double_critical_1", "darthit_opponentdouble_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_double_critical_2", "darthit_opponentdouble_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_double_critical_3", "darthit_opponentdouble_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_double_critical_4", "darthit_opponentdouble_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "opponent_triple_critical_1", "darthit_opponenttriple_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_triple_critical_2", "darthit_opponenttriple_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_triple_critical_3", "darthit_opponenttriple_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_triple_critical_4", "darthit_opponenttriple_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "opponent_bullring_critical_1", "darthit_opponentbullring_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_bullring_critical_2", "darthit_opponentbullring_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_bullring_critical_3", "darthit_opponentbullring_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_bullring_critical_4", "darthit_opponentbullring_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "opponent_bullseye_critical_1", "darthit_opponentbullseye_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_bullseye_critical_2", "darthit_opponentbullseye_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_bullseye_critical_3", "darthit_opponentbullseye_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "opponent_bullseye_critical_4", "darthit_opponentbullseye_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_single_critical_1", "darthit_playersingle_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_single_critical_2", "darthit_playersingle_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_single_critical_3", "darthit_playersingle_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_single_critical_4", "darthit_playersingle_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_double_critical_1", "darthit_playerdouble_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_double_critical_2", "darthit_playerdouble_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_double_critical_3", "darthit_playerdouble_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_double_critical_4", "darthit_playerdouble_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_triple_critical_1", "darthit_playertriple_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_triple_critical_2", "darthit_playertriple_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_triple_critical_3", "darthit_playertriple_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_triple_critical_4", "darthit_playertriple_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_bullring_critical_1", "darthit_playerbullring_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullring_critical_2", "darthit_playerbullring_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullring_critical_3", "darthit_playerbullring_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullring_critical_4", "darthit_playerbullring_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_critical_1", "darthit_playerbullseye_critical1_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_critical_2", "darthit_playerbullseye_critical2_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_critical_3", "darthit_playerbullseye_critical3_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "player_bullseye_critical_4", "darthit_playerbullseye_critical4_mp3" ) );
			
			_dartboardSoundController.addSound( new SMSound( "bounce_wall", "darthit_bouncewall_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "bounce_board", "darthit_bounceboard_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "shieldApply", "dartpower_shieldapply_mp3" ) );
			_dartboardSoundController.addSound( new SMSound( "shieldHit", "dartpower_shieldhit_mp3" ) );
			
			DartsGlobals.instance.soundManager.addSoundController(_dartboardSoundController);
		}//end initSounds()
		
		public function initModels():void
		{
			_boardMaterial = new MovieMaterial(_sprite);
			_boardMaterial.smooth = true;
			_boardMaterial.rect = new Rectangle( -175, -175, 350, 350 );
			
			_boardSprite = new Sprite3D(_boardMaterial, 192);
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
			
			return this.sprite.getChildByName(name) as Sprite;
		}//end getDartboardClip()
		
		public function getDistanceFromSection(a_x:Number, a_y:Number, a_points:Number, a_multiplier:Number):Number
		{
			var dist:Number = Number.POSITIVE_INFINITY;
			
			var p:Point = new Point( ( a_x / AppSettings.instance.dartboardScale ) * (_sprite.width / 2), ( -a_y / AppSettings.instance.dartboardScale ) * (_sprite.height / 2) );
			
			var clip:Sprite = this.getDartboardClip(a_points, a_multiplier);
			
			if ( clip ) 
			{			
				var clipScaledX:Number = (clip.x / (DartsGlobals.instance.gameManager.dartboard.boardSprite.width/2)) * AppSettings.instance.dartboardScale;
				var clipScaledY:Number = (clip.y / (DartsGlobals.instance.gameManager.dartboard.boardSprite.height/2)) * AppSettings.instance.dartboardScale;
				
				var dx:Number = p.x - clipScaledX;
				var dy:Number = p.y - clipScaledY;
				
				dist = Math.sqrt( dx * dx + dy * dy );
			}
			
			return dist;
		}
		
		public function submitDartPosition(a_x:Number, a_y:Number, a_block:Boolean):Boolean
		{				
			var p:Point = new Point( ( a_x / AppSettings.instance.dartboardScale ) * (_sprite.width/2), ( -a_y / AppSettings.instance.dartboardScale ) * (_sprite.height/2) );
			
			var objects:Array = _sprite.getObjectsUnderPoint(p);
			
			var points:int = 0;
			var multiplier:int = 0;
			var scoring:Boolean = false;
			var sticking:Boolean = false;
			
			if (objects.length > 0) {
		
				if (_pattern.test(objects[0].parent.name) && !_blockedSections[objects[0].parent.name]) 
				{
					var arr:Array = objects[0].parent.name.split("_");
					
					points = Number(arr[1]);
					multiplier = Number(arr[2]);
					
					playHitSound(DartsGlobals.instance.gameManager.currentPlayer, multiplier);
					
					scoring = DartsGlobals.instance.gameManager.scoreManager.submitThrow(DartsGlobals.instance.gameManager.currentPlayer, points, multiplier);					
									
					if (points > 0) 
					{
						var text:AnimatedText = new AnimatedText(points + " x " + multiplier, new CooperStd(), TweenMax.fromTo(null, 0.75, { x: p.x, y: p.y, alpha: 1 }, { x: p.x, y: p.y - 15, alpha: 0 } ));
						text.alpha = 0;
						_sprite.addChild(text);
						text.animate();					
					}
					
					if (a_block)
					{
						_dartboardSoundController.play("shieldApply");
						_shieldAction.startBlocking(points.toString());						
					}
					
					sticking = true;
				} else if ( _blockedSections[objects[0].parent.name] ) {
					_dartboardSoundController.play("shieldHit");
				} else {
					_dartboardSoundController.play("bounce_board");
				}
			} else {
				_dartboardSoundController.play("bounce_wall");
			}
			
			DartsGlobals.instance.gameManager.players[DartsGlobals.instance.gameManager.currentPlayer].processShotResult(points, multiplier, scoring);
			
			return sticking;			
		}//end submitDartPosition()
		
		private function playHitSound(a_player:int, multiplier:int):void
		{
			var version:int = Math.ceil(Math.random() * 4);
			
			var player:String = a_player == DartsGlobals.instance.localPlayer.playerNum ? "player" : "opponent";
			
			var score:String;
			if ( multiplier == 3 ) {
				score = "triple";
			} else if ( multiplier == 2 ) {
				score = "double";
			} else if ( multiplier == 1 ) {
				score = "single";
			} else {
				_dartboardSoundController.play("noscore_" + version.toString());
				return;
			}
			
			_dartboardSoundController.play(player + "_" + score + "_" + version.toString());
		}
		
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
			_blockedSections = new Object();
			
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
		
		public function get sprite():Sprite
		{
			return _sprite;
		}//end get sprite()
		
		public function get boardSprite():Sprite3D
		{
			return _boardSprite;
		}//end get boardSprite()
		
	}//end Dartboard

}//end com.bored.games.darts.objects