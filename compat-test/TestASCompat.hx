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

	function testTypeof() {
		equals("function", ASCompat.typeof(function() {}));
		equals("number", ASCompat.typeof(1));
		equals("boolean", ASCompat.typeof(true));
		equals("string", ASCompat.typeof("test"));
		equals("object", ASCompat.typeof(null));
	}

	function testDateApi() {
		var dTime = Date.fromTime(0);
		ASCompat.ASDate.setTime(dTime, 1234567);
		floatEquals(1234567, dTime.getTime());

		var dFull = Date.fromTime(0);
		var dFullExpected = Date.fromTime(0);
		ASCompat.ASDate.setFullYear(dFull, 2020, 1, 2);
		untyped dFullExpected.setFullYear(2020, 1, 2);
		floatEquals(dFullExpected.getTime(), dFull.getTime());

		var dMonth = Date.fromTime(0);
		var dMonthExpected = Date.fromTime(0);
		ASCompat.ASDate.setMonth(dMonth, 5, 6);
		untyped dMonthExpected.setMonth(5, 6);
		floatEquals(dMonthExpected.getTime(), dMonth.getTime());

		var dDate = Date.fromTime(0);
		var dDateExpected = Date.fromTime(0);
		ASCompat.ASDate.setDate(dDate, 7);
		untyped dDateExpected.setDate(7);
		floatEquals(dDateExpected.getTime(), dDate.getTime());

		var dHours = Date.fromTime(0);
		var dHoursExpected = Date.fromTime(0);
		ASCompat.ASDate.setHours(dHours, 8, 9, 10, 11);
		untyped dHoursExpected.setHours(8, 9, 10, 11);
		floatEquals(dHoursExpected.getTime(), dHours.getTime());

		var dMinutes = Date.fromTime(0);
		var dMinutesExpected = Date.fromTime(0);
		ASCompat.ASDate.setMinutes(dMinutes, 12, 13, 14);
		untyped dMinutesExpected.setMinutes(12, 13, 14);
		floatEquals(dMinutesExpected.getTime(), dMinutes.getTime());

		var dSeconds = Date.fromTime(0);
		var dSecondsExpected = Date.fromTime(0);
		ASCompat.ASDate.setSeconds(dSeconds, 15, 16);
		untyped dSecondsExpected.setSeconds(15, 16);
		floatEquals(dSecondsExpected.getTime(), dSeconds.getTime());

		var dMs = Date.fromTime(0);
		var dMsExpected = Date.fromTime(0);
		ASCompat.ASDate.setMilliseconds(dMs, 123);
		untyped dMsExpected.setMilliseconds(123);
		floatEquals(dMsExpected.getTime(), dMs.getTime());
		floatEquals(untyped dMsExpected.getMilliseconds(), ASCompat.ASDate.getMilliseconds(dMs));

		var dUtcMs = Date.fromTime(0);
		untyped dUtcMs.setUTCMilliseconds(321);
		floatEquals(untyped dUtcMs.getUTCMilliseconds(), ASCompat.ASDate.getUTCMilliseconds(dUtcMs));

		var utcValue = ASCompat.ASDate.UTC(2020, 0, 2, 3, 4, 5, 6);
		#if (js || flash || python)
		var utcExpected:Float = untyped Date.UTC(2020, 0, 2, 3, 4, 5, 6);
		floatEquals(utcExpected, utcValue);
		#else
		isTrue(utcValue >= 0 || utcValue <= 0);
		#end
	}
}
