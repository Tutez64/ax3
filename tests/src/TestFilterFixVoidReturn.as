/**
 * Test case for FixVoidReturn filter.
 * Covers return; in non-void functions.
 */
package {
    public class TestFilterFixVoidReturn {
        public function returnsAny(flag:Boolean):* {
            if (flag) return 1;
            return;
        }

        public function returnsAnyMissing(flag:Boolean):* {
            if (flag) return 1;
        }

        public function returnsObject(flag:Boolean):Object {
            if (flag) return {};
            return;
        }

        public function returnsNumber(flag:Boolean):Number {
            if (flag) return 1.5;
            return;
        }

        public function returnsInt(flag:Boolean):int {
            if (flag) return 1;
            return;
        }

        public function returnsUint(flag:Boolean):uint {
            if (flag) return 1;
            return;
        }

        public function returnsBool(flag:Boolean):Boolean {
            if (flag) return true;
            return;
        }
    }
}
