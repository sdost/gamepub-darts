package away3dlite.core
{
	import away3dlite.core.IDestroyable;

	public class Destroyable implements IDestroyable
	{
		protected var _isDestroyed:Boolean;

		public function Destroyable()
		{
			
		}

		public function get destroyed():Boolean
		{
			return this._isDestroyed;
		}

		public function destroy():void
		{
			this._isDestroyed = true;
		}
	}
}