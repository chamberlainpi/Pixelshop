package vo {
	import com.bigp.Lib;
	import com.bigp.utils.ColorUtils;
	import com.bigp.utils.SpriteUtils;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import pixelshop.imagebytes.PixelBytes;
	import pixelshop.imagebytes.PixelLayer;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class LayerSprite extends PixelLayer {
		public static var offsetX:Number = 0;
		public static var offsetY:Number = 0;
		
		private var _sprite:clsCustomSprite;
		
		public function LayerSprite(pName:String, pBytes:PixelBytes) {
			super(pName, pBytes);
			
			_sprite = new clsCustomSprite();
			_sprite.addEventListener(MouseEvent.CLICK, onClick);
			Lib.ROOT.addChild( _sprite );
			
			var label:TextField =	new TextField();
			label.autoSize =	TextFieldAutoSize.LEFT;
			//label.width =		0;
			//label.height =		0;
			label.multiline =	true;
			label.wordWrap =	true;
			label.selectable =	false;
			label.border =		true;
			label.text =		pName;
			_sprite.addChild(label);
			
			invalidateLayout();
		}
		
		public override function init():void {
			super.init();
			var r:int,rLen:int=ownerMulti.height,c:int,cLen:int=ownerMulti.width;
			
			var bytes:ByteArray = pixels.getBytes();
			var theRandomChoice:int = Math.random() * 4;
			var randomValue:int = Math.random() * ownerMulti.width;
			var randomColor:uint =	0xff000000 | ColorUtils.hsvToRGB(Math.random() * 360, 0.5, 0.5);
			switch(theRandomChoice) {
				case 0:
					for (r = 0; r < rLen; r++) {
						for (c = 0; c < cLen; c++) {
							if(c==randomValue) {
								bytes.writeUnsignedInt(randomColor);
							} else {
								bytes.writeUnsignedInt(0x00000000);
							}
						}
					}
					break;
				case 1:
					for (r = 0; r < rLen; r++) {
						for (c = 0; c < cLen; c++) {
							if(r==randomValue) {
								bytes.writeUnsignedInt(randomColor);
							} else {
								bytes.writeUnsignedInt(0x00000000);
							}
						}
					}
					break;
				case 2:
					for (r = 0; r < rLen; r++) {
						for (c = 0; c < cLen; c++) {
							if((c % randomValue == 0)) {
								bytes.writeUnsignedInt(randomColor);
							} else {
								bytes.writeUnsignedInt(0x00000000);
							}
						}
					}
					break;
				case 3:
					for (r = 0; r < rLen; r++) {
						for (c = 0; c < cLen; c++) {
							if(c==randomValue || r==randomValue) {
								bytes.writeUnsignedInt(randomColor);
							} else {
								bytes.writeUnsignedInt(0x00000000);
							}
						}
					}
					break;
			}			
		}
		
		public static function invalidateLayout():void {
			var allLabels:Vector.<DisplayObject> = SpriteUtils.getChildrenByType(Lib.ROOT, clsCustomSprite);
			
			for (var v:int = allLabels.length; --v >= 0; ) {
				var theLabel:clsCustomSprite = allLabels[v] as clsCustomSprite;
				theLabel.x =	offsetX;
				theLabel.y =	offsetY + v * 20;
			}
		}
		
		public override function dispose():void {
			super.dispose();
			
			if (!_sprite) return;
			if (_sprite.parent) _sprite.parent.removeChild(_sprite);
			_sprite = null;
			invalidateLayout();
		}
		
		private function onClick(e:MouseEvent):void {
			trace("Clicked on layer: " + this.index);
			owner.currentLayerID = this.index;
		}
	}
}
import flash.display.Sprite;

internal class clsCustomSprite extends Sprite {}