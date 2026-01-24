/**
 * Test case: cloneExpr should handle every expression kind without crashing.
 * The method below includes one instance of each expression form, including
 * E4X and conditional compilation, so the CloneExprSmoke filter can clone them.
 */
package {
    public class TestCloneExpr extends BaseClass {
        public static var staticValue:int = 0;
        public var instanceValue:int = 1;

        public function TestCloneExpr() {
            super();
            run();
        }

        public static function staticMethod():void {
            staticValue++;
        }

        public function run():void {
            use namespace AS3;

            var self:TestCloneExpr = this;
            var obj:Object = {};
            var arr:Array = [1, 2, 3];
            var vectorLiteral:Vector.<int> = new <int>[1, 2, 3];
            var vectorCast:Vector.<int> = Vector.<int>(arr);
            var cls:Class = BaseClass;
            var nan:Number = NaN;

            var paren:int = (1);
            var ternary:int = true ? 1 : 0;
            var binop:int = 1 + 2;
            var preIncr:int = ++staticValue;
            var preDecr:int = --staticValue;
            var preNot:Boolean = !true;
            var preNeg:Number = -1;
            var preBitNeg:int = ~1;
            var postIncr:int = staticValue++;
            var postDecr:int = staticValue--;
            var boolValue:Boolean = true;
            var nullValue:Object = null;
            var undefValue:* = undefined;
            var numValue:Number = 1.5;
            var strValue:String = "text";
            var reg:RegExp = /a+/gi;

            var objLit:Object = {a: 1, "b": 2, 3: 4};
            var arrAccess:int = arr[0];

            var fieldAccess:int = instanceValue;
            var fieldAccessExplicit:int = this.instanceValue;
            var fieldAccessStatic:int = TestCloneExpr.staticValue;

            var castInt:int = int("1");
            var typeOfValue:String = typeof obj;

            var f:Function = function(x:int):int { return x; };
            function localFunc():int { return 42; }
            var callValue:int = localFunc();

            var asObject:Object = obj as Object;
            var asXml:XML = obj as XML;
            var base:BaseClass = new BaseClass();

            if (boolValue) {
            } else {
            }

            while (false) {
                break;
            }

            do {
            } while (false);

            for (var i:int = 0; i < 3; i++) {
                if (i == 1) continue;
            }

            for (var j:int = 0; j < 3; j += 2) {
            }

            for (var key:String in obj) {
            }

            for each (var value:* in arr) {
            }

            switch (1) {
                case 0:
                    break;
                default:
                    break;
            }

            try {
                throw new Error("boom");
            } catch (e:Error) {
            }

            delete obj["a"];

            var xml:XML = new XML("<root attr=\"v\"><child/></root>");
            var xmlChild:XMLList = xml.child;
            var xmlAttr:XMLList = xml.@attr;
            var attrName:String = "attr";
            var xmlAttrExpr:XMLList = xml.@[attrName];
            var xmlDesc:XMLList = xml..child;

            CONFIG::cloneExpr;
            CONFIG::cloneExpr {
                var ccBlock:int = 0;
            }

            return;
        }
    }
}

class BaseClass {
    public function BaseClass() {
    }

    public function baseMethod():int {
        return 1;
    }
}
