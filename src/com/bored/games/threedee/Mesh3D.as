package com.bored.games.threedee {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shader;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.display.TriangleCulling;
	import flash.geom.Utils3D;
	/**
	 * ...
	 * @author sam
	 */
	public class Mesh3D
	{
		// original 3D object vertex data
		protected var _vertices:Vector.<Number>;
		
		// modified 3D vertex data (used for interactive transformations) 
		protected var _transformedVertices:Vector.<Number>;

		// projected 2D vertex data
		protected var _projVertices:Vector.<Number>;

		// indexed face set
		protected var _indices:Vector.<int>;

		// texture uvt data (if needed)
		protected var _uvtData:Vector.<Number>;

		// constructor
		public function Mesh3D():* 
		{
			_vertices = new Vector.<Number>();
			_transformedVertices = new Vector.<Number>();
			_projVertices = new Vector.<Number>();
			_indices = new Vector.<int>();
			_uvtData = new Vector.<Number>();
		}// end constructor
		
		public function applyTransform(a_trans:Matrix3D):void
		{
			a_trans.transformVectors(_vertices, _transformedVertices);
		}//end applyTransform()
		
		public function renderColorFill(a_persp:PerspectiveProjection, a_graphics:Graphics, a_color:Number):void
		{			
			Utils3D.projectVectors(a_persp.toMatrix3D(), _transformedVertices, _projVertices, _uvtData);
			
			a_graphics.beginFill(a_color);
			a_graphics.drawTriangles(_projVertices, _indices, null, TriangleCulling.NONE);
			a_graphics.endFill();
		}//end render()
		
		public function renderBitmapFill(a_persp:PerspectiveProjection, a_graphics:Graphics, a_bmp:BitmapData):void
		{
			Utils3D.projectVectors(a_persp.toMatrix3D(), _transformedVertices, _projVertices, _uvtData);
			
			a_graphics.beginBitmapFill(a_bmp);
			
			//trace("Projects Matrices: " + _projVertices.toString());
			//trace("Indices: " + _indices.toString());
			//trace("UV Data: " + _uvtData.toString());
			
			a_graphics.drawTriangles(_projVertices, _indices, _uvtData, TriangleCulling.NONE);
			a_graphics.endFill();
		}//end renderBitmapFill()
		
		public function renderPixelBenderFill(a_persp:PerspectiveProjection, a_graphics:Graphics, a_pb:Shader, a_matrix:Matrix = null):void
		{
			Utils3D.projectVectors(a_persp.toMatrix3D(), _transformedVertices, _projVertices, _uvtData);
			
			a_graphics.beginShaderFill(a_pb, a_matrix);
			a_graphics.drawTriangles(_projVertices, _indices, _uvtData, TriangleCulling.NONE);
			a_graphics.endFill();
		}//end renderPixelBenderFill()
		
	}//end class Mesh3D

}//end package com.bored.games.darts.threedee