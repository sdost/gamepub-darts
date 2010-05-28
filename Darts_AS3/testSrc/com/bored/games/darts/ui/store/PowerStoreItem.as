package com.bored.games.darts.ui.store 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.assets.hud.PowerSlot_MC;
	import com.bored.games.darts.DartsGlobals;
	import com.bored.services.StoreItem;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author sam
	 */
	public class PowerStoreItem extends StoreItem
	{
		private var _abilityRef:Ability;
		
		public function PowerStoreItem( a_iconClass:Class, a_name:String, a_abilityRef:Ability, a_id:String, a_price:int ) 
		{
			super();
			
			_abilityRef = a_abilityRef;
			
			_itemStoreIcon = new PowerSlot_MC();
			var icon:MovieClip = new a_iconClass();
			icon.width = icon.height = 70;
			((_itemStoreIcon as MovieClip).getChildByName("ability_mc") as MovieClip).addChild(icon);
			((_itemStoreIcon as MovieClip).getChildByName("ability_text") as TextField).text = a_name;
			((_itemStoreIcon as MovieClip).getChildByName("abilityPowerGauge_mc") as MovieClip).gotoAndStop(10 - this.abilityRef.refreshTime + 1);
			
			this.id = a_id;
			this.price = a_price;
		}//end constructor()
		
		public function get abilityRef():Ability
		{
			return _abilityRef;
		}//end get abilityRef()
		
		override public function doPurchase():Boolean
		{
			var obj:Object = DartsGlobals.instance.externalServices.getData("powerLevels");
			
			var powerObj:Object = obj[this.id];
			if ( powerObj == null ) 
			{
				powerObj = 
				{
					refreshTime: 10,
					name: this.abilityRef.name
				};
			}
			powerObj.refreshTime--;
			if ( powerObj.refreshTime < 0 ) 
			{
				powerObj.refreshTime == 0;
				return false;
			}
			
			obj[this.id] = powerObj;
			
			for ( var key:String in obj )
			{
				trace("obj[" + key + "] -> " + obj[key]);
			}
			
			DartsGlobals.instance.externalServices.setData("powerLevels", obj);
			
			this.abilityRef.refreshTime = powerObj.refreshTime;
			
			((_itemStoreIcon as MovieClip).getChildByName("abilityPowerGauge_mc") as MovieClip).gotoAndStop(10 - this.abilityRef.refreshTime + 1);
			
			return true;
		}//end doPurchase()
		
	}//end PowerStoreItem

}//end package