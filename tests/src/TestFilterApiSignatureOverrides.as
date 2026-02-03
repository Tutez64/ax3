/**
 * Test case for ApiSignatureOverrides filter.
 * Covers:
 * - TextFormat color argument coercions.
 * - ByteArray write* argument coercions.
 */
package {
    import flash.text.TextFormat;
    import flash.utils.ByteArray;

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

            var bytes:ByteArray = new ByteArray();
            var f:Number = 255.75;
            var d:* = 128;

            bytes.writeUnsignedInt(f);
            bytes.writeUnsignedInt(d);
            bytes.writeInt(f);
            bytes.writeInt(d);
            bytes.writeShort(f);
            bytes.writeShort(d);
            bytes.writeByte(f);
            bytes.writeByte(d);
        }
    }
}
