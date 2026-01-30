/**
 * Test case: class extending Array should be rewritten to ASArrayBase.
 * Expect extends ASArrayBase and array-style access/length usage to compile.
 */
package {
    public dynamic class TestArrayInheritance extends Array {
        public function TestArrayInheritance() {
            super();
        }

        override AS3 function push(...rest):uint {
            var idx:uint = super.push(rest[0]);
            this.sort(compare);
            return idx;
        }

        override AS3 function pop():* {
            return splice(0, 1);
        }

        public function front():* {
            return this[0];
        }

        public function contains(value:*):Boolean {
            var i:int = 0;
            while (i != length) {
                if (this[i] == value) {
                    return true;
                }
                i++;
            }
            return false;
        }

        private function compare(a:*, b:*):int {
            return 0;
        }
    }
}
