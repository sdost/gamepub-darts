package com.bored.games.threedee.primitives 
{
	import com.bored.games.threedee.Mesh3D;
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

			addTriangles(0, 1, 2, 3);
			addTriangles(4, 7, 6, 5);
			addTriangles(0, 4, 5, 1);
			addTriangles(1, 5, 6, 2);
			addTriangles(2, 6, 7, 3);
			addTriangles(4, 0, 3, 7);
			
			addTCoords( 0.000000, 0.000000 );
			addTCoords( 1.000000, 0.000000 );
			addTCoords( 1.000000, 0.000000 );
			addTCoords( 0.000000, 0.000000 );
			addTCoords( 0.000000, 1.000000 );
			addTCoords( 1.000000, 1.000000 );
			addTCoords( 1.000000, 1.000000 );
			addTCoords( 0.000000, 1.000000 );
		}//end constructor()

		// adding a vertex to our vertex data
		private function addVertex(x:Number, y:Number, z:Number):void 
		{
			 _vertices.push(x, y, z);

			// initialize vertices2D and uvtData with some values 
			 _projVertices.push(0, 0);
		}//end addVertex();

		// adding two triangle faces per rectangle
		private function addTriangles(index0:Number, index1:Number, index2:Number, index3:Number):void 
		{
			// first triangle 
			_indices.push(index3, index1, index0);

			// second triangle 
			_indices.push(index3, index2, index1);
		}//end addTriangles()
		
		private function addTCoords(t0:Number, t1:Number):void 
		{
			_uvtData.push(t0, t1, 0.000000);
		}//end addTCoords()
		
	}//end class Cube

}//end package com.bored.games.darts.3d.primitives