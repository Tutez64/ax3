/**
 * Test case: module-level import rewriting and ignore rules.
 * Expect module-level functions/vars to be rewritten via Globals (correct casing),
 * namespace imports to be dropped, and class/wildcard imports to be kept.
 */
package {
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;
    import externImports.moduleFunction;
    import externImports.moduleVar;
    import externImports.CustomNS;
    import externImports.ExternType;
    import externImports.*;

    public class TestFilterExternModuleLevelImports {
        public function TestFilterExternModuleLevelImports() {
        }

        public function check(value:*):String {
            var t = new ExternType();
            var n = moduleFunction(1);
            var v = moduleVar;
            var timer = getTimer();
            return getQualifiedClassName(value) + ":" + n + ":" + v + ":" + timer + ":" + (t != null);
        }
    }
}
