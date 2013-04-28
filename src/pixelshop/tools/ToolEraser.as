package pixelshop.tools {
	import pixelshop.commands.CommandDraw;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class ToolEraser extends Tool_Draw {
		
		public function ToolEraser() {
			super();
			
			createIcon( "tool_eraser" );
		}
		
		protected override function _mouseDown():void {
			super._mouseDown();
			
			Registry.MAN_LAYERS.multilayer.copyCurrentToDraw();
		}
		
		protected override function _createCommand():void {
			super._createCommand();
			
			var cmd:CommandDraw =	CommandDraw.create( Registry.BMP_CURRENT, Registry.BMP_DRAW, _bounds );
			
			//CLEAR the drawing layer:
			Registry.BMP_DRAW.fillRect(Registry.BMP_DRAW.rect, 0);
			
			if (!cmd) return;
			Registry.MAN_UNDO.add( cmd );
		}
		
		//TODO P200 - Restrict drawing to current Selection
		
		protected override function _customDraw(pNowX:int, pNowY:int):void {
			Registry.DRAW_LIB.drawLine( lastX, lastY, pNowX, pNowY, manager.currentColor, 128 );
		}
	}
}