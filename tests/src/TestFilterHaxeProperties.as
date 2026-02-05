/**
 * Test case for HaxeProperties filter.
 * Accessor pairs should be converted into Haxe properties and keep visibility rules.
 */
package {
    public class TestFilterHaxeProperties {
        private var _value:int = 0;
        private var _name:String = "";

        public function TestFilterHaxeProperties() {
            value = 5;
            name = "ok";
        }

        public function get value():int {
            return _value;
        }

        public function set value(v:int):void {
            _value = v;
        }

        public function get name():String {
            return _name;
        }

        public function set name(v:String):void {
            _name = v;
        }

        public function get readOnly():int {
            return _value;
        }

        public function set writeOnly(v:String):void {
            _name = v;
        }
    }
}
