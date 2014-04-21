package dk.sebb.tiled.layers
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import dk.sebb.tiled.TMXLoader;
	import dk.sebb.tiled.TileSet;
	
	public class TileLayer extends Layer
	{
		public function TileLayer(_layer:XML, _tmxLoader:TMXLoader)
		{
			super(_layer, _tmxLoader);
		}
		
		/**
		 * Parses the layer into a map
		 * */
		protected override function parseLayer():void {
			
			//parse tiles
			var tiles:Array = new Array();
			var tileLength:uint = 0;
			// assign the gid to each location in the layer
			for each (var tile:XML in layer.data.tile) {
				var gid:Number = tile.attribute("gid");
				// if gid > 0
				if (gid > 0) {
					tiles[tileLength] = gid;
				}
				tileLength++;
			}
			
			// store the gid into a 2d array
			map = [];
			for (var tileX:int = 0; tileX < tmxLoader.mapWidth; tileX++) {
				map[tileX] = new Array();
				for (var tileY:int = 0; tileY < tmxLoader.mapHeight; tileY++) {
					map[tileX][tileY] = tiles[(tileX+(tileY*tmxLoader.mapWidth))];
				}
			}
			
			draw();
		}
		
		public override function draw():void {
			bitmapData = new BitmapData( tmxLoader.mapWidth*tmxLoader.tileWidth, tmxLoader.mapHeight*tmxLoader.tileHeight, true, 0);
			
			for (var spriteForX:int = 0; spriteForX < tmxLoader.mapWidth; spriteForX++) {
				for (var spriteForY:int = 0; spriteForY < tmxLoader.mapHeight; spriteForY++) {
					var tileGid:int = int(map[spriteForX][spriteForY]);
					var currentTileset:TileSet;
					// only use tiles from this tileset (we get the source image from here)
					for each( var tileset1:TileSet in tmxLoader.tileSets) {
						if (tileGid >= tileset1.firstgid-1 && tileGid <= tileset1.lastgid) {
							// we found the right tileset for this gid!
							currentTileset = tileset1;
							break;
						}
					}
					var destY:int = spriteForY * tmxLoader.tileWidth;
					var destX:int = spriteForX * tmxLoader.tileWidth;
					// basic math to find out where the tile is coming from on the source image
					tileGid -= currentTileset.firstgid -1 ;
					var sourceY:int = Math.ceil(tileGid/currentTileset.tileAmountWidth)-1;
					var sourceX:int = tileGid - (currentTileset.tileAmountWidth * sourceY) - 1;
					
					// copy the tile from the tileset onto our bitmap
					bitmapData.copyPixels(currentTileset.bitmapData, new Rectangle(sourceX * currentTileset.tileWidth, sourceY * currentTileset.tileWidth, currentTileset.tileWidth, currentTileset.tileHeight), new Point(destX, destY), null, null, true);
				}
			}
		}
	}
}