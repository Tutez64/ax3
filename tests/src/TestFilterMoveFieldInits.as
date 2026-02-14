/**
 * Test case for MoveFieldInits filter.
 * Covers:
 * - Instance field init reading another field.
 * - Instance field init with explicit this.
 * - Instance field init calling an instance method.
 * - Field init that does not touch this (should stay).
 * - Derived class with a super() call.
 * - Field init depending on base class field assigned before super().
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

// Test case: field init depending on base class field assigned before super()
// The field init must be inserted BEFORE super() to preserve AS3 semantics
class TestMoveFieldInitsBeforeSuper extends BaseWithProtectedField {
    protected var mHelper:Helper;
    // This field init depends on mBaseField which is assigned before super()
    // Therefore it must be initialized BEFORE super() is called
    protected var mComponent:Component = new Component(mBaseField);

    public function TestMoveFieldInitsBeforeSuper(param1:int) {
        mBaseField = param1;
        super(param1);
    }
}

class BaseWithProtectedField {
    protected var mBaseField:int;

    public function BaseWithProtectedField(val:int) {
        // In AS3, child field inits happen before this constructor runs
        // So mComponent is already initialized here
    }
}

class Helper {}

class Component {
    public function Component(val:int) {}
}
