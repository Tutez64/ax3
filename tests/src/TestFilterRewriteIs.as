/**
 * Test case: `is` operator rewrites.
 * `x is Function` should become `Reflect.isFunction(x)`.
 * `x is Object` should become `x != null`.
 * XML/XMLList should use a typeReference() helper to avoid abstract-as-value issues.
 * Other types should use `Std.isOfType`.
 */
package {
    public class TestFilterRewriteIs {
        public function TestFilterRewriteIs() {
            var any:Object = {};
            var isFunc:Boolean = (any is Function);
            var isObj:Boolean = (any is Object);
            var isString:Boolean = (any is String);
            var isXml:Boolean = (any is XML);
            var isXmlList:Boolean = (any is XMLList);
        }
    }
}
