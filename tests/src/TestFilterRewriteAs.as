/**
 * Test case: `as` operator rewrites.
 * `obj as Function` should become `ASCompat.asFunction(obj)`.
 * `obj as Dictionary` should become `ASDictionary.asDictionary(obj)`.
 * `obj as Array` should use the compatibility helper.
 * `obj as XML` should become a retype cast.
 * `obj as XMLList` should become a retype cast.
 * `as` with basic types should report a non-blocking error.
 */
package {
    import flash.utils.Dictionary;

    public class TestFilterRewriteAs {
        public function TestFilterRewriteAs() {
            var obj:Object = {};
            var f:Function = obj as Function;
            var dict:Dictionary = obj as Dictionary;
            var arr:Array = obj as Array;
            var xml:XML = obj as XML;
            var xmlList:XMLList = obj as XMLList;
            var num:Number = obj as Number;
            var flag:Boolean = obj as Boolean;
        }
    }
}
