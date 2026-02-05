/**
 * Test case for ExtensionContextCall filter.
 * ExtensionContext.call with 3+ args should wrap extra args into an Array.
 */
package {
    import flash.external.ExtensionContext;

    public class TestFilterExtensionContextCall {
        public function TestFilterExtensionContextCall() {
            var ctx:ExtensionContext = ExtensionContext.createExtensionContext("test", null);
            ctx.call("ping", 1, 2, 3);
            ctx.call("single", 1);
        }
    }
}
