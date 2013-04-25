package pixelshop.windows {
	import com.bit101.bigp.WindowModal;
	import com.bit101.components.InputText;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class WndGridCustomize extends WindowModal {
		
		public var gridColor:String;
		public var gridVisible:String;
		public var transparencyColor:String;
		public var transparencyAnimation:String;
		
		public function WndGridCustomize(parent:DisplayObjectContainer=null, xpos:Number=-1, ypos:Number=-1) {
			super(parent, xpos, ypos, "Customize Grid");
			
			setSize(240, 150);
			
			createLabelFor( new InputText(this, 125, 10, Registry.GRID_CANVAS.gridColor.toString(16)), "Grid Color:", "gridColor" );
			createLabelFor( new InputText(this, 125, 30, Registry.GRID_VISIBILITY.toString()), "Auto Visible:", "gridVisible" );
			createLabelFor( new InputText(this, 125, 50, Registry.GRID_CANVAS.transparencyAnimation.toString()), "Transparency Animated:", "transparencyAnimation" );
			createLabelFor( new InputText(this, 125, 70, Registry.GRID_CANVAS.transparencyColor.toString(16)), "Transparency Color/Hue:", "transparencyColor" );
			
			createBottomButtons([
				{label: "OK", func: onGridCustomized, defaultAction: true },
				{label: "CANCEL", func: this.close }
			]);
		}
		
		private function onGridCustomized(e:Event = null):void {
			commitProperties();
			
			Registry.GRID_VISIBILITY = gridVisible == "true";
			Registry.GRID_CANVAS.gridColor = parseInt( gridColor, 16 );
			Registry.GRID_CANVAS.transparencyAnimation = transparencyAnimation == "true";
			Registry.GRID_CANVAS.transparencyColor = parseInt( transparencyColor, 16 );
			
			close();
		}
	}
}