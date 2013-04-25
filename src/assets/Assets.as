package assets {

	/**
	 * ...
	 * @author Pierre Chamberlain
	 */
	public class Assets {
		
		[Embed(source = "atlas.xml", mimeType="application/octet-stream")] public static const TEXTURES_XML:Class;
		[Embed(source = "atlas.png")] public static const TEXTURES_PNG:Class;
		
		[Embed(source="other_images/TransparencyGrid.gif")] public static const TEXTURE_TRANSPARENCY_GRID:Class;
	}
}