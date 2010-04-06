package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.assets.icons.Sammy_Portrait_BMP;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SammyProfile extends EnemyProfile
	{
		
		public function SammyProfile() 
		{
			super("Sammy");
			
			this.age = 32;
			this.height = 105;
			this.weight = 90;
			this.bio = "Crazy drunk!";
			
			this.portrait = new Sammy_Portrait_BMP(150, 150);
			
			this.setDartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_sammy", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight));
			
			this.accuracy = 0.1;
		}//end constructor()
	}//end SammyProfile
		

}//end com.bored.games.darts.profiles