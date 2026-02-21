/**
 * Test case: dynamic field access on dynamic classes (MovieClip).
 * Expect unknown field writes to use ASCompat.setProperty and reads to keep ASAny casts.
 */
package {
    import flash.display.MovieClip;

    public class TestFilterRewriteDynamicFieldAccess {
        public function TestFilterRewriteDynamicFieldAccess() {
            var mc:MovieClip = new MovieClip();
            mc.worldmap = new MovieClip();
            var value:* = mc.worldmap;
            var ctor:Class = mc.constructor;

            // Dynamic access via a typed holder (x.root) should keep ASAny reads and ASCompat.setProperty writes.
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
