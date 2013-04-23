package {
	import assets.Assets;
	import bigp.mathlib.DrawLib;
	import com.bigp.Lib;
	import com.bigp.utils.draw.DrawUtils_Base;
	import com.bigp.utils.KeyUtils;
	import com.bit101.bigp.MenuBar;
	import com.bit101.bigp.SimpleAtlas;
	import com.bit101.bigp.StyleDark;
	import com.bit101.bigp.Workspace;
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import com.genome2d.core.Genome2D;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	import pixelshop.GridCanvas;
	import pixelshop.managers.MngTools;
	import bigp.mathlib.PixelBytes;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Main {
		
		public function Main():void {
			init();
			
			Registry.instantiate();
			
			setupWorkspace();
			
			Registry.initManagers();
			
			Registry.whenNewFile.dispatch();
		}
		
		private function init():void {
			Registry.GENOME = Genome2D.getInstance();
			Registry.GCONFIG =	Registry.GENOME.config;
			Registry.GCONFIG.useFastMem = true;
			Registry.GCONFIG.enableStats = false;
			Registry.GCONFIG.backgroundColor =	StyleDark.BACKGROUND_EMPTY;
			
			
			PixelBytes.DONT_ALLOW_SMALL_RECTANGLES = false;
			DrawUtils_Base.INST = new DrawUtils_Base();
			Component.initStage( Lib.STAGE );
			SimpleAtlas.init( Assets.TEXTURES_XML, Assets.TEXTURES_PNG );
			PushButton.DEFAULT_MOUSE_EVENT =	MouseEvent.MOUSE_DOWN;
			Lib.STAGE.stageFocusRect = false;
			
			//Init SIGNALS:
			Registry.whenResize =		new Signal();
			Registry.whenZoom =			new Signal();
			Registry.whenNewFile =		new Signal();
			Registry.whenCloseFile =	new Signal();
			Registry.whenDrawBegin =	new Signal();
			Registry.whenDrawUpdate =	new Signal();
			Registry.whenDrawEnd =		new Signal();
			
			Lib.STAGE.addEventListener(Event.RESIZE, onResize);
			Lib.STAGE.addEventListener(Event.ENTER_FRAME, onUpdateFrame);
		}
		
		private function onUpdateFrame(e:Event):void {
			Registry.whenDrawBegin.dispatch();
			Registry.whenDrawUpdate.dispatch();
			Registry.whenDrawEnd.dispatch();
		}
		
		private function onResize(e:Event):void {
			Registry.whenResize.dispatch();
		}
		
		private function setupWorkspace():void {
			var bar:MenuBar =	new MenuBar(Lib.STAGE);
			var workspace:Workspace =	new Workspace();
			workspace.x =	0;
			workspace.y =	bar.barHeight;
			workspace.onResize();
			
			Registry.MENUBAR =		bar;
			Registry.WORKSPACE =	workspace;
			Registry.GENOME.root.addChild( workspace );
			Registry.GRID_CANVAS =	new GridCanvas();
			Registry.DRAW_LIB =		new DrawLib();
			Registry.WORKSPACE.addChild( Registry.GRID_CANVAS );
			Registry.WORKSPACE.isMouseWheelZoom = true;
			
			Registry.GRID_CANVAS.setSize( Registry.DEFAULT_WIDTH, Registry.DEFAULT_HEIGHT );
			
			Registry.whenZoom.add( Registry.WORKSPACE.readjustContent );
			Registry.whenResize.add( workspace.onResize );
		}
	}
	
	// TODO P150 - Undo Manager (PLAN: History-length, States, Compression)
	// TODO P200 - Make Selection Manager, the ToolSelect class will interact with it.
	// TODO P400 - Render multiple intervals of the grid ??
	// TODO P400 - Create Color Palette
}