package {
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	// Class Metadata Tests
	[Embed(source="/_assets/assets.swf", symbol="symbol27")]
	// Expected: @:native("symbol27")
	[Embed(source="font.ttf", mimeType="application/x-font")]
	// Expected: @:font("font.ttf")
	[Embed(source="data.bin", mimeType="application/octet-stream")]
	// Expected: @:file("data.bin")
	[Embed(source="image.png")]
	// Expected: @:bitmap("image.png")
	public class TestFilterRewriteMeta extends Sprite {

        // Member Metadata Tests

        [Inject]
        // Expected: @:inject
        public var injectVar:Object;

        [PostConstruct]
        // Expected: @:postConstruct
        public function postConstruct():void {}

        [PreDestroy]
        // Expected: @:preDestroy
        public function preDestroy():void {}

        [Inspectable]
        // Expected: @:inspectable
        public var inspectableVar:Object;

        [Bindable]
        // Expected: @:bindable
        public var bindableVar:Object;

        [Event]
        // Expected: @:event
        public var eventVar:Object;

        // HxOverride: Force override keyword
        [HxOverride]
        // Expected: override public function myOverride():void
        public function myOverride():void {}

        // HxCancelOverride: Remove override keyword
        [HxCancelOverride]
        // Expected: public function addChild(child:DisplayObject):DisplayObject
        public override function addChild(child:DisplayObject):DisplayObject { return null; }

        [HxRemove]
        // Expected: (This field should be removed)
        public var removedVar:Object;

        [HxArrayArgType("arg1", "String")]
        // Expected: public function arrayArg(arg1:Array<String>):void
        public function arrayArg(arg1:Array):void {}

        [ArrayElementType("int")]
        // Expected: public var arrayVar:Array<Int>
        public var arrayVar:Array;

        [ArrayElementType("Number")]
        // Expected: public function get arrayGetter():Array<Float>
        public function get arrayGetter():Array { return null; }

        [ArrayElementType("Boolean")]
        // Expected: public function set arraySetter(v:Array<Bool>):void
        public function set arraySetter(v:Array):void {}

        [ArrayElementType("String")]
        // Expected: public function arrayRet():Array<String>
        public function arrayRet():Array { return null; }
	}
}
