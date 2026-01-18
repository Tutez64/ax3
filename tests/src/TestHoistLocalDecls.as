/**
 * Test case: local variable used before declaration.
 * AS3 allows referencing a local declared later in the same block.
 * The variable should be hoisted to the top of the block.
 */
package {
    public class TestHoistLocalDecls {
        public function TestHoistLocalDecls() {
            var doThings:Function = function():void {
                function1();
                function3();
            };

            function2();
            function3();

            var function1:Function = function():void {
                x = 2;
                y = 3;
                var x;
                var y;
            };

            var function2:Function = function():void {
            };

            var function3:Function = function():void {
            };
        }
    }
}