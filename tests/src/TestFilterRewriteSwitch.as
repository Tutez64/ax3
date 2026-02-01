/**
 * Test case for RewriteSwitch filter.
 * Covers:
 * - Basic switch (trailing breaks removed).
 * - Nested break (should wrap in do-while loop).
 * - Fall-through cases (grouped).
 * - Default case.
 * - Continue inside switch (should use flag rewrite).
 */
package {
    public class TestFilterRewriteSwitch {
        public function testBasic(val:int):void {
            var res:int = 0;
            switch(val) {
                case 1:
                    res = 10;
                    break;
                case 2:
                    res = 20;
                    break;
                default:
                    res = 30;
                    break;
            }
        }

        public function testNestedBreak(val:int):void {
            var res:int = 0;
            switch(val) {
                case 1:
                    if (val > 0) {
                        res = 10;
                        break; // Nested break triggers loop wrapper
                    }
                    res = 20;
                    break;
            }
        }

        public function testFallThrough(val:int):void {
            switch(val) {
                case 1:
                case 2:
                    trace("1 or 2");
                    break;
            }
        }

        public function testContinue(val:int):void {
            var res:int = 0;
            for (var i:int = 0; i < 3; i++) {
                switch(val) {
                    case 0:
                        continue;
                    case 1:
                        if (i > 0) {
                            res++;
                            break;
                        }
                        res += 2;
                        break;
                }
            }
        }
    }
}
