package pixelshop.managers {
	import com.bigp.Lib;
	import com.bit101.bigp.MenuBar;
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import pixelshop.menus.MenuFileCommands;
	import pixelshop.menus.MenuViewCommands;
	import pixelshop.windows.WndGridCustomize;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngMenuBar extends Manager_Base {
		
		public var toolProperties:Sprite;
		
		public function MngMenuBar() {
			super();
			
		}
		
		public override function init():void {
			super.init();
			
			var bar:MenuBar =	Registry.MENUBAR;
			bar.addMenus( [
				{ label: "File", children: [
					{label: "New", func: MenuFileCommands.onFileNew},
					{label: "Open..."},
					{label: "Save" , func: MenuFileCommands.onFileSave},
					{label: "Save As...", func: MenuFileCommands.onFileSaveAs },
					{label: "Recent Documents >", children: [{label: "test 123"},{label: "test 456"}]}
				] },
				{ label: "Edit", children: [
					{label: "Undo", shortcut: "CTRL+Z", func: Registry.MAN_UNDO.undo },
					{label: "Redo", shortcut: "CTRL+SHIFT+Z", func: Registry.MAN_UNDO.redo },
					{label: "Cut" }
				] },
				{ label: "View", children: [
					{label: "Zoom In", func: MenuViewCommands.onZoomIn},
					{label: "Zoom Out", func: MenuViewCommands.onZoomOut},
					{label: "Zoom 100%", func: MenuViewCommands.onZoomActualSize},
					{label: "Fullscreen", func: MenuViewCommands.onFullscreenToggle }
				]}
			]);
			
			bar.addIcons( [
				//{ icon: "icon_happy" },
				//{ icon: "icon_neutral" },
				//{ icon: "icon_angry" },
				//{ icon: "icon_surprise" },
				{ icon: "icon_grid", func: onGridClick }
			]);
			
			toolProperties = new Sprite();
			bar.addChild( toolProperties );
			
			var lastMenu:PushButton = bar.menus[bar.menus.length - 1];
			toolProperties.x = lastMenu.x + lastMenu.width + 10;
		}
		
		private function onGridClick(e:Event=null):void {
			new WndGridCustomize(Lib.STAGE);
		}
		
		//TODO P100 - Add "File > Open".
		//TODO P100 - Open files in following formats (supported by Loader): JPG, JPEG, PNG, GIF, BMP*.
		//TODO P300 - Open files in proprietary format (*.psh).
		//TODO P400 - Make "Recent Documents" active
		
		//TODO P300 - Add Copy, Cut, Paste (HotKeys = CTRL+X, C, V)
		//TODO P350 - Create BitmapBytes class for a compressed-bitmap format
	}
}