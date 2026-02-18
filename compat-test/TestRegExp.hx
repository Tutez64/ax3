import utest.Assert.*;

class TestRegExp extends utest.Test {
	function testBasicApi() {
		var re = new compat.RegExp("a+", "g");
		isTrue(re.test("baac"));
		isFalse(re.test("xyz"));

		equals(1, re.search("baac"));
		equals(-1, re.search("xyz"));

		equals("x-b-x", re.replace("aa-b-aa", "x"));
		var sep = new compat.RegExp("--", "g");
		same(["a", "b", "c"], sep.split("a--b--c"));
	}

	function testExecAndMatch() {
		var re = new compat.RegExp("foo", "g");
		var execResult = re.exec("xxfooyy");
		isTrue(execResult != null);
		equals("foo", cast execResult[0]);

		var matchResult = re.match("xxfooyy");
		equals(1, matchResult.length);
		equals("foo", matchResult[0]);
	}

	function testLastIndexFieldExists() {
		var re = new compat.RegExp("foo", "g");
		re.lastIndex = 3;
		equals(3, re.lastIndex);
	}
}
