package dk.sebb.tiled.layers
{
	import flash.display.BitmapData;
	
	import dk.sebb.tiled.TMXLoader;
	
	public class Layer
	{
		public var layer:XML;
		public var map:Array;
		
		public var bitmapData:BitmapData;
		public var name:String;
		public var tmxLoader:TMXLoader;
		
		public var display:Boolean = true;
		public var functional:Boolean = false;
		
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
		protected function parseLayer():void {}
		
		public function parseProperties():void {
			//parse layer properties
			if(layer.properties) {
				for each (var property:XML in layer.properties.children()) {
					var pname:String = property.attribute("name");
					var pvalue:* = property.attribute("value");
					
					if(pvalue == "true") {
						pvalue = true;
					}
					
					if(pvalue == "false") {
						pvalue = false;
					}

					this[pname] = pvalue;	
				}
			}
		}
		
		/**
		 * Draws/Redraws the map on the instance bitmapdata attribute
		 * */
		public function draw():void {}
	}
}