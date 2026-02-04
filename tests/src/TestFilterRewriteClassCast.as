/**
 * Test case for RewriteClassCast filter.
 * Covers Class(expr) casts to Class.
 */
package {
    public class TestFilterRewriteClassCast {
        public function TestFilterRewriteClassCast() {
            var any:* = Object;
            var cls:Class = Class(any);
            var cls2:Class = Class(Object);
            if (cls == null || cls2 == null) {
                trace(cls, cls2);
            }
        }
    }
}
