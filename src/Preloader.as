package  {
	import com.bigp.preloaders.PreloaderStarling;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Preloader extends PreloaderStarling {
		
		public function Preloader() {
			super("Main");
			
			__autoAdaptResolution = true;
			__autoResizes = true;
			
			startLoading();
		}
		
		protected override function _instantiate():void {
			super._instantiate();
		}
	}
}