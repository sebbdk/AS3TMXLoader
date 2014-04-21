package dk.sebb.tiled
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import dk.sebb.tiled.layers.ImageLayer;
	import dk.sebb.tiled.layers.ObjectLayer;
	import dk.sebb.tiled.layers.TileLayer;
	import dk.sebb.tiled.loaders.ImageLoader;
	import dk.sebb.tiled.loaders.TilesetLoader;
	
	public dynamic class TMXLoader extends EventDispatcher
	{
		public var levelPath:String;
		public var xmlLoader:URLLoader;
		public var xml:XML;
		
		public var mapWidth:Number;
		public var mapHeight:Number;
		public var tileWidth:Number;
		public var tileHeight:Number;
		
		public var tileImageLoaders:Array = [];
		public var totalAssets:int;
		public var assetsLoaded:int;
		
		public var layers:Array = [];
		public var tileSets:Array = [];
		public var bitmapDatas:Array = [];
		
		public function TMXLoader(_levelPath:String) {
			levelPath = _levelPath;
		}
		
		public function load():void {
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete);
			xmlLoader.load(new URLRequest(levelPath));
		}
		
		private function xmlLoadComplete(e:Event):void {
			xml = new XML(e.target.data);
			mapWidth = xml.attribute("width");
			mapHeight = xml.attribute("height");
			tileWidth = xml.attribute("tilewidth");
			tileHeight = xml.attribute("tileheight");
			var xmlCounter:uint = 0;
			
			//find tile sets
			for each (var tileset:XML in xml.tileset) {
				var imageWidth:uint = tileset.image.attribute("width");
				var imageHeight:uint = tileset.image.attribute("height");
				var firstGid:uint = tileset.attribute("firstgid");
				var tilesetName:String = tileset.attribute("name");
				var tilesetTileWidth:uint = tileset.attribute("tilewidth");
				var tilesetTileHeight:uint = tileset.attribute("tileheight");
				var tilesetImagePath:String = tileset.image.attribute("source");
				tileSets.push(new TileSet(firstGid, tilesetName, tilesetTileWidth, tilesetTileHeight, tilesetImagePath, imageWidth, imageHeight, tileset));
				xmlCounter++;
			}
			totalAssets = xmlCounter;

			//parse map properties
			parseProperties();
			
			// load images from images layers
			loadImageLayerImages();
			
			// load images for tileset
			loadTilesetImages();
		}
		
		private function loadImageLayerImages():void {
			for each (var imageLayer:XML in xml.imagelayer) {
				var loader:ImageLoader = new ImageLoader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadComplete);
				
				var path:Array = levelPath.split('/');
				path.pop();
				var basePath:String = path.join('/') + '/';
				
				loader.filename = imageLayer.image.attribute("source");
				loader.load(new URLRequest(basePath + loader.filename));
				totalAssets++;
			}
		}
		
		private function imageLoadComplete(e:Event):void {
			var filename:String = e.target.loader.filename;
			bitmapDatas[filename] = Bitmap(e.target.content).bitmapData;
			assetsLoaded++;
			
			// wait until all the tileset images are loaded before we combine them layer by layer into one bitmap
			if (assetsLoaded == totalAssets) {
				addTileBitmapData();
			}
		}
		
		private function loadTilesetImages():void {
			for (var i:int = 0; i < tileSets.length; i++) {
				//trace("load tilset at " + tileSets[i].source);
				var loader:TilesetLoader = new TilesetLoader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, tileImageLoadComplete);
				loader.tileSet = tileSets[i];
				
				var path:Array = levelPath.split('/');
				path.pop();
				var basePath:String = path.join('/') + '/';
				
				loader.load(new URLRequest(basePath + tileSets[i].source));
				tileImageLoaders.push(loader);
			}
		}
		
		private function tileImageLoadComplete(e:Event):void {
			var currentTileset:TileSet = e.target.loader.tileSet;
			currentTileset.bitmapData = Bitmap(e.target.content).bitmapData;
			assetsLoaded++;

			// wait until all the tileset images are loaded before we combine them layer by layer into one bitmap
			if (assetsLoaded == totalAssets) {
				addTileBitmapData();
			}
		}
		
		public function parseProperties():void {
			//parse layer properties
			if(xml.attributes()) {
				for each (var attr:XML in xml.attributes()) {
					var aname:String = attr.name();
					var avalue:String = attr.valueOf();
					this[aname] = avalue;	
				}
			}
			
			if(xml.properties) {
				for each (var property:XML in xml.properties.children()) {
					var pname:String = property.attribute("name");
					var pvalue:String = property.attribute("value");
					this[pname] = pvalue;	
				}
			}
		}
		
		private function addTileBitmapData():void {
			
			for each (var layer:XML in xml.children()) {
				switch(layer.localName()) {
					case 'layer':
						layers.push(new TileLayer(layer, this));
						break;
					case 'imagelayer':
						layers.push(new ImageLayer(layer, this));
						break;
					case 'objectgroup':
						layers.push(new ObjectLayer(layer, this));
						break;
				}
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}