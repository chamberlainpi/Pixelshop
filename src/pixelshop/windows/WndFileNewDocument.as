package pixelshop.windows {
	import com.bit101.bigp.WindowModal;
	import com.bit101.components.InputText;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import pixelshop.menus.MenuFileCommands;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class WndFileNewDocument extends WindowModal {
		
		public var documentWidth:int;
		public var documentHeight:int;
		
		public function WndFileNewDocument(parent:DisplayObjectContainer=null, xpos:Number=-1, ypos:Number=-1) {
			super(parent, xpos, ypos, "New Document");
			
			setSize(300, 180);
			
			createLabelFor( new InputText(this, 100, 10, "128"), "Width:", "documentWidth" );
			createLabelFor( new InputText(this, 100, 30, "128"), "Height:", "documentHeight" );
			
			createBottomButtons([
				{label: "OK", func: MenuFileCommands.onFileNewComplete, defaultAction: true },
				{label: "CANCEL", func: this.close }
			]);
		}
	}
}