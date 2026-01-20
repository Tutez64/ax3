/**
 * Test case for RewriteArrayAccess filter.
 * AS3 Array access on non-Array objects (like Object or Dictionary) 
 * might need special handling if not using standard Haxe access.
 */
package {
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;

    public class TestFilterRewriteArrayAccess {
        public function TestFilterRewriteArrayAccess() {
            var obj:Object = { "a": 1, "b": 2 };
            var dict:Dictionary = new Dictionary();
            dict["key"] = "value";

            var val1:* = obj["a"];
            var val2:* = dict["key"];

            var key:String = "b";
            obj[key] = 3;

            var arr:Array = [];

            // Trigger "Array access using Number index"
            var num:Number = 0;
            var val3:Object = arr[num];

            // Trigger "String index used for array access on Array"
            var val4:Object = arr["0"];

            // Trigger "Non-integer index used for array access on Array/Vector"
            var val5:Object = arr[obj];

            // Trigger "Dictionary access using Number index"
            var val6:Object = dict[num];

            // Trigger "Dynamic array access?"
            var any:*;
            var val7:Object = any[0];

            // Trigger "ByteArray access using Number index"
            var barr:ByteArray = new ByteArray();
            var val8:Object = barr[num];

            // Trigger "Invalid dictionary key type"
            // @haxe-type(Dictionary<String, Dynamic>)
            var dictStr:Dictionary = new Dictionary();
            var val9:Object = dictStr[0];
        }
    }
}
