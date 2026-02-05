/**
 * Helper for FixOverrides tests.
 * Defines accessors that should be overridden by subclasses.
 */
package TestFilterFixOverrides {
    public class AccessorBase {
        private var _value:int = 0;

        public function AccessorBase() {}

        public function get value():int {
            return _value;
        }

        public function set value(v:int):void {
            _value = v;
        }
    }
}
