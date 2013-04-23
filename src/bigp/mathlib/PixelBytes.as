package  bigp.mathlib {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

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
		
		public function PixelBytes(pBitmapData:BitmapData, pSourceRect:Rectangle=null) {
			_bytes =	new ByteArray();
			
			if (pSourceRect == null) rect = pBitmapData.rect.clone();
			else rect = pSourceRect;
			
			_rectCopyTo =	rect.clone();
			
			if (DONT_ALLOW_SMALL_RECTANGLES && rect.width <= 1 && rect.height <= 1) {
				throw new Error("The rectangle is too small to bother to store the Bytes");
			}
			
			pBitmapData.copyPixelsToByteArray( rect, _bytes );
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
			var bytes:PixelBytes =	new PixelBytes( pBitmapData, rect );
			return bytes;
		}
		
		
		public function copyTo( pBitmapData:BitmapData, pDestPoint:Point = null, pMergeAlphaViaBitmap:BitmapData=null ):void {
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
				pBitmapData.copyPixels( pMergeAlphaViaBitmap, pMergeAlphaViaBitmap.rect, _POINT_ZERO );
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