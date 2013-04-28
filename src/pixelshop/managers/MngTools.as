package pixelshop.managers {
	import com.bigp.Lib;
	import com.bigp.utils.MathUtils;
	import com.bigp.utils.TimerUtils;
	import com.bit101.bigp.ButtonIcon;
	import com.bit101.bigp.ColorSwatch;
	import com.bit101.components.Style;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import pixelshop.GridCanvas;
	import pixelshop.tools.Tool_Base;
	import pixelshop.tools.ToolEraser;
	import pixelshop.tools.ToolFill;
	import pixelshop.tools.ToolPencil;
	import pixelshop.tools.ToolPicker;
	import pixelshop.tools.ToolSelect;
	import pixelshop.tools.ToolShape;
	import starling.display.Sprite;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngTools extends Manager_Panel {
		
		private var _currentTool:Tool_Base;
		private var _currentPos:Point;
		private var _mousePos:Point;
		private var _tools:Dictionary;
		
		public var currentX:int;
		public var currentY:int;
		
		public var colorFore:ColorSwatch;
		public var colorBack:ColorSwatch;
		public var opacity:int =	0xff;
		
		public var isDownLMB:Boolean = false;
		public var isDownRMB:Boolean = false;
		
		public var recentlyChanged:Boolean = false;
		
		public function MngTools() {
			super();
			_mousePos =		new Point();
			_currentPos =	new Point();
			_tools =		new Dictionary();
			
			createPanel(3, 25, 41, 120);
			
			colorFore = new ColorSwatch(_panel, 1, _height - 40, "FG:", 0x000000);
			colorBack = new ColorSwatch(_panel, 1, _height - 20, "BG:", 0xffffff);
		}
		
		public override function init():void {
			super.init();
			
			Lib.STAGE.addChildAt( _panel, 1 );
			Lib.STAGE.addEventListener(Event.DEACTIVATE, onAction);
			
			Registry.WORKSPACE.clickableSprite.addEventListener(MouseEvent.MOUSE_UP, onAction);
			Registry.WORKSPACE.clickableSprite.addEventListener(MouseEvent.MOUSE_DOWN, onAction);
			Registry.WORKSPACE.clickableSprite.addEventListener(MouseEvent.MOUSE_MOVE, onAction);
			Registry.WORKSPACE.clickableSprite.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onAction);
			Registry.WORKSPACE.clickableSprite.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onAction);
			Registry.WORKSPACE.clickableSprite.addEventListener(Event.ENTER_FRAME, onAction);
			
			addTool( getByType(ToolPencil) );
			addTool( getByType(ToolSelect) );
			addTool( getByType(ToolShape) );
			addTool( getByType(ToolFill) );
			addTool( getByType(ToolPicker) );
			addTool( getByType(ToolEraser) );
			
			draw();
			
			currentTool = getByType(ToolPencil);
		}
		
		public function getByType(pType:Class):Tool_Base {
			var tool:Tool_Base = _tools[pType];
			if (!tool) {
				tool = new pType();
				_tools[pType] = tool;
			}
			
			return tool;
		}
		
		public function addTool( pTool:Tool_Base ):void {
			_panel.addChild(pTool.icon);
			pTool.icon.addEventListener(MouseEvent.MOUSE_DOWN, onClick);
		}
		
		private function onClick(e:MouseEvent):void {
			e.stopImmediatePropagation();
			e.stopPropagation();
			e.preventDefault();
			
			Registry.MAN_TOOLS.currentTool.cancel();
			
			var icon:ButtonIcon = e.target as ButtonIcon;
			currentTool = icon.owner as Tool_Base;
		}
		
		public function draw():void {
			_panel.color = Style.BACKGROUND;
			
			var counter:int = 0;
			for (var n:int=0, nLen:int=_panel.content.numChildren; n<nLen; n++) {
				var theIcon:ButtonIcon = _panel.content.getChildAt(n) as ButtonIcon;
				if (!theIcon) continue;
				theIcon.x =	1 + (counter % 2) * (theIcon.width + 2);
				theIcon.y = 1 + int(counter / 2) * (theIcon.height + 2);
				
				counter++;
			}
		}
		
		private function onAction(e:Event):void {
			var theContent:Sprite =	Registry.WORKSPACE.content;
			var theCanvas:GridCanvas = Registry.GRID_CANVAS;
			
			if (!_currentTool || !Registry.CAN_DRAW) {
				return;
			}
			
			var mouseX:int =	(Lib.STAGE.mouseX - theContent.x - Registry.WORKSPACE.x) / theContent.scaleX;
			var mouseY:int =	(Lib.STAGE.mouseY - theContent.y - Registry.WORKSPACE.y) / theContent.scaleY;
			
			//trace(mouseX + " : " + mouseY);
			
			var edgeLimit:int =	2;
			var isOut:Boolean = mouseX < -edgeLimit || mouseX > (Registry.DOC_WIDTH + edgeLimit) ||
								mouseY < -edgeLimit || mouseY > (Registry.DOC_HEIGHT + edgeLimit)
			
			//TODO Why is theCanvas.width / .height 0 : 0 ???
			
			
			currentX = MathUtils.clamp(mouseX, 0, Registry.DOC_WIDTH);
			currentY = MathUtils.clamp(mouseY, 0, Registry.DOC_HEIGHT);
			
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:			if (isOut) return; isDownLMB = true; _currentTool.mouseDown(); break;
				case MouseEvent.MOUSE_UP:			isDownLMB = false; _currentTool.mouseUp(); break;
				case MouseEvent.RIGHT_MOUSE_DOWN:	if (isOut) return; isDownRMB = true; _currentTool.mouseDown(); break;
				case MouseEvent.RIGHT_MOUSE_UP:		isDownRMB = false; _currentTool.mouseUp(); break;
				case MouseEvent.MOUSE_MOVE:			if (isOut) return; _currentTool.mouseMove(); break;
				case Event.ENTER_FRAME:				_currentTool.mouseUpdate(); break;
				case Event.DEACTIVATE:
					isDownRMB = isDownLMB = false;
					//_currentTool.mouseUp();
					break;
			}
		}
		
		public function get currentTool():Tool_Base { return _currentTool; }
		public function set currentTool(value:Tool_Base):void {
			if (_currentTool == value || _currentTool is Object(value).constructor) {
				return;
			}
			
			if (_currentTool) {
				_currentTool.isActive = false;
				Registry.MAN_MENUBAR.toolProperties.removeChildren();
			}
			
			_currentTool = value;
			recentlyChanged = true;
			TimerUtils.defer( onRecentlyChanged );
			if (!_currentTool) {
				return;
			}
			
			_currentTool.isActive = true;
			if(_currentTool.containerProperties) {
				Registry.MAN_MENUBAR.toolProperties.addChild( _currentTool.containerProperties );
			}
		}
		
		private function onRecentlyChanged():void {
			recentlyChanged = false;
		}
		
		public function get foregroundColor():uint { return colorFore.color | (opacity << 24); }
		public function get backgroundColor():uint { return colorBack.color | (opacity << 24); }
		public function get currentColor():uint { return isDownLMB ? foregroundColor : (isDownRMB ? backgroundColor : 0); }
	}
}