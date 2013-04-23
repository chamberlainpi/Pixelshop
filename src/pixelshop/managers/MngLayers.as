package pixelshop.managers {
	import pixelshop.PixelLayer;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngLayers extends Manager_Base {
		
		private var _layers:Vector.<PixelLayer>;
		
		public function MngLayers() {
			super();
			
			
		}
		
		public override function init():void {
			super.init();
		}
		
		//TODO P100 - Create a Layer Management System (will require several bitmaps / bytearrays) and clever lock/unlock.
		protected override function onNewDocument():void {
			super.onNewDocument();
			
			if (_layers) {
				_layers
			}
		}
	}
}