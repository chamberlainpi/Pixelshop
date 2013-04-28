package pixelshop.display {
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import pixelshop.imagebytes.PixelBytes;
	import pixelshop.imagebytes.PixelLayer;
	

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class PixelshopLayer extends PixelLayer {
		private static var _GLOW_FILTER:GlowFilter = new GlowFilter(0xeeee33, 1, 4, 4, 3, 2, true);
		
		public var sprite:clsLayer;
		
		public function PixelshopLayer(pName:String, pPixelBytes:PixelBytes ) {
			super(pName, pPixelBytes);
			
			sprite = new clsLayer(pName);
			sprite.owner = this;
			sprite.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void {
			ownerMulti.currentLayerID = this.index;
		}
		
		public override function selected():void {
			super.selected();
			
			sprite.filters = [_GLOW_FILTER];
		}
		
		public override function deselected():void {
			super.deselected();
			
			sprite.filters = [];
		}
		
		public override function dispose():void {
			sprite.destroy();
			
			super.dispose();
		}
	}
}
import com.bit101.bigp.StyleDark;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import pixelshop.display.ListItem;

internal class clsLayer extends ListItem {
	public var label:TextField;
	
	public function clsLayer(pName:String) {
		super();
		
		label = new TextField();
		label.autoSize =	TextFieldAutoSize.LEFT;
		label.multiline =	true;
		label.wordWrap =	true;
		label.selectable =	false;
		label.text =		pName;
		label.textColor =	0x222222;
		
		this.addChild(label);
		
		var g:Graphics =	this.graphics;
		g.beginFill(StyleDark.LAYER_BUTTONS, 1);
		g.drawRect(0, 0, label.width, label.height);
		g.endFill();
	}
}