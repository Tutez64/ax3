/**
 * Test case for TextFieldApi filter.
 * Covers getXMLText() with 0, 1, and 2 arguments.
 */
package {
    import flash.text.TextField;

    public class TestFilterTextFieldApi {
        public function TestFilterTextFieldApi() {
            var field:TextField = new TextField();
            field.text = "<a>test</a>";

            var all:String = field.getXMLText();
            var from:String = field.getXMLText(2);
            var range:String = field.getXMLText(1, 4);

            // silence unused var warnings in AS3 tooling
            if (all == null || from == null || range == null) {
                trace(all, from, range);
            }
        }
    }
}
