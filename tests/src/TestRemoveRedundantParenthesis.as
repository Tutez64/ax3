/**
 * Test case: Redundant parentheses.
 * Parentheses around simple expressions should be removed in output.
 * `return` and `throw` should keep proper spacing after removal.
 */
package {
    public class TestRemoveRedundantParenthesis {
        public function TestRemoveRedundantParenthesis() {
            var value:int = (1);
            var copy:int = (value);
            var sum:int = (value + 1);
        }

        public function getValue():int {
            var result:int = (10);
            return (result);
        }

        public function throwValue():void {
            var error:Object = "boom";
            throw (error);
        }
    }
}