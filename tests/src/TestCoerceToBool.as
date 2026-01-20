/**
 * Test case for CoerceToBool filter.
 * AS3 allow using non-boolean values in conditions.
 * They should be explicitly coerced to boolean in Haxe.
 */
package {
    public class TestCoerceToBool {
        public function TestCoerceToBool() {
            var obj:Object = {};
            var str:String = "hello";
            var num:Number = 123;
            var arr:Array = [];

            if (obj) {}
            if (str) {}
            if (num) {}
            if (arr) {}

            var b:Boolean = obj ? true : false;

            while (str) {
                str = null;
            }

            if (!num) {}
        }
    }
}
