package pixelshop.imagebytes {

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Layer_Base {
		public var name:String;
		public var referenceID:int;
		public var owner:LayerSystem;
		
		public function Layer_Base(pName:String) {
			name = pName;
		}
		
		public function init():void { }
		public function dispose():void { name = null }
		public function selected():void { }
		public function deselected():void { }
	}
}