package pixelshop.tools {
	import com.bigp.utils.KeyAdvancedUtils;
	import com.bigp.utils.KeyUtils;
	import com.bit101.bigp.ButtonIcon;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import pixelshop.managers.MngTools;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Tool_Base {
		
		protected var _mouseMoveOnlyWhenDown:Boolean = true;
		protected var _containerProperties:Sprite;
		protected var _keys:KeyAdvancedUtils;
		protected var _icon:ButtonIcon;
		protected var _bounds:Rectangle;
		private var _isActive:Boolean = false;
		private var _cancelled:Boolean = false;
		
		public var lastX:int = 0;
		public var lastY:int = 0;
		
		public function Tool_Base() {
			_keys =			new KeyAdvancedUtils();
			_bounds =		new Rectangle();
			
			isActive = false;
		}
		
		public function createIcon( pImageName:String ):void {
			_icon = new ButtonIcon( null, 0, 0, pImageName );
			_icon.owner = this;
			
			_icon.isActive = _isActive;
		}
		
		public final function mouseDown():void {
			if (manager.isDownLMB && manager.isDownRMB) return;
			
			lastX = manager.currentX;
			lastY = manager.currentY;
			
			_bounds.left = lastX = manager.currentX;
			_bounds.top = lastY = manager.currentY;
			
			_bounds.right = _bounds.left + 1;
			_bounds.bottom = _bounds.top + 1;
			
			_mouseDown();
			_mouseUpdate();
			
			_cancelled = false;
		}
		
		public final function mouseUp():void {
			if (_cancelled) return;
			_createCommand();
			_mouseUp();
		}
		
		public final function mouseMove():void {
			if (_cancelled) return;
			if (_mouseMoveOnlyWhenDown) {
				if(!manager.isDownLMB && !manager.isDownRMB) return;
			}
			
			_mouseMove();
		}
		
		public final function mouseUpdate():void {
			if (_cancelled) return;
			if (_mouseMoveOnlyWhenDown) {
				if(!manager.isDownLMB && !manager.isDownRMB) return;
			}
			
			_mouseUpdate();
			inline_setBounds();
		}
		
		[Inline] private final function inline_setBounds():void {
			if (_bounds.left > manager.currentX) _bounds.left = manager.currentX;
			if (_bounds.right <= manager.currentX) _bounds.right = manager.currentX+1;
			
			if (_bounds.top > manager.currentY) _bounds.top = manager.currentY;
			if (_bounds.bottom <= manager.currentY) _bounds.bottom = manager.currentY+1;
		}
		
		public function cancel():void {
			_cancelled = true;
		}
		
		protected function _mouseDown():void {}
		protected function _mouseUp():void {}
		protected function _mouseMove():void { }
		protected function _mouseUpdate():void { }
		protected function _createCommand():void { }
		
		public function get manager():MngTools { return Registry.MAN_TOOLS; }
		public function get bitmap():BitmapData { return Registry.BMP_DRAW; }
		public function get icon():ButtonIcon { return _icon; }
		public function get containerProperties():Sprite { return _containerProperties; }
		
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void {
			_isActive = value;
			
			if (_icon) {
				_icon.isActive = value;
			}
		}
	}
}