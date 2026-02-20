/**
 * Test case: C/C++ macro name collisions.
 * Some AS3 identifiers (for example USHRT_MAX) collide with common C/C++ macros on hxcpp/MSVC.
 * The converter should rename conflicting declarations and rewrite their typed references.
 */
package {
    public class TestFilterCppMacroConflicts {
        public static const USHRT_MAX:int = 65535;
        public static var INT_MAX:int = 123;

        public var SHRT_MIN:int = 5;

        public function TestFilterCppMacroConflicts() {
            trace(USHRT_MAX);
            trace(TestFilterCppMacroConflicts.INT_MAX);
        }

        public function readValue() : int {
            return SHRT_MIN + INT_MAX + SHRT_MAX();
        }
    }
}

class TestFilterRenameCppMacroConflictsChild extends TestFilterCppMacroConflicts {
    public function TestFilterRenameCppMacroConflictsChild() {
        super();
    }

    public function readParent() : int {
        return this.SHRT_MIN + TestFilterCppMacroConflicts.USHRT_MAX;
    }
}

var UINT_MAX:int = 7;

function SHRT_MAX() : int {
    return UINT_MAX;
}
