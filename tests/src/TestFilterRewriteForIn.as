/**
 * Test case for RewriteForIn filter.
 * `for each` over Object should iterate values via iterator() in Haxe output.
 * `for in` over Object should iterate keys.
 */
package {
    public class TestFilterRewriteForIn {
        public function TestFilterRewriteForIn() {
            var obj:Object = { "a": 1, "b": 2 };
            var sum:int = 0;

            // Value iteration for Object should use iterator() in Haxe.
            for each (var v:* in obj) {
                sum += int(v);
            }

            // Key iteration for Object should use keys/___keys() in Haxe.
            for (var k:String in obj) {
                sum += k.length;
            }
        }
    }
}
