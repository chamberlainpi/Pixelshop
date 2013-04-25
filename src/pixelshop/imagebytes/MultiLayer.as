package pixelshop.imagebytes {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import org.osflash.signals.Signal;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MultiLayer extends LayerSystem {
		private static const _POINT_ZERO:Point = new Point();
		
		private var _width:int;
		private var _height:int;
		private var _layersMerged:Vector.<Layer_Base>;
		private var _bytesFinal:PixelBytes;
		private var _bitmapFinal:BitmapData;
		private var _bitmapUpper:BitmapData;	//BitmapData for whenever layers are merged above the current layer:
		private var _bitmapLower:BitmapData;	//BitmapData for whenever layers are merged below the current layer;
		private var _bitmapCurrent:BitmapData;
		private var _bitmapScratch:BitmapData;
		
		public var backgroundColor:uint = 0xff330000;
		
		public function MultiLayer(pWidth:int, pHeight:int, pLayerAmount:int=1, pDefaultLayerCls:Class=null, pSignalForValidation:Signal=null) {
			super(pDefaultLayerCls || PixelLayer, pSignalForValidation);
			
			_width = pWidth;
			_height = pHeight;
			
			_bitmapUpper = inline_newBitmap(0x00000000);
			_bitmapLower = inline_newBitmap(0x00000000);
			_bitmapFinal = inline_newBitmap(0x00000000);
			_bitmapScratch = inline_newBitmap(0x00000000);
			_bitmapCurrent = inline_newBitmap(0x00000000);
			
			_layersMerged = new Vector.<Layer_Base>();
			_bytesFinal = new PixelBytes();
			
			while (pLayerAmount > 0) {
				addLayer();
				pLayerAmount--;
			}
		}
		
		public function destroy():void {
			/////////////// ???
		}
		
		protected override function _createNewLayer(pName:String):Layer_Base {
			var bytes:PixelBytes =	PixelBytes.initWithSize( _width, _height );
			return new _defaultLayerClass(pName, bytes) as PixelLayer;
		}
		
		public function createFinalBitmap(pX:int = 0, pY:int = 0):Bitmap { return inline_createBitmapOf( _bitmapFinal, pX, pY ); }
		public function createUpperBitmap(pX:int = 0, pY:int = 0):Bitmap { return inline_createBitmapOf( _bitmapUpper, pX, pY ); }
		public function createLowerBitmap(pX:int = 0, pY:int = 0):Bitmap { return inline_createBitmapOf( _bitmapLower, pX, pY ); }
		public function createCurrentBitmap(pX:int = 0, pY:int = 0):Bitmap { return inline_createBitmapOf( _bitmapCurrent, pX, pY ); }
		
		/////////////////// INLINE METHODS:
		
		[Inline] private static function inline_createBitmapOf( pBitmapData:BitmapData, pX:int, pY:int ):Bitmap {
			var bitmap:Bitmap = new Bitmap( pBitmapData, PixelSnapping.NEVER, false );
			bitmap.x = pX;
			bitmap.y = pY;
			pBitmapData.unlock(); //Unlock since it may look strange when nothing changes in it! :P
			return bitmap;
		}
		
		[Inline] private static function inline_clear(pBitmap:BitmapData):void {
			pBitmap.fillRect( pBitmap.rect, 0x00000000 );
		}
		
		[Inline] private final function inline_newBitmap(pColor:uint):BitmapData {
			var bitmap:BitmapData =	new BitmapData(_width, _height, true, pColor);
			bitmap.lock();
			return bitmap;
		}
		
		[Inline] private static function inline_merge( pDest:BitmapData, pSource:BitmapData ):void {
			pDest.copyPixels( pSource, pSource.rect, _POINT_ZERO, null, null, true );
		}
		
		[Inline] private static function inline_vectorPixelLayers( pFrom:Vector.<Layer_Base>, pTo:Vector.<Layer_Base>, pStart:int, pEnd:int ):void {
			pTo.length = 0;
			if (pEnd > pFrom.length) pEnd = pFrom.length;
			if(pStart<pEnd) {
				for (var s:int = pStart; s < pEnd; s++) {
					pTo[pTo.length] = pFrom[s];
				}
			}
		}
		
		/////////////////// INLINE METHODS:
		
		protected override function validate():Boolean {
			_bitmapFinal.fillRect(_bitmapFinal.rect, backgroundColor);
			
			var theCurrent:PixelLayer = currentPixelLayer;
			if(!super.validate() || !_bitmapFinal || !_bytesFinal || !theCurrent) return false;
			
			//////mergeToBitmapData(_bitmapFinal, _layers, false ); //THE BIGGER DIRTY WAY!
			
			theCurrent.pixels.copyTo( _bitmapScratch ); //First copy the currentLayer to the SCRATCH bitmap for easier merging:
			
			var hasLowers:Boolean = _currentLayerID > 0;
			var hasUppers:Boolean = _currentLayerID < _layers.length - 1;
			
			if(hasUppers)	inline_merge( _bitmapFinal, _bitmapUpper );		// 3) Copy all UPPER merged layers.
			/***********/	inline_merge( _bitmapFinal, _bitmapScratch );	// 2) Copy the CURRENT layer.
			if (hasLowers)	inline_merge( _bitmapFinal, _bitmapLower );		// 1) Copy all LOWER merged layers.
			
			_bitmapFinal.copyPixelsToByteArray( _bitmapFinal.rect, _bytesFinal.getBytes() );
			
			return true;
		}
		
		protected override function _layersChanged():void {
			super._layersChanged();
			
			var str:String = "";
			
			inline_vectorPixelLayers( _layers, _layersMerged, 0, _currentLayerID );
			mergeToBitmapData( _bitmapLower, _layersMerged, true );
			str += "Lower [0-" + _currentLayerID + "] has: " + _layersMerged.length;
			
			str += ", current: " + _currentLayerID;
			inline_vectorPixelLayers( _layers, _layersMerged, _currentLayerID+1, _layers.length );
			mergeToBitmapData( _bitmapUpper, _layersMerged, true );
			str += ", Upper [" + _currentLayerID + "-" + _layers.length + "] has: " + _layersMerged.length;
			
			trace(str);
			
			currentPixelLayer.pixels.copyTo( _bitmapCurrent );
			
			_layersMerged.length = 0;
		}
		
		private function mergeToBitmapData( pBitmapData:BitmapData, pLayers:Vector.<Layer_Base>, pPreClear:Boolean=false, pScratchBitmap:BitmapData = null  ):void {
			if (pPreClear) inline_clear(pBitmapData);
			if (!pLayers || pLayers.length == 0) return;
			if (!pScratchBitmap) pScratchBitmap = _bitmapScratch;
			
			var theLayer:PixelLayer, thePixels:PixelBytes, theBytes:ByteArray, c:int, cLen:int, pointZero:Point = _POINT_ZERO;
			
			for (c = pLayers.length; --c >= 0; ) {
				theLayer =	pLayers[c] as PixelLayer;
				thePixels =	theLayer.pixels;
				theBytes =	thePixels.getBytes();
				pScratchBitmap.setPixels( thePixels.rect, theBytes );
				pBitmapData.copyPixels( pScratchBitmap, pScratchBitmap.rect, pointZero, null, null, true ); //Merge down!
			}
		}
		
		public function get width():int { return _width; }
		public function get height():int { return _height; }
		
		public function get finalBytes():PixelBytes { return _bytesFinal; }
		public function get bitmapUpper():BitmapData { return _bitmapUpper; }
		public function get bitmapLower():BitmapData { return _bitmapLower; }
		public function get bitmapCurrent():BitmapData { return _bitmapCurrent; }
		public function get bitmapFinal():BitmapData { return _bitmapFinal; }
		public function get currentPixelLayer():PixelLayer { return currentLayer as PixelLayer; }
	}
}