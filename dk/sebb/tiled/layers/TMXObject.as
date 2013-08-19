package dk.sebb.tiled.layers
{
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import nape.geom.Vec2;

	public dynamic class TMXObject extends Shape
	{
		public var object:XML;

		public var display:String = "true";
		public var type:String;
		
		public function TMXObject(_object:XML) {
			object = _object;
			parseProperties();
		}
		
		public function pointIsInside(vec:Vec2):void {
			//#complete me
		}
		
		public function parseProperties():void {
			if(object.attribute("name")[0]) {
				name = object.attribute("name")[0];
			}
			
			//parse layer properties
			if(object.properties) {
				for each (var property:XML in object.properties.children()) {
					var pname:String = property.attribute("name");
					var pvalue:String = property.attribute("value");
					this[pname] = pvalue;
				}
			}
			
			if(display === "false") {
				visible = false;
			}
		}
	}
}