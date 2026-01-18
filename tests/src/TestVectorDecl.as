/**
 * Test case: Vector literals.
 * `new <T>[...]` should become `Vector.ofArray([...])`.
 * `new <T>[]` should become `new Vector<T>()`.
 * Redundant Vector casts should report a non-blocking error.
 */
package {
    public class TestVectorDecl {
        public function TestVectorDecl() {
            var numbers:Vector.<int> = new <int>[1, 2, 3];
            var empty:Vector.<String> = new <String>[];
            var copy:Vector.<int> = Vector.<int>(numbers);
        }
    }
}