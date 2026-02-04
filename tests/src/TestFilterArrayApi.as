/**
 * Test case: ArrayApi filter rewrites.
 * sortOn defaults to options = 0 and routes to ASCompat.ASArray.sortOn.
 * sort uses Reflect.compare for statements and ASCompat.ASArray.sort for value usage.
 * sort options route to ASCompat.ASArray.sortWithOptions.
 * concat/join/push/unshift/length/insertAt/splice are rewritten as needed.
 * reverse/map/some route to compat helpers for Array/Vector.
 * untyped concat arguments should report a non-blocking error.
 * Vector sort/splice paths are covered.
 */
package {
    public class TestFilterArrayApi {
        public function TestFilterArrayApi() {
            var items:Array = [{n: "b"}, {n: "a"}];
            items = items.sortOn("n");
            items = items.sortOn("n", Array.CASEINSENSITIVE | Array.DESCENDING);
            var items2:Array = [{a: 1, b: "b"}, {a: 1, b: "a"}];
            items2 = items2.sortOn(["a", "b"], [Array.NUMERIC, Array.CASEINSENSITIVE]);

            items.sort();
            items = items.sort();

            var sorter:Function = function(a:*, b:*):int {
                return 0;
            };
            items.sort(sorter);
            items = items.sort(sorter);
            items = items.sort(Array.NUMERIC);

            var copy:Array = items.concat();
            var merged:Array = items.concat([1, 2]);
            var withOne:Array = items.concat(3);
            var any:* = {};
            items.concat(any);

            var joined:String = items.join();

            items.reverse();
            items = items.reverse();

            var anyFound:Boolean = items.some(function(item:*, index:int, array:Array):Boolean {
                return item != null;
            }, this);

            var mapped:Array = items.map(function(item:*, index:int, array:Array):* {
                return item;
            }, this);

            var newLen:int = items.push(1, 2);
            items.unshift(3, 4);

            items.length = 1;
            var len:int = (items.length = 2);

            items.insertAt(1, 9);

            items.splice(1, 0, 7);
            var removed:Array = items.splice(1, 2);
            items.splice(1);
            var removed2:Array = items.splice(1, 2, 3, 4);

            var vec:Vector.<int> = new Vector.<int>();
            vec.push(1);
            vec.sort(function(a:int, b:int):int {
                return a - b;
            });
            vec = vec.sort(function(a:int, b:int):int {
                return a - b;
            });
            vec = vec.sort(Array.DESCENDING);
            vec.splice(0, 0, 5);
            vec.splice(1);
            vec.splice(1, 2, 3, 4);

            var vec2:Vector.<int> = new Vector.<int>();
            vec2.push(1);
            vec2.reverse();
            vec2 = vec2.reverse();
            var mappedVec:Vector.<int> = vec2.map(function(item:int, index:int, vector:Vector.<int>):int {
                return item + 1;
            }, this);
        }
    }
}
