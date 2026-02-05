/**
 * Test case for ColorMatrixFilterApi filter.
 * Ensures ColorMatrixFilter constructor and matrix assignment coerce Array values to Float arrays.
 */
package {
    import flash.filters.ColorMatrixFilter;

    public class TestFilterColorMatrixFilterApi {
        public function TestFilterColorMatrixFilterApi() {
            var matrix:Array = [1, 0, 0, 0, 0,
                                0, 1, 0, 0, 0,
                                0, 0, 1, 0, 0,
                                0, 0, 0, 1, 0];
            var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
            filter.matrix = matrix;
            filter.matrix = [1, 0, 0, 0, 0,
                             0, 1, 0, 0, 0,
                             0, 0, 1, 0, 0,
                             0, 0, 0, 1, 0];
        }
    }
}
