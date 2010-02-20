package com.bored.games.away3d.cameras
{
	import away3dlite.arcane;
	import away3dlite.cameras.TargetCamera3D;
	import away3dlite.core.base.*;
	import flash.geom.Vector3D;
	
	use namespace arcane;
	
	/**
	 * ...
	 * @author sam
	 */
	public class FollowCamera3D extends TargetCamera3D
	{
		/** @private */
        arcane override function update():void
		{
			if( target != null ) {
				var position:Vector3D = target.transform.matrix3D.position.add(new Vector3D(0, -distance/4, -distance));
				this.x = position.x;
				this.y = position.y;
				this.z = position.z;
			}
			
			super.update();
        }
		
		public var distance:Number;
		
		public function FollowCamera3D(zoom:Number = 10, focus:Number = 100, target:Object3D = null, distance:Number = 800) 
		{
			super(zoom, focus, target);
			
			this.distance = distance;
			
		}//end constructor()
		
	}//end FollowCamera3D

}//end com.bored.games.away3d.cameras