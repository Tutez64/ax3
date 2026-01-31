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
        }
    }
}
