/**
 * Test case for MoveCtorBaseFieldAssignAfterSuper filter.
 *
 * Expectations:
 * - Only trailing assignments to base class fields immediately before super() are moved after super().
 * - Assignments to subclass fields before super() stay in place.
 * - Assignments nested inside other statements (like if blocks) are not moved.
 * - Constructors where super() is already first remain unchanged.
 */
package {
    public class TestFilterMoveCtorBaseFieldAssignAfterSuper {
        public function TestFilterMoveCtorBaseFieldAssignAfterSuper() {
            var a:ChildWithPreSuperBaseAssigns = new ChildWithPreSuperBaseAssigns(10);
            var b:ChildSuperFirst = new ChildSuperFirst();
            var c:ChildNoSuperCall = new ChildNoSuperCall();
        }
    }
}

class BaseWithFields {
    public var baseA:int = 0;
    public var baseB:int = 0;
}

class ChildWithPreSuperBaseAssigns extends BaseWithFields {
    public var ownA:int = 0;

    public function ChildWithPreSuperBaseAssigns(v:int) {
        baseA = v;       // should stay before super() (not trailing)
        ownA = 3;        // should stay before super()
        if (v > 0) {
            baseA = 4;   // should stay before super() (nested statement)
        }
        this.baseB = 2;  // should move after super() (trailing)
        super.baseA = 6; // should move after super() (trailing, explicit super access)
        super();
        baseA = 5;       // should stay after super()
    }
}

class ChildSuperFirst extends BaseWithFields {
    public function ChildSuperFirst() {
        super();
        baseA = 1; // already after super(), should remain as-is
    }
}

class ChildNoSuperCall extends BaseWithFields {
    public function ChildNoSuperCall() {
        baseA = 2; // no super() call, should remain as-is
    }
}
