/**
 * Helper for FixOverrides tests.
 * Exercises flash_proxy overrides to ensure Dynamic-typed signatures.
 */
package TestFilterFixOverrides {
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    use namespace flash_proxy;

    public dynamic class ProxyChild extends Proxy {
        public function ProxyChild() { super(); }

        override flash_proxy function getProperty(param1:*):* { return null; }
        override flash_proxy function callProperty(param1:*, ...rest):* { return null; }
        override flash_proxy function setProperty(param1:*, param2:*):void {}
        override flash_proxy function deleteProperty(param1:*):Boolean { return true; }
        override flash_proxy function nextValue(param1:int):* { return null; }
    }
}
