package com.bored.games.darts.ui.store 
{
	import com.bored.games.darts.abilities.Ability;
	import com.bored.games.darts.assets.hud.PowerSlot_MC;
	import com.bored.services.StoreItem;
	
	/**
	 * ...
	 * @author sam
	 */
	public class PowerStoreItem extends StoreItem
	{
		public function PowerStoreItem( a_iconClass:Class, a_name:String, a_abilityRef:Ability, a_id:String, a_price:int ) 
		{
			super();
			
			this.storeIcon = new PowerSlot_MC();
			var icon:MovieClip = new a_iconClass();
			icon.width = icon.height = 70;
			(_powerSlot.getChildByName("ability_mc") as MovieClip).addChild(icon);
			(_powerSlot.getChildByName("ability_text") as TextField).text = a_name;
			(_powerSlot.getChildByName("abilityPowerGauge_mc") as MovieClip).gotoAndStop(10 - a_abilityRef.refreshTime + 1);
			
			this.id = a_id;
			this.price = a_price;
		}//end constructor()
		
		
		
	}//end PowerStoreItem

}//end package