package pixelshop {
	import assets.Assets;
	import com.bigp.utils.TimerUtils;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import pixelshop.imagebytes.MultiLayer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.bigp.BitmapImage;
	import starling.extensions.bigp.ScrollImage;
	import starling.textures.Texture;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class GridCanvas extends Sprite {
		
		private var _gridColor:uint =		0x88002288;
		private var _gridVisible:Boolean =	false;
		private var _transparencyGrid:ScrollImage;
		
		public var pixelRatioX:Number = 0;
		public var pixelRatioY:Number = 0;
		public var transparencyColor:Number = 0xffffffff;
		public var transparencyAnimation:Boolean = true;
		
		public function GridCanvas() {
			super();
			
			trace("GridCanvas + whenNewFile!"); 
			Registry.whenNewFile.addWithPriority( onNewDocument, 1 );
			Registry.whenZoom.add( onZoom );
			Registry.whenDrawUpdate.add( onUpdate );
			
			_transparencyGrid =	new ScrollImage(Texture.fromBitmap( new Assets.TEXTURE_TRANSPARENCY_GRID ), true);
			
			Registry.WORKSPACE.content.addChild( this );
			Registry.WORKSPACE.content.addChild( _transparencyGrid );
			//////////////////////////addChild( _grid );
		}
		
		private function onNewDocument():void {
			trace(this + " new document dispatched!");
			setSize();
		}
		
		public function setSize( pWidth:int=-1, pHeight:int=-1 ):void {
			var theWidth:Number = pWidth==-1 ? Registry.DOC_WIDTH : pWidth;
			var theHeight:Number = pHeight == -1 ? Registry.DOC_HEIGHT : pHeight;
			
			_transparencyGrid.clipMaskRight = Registry.WORKSPACE.contentWidth = theWidth;
			_transparencyGrid.clipMaskBottom = Registry.WORKSPACE.contentHeight = theHeight;
			_transparencyGrid.color = 0xffffffff;
			_transparencyGrid.uvScaleX =	3;
			_transparencyGrid.uvScaleY =	3;
			
			onZoom();
		}
		
		private function onZoom():void {
			//Grid setup...
			var theContent:Sprite =	Registry.WORKSPACE.content;
			
			pixelRatioX = 1/theContent.scaleX;
			pixelRatioY = 1/theContent.scaleY;
			
			_transparencyGrid.uvScaleX = pixelRatioX;
			_transparencyGrid.uvScaleY = pixelRatioY;
		}
		
		private function onUpdate():void {
			if(transparencyAnimation) {
				// TODO - SET SCALE of UV for transparency ???
				_transparencyGrid.scrollX += 0.2 * pixelRatioX;
				_transparencyGrid.scrollY += 0.2 * pixelRatioX;
			} else {
				_transparencyGrid.scrollX = 0;
				_transparencyGrid.scrollY = 0;
			}
			
			_transparencyGrid.color = transparencyColor;
		}
		
		// TODO P100 - Reimplement the GRID in the GPU (Hmm.... how?)
		// TODO P300 - Improve rendering by drawing a BitmapData dynamically (could use Haxe + Tricks of copy pixels)
		// TODO P500 - Improve rendering further by using GPU (but everything else will need to, also!) It will have to eventually!!
		
		public function get gridVisible():Boolean { return _gridVisible; }
		public function set gridVisible(b:Boolean):void { /*_grid.visible = */ _gridVisible = b; }
		//public function get grid():Sprite { return _grid; }
		
		override public function get width():Number { throw new Error("NO WIDTH!"); return -1; }
		override public function get height():Number { throw new Error("NO HEIGHT!"); return -1; }
		
		public function get gridColor():uint { return _gridColor; }
		public function set gridColor(value:uint):void {
			_gridColor = value;
			
			trace("Set grid color... ??");
		}
	}
}