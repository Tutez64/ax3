import utest.Assert.*;

class TestASCompat extends utest.Test {
	function testProcessNull() {
		equals(0, ASCompat.processNull((null : Null<Int>)));
		equals(0, ASCompat.processNull((null : Null<UInt>)));

		equals(false, ASCompat.processNull((null : Null<Bool>)));

		floatEquals(0, ASCompat.processNull((null : Null<Float>)));

		var undefined = new ASDictionary<Int,Float>()[10];
		floatEquals(Math.NaN, ASCompat.processNull((undefined : Null<Float>)));
	}

	function testIsAnyVector() {
		isTrue(ASCompat.isVector(new flash.Vector<String>(), (_:ASAny)));
	}

	function testArraySortWithOptions() {
		var values = [3, 1, 2];
		ASCompat.ASArray.sortWithOptions(values, ASCompat.ASArray.NUMERIC | ASCompat.ASArray.DESCENDING);
		equals(3, values[0]);
		equals(2, values[1]);
		equals(1, values[2]);
	}

	function testArraySortOn() {
		var values = [{n: "b"}, {n: "A"}, {n: "c"}];
		ASCompat.ASArray.sortOn(values, "n", ASCompat.ASArray.CASEINSENSITIVE);
		equals("A", values[0].n);
		equals("b", values[1].n);
		equals("c", values[2].n);
	}

	function testArraySortOnMulti() {
		var values = [
			{a: 1, b: 2},
			{a: 1, b: 1},
			{a: 0, b: 5}
		];
		ASCompat.ASArray.sortOn(values, ["a", "b"], [ASCompat.ASArray.NUMERIC, ASCompat.ASArray.NUMERIC | ASCompat.ASArray.DESCENDING]);
		equals(0, values[0].a);
		equals(2, values[1].b);
		equals(1, values[2].b);
	}

	function testArraySortReturnIndexed() {
		var values = ["b", "a", "c"];
		var indices:Array<Int> = cast ASCompat.ASArray.sortWithOptions(values, ASCompat.ASArray.RETURNINDEXEDARRAY);
		equals("b", values[0]);
		equals(1, indices[0]);
		equals(0, indices[1]);
		equals(2, indices[2]);
	}

	function testFilterXmlList() {
		var x = new compat.XML('<root><a id="1"/><b/><a id="2"/></root>');
		var list = x.children();
		var filtered = ASCompat.filterXmlList(list, function(node) return node.name() == "a");
		equals('<a id="1"/>\n<a id="2"/>', filtered.toXMLString());
	}

	function testXmlToList() {
		var x = new compat.XML("<root/>");
		var list = ASCompat.xmlToList(x);
		equals("<root/>", list.toXMLString());
	}
}
