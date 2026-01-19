/**
 * Test case: Useless super() call.
 * AS3 allows calling super() in a class that doesn't explicitly extend anything (it extends Object).
 * Haxe forbids super() calls if there is no super class.
 * The converter should remove redundant super() calls.
 */
package {
    public class TestRemoveRedundantSuperCtorCall {
        public function TestRemoveRedundantSuperCtorCall() {
            super(); // useless
        }
    }
}

class TestRemoveRedundantSuperCtorCall2 extends TestRemoveRedundantSuperCtorCall {
    public function TestRemoveRedundantSuperCtorCall2() {
        super(); // NOT useless
    }
}

class TestRemoveRedundantSuperCtorCall3 {
    public function TestRemoveRedundantSuperCtorCall3() {
        super(); // useless
    }
}