/**
 * Test case: hasOwnProperty on non-Dictionary values.
 * Calls on class instances should be rewritten to use an explicit `this` retype.
 * Unqualified `hasOwnProperty` should be treated as instance access.
 * XML/XMLList calls should pass through as untyped hasOwnProperty usage.
 */
package {
    public class TestFilterRewriteHasOwnProperty {
        public function TestFilterRewriteHasOwnProperty() {
            var obj:Object = {};
            var hasKey1:Boolean = obj.hasOwnProperty("a");
            var hasKey2:Boolean = hasOwnProperty("b");
            var xml:XML = new XML("<root><item/></root>");
            var xmlList:XMLList = xml.children();
            var hasXml:Boolean = xml.hasOwnProperty("item");
            var hasXmlList:Boolean = xmlList.hasOwnProperty("item");
        }
    }
}
