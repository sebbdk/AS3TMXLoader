package dk.sebb.tiled.layers
{
	import dk.sebb.tiled.TMXLoader;
	
	import flash.display.Bitmap;

	public dynamic class ImageLayer extends Layer
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
			 
			 if(this.parallax) {
			 	var bmd01:Bitmap = new Bitmap(bitmapData);
				var bmd02:Bitmap = new Bitmap(bitmapData);
				var bmd03:Bitmap = new Bitmap(bitmapData);
				var bmd04:Bitmap = new Bitmap(bitmapData);
				var bmd05:Bitmap = new Bitmap(bitmapData);
				var bmd06:Bitmap = new Bitmap(bitmapData);
				var bmd07:Bitmap = new Bitmap(bitmapData);
				var bmd08:Bitmap = new Bitmap(bitmapData);
				
				//row 1
				bmd01.x = -bmd01.width;
				bmd01.y = -bmd01.height;
				displayObject.addChild(bmd01);
				
				bmd02.x = 0;
				bmd02.y = -bmd02.height;
				displayObject.addChild(bmd02);
				
				bmd03.x = bmd03.width;
				bmd03.y = -bmd03.height;
				displayObject.addChild(bmd03);
				
				//row 2
				bmd04.x = -bmd01.width;
				bmd04.y = 0;
				displayObject.addChild(bmd04);
				
				bmd05.x = bmd01.width;
				bmd05.y = 0;
				displayObject.addChild(bmd05);
				
				//row 3
				bmd06.x = -bmd01.width;
				bmd06.y = bmd01.height;
				displayObject.addChild(bmd06);
				
				bmd07.x = 0;
				bmd07.y = bmd01.height;
				displayObject.addChild(bmd07);
				
				bmd08.x = bmd01.width;
				bmd08.y = bmd01.height;
				displayObject.addChild(bmd08);
			 }
		}
	}
}