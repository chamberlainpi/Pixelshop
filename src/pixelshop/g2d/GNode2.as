package pixelshop.g2d {
	import com.bigp.Lib;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.core.GNode;
	import com.genome2d.g2d;
	import com.genome2d.textures.factories.GTextureFactory;
	import com.genome2d.textures.GTexture;
	import com.genome2d.textures.GTextureFilteringType;
	import flash.display.BitmapData;
	
	use namespace g2d;
	
	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class GNode2 extends GNode {
		
		protected var _sprite:GSprite;
		protected var _texture:GTexture;
		
		public function GNode2(p_name:String="") {
			super(p_name);
			
		}
		
		public function setTexture(pTexture:GTexture):void {
			_sprite = addComponent(GSprite) as GSprite;
			_sprite.setTexture( pTexture );
			
			_texture = pTexture;
			_texture.pivotX = -_texture.width * .5;
			_texture.pivotY = -_texture.height * .5;
		}
		
		public function setTextureBitmap(pBitmapData:BitmapData, pName:String):void {
			_texture = GTextureFactory.createFromBitmapData(pName, pBitmapData);
			_texture.filteringType = GTextureFilteringType.NEAREST;
			setTexture(_texture);
		}
		
		public function get x():int { return transform.x; }
		public function set x(n:int):void { transform.x = n; }
		public function get y():int { return transform.x; }
		public function set y(n:int):void { transform.y = n; }
		
		public function get mouseX():Number { return (Lib.STAGE.mouseX - transform.nWorldX) / transform.nWorldScaleX; }
		public function get mouseY():Number { return (Lib.STAGE.mouseY - transform.nWorldY) / transform.nWorldScaleY; }
		
		public function get width():Number { return _texture ? _texture.width * transform.scaleX : 0; }
		public function get height():Number { return _texture ? _texture.height * transform.scaleY : 0; }
		
		public function set width(n:Number):void { if(_texture) transform.scaleX = n / _texture.width; }
		public function set height(n:Number):void { if(_texture) transform.scaleY = n / _texture.height; }
		
		public function get scaleX():Number { return transform.scaleX; }
		public function get scaleY():Number { return transform.scaleY; }
		
		public function set scaleX(n:Number):void { transform.scaleX = n; }
		public function set scaleY(n:Number):void { transform.scaleY = n; }
	}
}