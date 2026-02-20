/**
 * Test case: package segment rename in imports/usages.
 * Input imports `floor.TestPackagePartRenamesSource`.
 * With `packagePartRenames.floor = floorpkg`, generated import should be `floorpkg.TestPackagePartRenamesSource`.
 */
package floor {
    import floor.TestPackagePartRenamesSource;

    public class TestPackagePartRenames {
        public function TestPackagePartRenames() {
            var source:TestPackagePartRenamesSource = new TestPackagePartRenamesSource();
            var value:String = source.id();
        }
    }
}

