/**
 * Test case: string escapes that are invalid in Haxe.
 * Expect \b and \f to be emitted using hex escapes in Haxe literals.
 */
package {
    public class TestStringEscapes {
        public function TestStringEscapes() {
        }

        public function normalize(value:String):String {
            switch (value) {
                case "\b": return "\\b";
                case "\f": return "\\f";
                default: return value;
            }
        }
    }
}
