/**
 * Test case: Useless super() call.
 * AS3 allows calling super() in a class that doesn't explicitly extend anything (it extends Object).
 * Haxe forbids super() calls if there is no super class.
 * The converter should remove redundant super() calls.
 */
package {
    public class TestSuper {
        public function TestSuper() {
            super(); // useless
        }
    }
}

class TestSuper2 extends TestSuper {
    public function TestSuper2() {
        super(); // NOT useless
    }
}

class TestSuper3 {
    public function TestSuper3() {
        super(); // useless
    }
}