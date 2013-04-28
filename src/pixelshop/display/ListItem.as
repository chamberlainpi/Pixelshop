package pixelshop.display {
	import flash.display.Sprite;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class ListItem extends Sprite {
		
		public var owner:Object;
		
		public function ListItem() {
			super();
			
		}
		
		public function destroy():void {
			if (owner) owner = null;
			if (parent) parent.removeChild(this);
		}
	}
}