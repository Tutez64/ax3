/**
 * Test case for RewriteCasts filter.
 * Verifies how AS3 casts are converted to Haxe.
 */
package {
    public class TestFilterRewriteCasts {
        public function TestFilterRewriteCasts() {
            var a:Object = "test";
            
            // Basic casts
            var s:String = String(a);
            var i:int = int(a);
            var n:Number = Number(a);
            var b:Boolean = Boolean(a);
            var u:uint = uint(a);

            // Class casts
            var spr:Sprite = Sprite(a);
            
            // Cast on complex expression
            var s2:String = String(a + "suffix");
        }
    }
}

class Sprite {}
