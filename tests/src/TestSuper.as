package {
    /**
     * Test case: Useless super() call.
     * AS3 allows calling super() in a class that doesn't explicitly extend anything (it extends Object).
     * Haxe forbids super() calls if there is no super class.
     * The converter should remove this redundant super() call.
     */
    public class TestSuper {
        public function TestSuper() {
            super();
        }
    }
}