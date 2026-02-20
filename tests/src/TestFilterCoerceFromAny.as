/**
 * Test case for CoerceFromAny filter.
 * Covers:
 * - ASAny to class types.
 * - ASAny to array types.
 * - Untyped array literals mixing different types in ASAny context.
 */
package {
    import flash.display.Sprite;
    import flash.filters.BitmapFilter;
    import flash.filters.BlurFilter;

    public class TestFilterCoerceFromAny {
        public function TestFilterCoerceFromAny() {
            var anySprite:* = new Sprite();
            var sprite:Sprite = anySprite;

            var anyFilter:* = new BlurFilter();
            var filter:BitmapFilter = anyFilter;

            var anyArray:* = [1, 2, 3];
            var arr:Array = anyArray;

            var mixedStore:Object = {};
            var fn:Function = function():void {};
            var args:Array = [1, 2, 3];
            mixedStore["bind"] = [fn, args];
            mixedStore["menu"] = new Array(10, args, "label");
        }
    }
}
