/**
 * Test case for DisplayObjectContainerApi filter.
 * Un-typed DisplayObject access to container fields should be cast to DisplayObjectContainer.
 */
package {
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    public class TestFilterDisplayObjectContainerApi {
        public function TestFilterDisplayObjectContainerApi() {
            var container:* = new Sprite();
            var child:DisplayObject = new Sprite();
            container.addChild(child);
            var found:DisplayObject = container.getChildByName("child");
            var count:int = container.numChildren;
            container.setChildIndex(child, 0);
        }
    }
}
