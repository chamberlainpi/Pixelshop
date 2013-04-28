package pixelshop.imagebytes {
	import org.osflash.signals.Signal;
	import pixelshop.Invalidator;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class LayerSystem {
		
		private var _layerGeneratedCount:int = 1;
		private var _layerReferenceCount:int = 0;
		internal var _layers:Vector.<Layer_Base>;
		protected var _defaultLayerClass:Class;
		protected var _currentLayerID:int = -1;
		private var _currentLayer:Layer_Base;
		
		public var whenValidating:Signal;
		public var whenNewLayerCreated:Signal;
		public var invalidator:Invalidator;
		
		public var invalidateOnLayerChanged:Boolean = true;
		
		public function LayerSystem(pDefaultLayerClass:Class=null, pWhenValidating:Signal=null) {
			_defaultLayerClass =	pDefaultLayerClass || Layer_Base;
			whenValidating =		pWhenValidating;
			whenNewLayerCreated =	new Signal();
			
			invalidator = new Invalidator(pWhenValidating, _validate);
			_layers = new Vector.<Layer_Base>();
		}
		
		[Inline] private final function generateName():String {
			return "Layer " + _layerGeneratedCount++;
		}
		
		public function destroy():void {
			while (_layers.length > 0) {
				_layers.pop().dispose();
			}
			
			invalidator.destroy();
			invalidator = null;
			
			whenNewLayerCreated.removeAll();
			whenNewLayerCreated = null;
		}
		
		public final function addLayer(pName:String=null):Layer_Base {
			if (!pName || pName.length == 0) pName = generateName();
			
			var layer:Layer_Base = _createNewLayer(pName);
			layer.owner = this;
			layer.referenceID =	_layerReferenceCount++;
			layer.init();
			_layers.push(layer);
			
			currentLayerID = _layers.length - 1;
			
			_onAdded();
			invalidator.invalidate();
			
			return layer;
		}
		
		protected function _createNewLayer(pName:String):Layer_Base {
			return new _defaultLayerClass(pName);
		}
		
		public function removeLayer(pIndex:int=-1, pDispose:Boolean=true):Layer_Base {
			if (pIndex == -1) pIndex = _currentLayerID;
			if (pIndex < 0 || pIndex>=_layers.length) return null;
			
			var theLayer:Layer_Base = _layers.splice(pIndex, 1)[0];
			if (pDispose) theLayer.dispose();
			currentLayerID = pIndex - 1;
			
			_onRemoved();
			invalidator.invalidate();
			
			return theLayer;
		}
		
		public function removeByRefID( pRefID:int, pDispose:Boolean = true):Layer_Base {
			for (var r:int=0, rLen:int=_layers.length; r<rLen; r++) {
				var theLayer:Layer_Base = _layers[r];
				if (theLayer.referenceID == pRefID) {
					removeLayer( pRefID, pDispose );
					return theLayer;
				}
			}
			
			return null;
		}
		
		public function setCurrentByRefID(pRefID:int):Layer_Base {
			for (var r:int=0, rLen:int=_layers.length; r<rLen; r++) {
				var theLayer:Layer_Base = _layers[r];
				if (theLayer.referenceID == pRefID) {
					currentLayerID = r;
					return theLayer;
				}
			}
			
			return null;
		}
		
		
		public function get currentLayer():Layer_Base { return _currentLayer; }
		public function get currentLayerID():int { return _currentLayerID; }
		public function set currentLayerID(value:int):void {
			if (_currentLayerID == value) return;
			if (value < 0) value = 0;
			if (value >= _layers.length ) value = _layers.length - 1;
			_currentLayerID = value;
			
			if (_currentLayer) {
				_currentLayer.deselected();
			}
			
			if (_currentLayerID < 0) {
				_currentLayer = null;
				return;
			}
			
			_currentLayer = _layers[_currentLayerID];
			_currentLayer.selected();
			
			_layersChanged();
			
			if (invalidateOnLayerChanged) {
				invalidator.invalidate();
			}
		}
		
		//OVERRIDE...
		protected function _layersChanged():void {}
		protected function _onAdded():void {}
		protected function _onRemoved():void {}
		protected function _validate():void {}
	}
}