/**
 * Helper for FixOverrides tests.
 * Overrides getter/setter without explicit override keywords.
 */
package TestFilterFixOverrides {
    public class AccessorChild extends AccessorBase {
        public function AccessorChild() {
            super();
        }

        public function get value():int {
            return super.value;
        }

        public function set value(v:int):void {
            super.value = v;
        }
    }
}
