/**
 * Test case: local variable hoisting in AS3-style scoping.
 * Covers:
 * - Use-before-declaration in the same block.
 * - Function literal referencing a later-declared variable (needs hoist).
 * - Self-referential function initializer (needs hoist).
 * - for-each loop var should stay near the loop (no global hoist).
 */
package {
    public class TestFilterHoistLocalDecls {
        public function TestFilterHoistLocalDecls() {
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

            var useLater:Function = function():void {
                laterVar = 1;
            };
            var laterVar:int = 0;

            var selfRef:Function = function():void {
                selfRef();
            };

            var function2:Function = function():String {
                if (1==1)
                {
                    var _loc6_:String = "";
                }
                return _loc6_;
            };

            var function3:Function = function():void {
                var noop:Function = function():void {};
                for each(var nb in [0, 1, 2])
                {
                    function1();
                }
                nb = 0;
            };
        }
    }
}
