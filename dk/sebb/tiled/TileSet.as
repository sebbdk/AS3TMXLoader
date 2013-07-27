package dk.sebb.tiled
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
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
		
		public function TileSet(firstgid:int, name:String, tileWidth:Number, tileHeight:Number, source:String, imageWidth:Number, imageHeight:Number)
		{
			this.firstgid = firstgid;
			this.name = name;
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			this.source = source;
			this.imageWidth = imageWidth;
			this.imageHeight = imageHeight;
			tileAmountWidth = Math.floor(imageWidth / tileWidth);
			lastgid = tileAmountWidth * Math.floor(imageHeight / tileHeight) + firstgid - 1;
		}
	}
}