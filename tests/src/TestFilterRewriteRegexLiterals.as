/**
 * Test case: RegExp literals and RegExp copy construction.
 * `/.../` should be rewritten to `new RegExp("...", "flags")`.
 * `new RegExp(existing)` should reuse the existing instance.
 */
package {
    public class TestFilterRewriteRegexLiterals {
        public function TestFilterRewriteRegexLiterals() {
            var re:RegExp = /ab+c/i;
            var same:RegExp = new RegExp(re);
        }
    }
}