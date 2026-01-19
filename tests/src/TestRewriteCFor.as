/**
 * Test case: C-style for loops.
 * Simple integer sequences should be rewritten to Haxe int iterators.
 * Boundaries like `<=` should be normalized to the exclusive upper bound.
 */
package {
    public class TestRewriteCFor {
        public function TestRewriteCFor() {
            var sum:int = 0;
            var limit:int = 3;

            for (var i:int = 0; i < limit; i++) {
                sum += i;
            }

            for (var j:int = 0; j <= 2; j++) {
                sum += j;
            }
        }
    }
}