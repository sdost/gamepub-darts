package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.assets.icons.BigBill_Portrait_BMP;
	import com.bored.games.darts.assets.icons.Sammy_Portrait_BMP;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class BigBillProfile extends EnemyProfile
	{
		
		public function BigBillProfile() 
		{
			super("Big Bill");
			
			this.age = 32;
			this.height = 105;
			this.weight = 90;
			this.bio = "A big guy with a big ego, and a big temper.";
			
			this.portrait = new BigBill_Portrait_BMP(150, 150);
			
			this.setDartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_bigbill", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight));
			
			this.accuracy = 0.7;
		}//end constructor()
	}//end BigBillProfile
		

}//end com.bored.games.darts.profiles