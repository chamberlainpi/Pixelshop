package pixelshop.managers {
	import com.bit101.components.Panel;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Manager_Panel extends Manager_Base {
		
		protected var _panel:Panel;
		protected var _width:int = 0;
		protected var _height:int = 0;
		
		public function Manager_Panel() {
			super();
			
		}
		
		public function createPanel(pX:int, pY:int, pWidth:int, pHeight:int):void {
			_panel = new Panel(null, pX, pY);
			_panel.setSize( _width = pWidth, _height = pHeight );
			
		}
	}
}