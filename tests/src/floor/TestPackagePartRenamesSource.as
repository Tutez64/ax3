/**
 * Test case: package segment rename source.
 * This file intentionally declares package `floor`.
 * With `packagePartRenames.floor = floorpkg`, generated Haxe package should become `floorpkg`.
 */
package floor {
    public class TestPackagePartRenamesSource {
        public function TestPackagePartRenamesSource() {
        }

        public function id():String {
            return "ok";
        }
    }
}

