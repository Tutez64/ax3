/**
 * Test case: E4X filter expressions with descendant wildcard and attribute checks.
 * Expected: xml.(...) filters are parsed and rewritten without fatal errors.
 */
package {
    public class TestFilterRewriteE4X {
        public function TestFilterRewriteE4X() {
            var xml:XML = new XML("<root><variable/><accessor access='r'/><accessor access='w'/></root>");
            var list:XMLList = xml..*.(name() == "variable" || name() == "accessor" && attribute("access").charAt(0) == "r");
            var simple:XMLList = xml..*.(name() == "variable" || name() == "accessor");

            var rootOnly:XMLList = xml.(name() == "root");
            var childFilter:XMLList = xml.child("accessor").(attribute("access") == "w");
            var descendByName:XMLList = xml..accessor.(name() == "accessor");
            var attrShort:XMLList = xml.child("accessor").(@access == "r");
            var mixedAttr:XMLList = xml..*.(name() == "accessor" && @access == "r");
        }
    }
}
