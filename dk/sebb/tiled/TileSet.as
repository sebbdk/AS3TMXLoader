package dk.sebb.tiled
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class TileSet extends EventDispatcher
	{
		public var firstgid:uint;
		public var lastgid:uint;
		public var name:String;
		public var tileWidth:uint;
		public var source:String;
		public var tileHeight:uint;
		public var imageWidth:uint;
		public var imageHeight:uint;
		public var bitmapData:BitmapData;
		public var tileAmountWidth:uint;
		public var xml:XML;
		
		public static var tiles:Array = [];
		
		public function TileSet(firstgid:int, name:String, tileWidth:Number, tileHeight:Number, source:String, imageWidth:Number, imageHeight:Number, xml:XML)
		{
			this.firstgid = firstgid;
			this.name = name;
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			this.source = source;
			this.imageWidth = imageWidth;
			this.imageHeight = imageHeight;
			this.xml = xml;
			tileAmountWidth = Math.floor(imageWidth / tileWidth);
			lastgid = tileAmountWidth * Math.floor(imageHeight / tileHeight) + firstgid - 1;
			
			parseFuncTiles();
		}
		
		public function parseFuncTiles():void {
			for each (var tile:XML in xml.tile) {
				var localGid:int = parseInt(tile.attribute("id"));
				var funcTile:Object = new Object();

				//parse tile properties
				if(xml.properties) {
					for each (var property:XML in tile.properties.children()) {
						var pname:String = property.attribute("name");
						var pvalue:String = property.attribute("value");
						funcTile[pname] = pvalue;
					}
				}
				tiles[localGid + firstgid] = funcTile;
			}
		}
	}
}