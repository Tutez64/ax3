/**
 * Helper for FixOverrides tests.
 * Ensures Array subclass push keeps varargs in the override signature.
 */
package TestFilterFixOverrides {
    public dynamic class ArrayChild extends Array {
        public function ArrayChild() { super(); }

        override AS3 function push(...rest):uint { return super.push(rest[0]); }
    }
}
