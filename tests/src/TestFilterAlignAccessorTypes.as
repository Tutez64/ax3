/**
 * Test case for AlignAccessorTypes filter.
 * Getter/setter signatures should align with the property type when one side is untyped.
 */
package {
    public class TestFilterAlignAccessorTypes {
        private var _count:int = 0;
        private var _name:String = "";

        public function TestFilterAlignAccessorTypes() {
            count = 3;
            var c:int = count;
            name = "test";
            var n:String = name;
        }

        public function get count():* {
            return _count;
        }

        public function set count(value:int):void {
            _count = value;
        }

        public function get name():String {
            return _name;
        }

        public function set name(value:*):void {
            _name = value;
        }
    }
}
