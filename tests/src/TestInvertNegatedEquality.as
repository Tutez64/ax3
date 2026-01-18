/**
 * Test case: Negated equality comparisons.
 * `!(a == b)` should become `a != b`.
 * `!(a != b)` should become `a == b`.
 */
package {
    public class TestInvertNegatedEquality {
        public function TestInvertNegatedEquality() {
            var a:int = 1;
            var b:int = 2;
            var c:Boolean = !(a == b);
            var d:Boolean = !(a != b);
        }
    }
}