/**
 * Test case for CoerceToNumber filter.
 * Covers:
 * - ASAny to int/uint/Number in assignments and args.
 * - String/Boolean to int/uint/Number.
 * - Number to int/uint truncation.
 */
package {
    public class TestFilterCoerceToNumber {
        public function TestFilterCoerceToNumber() {
            var any:* = "42";
            var num:Number = any;
            var i:int = any;
            var u:uint = any;

            var s:String = "7";
            var i2:int = s;
            var n2:Number = s;

            var b:Boolean = true;
            var i3:int = b;
            var u3:uint = b;

            var f:Number = 3.9;
            var i4:int = f;
            var u4:uint = f;

            takesInt(any);
            takesUInt(any);
            takesNumber(any);
        }

        private function takesInt(v:int):void {}
        private function takesUInt(v:uint):void {}
        private function takesNumber(v:Number):void {}
    }
}
