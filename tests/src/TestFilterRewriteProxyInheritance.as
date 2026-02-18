/**
 * Test case: class extending flash.utils.Proxy should be rewritten to ASProxyBase.
 * Also verifies property access helpers keep get/set/delete behavior compatible on non-Flash targets.
 */
package {
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    use namespace flash_proxy;

    public dynamic class TestFilterRewriteProxyInheritance extends Proxy {
        private var data:Object = {};

        override flash_proxy function getProperty(name:*):* {
            return data[name];
        }

        override flash_proxy function setProperty(name:*, value:*):void {
            data[name] = value;
        }

        override flash_proxy function deleteProperty(name:*):Boolean {
            return delete data[name];
        }

        public function run():void {
            this["a"] = 1;
            delete this["a"];
        }
    }
}
