package pixelshop.tools {
	import com.bigp.utils.enums.Direction;
	import com.bit101.bigp.ButtonIcon;
	import com.bit101.bigp.Parser;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class ToolShape extends Tool_Base {
		
		public var shapeTypeLabel:Label;
		public var shapeTypeSquare:ButtonIcon;
		public var shapeTypeTriangle:ButtonIcon;
		public var shapeTypeCircle:ButtonIcon;
		
		public var shapeAll:Array;
		public var mode:Function;
		
		private var _currentShape:ButtonIcon;
		private var _lastX:int = 0;
		private var _lastY:int = 0;
		private var _mode:Function;
		
		public function ToolShape() {
			super();
			
			createIcon("tool_shape");
			
			_containerProperties =	new Sprite();
			_containerProperties.y = -1;
			shapeTypeLabel = new Label(_containerProperties, 0, 0, "shape type:");
			var json:Object = {
				direction: Direction.AXIS_HORIZONTAL,
				gap: 2,
				children: [
					{type: Label, text: "shape type:", ref: "shapeTypeLabel", width: 50 },
					{type: ButtonIcon, iconName: "icon_shape_square", defaultHandler: onShapeSelect, ref: "shapeTypeSquare", click: ["mode", modeSquare]},
					{type: ButtonIcon, iconName: "icon_shape_tri", defaultHandler: onShapeSelect, ref: "shapeTypeTriangle", click: ["mode", modeTriangle]},
					{type: ButtonIcon, iconName: "icon_shape_circle", defaultHandler: onShapeSelect, ref: "shapeTypeCircle", click: ["mode", modeCircle]}
				]
			};
			
			Parser.create( json, _containerProperties, this );
			
			shapeAll = [shapeTypeSquare, shapeTypeTriangle, shapeTypeCircle];
			shapeTypeSquare.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function onShapeSelect(e:MouseEvent=null):void {
			selectShape(  e.target as ButtonIcon );
		}
		
		private function selectShape(button:ButtonIcon):void {
			if (!_currentShape) {
				for (var a:int=0, aLen:int=shapeAll.length; a<aLen; a++) {
					var theChild:ButtonIcon = shapeAll[a];
					theChild.isActive = false;
				}
			} else {
				_currentShape.isActive = false;
			}
			
			_currentShape = button;
			_currentShape.isActive = true;
		}
		
		protected override function _mouseDown():void {
			super._mouseDown();
			
			if (mode == null) return;
			
			_mode = mode;
			
			_lastX = manager.currentX;
			_lastY = manager.currentY;
		}
		
		protected override function _mouseUpdate():void {
			super._mouseUpdate();
			
			if (mode == null || _mode != mode) return;
			
			mode();
		}
		
		private function modeSquare():void {
			trace("Drawing square...");
			//TODO P100 - draw square mode...
		}
		
		private function modeTriangle():void {
			trace("Drawing tri...");
			//TODO P100 - draw triangle mode...
		}
		
		private function modeCircle():void {
			trace("Drawing circ...");
			//TODO P100 - draw circle mode...
		}
	}
}