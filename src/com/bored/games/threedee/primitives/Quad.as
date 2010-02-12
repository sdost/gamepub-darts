package com.bored.games.threedee.primitives 
{
	import com.bored.games.threedee.Mesh3D;
	/**
	 * ...
	 * @author sam
	 */
	public class Quad extends Mesh3D
	{
		public function Quad() {
			super(  );
	 
			addVertex( -1.000000, -1.000000 );
			addVertex(  1.000000, -1.000000 );
			addVertex(  1.000000,  1.000000 );
			addVertex( -1.000000,  1.000000 );
			
			addTriangles(0, 1, 2, 3);
			
			addTCoords( 0.000000, 0.000000 );
			addTCoords( 1.000000, 0.000000 );
			addTCoords( 1.000000, 1.000000 );
			addTCoords( 0.000000, 1.000000 );
		}//end constructor()

		// adding a vertex to our vertex data
		private function addVertex(x:Number, y:Number):void {
			 _vertices.push(x, y, 0.000000);

			// initialize vertices2D and uvtData with some values 
			 _projVertices.push(0, 0);
		}//end addVertex();

		// adding two triangle faces per rectangle
		private function addTriangles(index0:Number, index1:Number, index2:Number, index3:Number):void {
			// first triangle 
			_indices.push(index0, index1, index3);

			// second triangle 
			_indices.push(index1, index2, index3);
		}//end addTriangles()
		
		private function addTCoords(t0:Number, t1:Number):void {
			_uvtData.push(t0, t1, 0.000000);
		}//end addTCoords()
		
	}//end class Cube

}//end package com.bored.games.darts.3d.primitives