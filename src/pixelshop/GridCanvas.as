package pixelshop {
	import com.bigp.utils.BitmapUtils;
	import com.genome2d.core.GNode;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import pixelshop.g2d.GNode2;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class GridCanvas extends GNode2 {
		
		private var _grid:Sprite;
		private var _gridColor:uint =		0x88002288;
		private var _gridVisible:Boolean =	false;
		
		private var _layerDraw:PixelLayer;
		private var _layerFinal:PixelLayer;
		
		private var _backgroundColor:uint = 0xffffff;
		
		private var _parentScale:Point;
		
		public function GridCanvas() {
			super();
			
			_grid = new Sprite();
			_grid.alpha = 0.5;
			
			Registry.whenZoom.add( onZoom );
			
			onAddedToStage.addOnce( added );
		}
		
		private function added():void {
			trace("Canvas added.");
		}
		
		public function setSize( pWidth:int=-1, pHeight:int=-1 ):void {
			if (_layerFinal) {
				_layerFinal.destroy();
				_layerFinal = null;
				
				/////////////////removeChild( _grid );
				_grid.graphics.clear();
				//_grid = null;
				
				_layerDraw.destroy();
				_layerDraw = null;
			}
			
			if (getTimer() > 2000) {
				//throw new Error("TEST!");
			}
			
			Registry.WORKSPACE.contentWidth = pWidth==-1 ? Registry.WORKSPACE.contentWidth : pWidth;
			Registry.WORKSPACE.contentHeight = pHeight==-1 ? Registry.WORKSPACE.contentHeight : pHeight;
			
			//Draw the background color:
			/*
			this.graphics.beginFill(_backgroundColor, 1);
			this.graphics.drawRect(0, 0, pWidth, pHeight);
			this.graphics.endFill();
			*//////////////////////////////////////////////////
			
			_layerFinal =	new PixelLayer(Registry.WORKSPACE.contentWidth, Registry.WORKSPACE.contentHeight, 0xffffffff);
			_layerDraw =	new PixelLayer(Registry.WORKSPACE.contentWidth, Registry.WORKSPACE.contentHeight, 0x00000000);
			
			addChild( _layerFinal );
			addChild( _layerDraw );
			
			//////////////////////////addChild( _grid );
			
			//this.filters = [new DropShadowFilter(4, 90, 0, 0.75, 8, 8, 1, 2)];
			
			//DEBUG
			//_layerFinal.bitmapContainer.filters = [new GlowFilter(0xffcc8800, 1, 2, 2, 4, 2)];
			
			onZoom();
		}
		
		private function onZoom():void {
			//getParentScale();
			_grid.cacheAsBitmap = false;
			_grid.graphics.clear();
			
			////////////BitmapUtils.drawGrid( _grid, Registry.WORKSPACE.contentWidth, Registry.WORKSPACE.contentHeight, 1, 0x88002288, _parentScale.x);
			_grid.cacheAsBitmap = true;
		}
		
		// TODO P300 - Improve rendering by drawing a BitmapData dynamically (could use Haxe + Tricks of copy pixels)
		// TODO P500 - Improve rendering further by using GPU (but everything else will need to, also!) It will have to eventually!!
		
		/*
		public function getParentScale():Point {
			if (!_parentScale) {
				_parentScale = new Point();
			}
			
			var mtx:Matrix =	this.transform..concatenatedMatrix;
			_parentScale.setTo( mtx.a, mtx.d );
			return _parentScale;
		}*/
		
		public function get gridVisible():Boolean { return _gridVisible; }
		public function set gridVisible(b:Boolean):void { _grid.visible = _gridVisible = b; }
		
		public function get layerFinal():PixelLayer { return _layerFinal; }
		public function get layerDraw():PixelLayer { return _layerDraw; }
		
		public function get grid():Sprite { return _grid; }
		
		override public function get width():Number { return _layerFinal.width; }
		override public function get height():Number { return _layerFinal.height; }
		
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
		}
		
		public function get gridColor():uint { return _gridColor; }
		public function set gridColor(value:uint):void {
			_gridColor = value;
			
			setSize();
		}
	}
}