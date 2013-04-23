package pixelshop.tools {

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class ToolPicker extends Tool_Base {
		
		public function ToolPicker() {
			super();
			
			createIcon( "tool_picker" );
		}
		
		protected override function _mouseUpdate():void {
			super._mouseUpdate();
			
			var theColor:uint =	bitmap.getPixel(manager.currentX, manager.currentY);
			if(manager.isDownLMB) {
				manager.colorFore.color = theColor;
			} else if(manager.isDownRMB) {
				manager.colorBack.color = theColor;
			}
		}
	}
}