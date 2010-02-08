package com.bored.games.darts.threedee {
	/**
	 * ...
	 * @author sam
	 */
	public class Mesh3D
	{
		// original 3D object vertex data
		public var vertices3D:Vector.<Number>;
		
		// modified 3D vertex data (used for interactive transformations) 
		public var vertices3D2:Vector.<Number>;

		// projected 2D vertex data
		public var vertices2D:Vector.<Number>;

		// indexed face set
		public var indices:Vector.<int>;

		// texture uvt data (if needed)
		public var uvtData:Vector.<Number>;

		// constructor
		public function Mesh3D():* 
		{
			vertices3D=new Vector.<Number>();
			vertices3D2=new Vector.<Number>();
			vertices2D=new Vector.<Number>();
			indices=new Vector.<int>();
			uvtData=new Vector.<Number>();
		}// end constructor
		
	}//end class Mesh3D

}//end package com.bored.games.darts.threedee