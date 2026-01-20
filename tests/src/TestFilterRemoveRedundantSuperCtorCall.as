/**
 * Test case: Useless super() call.
 * AS3 allows calling super() in a class that doesn't explicitly extend anything (it extends Object).
 * Haxe forbids super() calls if there is no super class.
 * The converter should remove redundant super() calls.
 */
package {
    public class TestFilterRemoveRedundantSuperCtorCall {
        public function TestFilterRemoveRedundantSuperCtorCall() {
            super(); // useless
        }
    }
}

class TestFilterRemoveRedundantSuperCtorCall2 extends TestFilterRemoveRedundantSuperCtorCall {
    public function TestFilterRemoveRedundantSuperCtorCall2() {
        super(); // NOT useless
    }
}

class TestFilterRemoveRedundantSuperCtorCall3 {
    public function TestFilterRemoveRedundantSuperCtorCall3() {
        super(); // useless
    }
}