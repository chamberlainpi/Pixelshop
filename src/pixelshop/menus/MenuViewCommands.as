package pixelshop.menus {
	import com.bigp.utils.FullscreenUtils;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MenuViewCommands {
		
		public static function onZoomIn():void {
			Registry.WORKSPACE.zoom++;
		}
		public static function onZoomOut():void {
			Registry.WORKSPACE.zoom--;
		}
		public static function onZoomActualSize():void {
			Registry.WORKSPACE.zoom = 0;
		}
		
		public static function onFullscreenToggle():void {
			FullscreenUtils.toggleCallback();
		}
	}
}