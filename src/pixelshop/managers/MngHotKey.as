package pixelshop.managers {
	import com.bigp.Lib;
	import flash.ui.Keyboard;
	import pixelshop.tools.ToolEraser;
	import pixelshop.tools.ToolFill;
	import pixelshop.tools.ToolPencil;
	import pixelshop.tools.ToolPicker;
	import pixelshop.tools.ToolSelect;
	import pixelshop.tools.ToolShape;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngHotKey extends Manager_Base {
		
		public function MngHotKey() {
			super();
		}
		
		public override function init():void {
			super.init();
			
			//Zoom
			Lib.KEYS.bind([Keyboard.CONTROL, Keyboard.BACKQUOTE], onCTRLTilde);
			
			//Selection
			Lib.KEYS.bind([Keyboard.CONTROL, Keyboard.A], onCTRL_A);
			Lib.KEYS.bind([Keyboard.CONTROL, Keyboard.D], onCTRL_D);
			Lib.KEYS.bind([Keyboard.CONTROL, Keyboard.X], onCTRL_X);
			Lib.KEYS.bind([Keyboard.CONTROL, Keyboard.C], onCTRL_C);
			Lib.KEYS.bind([Keyboard.CONTROL, Keyboard.V], onCTRL_V);
			Lib.KEYS.bind(Keyboard.DELETE, onDelete); //Clear
			
			// Undo
			Lib.KEYS.bind([Keyboard.CONTROL, Keyboard.Z], onCTRL_Undo);
			Lib.KEYS.bind([Keyboard.CONTROL, Keyboard.Z, Keyboard.SHIFT], onCTRL_Redo);
			
			//Tools
			Lib.KEYS.bind(Keyboard.A, onToolSwitch, [ToolPencil]);
			Lib.KEYS.bind(Keyboard.S, onToolSwitch, [ToolSelect]);
			Lib.KEYS.bind(Keyboard.D, onToolSwitch, [ToolShape]);
			Lib.KEYS.bind(Keyboard.F, onToolSwitch, [ToolFill]);
			Lib.KEYS.bind(Keyboard.G, onToolSwitch, [ToolPicker]);
			Lib.KEYS.bind(Keyboard.E, onToolSwitch, [ToolEraser]);
		}
		
		private function onCTRL_A():void { Registry.MAN_SELECT.selectAll(); }
		private function onCTRL_D():void { Registry.MAN_SELECT.selectNone(); }
		private function onCTRL_X():void { Registry.MAN_SELECT.cut(); }
		private function onCTRL_C():void { Registry.MAN_SELECT.copy(); }
		private function onCTRL_V():void { Registry.MAN_SELECT.paste(); }
		private function onCTRL_Undo():void { Registry.MAN_UNDO.undo(); }
		private function onCTRL_Redo():void { Registry.MAN_UNDO.redo(); }
		private function onCTRLTilde():void { Registry.WORKSPACE.zoom = 0; }
		
		private function onToolSwitch( pToolType:Class ):void {
			Registry.MAN_TOOLS.currentTool = Registry.MAN_TOOLS.getByType( pToolType );
		}
		
		private function onDelete():void {
			
		}
	}
}