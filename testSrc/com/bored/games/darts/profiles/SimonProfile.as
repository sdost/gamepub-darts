package com.bored.games.darts.profiles 
{
	import com.bored.games.darts.assets.icons.Simon_Portrait_BMP;
	import com.bored.games.darts.profiles.EnemyProfile;
	import com.sven.utils.ImageFactory;
	import com.sven.utils.AppSettings;
	
	/**
	 * ...
	 * @author sam
	 */
	public class SimonProfile extends EnemyProfile
	{
		
		public function SimonProfile() 
		{
			super("Simon");
			
			this.age = 22;
			this.height = 185;
			this.weight = 70;
			this.bio = "Some dude";
			
			this.portrait = new Simon_Portrait_BMP(150, 150);
			
			this.setDartSkin(ImageFactory.getBitmapDataByQualifiedName("dartuv_simon", AppSettings.instance.dartTextureWidth, AppSettings.instance.dartTextureHeight));
			
			this.accuracy = 0.2;
		}//end constructor()
		
	}//end SimonProfile

}//end com.bored.games.darts.profiles