/**
 * Test cases for SWCLoader special handling
 * Tests that Array, Dictionary, and QName are not skipped, and dynamic classes (such as MovieClip) are treated as such
 */
package {
	import flash.utils.Dictionary;
	import flash.display.MovieClip;

	public class TestSWCLoader extends Array {
		public function TestSWCLoader() {
			// Array extension is tested by the class definition itself

			// Dictionary usage
			var d:Dictionary = new Dictionary();
			d["key"] = "value";

			// QName usage
			var q:QName = new QName("http://example.com", "MyClass");

			// MovieClip dynamic property access (handled by dynList in SWCLoader)
			var mc:MovieClip = new MovieClip();
			mc.someArbitraryProperty = 123;
			mc.anotherProp = "test";
		}
	}
}