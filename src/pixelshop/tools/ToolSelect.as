package pixelshop.tools {
	import flash.display.Graphics;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class ToolSelect extends Tool_Base {
		
		private var _startX:int = 0;
		private var _startY:int = 0;
		
		public function ToolSelect() {
			super();
			
			createIcon( "tool_select" );
			
			
			_mouseMoveOnlyWhenDown = false;
			
			
			//Lib.STAGE.addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function onNewFile():void {
			
		}
		
		protected override function _mouseDown():void {
			super._mouseDown();
			
			if(manager.isDownLMB) {
				_startX = manager.currentX;
				_startY = manager.currentY;
			}
		}
		
		protected override function _mouseUpdate():void {
			super._mouseUpdate();
			
			if (manager.isDownLMB) {
				var nowX:int =	(_startX > manager.currentX ? 0 : 1.5) + manager.currentX;
				var nowY:int =	(_startY > manager.currentY ? 0 : 1.5) + manager.currentY;
				Registry.MAN_SELECT.selectFrom( _startX, _startY, nowX, nowY );
			}
		}
		
		override public function get isActive():Boolean { return super.isActive; }
		public override function set isActive(value:Boolean):void {
			super.isActive = value;
			
		}
		
		//TODO P300 - Have a way to select just the contour of the opaque pixels
		//TODO P300 - Have a way to select the bound (rect) of the opaque pixels
		//TODO P300 - Make a Magic wand tool
		//TODO P300 - Make a Lasso tool
		//TODO P100 - FIX rectangle selection (inverse down-right to top-left)
	}
}