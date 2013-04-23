package pixelshop.tools {
	import com.bigp.utils.KeyAdvancedUtils;
	import com.bigp.utils.KeyUtils;
	import com.bit101.bigp.ButtonIcon;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import pixelshop.managers.MngTools;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Tool_Base {
		
		protected var _mouseMoveOnlyWhenDown:Boolean = true;
		
		protected var _keys:KeyAdvancedUtils;
		protected var _icon:ButtonIcon;
		protected var _containerProperties:Sprite;
		
		private var _isActive:Boolean = false;
		private var _cancelled:Boolean = false;
		
		
		public function Tool_Base() {
			_keys = new KeyAdvancedUtils();
			
			isActive = false;
		}
		
		public function createIcon( pImageName:String ):void {
			_icon = new ButtonIcon( null, 0, 0, pImageName );
			_icon.owner = this;
			
			_icon.isActive = _isActive;
		}
		
		public final function mouseDown():void {
			if (manager.isDownLMB && manager.isDownRMB) return;
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
		public function get bitmap():BitmapData { return Registry.LAYER_DRAW.bitmap; }
		
		public function get icon():ButtonIcon { return _icon; }
		
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void {
			_isActive = value;
			
			if (_icon) {
				_icon.isActive = value;
			}
		}
		
		public function get containerProperties():Sprite { return _containerProperties; }
	}
}