/**
 * Test case: block-level `&&` rewrite.
 * `condition && doSomething()` should become `if (condition) doSomething()`.
 */
package {
    public class TestRewriteBlockBinops {
        public function TestRewriteBlockBinops() {
            var ready:Boolean = true;
            ready && initialize();
        }

        private function initialize():void {
        }
    }
}