/**
 * Test case for NumberToInt filter.
 * AS3 often uses Numbers where Haxe expects Int.
 * This filter should add Std.int() where necessary.
 */
package {
    public class TestFilterNumberToInt {
        public function TestFilterNumberToInt() {
            var n:Number = 10.5;
            var i:int = n;
            
            var arr:Array = [1, 2, 3];
            var val:* = arr[n];
            
            var s:String = "abc";
            var char:* = s.charAt(n);

            takeInt(n);
        }

        public function takeInt(val:int):void {}
    }
}
