/**
 * Test case for ToString filter.
 * Covers:
 * - Error.toString() should be rewritten to Std.string to avoid missing method on flash.errors.Error.
 * - Custom class with its own toString should remain unchanged.
 * - Primitive toString() and radix toString() stay mapped correctly.
 */
package {
    public class TestFilterToString {
        public function TestFilterToString() {
            var err:Error = new Error("boom");
            var msg:String = err.toString();
            trace(msg);

            var custom:HasToString = new HasToString();
            trace(custom.toString());

            var num:int = 255;
            trace(num.toString());
            trace(num.toString(16));

            var flag:Boolean = true;
            trace(flag.toString());
        }
    }
}
