package {
	import assets.Assets;
	import bigp.mathlib.DrawLib;
	import com.bigp.Lib;
	import com.bigp.utils.draw.DrawUtils_Base;
	import com.bit101.bigp.MenuBar;
	import com.bit101.bigp.SimpleAtlas;
	import com.bit101.bigp.StyleDark;
	import com.bit101.bigp.Workspace;
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import pixelshop.GridCanvas;
	import pixelshop.imagebytes.PixelBytes;
	import starling.display.Sprite;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Main extends Sprite {
		
		public function Main():void {
			PixelBytes.DONT_ALLOW_SMALL_RECTANGLES = false;
			DrawUtils_Base.INST = new DrawUtils_Base();
			Component.initStage( Lib.STAGE );
			SimpleAtlas.init( Assets.TEXTURES_XML, Assets.TEXTURES_PNG );
			PushButton.DEFAULT_MOUSE_EVENT =	MouseEvent.MOUSE_DOWN;
			
			TextureSmoothing.DEFAULT = TextureSmoothing.NONE;
			
			Lib.STAGE.stageFocusRect = false;
			Lib.STAGE.addEventListener(Event.RESIZE, onResize);
			Lib.STAGE.addEventListener(Event.ENTER_FRAME, onUpdateFrame);
			
			Registry.instantiate();
			
			setupWorkspace();
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
			var workspace:Workspace =	new Workspace();
			var bar:MenuBar =	new MenuBar(Lib.STAGE);
			workspace.x =	0;
			workspace.y =	bar.barHeight;
			workspace.onResize();
			addChild( workspace );
			
			Registry.STARLING.stage.color = StyleDark.BACKGROUND_EMPTY;
			
			Registry.MENUBAR =		bar;
			Registry.WORKSPACE =	workspace;
			Registry.DRAW_LIB =		new DrawLib();
			Registry.GRID_CANVAS =	new GridCanvas();
			Registry.WORKSPACE.content.addChild( Registry.GRID_CANVAS );
			Registry.DOC_WIDTH = Registry.DEFAULT_WIDTH;
			Registry.DOC_HEIGHT = Registry.DEFAULT_HEIGHT;
			
			
			Registry.initManagers();
			
			//Bind Signal methods:
			Registry.whenZoom.add( Registry.WORKSPACE.readjustContent );
			Registry.whenResize.add( workspace.onResize );
			Registry.whenNewFile.dispatch();
		}
	}
	
	// TODO P150 - Undo Manager (PLAN: History-length, States, Compression)
	// TODO P200 - Make Selection Manager, the ToolSelect class will interact with it.
	// TODO P400 - Render multiple intervals of the grid ?? (quarter, eights, sixteenth, etc.)
	// TODO P400 - Create Color Palette
	// TODO P500 - Use Dynamic TexturePacker for assembling layers?
}