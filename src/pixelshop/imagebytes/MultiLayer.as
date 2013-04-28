package pixelshop.imagebytes {
	import com.bigp.utils.BitmapUtils;
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
		private var _bitmapDraw:BitmapData;
		
		private var _lastLayer:PixelLayer;
		
		public var backgroundColor:uint = 0;
		
		public function MultiLayer(pWidth:int, pHeight:int, pDefaultLayerCls:Class=null, pWhenValidating:Signal=null) {
			super(pDefaultLayerCls || PixelLayer, pWhenValidating);
			
			_width = pWidth;
			_height = pHeight;
			
			_bitmapDraw =		inline_newBitmap(0x00000000);
			_bitmapUpper =		inline_newBitmap(0x00000000);
			_bitmapLower =		inline_newBitmap(0x00000000);
			_bitmapFinal =		inline_newBitmap(0x00000000);
			_bitmapScratch =	inline_newBitmap(0x00000000);
			_bitmapCurrent =	inline_newBitmap(0x00000000);
			
			_layersMerged = new Vector.<Layer_Base>();
			_bytesFinal = new PixelBytes();
		}
		
		public function addLayers(pLayerAmount:int=1):void {
			while (pLayerAmount > 0) {
				addLayer();
				pLayerAmount--;
			}
		}
		
		protected override function _createNewLayer(pName:String):Layer_Base {
			var bytes:PixelBytes =	PixelBytes.initWithSize( _width, _height );
			var inst:PixelLayer =	new _defaultLayerClass(pName, bytes) as PixelLayer;
			whenNewLayerCreated.dispatch( inst );
			return inst;
		}
		
		public function commitCurrent():void {
			inline_copyBitmapToLayer( _bitmapCurrent, currentLayerPixels );
			BitmapUtils.inline_clear( _bitmapDraw );
			
			invalidator.invalidate();
		}
		
		public function createDrawBitmap(pX:int = 0, pY:int = 0):Bitmap { return inline_createBitmapOf( _bitmapDraw, pX, pY ); }
		public function createFinalBitmap(pX:int = 0, pY:int = 0):Bitmap { return inline_createBitmapOf( _bitmapFinal, pX, pY ); }
		public function createUpperBitmap(pX:int = 0, pY:int = 0):Bitmap { return inline_createBitmapOf( _bitmapUpper, pX, pY ); }
		public function createLowerBitmap(pX:int = 0, pY:int = 0):Bitmap { return inline_createBitmapOf( _bitmapLower, pX, pY ); }
		public function createCurrentBitmap(pX:int = 0, pY:int = 0):Bitmap { return inline_createBitmapOf( _bitmapCurrent, pX, pY ); }
		
		public function copyCurrentToDraw():void {
			_bitmapDraw.setPixels( currentLayerPixels.pixels.rect, currentLayerPixels.pixels.getBytes() );
		}
		
		/////////////////// INLINE METHODS:
		
		[Inline] private static function inline_createBitmapOf( pBitmapData:BitmapData, pX:int, pY:int ):Bitmap {
			var bitmap:Bitmap = new Bitmap( pBitmapData, PixelSnapping.NEVER, false );
			bitmap.x = pX;
			bitmap.y = pY;
			pBitmapData.unlock(); //Unlock since it may look strange when nothing changes in it! :P
			return bitmap;
		}
		
		[Inline] private final function inline_newBitmap(pColor:uint):BitmapData {
			var bitmap:BitmapData =	new BitmapData(_width, _height, true, pColor);
			bitmap.lock();
			return bitmap;
		}
		
		[Inline] private static function inline_merge( pDest:BitmapData, pSource:BitmapData ):void {
			pDest.copyPixels( pSource, pSource.rect, _POINT_ZERO, null, null, true );
		}
		
		[Inline] private static function inline_copyBitmapToLayer( pBitmap:BitmapData, pPixelBytes:PixelLayer ):void {
			pBitmap.copyPixelsToByteArray( pBitmap.rect, pPixelBytes.pixels.getBytes() );
			pPixelBytes.pixels.rect = pBitmap.rect;
		}
		
		[Inline] private static function inline_sliceLayers( pFrom:Vector.<Layer_Base>, pTo:Vector.<Layer_Base>, pStart:int, pEnd:int ):void {
			pTo.length = 0;
			if(pEnd > pFrom.length) pEnd = pFrom.length;
			if(pStart<pEnd) {
				for (var s:int = pStart; s < pEnd; s++) {
					pTo[pTo.length] = pFrom[s];
				}
			}
		}
		
		/////////////////// INLINE METHODS:
		
		protected override function _validate():void {
			_bitmapFinal.fillRect(_bitmapFinal.rect, backgroundColor);
			
			var theCurrentLayer:PixelLayer = currentLayerPixels;
			if(!_bitmapFinal || !_bytesFinal || !theCurrentLayer) return;
			
			//THE BIGGER DIRTY WAY!
			//////mergeToBitmapData(_bitmapFinal, _layers, false );
			
			//First copy the bytes of the current-layer to the CURRENT bitmap.
			theCurrentLayer.pixels.copyTo( _bitmapCurrent );
			
			var hasLowers:Boolean = _currentLayerID > 0;
			var hasUppers:Boolean = _currentLayerID < _layers.length - 1;
			
			if (hasLowers)	inline_merge( _bitmapFinal, _bitmapLower );		// 1) Copy all LOWER merged layers.
			/*************/	inline_merge( _bitmapFinal, _bitmapCurrent );	// 2) Copy the CURRENT layer.
			/*************/	inline_merge( _bitmapFinal, _bitmapDraw);		// 3) Copy the DRAW layer (possibly not commited, but draw preview)
			if (hasUppers)	inline_merge( _bitmapFinal, _bitmapUpper );		// 4) Copy all UPPER merged layers.
			
			// Last but not least, update the FINAL pixel bytes:
			// TODO P300 - Maybe the _bytesFinal only needs to be completed during PNG Exports? Maybe frame-by-frame anim?
			_bitmapFinal.copyPixelsToByteArray( _bitmapFinal.rect, _bytesFinal.getBytes() );
		}
		
		private function mergeToBitmapData( pBitmapData:BitmapData, pLayers:Vector.<Layer_Base>, pPreClear:Boolean=false, pScratchBitmap:BitmapData = null  ):void {
			if (pPreClear) BitmapUtils.inline_clear(pBitmapData);
			if (!pLayers || pLayers.length == 0) return;
			if (!pScratchBitmap) pScratchBitmap = _bitmapScratch;
			var theLayer:PixelLayer, thePixels:PixelBytes, theBytes:ByteArray,
				c:int, cLen:int, pointZero:Point = _POINT_ZERO;
			
			BitmapUtils.inline_clear( _bitmapScratch );
			
			for (c = pLayers.length; --c >= 0; ) {
				theLayer =	pLayers[c] as PixelLayer;
				thePixels =	theLayer.pixels;
				theBytes =	thePixels.getBytes();
				pScratchBitmap.setPixels( thePixels.rect, theBytes );
				pBitmapData.copyPixels( pScratchBitmap, pScratchBitmap.rect, pointZero, null, null, true ); //Merge down!
			}
		}
		
		protected override function _onAdded():void {
			super._onAdded();
			BitmapUtils.inline_clear( _bitmapDraw );
		}
		
		protected override function _onRemoved():void {
			super._onRemoved();
			BitmapUtils.inline_clear( _bitmapDraw );
		}
		
		protected override function _layersChanged():void {
			super._layersChanged();
			
			if (_lastLayer) trace("_lastLayerPixels: " + _lastLayer.referenceID + " new = " + currentLayerPixels.referenceID);
			
			//MERGE UPPER & LOWER layers:
			inline_sliceLayers( _layers, _layersMerged, 0, _currentLayerID );
			mergeToBitmapData( _bitmapLower, _layersMerged, true );
			inline_sliceLayers( _layers, _layersMerged, _currentLayerID+1, _layers.length );
			mergeToBitmapData( _bitmapUpper, _layersMerged, true );
			
			_layersMerged.length = 0;
			_lastLayer = currentLayerPixels;
		}
		
		public function get currentLayerPixels():PixelLayer { return currentLayer as PixelLayer; }
		public function get bitmapCurrent():BitmapData { return _bitmapCurrent; }
		public function get bitmapUpper():BitmapData { return _bitmapUpper; }
		public function get bitmapLower():BitmapData { return _bitmapLower; }
		public function get bitmapDraw():BitmapData { return _bitmapDraw; }
		public function get bitmapScratch():BitmapData { return _bitmapScratch; }
		public function get bitmapFinal():BitmapData { return _bitmapFinal; }
		public function get bytesFinal():PixelBytes { return _bytesFinal; }
		public function get width():int { return _width; }
		public function get height():int { return _height; }
	}
}