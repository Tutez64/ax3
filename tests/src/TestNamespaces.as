/**
 * Test case: namespace-qualified access and namespace modifiers.
 * `use namespace` at class scope should allow `ns::field`, `obj.ns::field`,
 * and dynamic access like `obj.ns::[name]`.
 * Members declared with a namespace modifier should be parsed and preserved.
 * Unary bitwise negation should not merge with namespace comments.
 * AS3 should become null.
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

            var nsList:Array = [AS3];
            var ns:* = AS3;

            var other:NamespaceOther = new NamespaceOther();
            var e:int = other.testns::otherValue;
            var f:int = other.testns::otherMethod();
            var fieldName:String = "otherValue";
            var otherDyn:Object = other;
            var g:* = otherDyn.testns::[fieldName];
            var h:int = ~testns::nsValue;
            var i:int = ~this.testns::nsValue;
        }
    }
}

class NamespaceOther {
    testns var otherValue:int = 10;
    testns function otherMethod():int { return 20; }

    public function NamespaceOther() {
    }
}
