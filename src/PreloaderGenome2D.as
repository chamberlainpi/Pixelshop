package  {
	import com.bigp.Lib;
	import com.bigp.preloaders.Preloader_Base;
	import com.genome2d.core.GConfig;
	import com.genome2d.core.Genome2D;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class PreloaderGenome2D extends Preloader_Base {
		public var g2dconfig:GConfig;
		public var g2dcore:Genome2D;
		
		public var autoResize:Boolean = true;
		
		public function PreloaderGenome2D(pMainClassName:String=null, pDebug:Boolean=false) {
			super(pMainClassName);
			
			__autoInstantiate = false;
			__autoAttach = false;
			
		}
		
		protected override function _prepare():void {
			g2dcore =	Genome2D.getInstance();
			g2dconfig = new GConfig(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			g2dconfig.backgroundColor =	stage.color;
			g2dconfig.enableStats = true;
			
			g2dcore.onInitialized.addOnce(onInitComplete);
			g2dcore.onFailed.addOnce(onInitFailed);
			g2dcore.init(stage, g2dconfig);
			
			super._prepare();
		}
		
		protected function onInitFailed():void {
			trace("Failed to initialize Genome2D! Please verify that you're using the correct Flash Player version.");
			stage.dispatchEvent(new Event("Genome2D:failed"));
		}
		
		protected function onInitComplete():void {
			_instantiate();
			
			stage.dispatchEvent(new Event("Genome2D:init"));
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(e:Event):void {
			if (!autoResize) {
				return;
			}
			
			if(g2dconfig) {
				g2dconfig.viewRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
				
				if (Lib.CONTEXT) {
					Lib.CONTEXT.configureBackBuffer(stage.stageWidth, stage.stageHeight, g2dconfig.antiAliasing, g2dconfig.enableDepthAndStencil);
					g2dcore.config
				}
			}
		}
		
		
		
		///////////////////////////////////////////// STATIC PUBLIC
		
		///////////////////////////////////////////// STATIC PRIVATE
		
		///////////////////////////////////////////// PUBLIC
		
		///////////////////////////////////////////// PRIVATE & PROTECTED
		
		///////////////////////////////////////////// EVENT-LISTENERS
		
		///////////////////////////////////////////// GETTERS-SETTERS
		
	}
}