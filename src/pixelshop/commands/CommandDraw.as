package pixelshop.commands {
	import com.bigp.utils.TimerUtils;
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
		public var layerReferenceID:int = 0;
		
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
		
		public static function create( pTarget:BitmapData, pNewPixels:BitmapData, pNewRect:Rectangle = null ):CommandDraw {
			if (!Registry.MAN_LAYERS.multilayer.currentLayer) return null;
			
			var cmd:CommandDraw = new CommandDraw( pTarget );
			cmd.bytesNew = pNewRect ? PixelBytes.initWithBitmap( pNewPixels, pNewRect ) : PixelBytes.getBoundsBytes( pNewPixels );
			cmd.bytesOld =			PixelBytes.initWithBitmap( pTarget, cmd.bytesNew.rect );
			cmd.layerReferenceID =	Registry.MAN_LAYERS.multilayer.currentLayer.referenceID;
			return cmd;
		}
		
		public override function redo():void {
			super.redo();
			
			if (!Registry.MAN_LAYERS.multilayer.setCurrentByRefID( this.layerReferenceID )) {
				throw new Error("The current layer could not be changed to non-existing Reference ID: " + this.layerReferenceID);
			}
			
			try {
				bytesNew.copyTo( bitmapTarget, null, Registry.BMP_SCRATCH );
				Registry.MAN_LAYERS.multilayer.commitCurrent();
				TimerUtils.defer( Registry.RENDER_VALIDATOR.invalidate );
			} catch (err:Error) {
				trace("redo error: \n" + issuedStack.getStackTrace() );
			}
		}
		
		public override function undo():void {
			super.undo();
			
			if (!Registry.MAN_LAYERS.multilayer.setCurrentByRefID( this.layerReferenceID )) {
				throw new Error("The current layer could not be changed to non-existing Reference ID: " + this.layerReferenceID);
			}
			
			try {
				bytesOld.copyTo( bitmapTarget );
				Registry.MAN_LAYERS.multilayer.commitCurrent();
				TimerUtils.defer( Registry.RENDER_VALIDATOR.invalidate );
			} catch (err:Error) {
				trace("undo error: \n" + issuedStack.getStackTrace() );
			}
		}
	}
}