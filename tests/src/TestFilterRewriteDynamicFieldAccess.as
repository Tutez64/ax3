/**
 * Test case: dynamic field access on dynamic classes (MovieClip).
 * Expect unknown fields to be accessed through ASAny casts in Haxe output.
 */
package {
    import flash.display.MovieClip;

    public class TestFilterRewriteDynamicFieldAccess {
        public function TestFilterRewriteDynamicFieldAccess() {
            var mc:MovieClip = new MovieClip();
            mc.worldmap = new MovieClip();
            var value:* = mc.worldmap;
            var ctor:Class = mc.constructor;

            // Dynamic access via a typed holder (x.root) should still cast to ASAny in Haxe output.
            var holder:RootHolder = new RootHolder();
            holder.root = new MovieClip();
            holder.root.selectionFrame = new MovieClip();
            holder.root.selectionFrame.visible = false;
        }
    }
}

class RootHolder {
    public var root:MovieClip;
}
