package dk.sebb.tiled.layers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import dk.sebb.tiled.TMXLoader;
	import dk.sebb.tiled.TileSet;
	
	public dynamic class Layer extends EventDispatcher
	{
		public var layer:XML;
		public var map:Array;
		
		public var bitmapData:BitmapData;
		public var displayObject:MovieClip = new MovieClip();
		public var name:String;
		public var tmxLoader:TMXLoader;
		
		public var display:String = "true";
		
		public function Layer(_layer:XML, _tmxLoader:TMXLoader) {
			layer = _layer;
			tmxLoader = _tmxLoader;
			name = layer.attribute("name")[0];
			parseProperties();
			parseLayer();
		}
		
		/**
		 * Parses the layer into a map
		 * */
		protected function parseLayer():void {
			displayObject.removeChildren();
			
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
		
		public function parseProperties():void {
			//parse layer properties
			if(layer.properties) {
				for each (var property:XML in layer.properties.children()) {
					var pname:String = property.attribute("name");
					var pvalue:String = property.attribute("value");
					this[pname] = pvalue;	
				}
			}
		}
		
		/**
		 * Draws/Redraws the map on the instance bitmapdata attribute
		 * */
		public function draw():void {
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
			
			displayObject.addChild(new Bitmap(bitmapData));
		}
	}
}