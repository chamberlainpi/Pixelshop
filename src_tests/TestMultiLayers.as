package  {
	import com.bigp.Lib;
	import com.bigp.utils.BenchmarkUtils;
	import com.bigp.utils.KeyAdvancedUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import org.osflash.signals.Signal;
	import pixelshop.imagebytes.MultiLayer;
	import vo.LayerSprite;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class TestMultiLayers extends Test_Base {
		
		private var _multi:MultiLayer;
		private var _bitmap:Bitmap;
		private var _whenDrawBegin:Signal;
		private var _whenDrawEnd:Signal;
		private var _benchmark:BenchmarkUtils;
		private var size:Point;
		
		public override function _begin():void {
			super._begin();
			
			_whenDrawBegin = new Signal();
			_whenDrawEnd = new Signal();
			_benchmark =	new BenchmarkUtils();
			_benchmark.autoClear = true;
			Lib.KEYS.bind(Keyboard.EQUAL, onPressPLUS );
			Lib.KEYS.bind(Keyboard.MINUS, onPressMINUS );
			trace("Press + or - to add/remove layers.");
			
			size = new Point(32, 32);
			LayerSprite.offsetX = size.x + 272;
			_multi = new MultiLayer(size.x, size.y, 1, LayerSprite, _whenDrawBegin);
			
			var container:Sprite =	new Sprite();
			container.scaleX = container.scaleY = 4;
			container.addChild( _bitmap = _multi.createFinalBitmap(0, size.y + 1) );
			container.addChild( _multi.createLowerBitmap(size.x + 1) );
			container.addChild( _multi.createUpperBitmap(size.x + 1, size.y * 2 + 1) );
			container.addChild( _multi.createCurrentBitmap(size.x + 1, size.y + 1) );
			addChild(container);
		}
		
		private function onPressMINUS():void {
			_multi.removeLayer();
		}
		
		private function onPressPLUS():void {
			_multi.addLayer();
		}
		
		public override function _mouseDown():void {
			super._mouseDown();
		}
		
		public override function _mouseUp():void {
			super._mouseUp();
		}
		
		public override function _update():void {
			super._update();
			
			_whenDrawBegin.dispatch();
			_whenDrawEnd.dispatch();
		}
	}
}