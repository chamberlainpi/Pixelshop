package pixelshop.managers {
	import pixelshop.imagebytes.MultiLayer;
	import starling.extensions.bigp.BitmapImage;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngLayers extends Manager_Panel {
		
		private var _multilayer:MultiLayer;
		
		public function MngLayers() {
			super();
			
			createPanel(0, 20, 100, 100);
		}
		
		public override function init():void {
			super.init();
		}
		
		//TODO P100 - Create a Layer Management System (will require several bitmaps / bytearrays) and clever lock/unlock.
		protected override function onNewDocument():void {
			super.onNewDocument();
			
			if (_multilayer) {
				_multilayer.destroy();
				_multilayer = null;
			}
			
			_multilayer = new MultiLayer( Registry.DOC_WIDTH, Registry.DOC_HEIGHT );
		}
		
		public function frameNext():void {}
		public function framePrev():void {}
		public function layerNext():void {}
		public function layerPrev():void {}
		
		public function get multilayer():MultiLayer { return _multilayer; }
	}
}