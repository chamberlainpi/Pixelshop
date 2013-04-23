package pixelshop.managers {
	import com.bigp.Lib;
	import flash.display.Stage;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Manager_Base {
		
		private var _isUpdated:Boolean = false;
		public function Manager_Base() {
			
		}
		
		public function init():void {
			Registry.whenNewFile.add( onNewDocument );
			Registry.whenCloseFile.add( onCloseDocument );
		}
		
		protected function onNewDocument():void {
			
		}
		
		protected function onCloseDocument():void {
			
		}
		
		protected function onUpdate():void {
			
		}
		
		public function get stage():Stage { return Lib.STAGE; }
		
		public function get isUpdated():Boolean { return _isUpdated; }
		public function set isUpdated(value:Boolean):void {
			_isUpdated = value;
			
			if (_isUpdated) {
				Registry.whenDrawUpdate.add( onUpdate );
			} else {
				Registry.whenDrawUpdate.remove( onUpdate );
			}
		}
	}
}