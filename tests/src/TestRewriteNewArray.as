/**
 * Test case: `new Array(...)` rewrites.
 * `new Array(length)` should become `ASCompat.allocArray(length)`.
 * `new Array(a, b, c)` should become an array literal.
 */
package {
    public class TestRewriteNewArray {
        public function TestRewriteNewArray() {
            var sized:Array = new Array(3);
            var values:Array = new Array(1, 2, 3);
        }
    }
}