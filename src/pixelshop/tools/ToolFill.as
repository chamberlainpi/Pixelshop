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
			Registry.BMP_CURRENT.floodFill( manager.currentX, manager.currentY, theColor );
			Registry.MAN_LAYERS.multilayer.commitCurrent();
			///////// TODO OMG OMG REALLY AGAIN???
			
			
			//Registry.LAYER_DRAW.invalidate();
		}
	}
}