package pixelshop.imagebytes {

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class PixelLayer extends Layer_Base {
		public var pixels:PixelBytes;
		
		public function PixelLayer(pName:String, pPixelBytes:PixelBytes) {
			super(pName);
			
			pixels = pPixelBytes;
		}
		
		public override function dispose():void {
			super.dispose();
			
			pixels.destroy();
		}
		
		public function get ownerMulti():MultiLayer { return owner as MultiLayer; }
		public function get index():int { return owner._layers.indexOf(this); }
	}
}