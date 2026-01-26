/**
 * Test case: float exponent literals without a decimal point should parse.
 * Expected: 1e-8, 1E+8, 0e-2, and 1e8 are treated as Number literals.
 */
package {
    public class TestFloatExponent {
        public function TestFloatExponent() {
            var a:Number = 1e-8;
            var b:Number = 1E+8;
            var c:Number = 0e-2;
            var d:Number = 1e8;
        }
    }
}
