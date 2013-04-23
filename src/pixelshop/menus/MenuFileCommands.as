package pixelshop.menus {
	import com.bigp.Lib;
	import flash.events.Event;
	import pixelshop.windows.WndFileNewDocument;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MenuFileCommands {
		
		public static var FILE_NEW:WndFileNewDocument;
		
		public static function onFileNew(e:Event=null):void {
			FILE_NEW =	new WndFileNewDocument(Lib.STAGE);
		}
		
		public static function onFileNewComplete(e:Event=null):void {
			if (!FILE_NEW) { throw new Error("Can't create new from no window!"); }
			
			FILE_NEW.commitProperties();
			
			Registry.whenCloseFile.dispatch();
			Registry.GRID_CANVAS.setSize( FILE_NEW.documentWidth, FILE_NEW.documentHeight );
			FILE_NEW.close();
			FILE_NEW = null;
			
			Registry.whenNewFile.dispatch();
			Registry.whenResize.dispatch();
		}
		
		public static function onFileSave(e:Event = null):void {
			Registry.MAN_FILE.exportPNG( Registry.LAYER_FINAL.bitmap );
		}
		
		public static function onFileSaveAs(e:Event = null):void {
			Registry.MAN_FILE.exportPNG( Registry.LAYER_FINAL.bitmap, true );
		}
	}
}