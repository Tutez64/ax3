/**
 * Test case: Compound assignment operators.
 * `/=`, `*=`, `%=` on int/uint should be rewritten to explicit assignments.
 * `||=` and `&&=` should be rewritten to boolean logic assignments.
 */
package {
    public class TestAssignOps {
        public function TestAssignOps() {
            var count:int = 10;
            var denom:Number = 2.5;
            count /= denom;
            count *= denom;
            count %= denom;

            var enabled:Boolean = false;
            enabled ||= true;
            enabled &&= false;
        }
    }
}