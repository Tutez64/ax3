/**
 * Test case for ApiSignatureOverrides filter.
 * Covers:
 * - TextFormat color argument coercions.
 */
package {
    import flash.text.TextFormat;

    public class TestFilterApiSignatureOverrides {
        public function TestFilterApiSignatureOverrides() {
            var n:Number = 3.5;
            var u:uint = 0x112233;
            var i:int = 0x445566;
            var any:* = 0x778899;
            var nullColor:* = null;

            var tf1:TextFormat = new TextFormat("Arial", 12, n);
            var tf2:TextFormat = new TextFormat("Arial", 12, u);
            var tf3:TextFormat = new TextFormat("Arial", 12, i);
            var tf4:TextFormat = new TextFormat("Arial", 12, any);
            var tf5:TextFormat = new TextFormat("Arial", 12, nullColor);
        }
    }
}
