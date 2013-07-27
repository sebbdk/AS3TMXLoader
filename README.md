AS3TMXLoader
============

Parses a XML Tiled TMX file and loads assets and creates bitmap layers

#Note:
I wrote this to scratch my own itch, use it any way you like. 
Oh and this is a alpha so breaking changes are liable to happen since this was hastily written.
	
#Usage example:

	tmxLoader = new TMXLoader("levels/demo_001_basic/level.tmx");
	tmxLoader.addEventListener(Event.COMPLETE, onLevelLoaded);
	tmxLoader.load();
	

	public function onLevelLoaded(evt:Event):void {
		trace("loaded and ready!");
	
		for each(var layer:Layer in tmxLoader.layers) {
			addChild(layer.displayObject);
		}
	}
	
#Notes:
Each layer object has the properties you specified in Tiled, ObjectLayers contains objects which has the object properties specified in Tiled.
