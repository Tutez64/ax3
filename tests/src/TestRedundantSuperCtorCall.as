/**
 * Test case: Useless super() call.
 * AS3 allows calling super() in a class that doesn't explicitly extend anything (it extends Object).
 * Haxe forbids super() calls if there is no super class.
 * The converter should remove redundant super() calls.
 */
package {
    public class TestRedundantSuperCtorCall {
        public function TestRedundantSuperCtorCall() {
            super(); // useless
        }
    }
}

class TestRedundantSuperCtorCall2 extends TestRedundantSuperCtorCall {
    public function TestRedundantSuperCtorCall2() {
        super(); // NOT useless
    }
}

class TestRedundantSuperCtorCall3 {
    public function TestRedundantSuperCtorCall3() {
        super(); // useless
    }
}