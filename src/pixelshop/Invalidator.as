package pixelshop {
	import org.osflash.signals.Signal;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Invalidator {
		
		private var _isDirty:Boolean = false;
		private var _whenInvalidating:Signal;
		private var _whenInvalidateExternal:Signal;
		
		public var args:Array;
		
		public function Invalidator( pInvalidateExternalSignal:Signal, pFunc:Function=null ) {
			_whenInvalidating = new Signal();
			_whenInvalidating.add( pFunc );
			_whenInvalidateExternal = pInvalidateExternalSignal;
			
			invalidate();
		}
		
		public function destroy():void {
			_whenInvalidating = null;
			_whenInvalidateExternal = null;
		}
		
		public function invalidate():void {
			if (_isDirty) return;
			_isDirty = true;
			_whenInvalidateExternal.addOnce( this.validate );
		}
		
		private function validate():void {
			if (!_isDirty) return;
			_isDirty = false;
			if(args) _whenInvalidating.dispatch(args);
			else	 _whenInvalidating.dispatch();
		}
	}
}