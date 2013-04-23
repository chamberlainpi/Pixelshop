package pixelshop.tools {

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class ToolFill extends Tool_Base {
		
		public function ToolFill() {
			super();
			
			createIcon("tool_fill");
		}
		
		protected override function _mouseDown():void {
			super._mouseDown();
			
			var theColor:uint =	manager.isDownLMB ? manager.foregroundColor : manager.backgroundColor;
			this.bitmap.floodFill( manager.currentX, manager.currentY, theColor );
		}
	}
}