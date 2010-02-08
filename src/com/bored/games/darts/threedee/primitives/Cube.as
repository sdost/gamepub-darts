package com.bored.games.darts.threedee.primitives 
{
	import com.bored.games.darts.threedee.Mesh3D;
	/**
	 * ...
	 * @author sam
	 */
	public class Cube extends Mesh3D
	{
		public function Cube() {
			super(  );
	 
			addVertex(  1.000000, -1.000000,  1.000000 );
			addVertex(  1.000000, -1.000000, -1.000000 );
			addVertex( -1.000000, -1.000000, -1.000000 );
			addVertex( -1.000000, -1.000000,  1.000000 );
			addVertex(  1.000000,  1.000000,  1.000000 );
			addVertex(  1.000000,  1.000000, -1.000000 );
			addVertex( -1.000000,  1.000000, -1.000000 );
			addVertex( -1.000000,  1.000000,  1.000000 );

			addTriangles(0,1,2,3);
			addTriangles(4,7,6,5);
			addTriangles(0,4,5,1);
			addTriangles(1,5,6,2);
			addTriangles(2,6,7,3);
			addTriangles(4,0,3,7);
		}//end constructor()

		// adding a vertex to our vertex data
		public function addVertex(x:Number, y:Number, z:Number):void {
			 vertices3D.push(x, y, z);

			// initialize vertices2D and uvtData with some values 
			 vertices2D.push(0, 0, 0); 
			 uvtData.push(1, 0, 0); 
		}//end addVertex();

		// adding two triangle faces per rectangle
		public function addTriangles(index0:Number, index1:Number, index2:Number, index3:Number):void {
			// first triangle 
			indices.push(index3, index1, index0);

			// second triangle 
			indices.push(index3, index2, index1);
		}//end addTriangles()
		
	}//end class Cube

}//end package com.bored.games.darts.3d.primitives