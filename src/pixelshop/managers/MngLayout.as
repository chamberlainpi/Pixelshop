package pixelshop.managers {
	import com.bigp.utils.StringUtils;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngLayout extends Manager_Base {
		
		public var appTitle:String;
		
		public function MngLayout() {
			super();
			
		}
		
		public override function init():void {
			super.init();
			
			Registry.whenZoom.add( onZoom );
			Registry.whenNewFile.add( onNewFile );
			Registry.whenTitleInvalidated.add( updateTitle );
			onZoom();
		}
		
		private function onNewFile():void {
			Registry.WORKSPACE.zoom = Registry.DEFAULT_ZOOM;
			Registry.GRID_CANVAS.setSize( Registry.DOC_WIDTH, Registry.DOC_HEIGHT );
			
			updateTitle();
		}
		
		private function updateTitle( pStr:String=null ):void {
			var sizeStr:String =	" (" + Registry.DOC_WIDTH + "x" + Registry.DOC_HEIGHT + ")";
			var zoomStr:String =	" [zoom: " + Registry.WORKSPACE.zoom + "x]";
			var extraStr:String =	pStr == null || pStr.length == 0 ? "" : pStr;
			
			stage.nativeWindow.title = StringUtils.replaceMany("$0$1$2$3", [Registry.STR.APP_TITLE,sizeStr,zoomStr,extraStr]);
		}
		
		private function onZoom():void {
			if (Registry.GRID_VISIBILITY) {
				Registry.GRID_CANVAS.gridVisible = Registry.WORKSPACE.zoom > 3;
			} else {
				Registry.GRID_CANVAS.gridVisible = false;
			}
			
			updateTitle();
		}
	}
}