/**
 * Test case: package normalization and type name normalization in imports.
 * Expect package TestCases.ForPackage to become testCases.forPackage in output,
 * and class testClassCase to become TestClassCase in import and usage.
 */
package TestCases.ForPackage {
    import TestCases.ForClass.testClassCase;

    public class TestPackageCase {
        public function TestPackageCase() {
            var value:testClassCase = new testClassCase();
        }
    }
}
