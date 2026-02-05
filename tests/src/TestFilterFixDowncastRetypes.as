/**
 * Test case for FixDowncastRetypes filter.
 * Assigning DisplayObject results to MovieClip vars should use explicit casts.
 */
package {
    import flash.display.MovieClip;

    public class TestFilterFixDowncastRetypes {
        public function TestFilterFixDowncastRetypes() {
            var container:DummyContainer = new DummyContainer();
            var clip:MovieClip = container.getChildByName("clip");
            var clip2:MovieClip = container.getChildAt(0);
        }
    }
}

class DummyContainer {
    public function getChildByName(name:String):* {
        return null;
    }

    public function getChildAt(index:int):* {
        return null;
    }
}
