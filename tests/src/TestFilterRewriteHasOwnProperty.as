/**
 * Test case: hasOwnProperty on non-Dictionary values.
 * Calls on class instances should be rewritten to use an explicit `this` retype.
 * Unqualified `hasOwnProperty` should be treated as instance access.
 * XML/XMLList calls should pass through as untyped hasOwnProperty usage.
 * The `in` operator should rewrite to `exists` for Dictionary/DynamicAccess,
 * and to hasOwnProperty elsewhere (with string coercion when needed).
 */
package {
    import flash.utils.Dictionary;

    public class TestFilterRewriteHasOwnProperty {
        public function TestFilterRewriteHasOwnProperty() {
            var obj:Object = {};
            var hasKey1:Boolean = obj.hasOwnProperty("a");
            var hasKey2:Boolean = hasOwnProperty("b");
            var xml:XML = new XML("<root><item/></root>");
            var xmlList:XMLList = xml.children();
            var hasXml:Boolean = xml.hasOwnProperty("item");
            var hasXmlList:Boolean = xmlList.hasOwnProperty("item");
            // `in` operator rewrites.
            var dict:Dictionary = new Dictionary();
            var hasDict:Boolean = "a" in dict;
            var hasObjIn:Boolean = "a" in obj;
            var hasObjInNum:Boolean = 1 in obj;
            // @haxe-type(haxe.DynamicAccess<String>)
            var map:Object = {};
            var hasMap:Boolean = "a" in map;
            var hasThis:Boolean = "prop" in this;
            var hasXmlIn:Boolean = "item" in xml;
            var hasXmlListIn:Boolean = "item" in xmlList;
        }
    }
}
