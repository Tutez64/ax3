/**
 * Test case: `is` operator rewrites.
 * `x is Function` should become `Reflect.isFunction(x)`.
 * `x is Object` should become `x != null`.
 * Other types should use `Std.isOfType`.
 */
package {
    public class TestIs {
        public function TestIs() {
            var any:Object = {};
            var isFunc:Boolean = (any is Function);
            var isObj:Boolean = (any is Object);
            var isString:Boolean = (any is String);
        }
    }
}