package pixelshop.managers {

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngLayout extends Manager_Base {
		
		public function MngLayout() {
			super();
			
		}
		
		public override function init():void {
			super.init();
			
			Registry.whenZoom.add( onZoom );
			Registry.whenNewFile.add( onNewFile );
			
			onZoom();
		}
		
		private function onNewFile():void {
			Registry.WORKSPACE.zoom = Registry.DEFAULT_ZOOM;
		}
		
		private function onZoom():void {
			if (Registry.GRID_VISIBILITY) {
				Registry.GRID_CANVAS.gridVisible = Registry.WORKSPACE.zoom > 3;
			} else {
				Registry.GRID_CANVAS.gridVisible = false;
			}
		}
	}
}