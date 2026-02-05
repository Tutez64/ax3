/**
 * Test case for RewriteObjectCompare filter.
 * Object comparisons should be rewritten to Reflect.compare while numeric/string remain direct.
 */
package {
    public class TestFilterRewriteObjectCompare {
        public function TestFilterRewriteObjectCompare() {
            var a:Foo = new Foo();
            var b:Foo = new Foo();
            var less:Boolean = a < b;
            var greater:Boolean = a >= b;

            var numA:int = 1;
            var numB:int = 2;
            var numLess:Boolean = numA < numB;

            var strLess:Boolean = "a" < "b";
        }
    }
}

class Foo {
    public function Foo() {}
}
