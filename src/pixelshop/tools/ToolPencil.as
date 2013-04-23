package pixelshop.tools {
	import bigp.mathlib.DrawLib;
	import bigp.mathlib.PixelBytes;
	import com.bigp.Lib;
	import com.bigp.utils.enums.Direction;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import pixelshop.commands.CommandDraw;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class ToolPencil extends Tool_Base {
		
		public var lastX:int = 0;
		public var lastY:int = 0;
		
		private var _straight:Boolean = false;
		private var _straightValue:int;
		private var _straightSide:int;
		
		public function ToolPencil() {
			super();
			
			createIcon( "tool_pencil" );
			_keys.bind(Keyboard.SPACE, onSpaceDown);
		}
		
		private function onSpaceDown():void {
			manager.colorFore.color = 0xff000000 | Math.random() * 0xffffff;
		}
		
		protected override function _mouseDown():void {
			super._mouseDown();
			
			lastX = manager.currentX;
			lastY = manager.currentY;
			
			_straight = Lib.KEYS.isSHIFT;
			_straightSide = 0;
			
			Registry.DRAW_LIB.setBitmapData( Registry.LAYER_DRAW.bitmap );
		}
		
		protected override function _mouseUp():void {
			super._mouseUp();
			
			_straight = false;
			_straightSide = 0;
			
			Registry.LAYER_DRAW.clear();
		}
		
		protected override function _createCommand():void {
			super._createCommand();
			
			var cmd:CommandDraw =	CommandDraw.create( Registry.LAYER_CURRENT.bitmap, Registry.LAYER_DRAW.bitmap );
			
			Registry.MAN_UNDO.add( cmd );
		}
		
		//TODO P200 - Restrict drawing to current Selection
		
		protected override function _mouseUpdate():void {
			super._mouseUpdate();
			
			if (!Registry.CAN_DRAW || (!manager.isDownLMB && !manager.isDownRMB)) {
				lastX = manager.currentX;
				lastY = manager.currentY;
				return;
			}
			
			
			var theX:int = manager.currentX;
			var theY:int = manager.currentY;
			
			if (_straight) {
				if (_straightSide == 0) {
					if (lastX != manager.currentX) {
						_straightSide = Direction.AXIS_HORIZONTAL;
						_straightValue = lastY;
					} else if (lastY != manager.currentY) {
						_straightSide = Direction.AXIS_VERTICAL;
						_straightValue = lastX;
					}
				}
				
				if (_straightSide == Direction.AXIS_HORIZONTAL) {
					theY = _straightValue;
				} else if (_straightSide == Direction.AXIS_VERTICAL) {
					theX = _straightValue;
				}
			}
			
			Registry.DRAW_LIB.drawLine( lastX, lastY, theX, theY, manager.currentColor, 128 );
			
			lastX = theX;
			lastY = theY;
		}
	}
}