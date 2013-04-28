package pixelshop.tools {
	import com.bigp.utils.BitmapUtils;
	import pixelshop.commands.CommandDraw;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class ToolPencil extends Tool_Draw {
		
		public function ToolPencil() {
			super();
			
			createIcon( "tool_pencil" );
		}
		
		protected override function _createCommand():void {
			super._createCommand();
			
			var cmd:CommandDraw =	CommandDraw.create( Registry.BMP_CURRENT, Registry.BMP_DRAW );
			
			if (!cmd) return;
			Registry.MAN_UNDO.add( cmd );
		}
		
		//TODO P200 - Restrict drawing to current Selection
		
		protected override function _customDraw(pNowX:int, pNowY:int):void {
			Registry.DRAW_LIB.drawLine( lastX, lastY, pNowX, pNowY, manager.currentColor, 128 );
		}
	}
}