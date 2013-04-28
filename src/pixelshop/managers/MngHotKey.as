package pixelshop.managers {
	import com.bigp.Lib;
	import com.bigp.utils.KeyAdvancedUtils;
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
			
			var theKeys:KeyAdvancedUtils = Lib.KEYS;
			
			//Zoom
			theKeys.bind([Keyboard.CONTROL, Keyboard.BACKQUOTE], onCTRLTilde);
			
			//Selection
			theKeys.bind([Keyboard.CONTROL, Keyboard.A], onCTRL_A);
			theKeys.bind([Keyboard.CONTROL, Keyboard.D], onCTRL_D);
			theKeys.bind([Keyboard.CONTROL, Keyboard.X], onCTRL_X);
			theKeys.bind([Keyboard.CONTROL, Keyboard.C], onCTRL_C);
			theKeys.bind([Keyboard.CONTROL, Keyboard.V], onCTRL_V);
			theKeys.bind(Keyboard.DELETE, onDelete); //Clear
			
			// Undo
			theKeys.bind([Keyboard.CONTROL, Keyboard.Z], onCTRL_Undo);
			theKeys.bind([Keyboard.CONTROL, Keyboard.Z, Keyboard.SHIFT], onCTRL_Redo);
			
			//Tools
			theKeys.bind(Keyboard.A, onToolSwitch, [ToolPencil]);
			theKeys.bind(Keyboard.S, onToolSwitch, [ToolSelect]);
			theKeys.bind(Keyboard.D, onToolSwitch, [ToolShape]);
			theKeys.bind(Keyboard.F, onToolSwitch, [ToolFill]);
			theKeys.bind(Keyboard.G, onToolSwitch, [ToolPicker]);
			theKeys.bind(Keyboard.E, onToolSwitch, [ToolEraser]);
			
			//Layer
			theKeys.bind(Keyboard.EQUAL, onLayerAdd);
			theKeys.bind(Keyboard.MINUS, onLayerRemove);
		}
		
		private function onLayerAdd():void { Registry.MAN_LAYERS.addLayer(); }
		private function onLayerRemove():void { Registry.MAN_LAYERS.removeLayer(); }
		
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