/**
 * Test case for ApiSignatureOverrides filter.
 * Covers:
 * - TextFormat color argument coercions.
 * - Error id argument coercions.
 * - DisplayObjectContainer.setChildIndex coercions.
 */
package {
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.text.TextFormat;

    public class TestFilterApiSignatureOverrides {
        public function TestFilterApiSignatureOverrides() {
            var n:Number = 3.5;
            var u:uint = 0x112233;
            var i:int = 0x445566;
            var any:* = getAny();
            var nullColor:* = null;

            var tf1:TextFormat = new TextFormat("Arial", 12, n);
            var tf2:TextFormat = new TextFormat("Arial", 12, u);
            var tf3:TextFormat = new TextFormat("Arial", 12, i);
            var tf4:TextFormat = new TextFormat("Arial", 12, any);
            var tf5:TextFormat = new TextFormat("Arial", 12, nullColor);

            var err1:Error = new Error("message", n);
            var err2:Error = new Error("message", u);
            var err3:Error = new Error("message", i);
            var err4:Error = new Error("message", any);
            var err5:Error = new Error("message", nullColor);

            var container:DisplayObjectContainer = new Sprite();
            var child:DisplayObject = new Sprite();
            container.addChild(child);
            container.setChildIndex(child, n);
            container.setChildIndex(child, u);
            container.setChildIndex(child, i);
            container.setChildIndex(child, getAny());
        }

        private function getAny():* {
            return 3.5;
        }
    }
}
