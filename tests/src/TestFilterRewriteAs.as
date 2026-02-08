/**
 * Test case: `as` operator rewrites.
 * `obj as Function` should become `ASCompat.asFunction(obj)`.
 * `obj as Dictionary` should become `ASDictionary.asDictionary(obj)`.
 * `obj as Array` should use the compatibility helper.
 * `obj as XML` should become `ASCompat.asXML(obj)`.
 * `obj as XMLList` should become `ASCompat.asXMLList(obj)`.
 * `as` with basic types should use `ASCompat.asString`, `ASCompat.asNumber`, etc.
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
            
            var s:String = obj as String;
            var num:Number = obj as Number;
            var flag:Boolean = obj as Boolean;
            var i:int = obj as int;
            var ui:uint = obj as uint;
            
            // Verifying behavior with mismatched types
            var f2:Function = function():void {};
            var s2:String = f2 as String; // Should be null in AS3
            
            var n:Object = 123;
            var s3:String = n as String; // Should be null in AS3
            
            var strObj:Object = "hello";
            var s4:String = strObj as String; // Should be "hello"
        }
    }
}
