/**
 * Helper for FixOverrides tests.
 * Overrides a method without override keyword or defaults; the filter should fix it.
 */
package TestFilterFixOverrides {
import TestFilterFixOverrides.OverrideBase;

public class OverrideChild extends OverrideBase {
        public function OverrideChild() {}

        public function Reset(param1:Object, param2:Object):void {}
    }
}
