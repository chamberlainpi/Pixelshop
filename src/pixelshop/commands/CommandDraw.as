package pixelshop.commands {
	import pixelshop.imagebytes.PixelBytes;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class CommandDraw extends Command_Base {
		
		public var bytesNew:PixelBytes;
		public var bytesOld:PixelBytes;
		public var bitmapTarget:BitmapData;
		public var pointTarget:Point;
		
		public static var COUNTER:int = 0;
		public var id:int = 0;
		public var issuedStack:Error;
		
		public function CommandDraw( pTarget:BitmapData=null ) {
			super();
			
			if (pTarget) bitmapTarget = pTarget;
			
			id = COUNTER++;
			pointTarget = new Point();
			issuedStack = new Error();
		}
		
		public static function create( pTarget:BitmapData, pNewPixels:BitmapData, pNewRect:Rectangle=null ):CommandDraw {
			var cmd:CommandDraw = new CommandDraw( Registry.LAYER_CURRENT.bitmap );
			 
			cmd.bytesNew = !pNewRect ? PixelBytes.getBoundsBytes( pNewPixels ) : PixelBytes.initWithBitmap( pNewPixels, pNewRect );
			cmd.bytesOld = PixelBytes.initWithBitmap( Registry.LAYER_CURRENT.bitmap, cmd.bytesNew.rect );
			
			return cmd;
		}
		
		public override function redo():void {
			super.redo();
			
			try {
				//First draw to the scratch layer:
				bytesNew.copyTo( bitmapTarget, null, Registry.LAYER_DRAW.bitmap );
			} catch (err:Error) {
				trace("redo error: \n" + issuedStack.getStackTrace() );
			}
			
			Registry.LAYER_DRAW.invalidate();
			Registry.LAYER_CURRENT.invalidate();
		}
		
		public override function undo():void {
			super.undo();
			
			try {
				//First draw to the scratch layer:
				bytesOld.copyTo( bitmapTarget, null, Registry.LAYER_DRAW.bitmap );
			} catch (err:Error) {
				trace("undo error: \n" + issuedStack.getStackTrace() );
			}
			
			Registry.LAYER_DRAW.invalidate();
			Registry.LAYER_CURRENT.invalidate();
		}
	}
}