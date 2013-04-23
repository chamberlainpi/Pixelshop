package  {
	import bigp.mathlib.DrawLib;
	import com.bigp.Lib;
	import com.bigp.utils.SpriteUtils;
	import com.bit101.bigp.ColorSwatch;
	import com.bit101.bigp.MenuBar;
	import com.bit101.bigp.WindowModal;
	import com.bit101.bigp.Workspace;
	import com.genome2d.core.GConfig;
	import com.genome2d.core.Genome2D;
	import flash.display.DisplayObject;
	import org.osflash.signals.Signal;
	import pixelshop.GridCanvas;
	import pixelshop.managers.Manager_Base;
	import pixelshop.managers.MngFileIO;
	import pixelshop.managers.MngHotKey;
	import pixelshop.managers.MngLayers;
	import pixelshop.managers.MngLayout;
	import pixelshop.managers.MngMenuBar;
	import pixelshop.managers.MngSelection;
	import pixelshop.managers.MngTools;
	import pixelshop.managers.MngUndo;
	import pixelshop.PixelLayer;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Registry {
		
		public static var WORKSPACE:Workspace;
		public static var MENUBAR:MenuBar;
		public static var GRID_CANVAS:GridCanvas;
		
		public static var whenResize:Signal;
		public static var whenZoom:Signal;
		public static var whenNewFile:Signal;
		public static var whenCloseFile:Signal;
		public static var whenDrawBegin:Signal;
		public static var whenDrawUpdate:Signal;
		public static var whenDrawEnd:Signal;
		
		public static var DEFAULT_WIDTH:int =	16;
		public static var DEFAULT_HEIGHT:int =	16;
		public static var DEFAULT_ZOOM:int =	16;
		
		public static var GRID_VISIBILITY:Boolean = true;
		public static var _MODAL_WINDOWS:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private static var _MANAGERS:Vector.<Manager_Base>;
		
		public static var MAN_HOTKEYS:MngHotKey;
		public static var MAN_FILE:MngFileIO;
		public static var MAN_MENUBAR:MngMenuBar;
		public static var MAN_LAYOUT:MngLayout;
		public static var MAN_LAYERS:MngLayers;
		public static var MAN_UNDO:MngUndo;
		public static var MAN_TOOLS:MngTools;
		public static var MAN_SELECT:MngSelection;
		
		public static var DRAW_LIB:DrawLib;
		public static var GENOME:Genome2D;
		public static var GCONFIG:GConfig;
		
		public static function get LAYER_DRAW():PixelLayer { return GRID_CANVAS.layerDraw; }
		public static function get LAYER_FINAL():PixelLayer { return GRID_CANVAS.layerFinal; }
		public static function get LAYER_CURRENT():PixelLayer { return GRID_CANVAS.layerFinal; }
		
		public static function get CAN_DRAW():Boolean {
			if (ColorSwatch.PANEL && ColorSwatch.PANEL.stage) {
				return false;
			}
			
			if (MAN_TOOLS.recentlyChanged) {
				return false;
			}
			
			SpriteUtils.getChildrenByType(Lib.STAGE, WindowModal, true, _MODAL_WINDOWS);
			
			if (_MODAL_WINDOWS.length > 0) {
				return false;
			}
			
			return true;
		}
		
		public static function instantiate():void {
			_MANAGERS =	new Vector.<Manager_Base>();
			
			_MANAGERS[_MANAGERS.length] = MAN_HOTKEYS = new MngHotKey();
			_MANAGERS[_MANAGERS.length] = MAN_FILE = new MngFileIO();
			_MANAGERS[_MANAGERS.length] = MAN_MENUBAR = new MngMenuBar();
			_MANAGERS[_MANAGERS.length] = MAN_LAYOUT = new MngLayout();
			_MANAGERS[_MANAGERS.length] = MAN_LAYERS = new MngLayers();
			_MANAGERS[_MANAGERS.length] = MAN_UNDO = new MngUndo();
			_MANAGERS[_MANAGERS.length] = MAN_TOOLS = new MngTools();
			_MANAGERS[_MANAGERS.length] = MAN_SELECT = new MngSelection();
		}
		
		public static function initManagers():void {
			for (var m:int=0, mLen:int=_MANAGERS.length; m<mLen; m++) {
				var theManager:Manager_Base = _MANAGERS[m];
				theManager.init();
			}
		}
	}
}