package dk.sebb.tiled.layers
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import dk.sebb.tiled.TMXLoader;

	public dynamic class ObjectLayer extends Layer
	{	
		public var objects:Array;
		
		public function ObjectLayer(_layer:XML, _tmxLoader:TMXLoader)
		{
			super(_layer, _tmxLoader);
		}
		
		protected override function parseLayer():void {
			objects = [];
			
			//#TODO draw rectangles to bitmapdata instead.. 
			bitmapData = new BitmapData(tmxLoader.mapWidth * tmxLoader.tileWidth, tmxLoader.mapHeight * tmxLoader.tileHeight, true, 0x00000000);
			for each (var object:XML in layer.object) {
				var rectangle:Shape = new TMXObject(object);
				rectangle.graphics.lineStyle(2);
				rectangle.graphics.beginFill(0x0099CC, 1);
				rectangle.graphics.drawRect(0, 0, object.attribute("width"), object.attribute("height") );
				rectangle.graphics.endFill();
				rectangle.x = object.attribute("x");
				rectangle.y = object.attribute("y");

				var mtrx:Matrix = new Matrix();
				mtrx.translate(object.attribute("x"), object.attribute("y"));
				bitmapData.draw(rectangle, mtrx);
				
				objects.push(rectangle);
			}
		}
		
		public override function draw():void {}
	}
}