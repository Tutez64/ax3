/**
 * Test case for AddMissingAccessorInSuper filter.
 * Superclasses with only getter/setter should receive missing accessors
 * when subclasses introduce the complementary accessor.
 * This filter changes the class declaration (adds the missing accessor in the parent).
 */
package {
    public class TestFilterAddMissingAccessorInSuper {
        public function TestFilterAddMissingAccessorInSuper() {
            var childA:ChildWithSetter = new ChildWithSetter();
            childA.value = 2;

            var childB:ChildWithGetter = new ChildWithGetter();
            var name:String = childB.name;
        }
    }
}

class BaseWithGetter {
    protected var _value:int = 1;

    public function get value():int {
        return _value;
    }
}

class ChildWithSetter extends BaseWithGetter {
    public function set value(v:int):void {
        _value = v;
    }
}

class BaseWithSetter {
    protected var _name:String = "";

    public function set name(v:String):void {
        _name = v;
    }
}

class ChildWithGetter extends BaseWithSetter {
    public function get name():String {
        return _name;
    }
}
