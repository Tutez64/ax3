/**
 * Test case: Compound assignment operators.
 * `/=`, `*=`, `%=` on int/uint should be rewritten to explicit assignments.
 * `||=` and `&&=` should be rewritten to boolean logic assignments.
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
        }
    }
}
