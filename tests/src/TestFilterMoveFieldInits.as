/**
 * Test case for MoveFieldInits filter.
 * Covers:
 * - Instance field init reading another field.
 * - Instance field init with explicit this.
 * - Instance field init calling an instance method.
 * - Field init that does not touch this (should stay).
 * - Derived class with a super() call.
 */
package {
    public class TestFilterMoveFieldInits extends BaseMoveFieldInits {
        private var a:int = 1;
        private var b:int = a + 1;
        private var c:int = this.a + 2;
        private var d:int = getValue();
        private var e:int = 7;

        public function TestFilterMoveFieldInits() {
            super();
        }

        private function getValue():int {
            return a + 3;
        }
    }
}

class BaseMoveFieldInits {
    public function BaseMoveFieldInits() {
    }
}