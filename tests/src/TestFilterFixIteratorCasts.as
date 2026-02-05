/**
 * Test case for FixIteratorCasts filter.
 * Assigning an untyped iterator to IIterator should be wrapped with a cast.
 */
package {
    import org.as3commons.collections.framework.IIterator;

    public class TestFilterFixIteratorCasts {
        public function TestFilterFixIteratorCasts() {
            var list:DummyList = new DummyList();
            var it:IIterator = list.iterator();
            if (it != null && it.hasNext()) {
                trace(it);
            }
        }
    }
}

class DummyList {
    public function iterator():* {
        return new DummyIterator();
    }
}

class DummyIterator {
    public function hasNext():Boolean {
        return false;
    }
}
