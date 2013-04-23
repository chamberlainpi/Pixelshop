package pixelshop {
	import com.bigp.Lib;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.core.GNode;
	import com.genome2d.textures.factories.GTextureFactory;
	import com.genome2d.textures.GTexture;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.utils.ByteArray;
	import pixelshop.g2d.GNode2;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class PixelLayer extends GNode2 {
		private static var _COUNT:int = 0;
		
		private var _parent:DisplayObjectContainer;
		private var _bitmap:BitmapData;
		
		public function PixelLayer(pWidth:int, pHeight:int, pStartColorFill:uint = 0xffffffff) {
			if (pWidth == -1 || pHeight == -1) {
				trace("Unable to create new PixelLayer (illegal width and height).");
				return;
			}
			
			_bitmap =	new BitmapData(pWidth, pHeight, true, pStartColorFill);
			
			setTextureBitmap( _bitmap, "pixellayer_" + _COUNT );
			_COUNT++;
			
			Registry.whenDrawBegin.add( onDrawStart );
			Registry.whenDrawBegin.add( onDrawUpdate );
			Registry.whenDrawBegin.add( onDrawEnd );
		}
		
		private function onDrawStart():void {
			_bitmap.lock();
		}
		
		private function onDrawUpdate():void {
			
		}
		
		private function onDrawEnd():void {
			if (!_bitmap) {
				return;
			}
			
			_bitmap.unlock();
			_texture.invalidate();
		}
		
		public function destroy():void {
			trace("destroy?");
			if (_bitmap) {
				_bitmap.dispose();
				_bitmap = null;
			}
			
			parent && parent.removeChild(this);
			
			Registry.whenDrawBegin.remove( onDrawStart );
			Registry.whenDrawBegin.remove( onDrawUpdate );
			Registry.whenDrawBegin.remove( onDrawEnd );
		}
		
		public function clear():void {
			trace("cleared?");
			
			_bitmap.fillRect( _bitmap.rect, 0x00000000 );
		}
		
		public override function get width():Number { return _bitmap ? _bitmap.width : 0; } //TODO WIDTH of dynamic texture
		public override function get height():Number{ return _bitmap ? _bitmap.height : 0; } //TODO HEIGHT of dynamic texture
		
		public function get bitmap():BitmapData { return _bitmap; }
	}
}