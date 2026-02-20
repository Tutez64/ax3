/**
 * Test case: Compound assignment operators.
 * `/=`, `*=`, `%=` on int/uint should be rewritten to explicit assignments.
 * `||=` and `&&=` should be rewritten to boolean logic assignments.
 * Dynamic field compound assignments should be rewritten with a temporary object target.
 */
package {
    public class TestFilterRewriteAssignOps {
        public function TestFilterRewriteAssignOps() {
            var count:int = 10;
            var denom:Number = 2.5;
            count /= denom;
            count *= denom;
            count %= denom;

            var enabled:Boolean = false;
            enabled ||= true;
            enabled &&= false;

            var flags:int = 1;
            flags |= 2;
            flags &= 3;
            flags ^= 4;
            flags <<= 1;
            flags >>= 1;
            flags >>>= 1;

            var dyn:* = {};
            dyn.node = {};
            dyn.node.x = 1;
            dyn.node.scale = 2;
            dyn.node.x += 100;
            dyn.node.x -= 5;
            dyn.node.scale *= 3;
        }
    }
}
