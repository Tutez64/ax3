/**
 * Test case: typeof.
 * Expect conversion to ASCompat.typeof(this.vars.ease) == "function".
 */
package {
    public class TestTypeof {
        public var vars:*;

        public function TestTypeof() {
            vars = {};
        }

        public function check():void {
            if (typeof this.vars.ease == "function") {
            }
        }
    }
}
