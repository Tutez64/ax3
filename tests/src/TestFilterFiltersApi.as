/**
 * Test case for FiltersApi filter.
 * Ensures assignments to `filters` accept untyped arrays.
 */
package {
    import flash.display.Sprite;
    import flash.filters.BlurFilter;

    public class TestFilterFiltersApi {
        public function TestFilterFiltersApi() {
            var sprite:Sprite = new Sprite();
            var filters:Array = [new BlurFilter()];
            sprite.filters = filters;
            sprite.filters = [];
            sprite.filters = null;
            var current:Array = sprite.filters;
            if (current == null) {
                trace(current);
            }
        }
    }
}
