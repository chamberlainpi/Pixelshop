package pixelshop.managers {
	import com.bigp.Lib;
	import com.bigp.utils.SpriteUtils;
	import com.bit101.bigp.StyleDark;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import pixelshop.display.ListItem;
	import pixelshop.display.PixelshopLayer;
	import pixelshop.imagebytes.MultiLayer;
	import pixelshop.imagebytes.PixelLayer;
	import starling.extensions.bigp.BitmapImage;

	/**
	 * @author Pierre Chamberlain
	 */
	public class MngLayers extends Manager_Panel {
		
		private var _multilayer:MultiLayer;
		private var _listItems:Vector.<DisplayObject>;
		private var _layerFinal:BitmapImage;
		
		public var offsetY:int = 20;
		
		public function MngLayers() {
			super();
		}
		
		public override function init():void {
			super.init();
			
			_listItems =	new Vector.<DisplayObject>();
			
			createPanel(0, 20, 100, 100);
			_panel.color =	StyleDark.LAYER_BUTTONS;
			_panel.addEventListener(Event.ADDED, onLayersChanged );
			_panel.addEventListener(Event.REMOVED, onLayersChanged );
			Lib.STAGE.addChild( _panel );
			
			Registry.whenResize.add( onResize );
			onResize();
		}
		
		private function onResize():void {
			_panel.x = Lib.WIDTH - _panel.width - 2;
			_panel.y = 20;
		}
		
		protected override function onNewDocument():void {
			super.onNewDocument();
			
			if (_multilayer) {
				_multilayer.destroy();
				_multilayer = null;
			}
			
			if (_layerFinal) {
				Registry.WORKSPACE.content.removeChild( _layerFinal, true );
				_layerFinal = null;
			}
			
			// TODO P700 - Reset anything in the panel??
			// ....
			
			_multilayer = new MultiLayer(Registry.DOC_WIDTH, Registry.DOC_HEIGHT, PixelshopLayer, Registry.whenDrawBegin);
			_multilayer.backgroundColor = 0x88000000;
			_multilayer.whenNewLayerCreated.add( onNewLayer );
			_layerFinal =	new BitmapImage(Registry.DOC_WIDTH, Registry.DOC_HEIGHT, true, 0, _multilayer.bitmapFinal);
			Registry.WORKSPACE.content.addChild( _layerFinal );
			
			/*
			 * It's only "safe" to add layers once the _layerFinal BitmapImage has been instantiated, they both
			 * invalidate at the same time from **Registry.invalidateLayersAndCanvas()**
			 */
			_multilayer.addLayers();
			
			CONFIG::debug { //Debug rendering of layers:
				var debug:Bitmap;
				debug = _multilayer.createCurrentBitmap(120, 30);
				debug.filters = [new GlowFilter(0x44ff66, 1, 8, 8, 6, 2)];
				debug.scaleX = debug.scaleY = 4;
				stage.addChild( debug );
				
				debug = _multilayer.createDrawBitmap(120, 150);
				debug.filters = [new GlowFilter(0xff4466, 1, 8, 8, 6, 2)];
				debug.scaleX = debug.scaleY = 4;
				stage.addChild( debug );
			}
		}
		
		private function onNewLayer( pLayer:PixelshopLayer ):void {
			_panel.addChild( pLayer.sprite );
		}
		
		private function onLayersChanged(e:Event=null):void {
			if (e.target == _panel) return;
			
			SpriteUtils.getChildrenByType(_panel.content, ListItem, false, _listItems, false, true );
			
			var theLayer:PixelshopLayer;
			var theLayerSprite:ListItem;
			for (var f:int=0, fLen:int=_listItems.length; f<fLen; f++) {
				theLayerSprite = _listItems[f] as ListItem;
				theLayerSprite.y = offsetY + f * theLayerSprite.height;
			}
			
			if(theLayerSprite) {
				_panel.height = theLayerSprite.y + theLayerSprite.height;
			}
			
			Registry.RENDER_VALIDATOR.invalidate();
		}
		
		public function frameNext():void {}
		public function framePrev():void {}
		public function layerNext():void {}
		public function layerPrev():void {}
		
		public function addLayer():void {
			_multilayer.addLayer();
		}
		
		public function removeLayer():void {
			_multilayer.removeLayer( -1, true );
		}
		
		public function get multilayer():MultiLayer { return _multilayer; }
		public function get layerFinal():BitmapImage { return _layerFinal; }
	}
}