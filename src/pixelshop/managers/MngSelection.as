package pixelshop.managers {
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class MngSelection extends Manager_Base{
		
		private var _selectionOutline:Sprite;
		private var _selectionRect:Rectangle;
		private var _gradientMatrix:Matrix;
		
		private var _isReallySelected:Boolean = false;
		
		public function MngSelection() {
			super();
		}
		
		public override function init():void {
			super.init();
			
			isUpdated = true;
			
			_selectionRect =	new Rectangle();
			_selectionOutline =	new Sprite();
			_gradientMatrix =	new Matrix();
			_gradientMatrix.identity();
			_gradientMatrix.scale(0.0005, 0.0005);
			_gradientMatrix.rotate(180 / Math.PI * 45);
			
			//TODO create a Genome2D sprite that can render outlines (dashed black & white)
			/////////////////Registry.WORKSPACE.content.add( _selectionOutline );
		}
		
		protected override function onNewDocument():void {
			super.onNewDocument();
			
			if (!Registry.LAYER_DRAW) return;
			
			_selectionRect.setTo(0, 0, Registry.LAYER_DRAW.width, Registry.LAYER_DRAW.height); 
		}
		
		protected override function onUpdate():void {
			super.onUpdate();
			
			if (!_selectionOutline) {
				return;
			}
			
			var g:Graphics =	_selectionOutline.graphics;
			g.clear();
			
			if (!_isReallySelected) return;
			
			g.lineStyle(Registry.WORKSPACE.zoom < 8 ? 1 : 2, 0, 1, true, LineScaleMode.NONE);
			g.lineGradientStyle( GradientType.LINEAR, [0, 0xffffff], [1, 1], [126, 130], _gradientMatrix, SpreadMethod.REFLECT );
			_gradientMatrix.translate(0.25, 0);
			
			if (_gradientMatrix.tx > 255) {
				_gradientMatrix.tx %= 255;
			}
			
			if (_selectionRect.width == 0) _selectionRect.width = 1;
			if (_selectionRect.height == 0) _selectionRect.height = 1;
			g.drawRect(int(_selectionRect.x), int(_selectionRect.y), int(_selectionRect.width), int(_selectionRect.height));
		}
		
		public function selectFrom( x0:int, y0:int, x1:int, y1:int ):void {
			var temp:int;
			if (x0 > x1) { temp = x0; x0 = x1; x1 = temp; }
			if (y0 > y1) { temp = y0; y0 = y1; y1 = temp; }
			
			_selectionRect.setTo(x0, y0, x1 - x0, y1 - y0);
			
			_isReallySelected = true;
		}
		
		public function selectAll():void {
			selectFrom(0, 0, Registry.LAYER_FINAL.width,  Registry.LAYER_FINAL.height);
		}
		
		public function selectNone():void {
			_isReallySelected = false;
		}
		
		public function cut():void {
			trace("CUT");
		}
		
		public function copy():void {
			trace("COPY");
		}
		
		public function paste():void {
			trace("PASTE");
		}
	}
}