package com.bored.games.math 
{
	/**
	 * ...
	 * @author sam
	 */
	public class CartesianCoord
	{
		protected var _x:Number, _y:Number;		
		
		public function CartesianCoord(a_x:Number = 0, a_y:Number = 0)
		{
			_x = a_x;
			_y = a_y;
		}//end constructor()
		
		public function get x():Number
		{
			return _x;
		}//end x()
		
		public function get y():Number
		{
			return _y;
		}//end y()
		
		public function setCoords(...args:Array):void
		{
			var argc:int = args.length;
			
			try{
				if (argc == 1) {
					var coords:CartesianCoord = (args[0] as CartesianCoord);
					_x = coords.x;
					_y = coords.y;
				} else if (argc == 2) {
					_x = Number(args[0]);
					_y = Number(args[1]);
				} else throw new Error();
			} catch (e:Error) {
				throw new ArgumentError("Illegal method signiture. Use setCoords(CartesianCoord) or setCoords(Number, Number).");
			}
		}//end setCoords()
		
	}//end CartesianCoord

}//end com.bored.games.math