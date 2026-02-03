/**
 * Test case for FixNonInlineableDefaultArgs filter.
 * Covers:
 * - Non-constant defaults (NaN, new Object, new Point).
 * - Non-inline static field defaults.
 * - Constant defaults left untouched.
 */
package {
    import flash.geom.Point;

    public class TestFilterFixNonInlineableDefaultArgs {
        public static var DEFAULT_COUNT:int = 5;

        public function withDefaults(
            a:Number = NaN,
            b:Object = new Object(),
            c:Point = new Point(1, 2),
            d:int = DEFAULT_COUNT,
            e:String = "ok"
        ):void {
        }
    }
}
