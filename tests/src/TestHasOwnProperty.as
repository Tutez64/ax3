/**
 * Test case: hasOwnProperty on non-Dictionary values.
 * Calls on class instances should be rewritten to use an explicit `this` retype.
 * Unqualified `hasOwnProperty` should be treated as instance access.
 */
package {
    public class TestHasOwnProperty {
        public function TestHasOwnProperty() {
            var obj:Object = {};
            var hasKey1:Boolean = obj.hasOwnProperty("a");
            var hasKey2:Boolean = hasOwnProperty("b");
        }
    }
}