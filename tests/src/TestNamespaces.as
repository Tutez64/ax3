/**
 * Test case: namespace-qualified access and namespace modifiers.
 * `use namespace` at class scope should allow `ns::field` and `obj.ns::field`.
 * Members declared with a namespace modifier should be parsed and preserved.
 */
package {
    public class TestNamespaces {
        use namespace testns;

        testns var nsValue:int = 1;
        testns function nsMethod():int { return 2; }

        public function TestNamespaces() {
            var a:int = testns::nsValue;
            var b:int = this.testns::nsValue;
            var c:int = testns::nsMethod();
            var d:int = this.testns::nsMethod();

            var other:NamespaceOther = new NamespaceOther();
            var e:int = other.testns::otherValue;
            var f:int = other.testns::otherMethod();
        }
    }
}

class NamespaceOther {
    testns var otherValue:int = 10;
    testns function otherMethod():int { return 20; }

    public function NamespaceOther() {
    }
}
