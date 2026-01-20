/**
 * Test case: `delete` rewrites.
 * Object and Dictionary deletes should be rewritten to supported calls.
 * Array deletes should emit warnings but still produce output.
 * Unsupported deletes should report non-blocking errors.
 * XMLList deletes should be rewritten to a compatibility helper.
 */
package {
    import flash.utils.Dictionary;

    public class TestFilterRewriteDelete {
        public function TestFilterRewriteDelete() {
            var obj:Object = {};
            var key:int = 1;
            delete obj["a"];
            delete obj[key];
            delete obj.someField;

            var dict:Dictionary = new Dictionary();
            var dictKey:Object = {};
            delete dict[dictKey];

            var values:Array = [1, 2, 3];
            delete values[0];
            delete values[1];

            var list:XMLList = new XML("<a/><b/>").children();
            delete list[0];
        }
    }
}