/**
 * Helper class for TestFilterToString.
 * Provides an explicit toString() implementation to ensure it is not rewritten.
 */
package {
    public class HasToString {
        public function HasToString() {}

        public function toString():String {
            return "ok";
        }
    }
}
