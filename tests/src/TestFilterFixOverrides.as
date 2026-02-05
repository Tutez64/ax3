/**
 * Test case for FixOverrides filter.
 * - Adds missing override keywords and aligns signatures with base classes.
 * - Ensures Array.push rest args are Dynamic.
 * - Applies Proxy namespace metadata and dynamic signatures.
 */
package {
    import flash.utils.Proxy;
    import TestFilterFixOverrides.AccessorChild;

    public class TestFilterFixOverrides {
        public function TestFilterFixOverrides() {
            var child:ChildWithOverride = new ChildWithOverride();
            child.compute(1);

            var arr:MyArray = new MyArray();
            arr.push(1, "extra", true);

            var acc:AccessorChild = new AccessorChild();
            acc.value = 3;
            var value:int = acc.value;

            var proxy:MyProxy = new MyProxy();
            proxy.getProperty("name");
            proxy.callProperty("call", 1, 2);
        }
    }
}

class BaseWithOverride {
    public function compute(value:int, label:String = "ok"):String {
        return label + value;
    }
}

class ChildWithOverride extends BaseWithOverride {
    public function compute(value:*, label:String):* {
        return super.compute(1);
    }
}

class MyArray extends Array {
    public function MyArray() {
        super();
    }

    public function push(item:int, ...rest):int {
        return super.push(item);
    }
}

class MyProxy extends Proxy {
    flash_proxy function getProperty(name:String):String {
        return null;
    }

    flash_proxy function setProperty(name:String, value:int):void {
    }

    flash_proxy function callProperty(name:String, ...rest):int {
        return 0;
    }
}
