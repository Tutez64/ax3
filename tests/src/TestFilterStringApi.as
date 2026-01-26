/**
 * Test case: String.replace should accept non-string replacement values.
 * Expected: replacement is coerced to string when using a string pattern.
 * Also covers regex replace/match/search/split and string API rewrites.
 */
package {
    public class TestFilterStringApi {
        public function TestFilterStringApi() {
            var replaceDict:Object = {};
            replaceDict["#NAME"] = "Hero";
            replaceDict["#LEVEL"] = 5;
            var text:String = "#NAME is level #LEVEL";
            var key:String;
            for (key in replaceDict) {
                text = text.replace(key, replaceDict[key]);
            }

            var lower:String = " TeSt ";
            var upper:String = lower.toLocaleUpperCase();
            lower = upper.toLocaleLowerCase();

            var sliceText:String = lower.slice(1, 3);
            var concatText:String = "a".concat("b", 1, true);
            var compareValue:int = "a".localeCompare("b");

            var regText:String = "aa bb aa";
            var regMatch:Array = regText.match(/a+/g);
            var regSearch:int = regText.search(/b+/);
            var regSplit:Array = regText.split(/\s+/);
            regText = regText.replace(/a+/g, "x");
            regText = regText.replace(/b+/g, function(v:String):String { return v.toUpperCase(); });

            var strSearch:int = regText.search("bb");
            var strSplit:Array = regText.split(" ");
            regText = regText.replace("x", 42);
            regText = regText.replace("y", false);
            regText = regText.replace("z", null);
        }
    }
}
