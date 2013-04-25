package {
	import com.bigp.Lib;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Test_Base extends Sprite {
		public var isMouseDown:Boolean = false;
		
		public function Test_Base() {
			super();
			
			stage ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void {
			e && removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.ENTER_FRAME, __onUpdate);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, __onMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, __onMouse);
			
			Lib.init(stage);
			//Lib.initInfo();
			
			_begin();
		}
		
		private function __onMouse(e:MouseEvent):void {
			isMouseDown = e.type == MouseEvent.MOUSE_DOWN;
			isMouseDown ? _mouseDown() : _mouseUp();
		}
		
		private function __onUpdate(e:Event):void { _update(); }
		
		public function _update():void {}
		public function _mouseDown():void {}
		public function _mouseUp():void {}
		public function _begin():void {}
	}
}