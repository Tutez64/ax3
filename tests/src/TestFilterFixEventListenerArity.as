/**
 * Test case for FixEventListenerArity filter.
 * Zero-arg listeners should be treated as Event listeners for add/removeEventListener.
 */
package {
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class TestFilterFixEventListenerArity {
        public function TestFilterFixEventListenerArity() {
            var sprite:Sprite = new Sprite();
            function onClick():void {
                trace("clicked");
            }
            sprite.addEventListener(MouseEvent.CLICK, onClick);
            sprite.removeEventListener(MouseEvent.CLICK, onClick);
        }
    }
}
