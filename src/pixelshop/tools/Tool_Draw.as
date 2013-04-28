package pixelshop.tools {
	import com.bigp.Lib;
	import com.bigp.utils.enums.Direction;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Tool_Draw extends Tool_Base {
		
		private var _straight:Boolean = false;
		private var _straightValue:int = 0;
		private var _straightSide:int = 0;
		
		public function Tool_Draw() {
			super();
			
		}
		
		protected override function _mouseDown():void {
			super._mouseDown();
			
			_straight = Lib.KEYS.isSHIFT;
			_straightSide = 0;
			
			if (!Registry.BMP_DRAW ) throw new Error("Missing drawing-layer!");
			
			Registry.DRAW_LIB.setBitmapData( Registry.BMP_DRAW );
		}
		
		protected override function _mouseUp():void {
			super._mouseUp();
			
			_straight = false;
			_straightSide = 0;
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
			
			manager.currentX = theX;
			manager.currentY = theY;
			
			_customDraw( theX, theY );
			Registry.RENDER_VALIDATOR.invalidate();
			
			lastX = theX;
			lastY = theY;
		}
		
		protected function _customDraw( pNowX:int, pNowY:int ):void {
			//OVERRIDE (in Pencil, Erase, etc.
		}
	}
}