package dk.sebb.tiled.layers
{
	import flash.display.Bitmap;
	import dk.sebb.tiled.TMXLoader;

	public class ImageLayer extends Layer
	{
		public function ImageLayer(_layer:XML, _tmxLoader:TMXLoader)
		{
			super(_layer, _tmxLoader);
		}
		
		protected override function parseLayer():void {
			draw();
		}
		
		public override function draw():void {
			 bitmapData = tmxLoader.bitmapDatas[layer.image.attribute("source")];
			 displayObject.addChild(new Bitmap(bitmapData));
		}
	}
}