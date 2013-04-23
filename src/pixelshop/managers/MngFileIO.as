package pixelshop.managers {
	import by.blooddy.crypto.image.PNGEncoder;
	import com.bigp.Lib;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.ColorTransform;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngFileIO extends Manager_Base {
		
		private var _encoder:PNGEncoder;
		private var _path:String;
		private var file:FileReference;
		
		public function MngFileIO() {
			super();
			
		}
		
		public override function init():void {
			super.init();
			file =	new FileReference();
			file.addEventListener(Event.COMPLETE, onFileSaveComplete);
			file.addEventListener(IOErrorEvent.IO_ERROR, onFileSaveError);
		}
		
		private function onFileSaveError(e:IOErrorEvent):void {
			Lib.ROOT.transform.colorTransform = new ColorTransform(5, 0.25, .25, 1, 128);
		}
		
		private function onFileSaveComplete(e:Event):void {
			trace("File save completed: " + file.name);
		}
		
		public function exportPNG( pBitmapData:BitmapData, pForceNewName:Boolean = false ):void {
			var bytes:ByteArray = PNGEncoder.encode( pBitmapData );
			
			file.save( bytes, "image.png");
			
			/*
			if (pForceNewName) {
				
			} else {
				trace("???");
			}
			*/
		}
	}
}