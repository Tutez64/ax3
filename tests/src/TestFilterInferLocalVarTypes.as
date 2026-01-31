/**
 * Test case: type of a local variable should be inferred from its usage.
 * This test case verifies that local variable types are correctly inferred
 * based on their usage within the code. It covers various scenarios including
 * basic literal inference, uninitialized variables, and complex expressions.
 */
package {
    import flash.filters.ColorMatrixFilter;
    import flash.display.Sprite;

    public class TestFilterInferLocalVarTypes {
        public function TestFilterInferLocalVarTypes() {
            // Case 0: Basic literal inference
            var i = 0;
            i++; // Int

            var n = 1.5;
            n = 2.5; // Number

            var flag = true;
            flag = false; // Bool

            var text = "hello";
            text += "!"; // String

            var mixed = 0;
            mixed = "oops"; // ASAny (incompatible)

            // Case 1: Uninitialized var, inferred from usage (Bitwise)
            var bitVar:*; // ASAny
            var res1 = bitVar >> 5; // Implies bitVar is Int
            // bitVar should be Int

            // Case 2: Uninitialized var, inferred from usage (Arithmetic)
            var numVar:*;
            var res2 = numVar - 15; // Implies numVar is Number (or Int)
            // numVar should be Number (or Int)

            // Case 3: Assignment from complex expression
            var complexInt:*;
            complexInt = (i << 2) ^ (i >>> 3); // Implies Int
            // complexInt should be Int

            // Case 4: Assignment with increment embedded
            var loopVar:*;
            var other:*;
            var arr:Array = [];
            other = arr[loopVar++]; // loopVar++ implies numeric.
            // loopVar should be Int (or Number)
            
            // Case 5: Inferred from first assignment
            var assignedLater:*;
            assignedLater = 10;
            // assignedLater should be Int

            // Case 6: Read before write (Unsafe)
            var unsafe:*;
            var val = unsafe; // Read!
            unsafe = 10;
            // unsafe should remain ASAny because it was read before type was known.
            
            // Case 7: Math call inference
            var mathVal:*;
            mathVal = Math.round(1.5); // Should imply Number
            // mathVal should be Number
            
            // Case 8: Array Access Index Inference
            var idx:*;
            var arr2:Array = [];
            var val2 = arr2[idx]; // idx used as index
            // idx should be Int
            
            // Case 9: Array Literal Inference
            var arrVar:*;
            arrVar = [1, 2, 3];
            // arrVar should be Array (or Array<Any>)
            
            // Case 10: OpAdd inference
            var sum:*;
            sum = 1 + 2; // Number/Int
            // sum should be Number
            
            var strSum:*;
            strSum = "a" + "b"; // String
            // strSum should be String
            
            var mixedSum:*;
            mixedSum = "a" + 1; // String
            // mixedSum should be String
            
            // Case 11: ColorMatrixFilter matrix
            var matrixVar:*;
            matrixVar = [1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0];
            var cmf:ColorMatrixFilter = new ColorMatrixFilter(matrixVar);
            cmf.matrix = matrixVar;
            // matrixVar should be Array
            
            // Case 12: Class Instantiation Inference
            var spriteVar:*;
            spriteVar = new Sprite();
            // spriteVar should be Sprite
            
            var filterVar:*;
            filterVar = new ColorMatrixFilter();
            // filterVar should be ColorMatrixFilter
        }
    }
}
