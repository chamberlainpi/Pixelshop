package  {
	import bigp.mathlib.DrawLib;
	import com.bigp.Lib;
	import com.bigp.utils.SpriteUtils;
	import com.bit101.bigp.ColorSwatch;
	import com.bit101.bigp.MenuBar;
	import com.bit101.bigp.WindowModal;
	import com.bit101.bigp.Workspace;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import org.osflash.signals.PrioritySignal;
	import org.osflash.signals.Signal;
	import pixelshop.AppStrings;
	import pixelshop.GridCanvas;
	import pixelshop.Invalidator;
	import pixelshop.managers.Manager_Base;
	import pixelshop.managers.MngFileIO;
	import pixelshop.managers.MngHotKey;
	import pixelshop.managers.MngLayers;
	import pixelshop.managers.MngLayout;
	import pixelshop.managers.MngMenuBar;
	import pixelshop.managers.MngSelection;
	import pixelshop.managers.MngTools;
	import pixelshop.managers.MngUndo;
	import starling.core.Starling;
	import starling.extensions.bigp.BitmapImage;
	import starling.textures.TextureAtlas;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Registry {
		
		public static var WORKSPACE:Workspace;
		public static var MENUBAR:MenuBar;
		public static var GRID_CANVAS:GridCanvas;
		
		public static var whenResize:PrioritySignal;
		public static var whenZoom:PrioritySignal;
		public static var whenNewFile:PrioritySignal;
		public static var whenCloseFile:PrioritySignal;
		public static var whenDrawBegin:PrioritySignal;
		public static var whenDrawUpdate:PrioritySignal;
		public static var whenDrawEnd:PrioritySignal;
		public static var whenTitleInvalidated:PrioritySignal;
		
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
		public static var STARLING:Starling;
		public static var ATLAS:TextureAtlas;
		public static var STR:AppStrings;
		public static var DOC_WIDTH:int;
		public static var DOC_HEIGHT:int;
		
		public static var RENDER_VALIDATOR:Invalidator;
		
		public static function get LAYER_FINAL():BitmapImage { return MAN_LAYERS.layerFinal; }
		public static function get BMP_FINAL():BitmapData { return MAN_LAYERS && MAN_LAYERS.multilayer ? MAN_LAYERS.multilayer.bitmapFinal : null; }
		public static function get BMP_DRAW():BitmapData { return MAN_LAYERS && MAN_LAYERS.multilayer ? MAN_LAYERS.multilayer.bitmapDraw : null; }
		public static function get BMP_CURRENT():BitmapData { return MAN_LAYERS && MAN_LAYERS.multilayer ? MAN_LAYERS.multilayer.bitmapCurrent : null; }
		public static function get BMP_SCRATCH():BitmapData { return MAN_LAYERS && MAN_LAYERS.multilayer ? MAN_LAYERS.multilayer.bitmapScratch : null; }
		public static function get LAYER_CURRENT_ID():int { return MAN_LAYERS.multilayer.currentLayer.referenceID; }
		
		public static function get CAN_DRAW():Boolean {
			if (ColorSwatch.PANEL && ColorSwatch.PANEL.stage) return false;
			if (MAN_TOOLS.recentlyChanged) return false;
			
			SpriteUtils.getChildrenByType(Lib.STAGE, WindowModal, true, _MODAL_WINDOWS);
			if (_MODAL_WINDOWS.length > 0) return false;
			
			return true;
		}
		
		public static function instantiate():void {
			_MANAGERS =	new <Manager_Base>[
				MAN_HOTKEYS = new MngHotKey(),
				MAN_FILE = new MngFileIO(),
				MAN_MENUBAR = new MngMenuBar(),
				MAN_LAYOUT = new MngLayout(),
				MAN_LAYERS = new MngLayers(),
				MAN_UNDO = new MngUndo(),
				MAN_TOOLS = new MngTools(),
				MAN_SELECT = new MngSelection()
			];
			
			//Init SIGNALS:
			whenResize =			new PrioritySignal();
			whenZoom =				new PrioritySignal();
			whenNewFile =			new PrioritySignal();
			whenCloseFile =			new PrioritySignal();
			whenDrawBegin =			new PrioritySignal();
			whenDrawUpdate =		new PrioritySignal();
			whenDrawEnd =			new PrioritySignal();
			whenTitleInvalidated =	new PrioritySignal();
			
			RENDER_VALIDATOR =		new Invalidator(whenDrawBegin, _validateRenders);
			
			STARLING = Starling.current;
			STR =	new AppStrings();
		}
		
		private static function _validateRenders():void {
			MAN_LAYERS.multilayer.invalidator.invalidate();		//Invalidation (Mostly to update the drawing layer
			MAN_LAYERS.layerFinal.invalidate();		//Invalidation for the final-bitmapdata to commit to GPU
		}
		
		public static function initManagers():void {
			for (var m:int=0, mLen:int=_MANAGERS.length; m<mLen; m++) {
				var theManager:Manager_Base = _MANAGERS[m];
				theManager.init();
			}
		}
	}
}