package  {

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Preloader extends PreloaderGenome2D {
		
		public function Preloader() {
			super();
			
			//__autoInstantiate = true;
			//__autoAttach = true;
			
			startLoading();
		}
		
		protected override function _instantiate():void {
			super._instantiate();
		}
	}
}