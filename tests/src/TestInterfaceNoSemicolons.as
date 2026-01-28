/**
 * Test case: interface methods without trailing semicolons.
 * Expected: parser adds missing semicolons.
 */
package {
    public interface TestInterfaceNoSemicolons {
        function foo():void
        function bar(a:int):int
    }
}
