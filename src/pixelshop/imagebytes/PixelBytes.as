package  pixelshop.imagebytes {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import pixelshop.imagebytes.PixelBytes;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class PixelBytes {
		
		private static var _POINT_ZERO:Point = new Point();
		
		public static var DONT_ALLOW_SMALL_RECTANGLES:Boolean = true;
		
		private var _bytes:ByteArray;
		private var _rectCopyTo:Rectangle;
		
		public var rect:Rectangle;
		
		public function PixelBytes() {
			_bytes =	new ByteArray();
		}
		
		public static function initWithBitmap(pBitmapData:BitmapData, pSourceRect:Rectangle=null):PixelBytes {
			var inst:PixelBytes =	new PixelBytes();
			
			if (pSourceRect == null) inst.rect = pBitmapData.rect.clone();
			else inst.rect = pSourceRect;
			
			inst._rectCopyTo =	inst.rect.clone();
			
			if (DONT_ALLOW_SMALL_RECTANGLES && inst.rect.width <= 1 && inst.rect.height <= 1) {
				throw new Error("The rectangle is too small to bother to store the Bytes");
			}
			
			pBitmapData.copyPixelsToByteArray( inst.rect, inst._bytes );
			
			return inst;
		}
		
		public function destroy():void {
			_bytes.position = 0;
			_bytes.clear();
			_bytes = null;
			
			rect = _rectCopyTo = null;
		}
		
		public static function getBounds( pBitmapData:BitmapData ):Rectangle {
			return pBitmapData.getColorBoundsRect(0xff000000, 0x00000000, false);
		}
		
		public static function getBoundsBytes( pBitmapData:BitmapData ):PixelBytes {
			var rect:Rectangle =	getBounds( pBitmapData );
			var inst:PixelBytes =	initWithBitmap( pBitmapData, rect );
			return inst;
		}
		
		public static function initWithSize( pWidth:int, pHeight:int, pColor:uint = 0x00000000):PixelBytes {
			var inst:PixelBytes = new PixelBytes();
			var total:int =	pWidth * pHeight;
			
			while (total>0) {
				total--;
				inst._bytes.writeUnsignedInt( pColor );
			}
			
			inst.rect = new Rectangle(0, 0, pWidth, pHeight);
			inst._rectCopyTo = inst.rect.clone();
			
			return inst;
		}
		
		public function copyTo( pBitmapData:BitmapData, pDestPoint:Point = null, pMergeAlphaViaBitmap:BitmapData = null ):void {
			CONFIG::debug {
				if (!_rectCopyTo || !rect) {
					throw new Error("Cannot 'copyTo()' when the PixelBytes hasn't been initialized yet!");
					return;
				}
			}
			
			if (pDestPoint == null) {
				_rectCopyTo.setTo( rect.x, rect.y, rect.width, rect.height );
			} else {
				_rectCopyTo.setTo( pDestPoint.x, pDestPoint.y, rect.width, rect.height );
			}
			
			_bytes.position = 0;
			if (_bytes.length == 0) {
				throw new Error("There is no pixel bytes to copy! [empty bytearray]");
			}
			
			if (pMergeAlphaViaBitmap) {
				pMergeAlphaViaBitmap.setPixels(_rectCopyTo, _bytes);
				pBitmapData.copyPixels( pMergeAlphaViaBitmap, pMergeAlphaViaBitmap.rect, _POINT_ZERO, null, null, true );
			} else {
				pBitmapData.setPixels( _rectCopyTo, _bytes );
			}
		}
		
		public function getBytes():ByteArray { _bytes.position = 0; return _bytes; }
		
		public function toString( pWholeHex:Boolean=false ):String {
			_bytes.position = 0;
			var output:Array = new Array();
			var line:Array =	new Array();
			var theColor:uint;
			var xIncrement:int = 0;
			if(pWholeHex) {
				while (_bytes.position < _bytes.length) {
					theColor = _bytes.readUnsignedInt();
					line.push( theColor.toString(16) );
					
					if ((xIncrement % rect.width) == 0) {
						output.push(line.join(" "));
						line =	new Array();
					}
					xIncrement++;
				}
			} else {
				while (_bytes.position < _bytes.length) {
					theColor = _bytes.readUnsignedInt();
					line.push( (theColor > 0 ? "#" : "-") );
					
					xIncrement++;
					
					if ((xIncrement % rect.width) == 0) {
						output.push(line.join(" "));
						line =	new Array();
					}
				}
			}
			
			_bytes.position = 0;
			return output.join("\n");
		}
			
	}
}