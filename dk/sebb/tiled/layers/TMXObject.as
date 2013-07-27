package dk.sebb.tiled.layers
{
	import flash.display.Shape;

	public class TMXObject extends Shape
	{
		public var object:XML;

		public var display:String = "true";
		public var type:String;
		
		public function TMXObject(_object:XML) {
			object = _object;
			parseProperties();
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
					if(this.hasOwnProperty(pname)) {
						this[pname] = pvalue;
					} else {
						trace('unknown layer property', pname, 'being used on layer' , name);
					}	
				}
			}
			
			if(display === "false") {
				visible = false;
			}
		}
	}
}