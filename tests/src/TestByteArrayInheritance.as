/**
 * Test case: class extending ByteArray should be rewritten to ASByteArrayBase.
 * Expect extends ASByteArrayBase so it compiles on non-Flash targets where ByteArray is an abstract.
 */
package {
    import flash.utils.ByteArray;

    public class TestByteArrayInheritance extends ByteArray {
        public function TestByteArrayInheritance() {
            super();
            endian = "littleEndian";
        }

        public function copyTo(out:ByteArray):void {
            var p:uint = position;
            position = 0;
            readBytes(out);
            position = p;
        }
    }
}
