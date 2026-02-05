/**
 * Test case for FileModeApi filter.
 * FileStream open/openAsync should map string modes to FileMode constants.
 */
package {
    import flash.filesystem.File;
    import flash.filesystem.FileStream;

    public class TestFilterFileModeApi {
        public function TestFilterFileModeApi() {
            var stream:FileStream = new FileStream();
            var file:File = File.applicationDirectory;
            stream.open(file, "read");
            stream.openAsync(file, "write");
            stream.open(file, "append");
        }
    }
}
