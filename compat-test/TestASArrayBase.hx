import utest.Assert.*;

class TestASArrayBase extends utest.Test {
	function getAt(items:ASArrayBase, index:Int):ASAny {
		var any:ASAny = items;
		return any[index];
	}

	function setAt(items:ASArrayBase, index:Int, value:ASAny):ASAny {
		var any:ASAny = items;
		return any[index] = value;
	}

	function testConstructorAndLength() {
		var sized = new ASArrayBase(3);
		equals(3, sized.length);
		equals(null, getAt(sized, 0));

		var values = new ASArrayBase(1, 2);
		equals(2, values.length);
		equals(1, getAt(values, 0));
		equals(2, getAt(values, 1));

		var nested = new ASArrayBase([1, 2]);
		equals(1, nested.length);
		var inner:Array<ASAny> = cast getAt(nested, 0);
		equals(2, inner.length);
	}

	function testPushPopUnshiftShift() {
		var items = new ASArrayBase();
		equals(2, (items.push(1, 2) : Int));
		equals(2, items.length);
		equals(2, items.pop());
		equals(1, items.length);

		equals(3, (items.unshift(0, -1) : Int));
		equals(0, getAt(items, 0));
		equals(-1, getAt(items, 1));
		equals(1, getAt(items, 2));
		equals(0, items.shift());
		equals(2, items.length);
	}

	function testSpliceConcatSliceJoin() {
		var items = new ASArrayBase(1, 2, 3);
		var removed = items.splice(1, 1, 9, 10);
		equals(1, removed.length);
		equals(2, removed[0]);
		equals(4, items.length);
		equals(1, getAt(items, 0));
		equals(9, getAt(items, 1));
		equals(10, getAt(items, 2));
		equals(3, getAt(items, 3));

		var copy = items.concat();
		equals(4, copy.length);

		var other = new ASArrayBase(7, 8);
		var merged = items.concat([4, 5], other);
		equals(8, merged.length);
		equals(5, merged[5]);
		equals(7, merged[6]);
		equals(8, merged[7]);

		var joined = items.join();
		equals("1,9,10,3", joined);

		var slice = items.slice(1, 3);
		equals(2, slice.length);
		equals(9, slice[0]);
		equals(10, slice[1]);
	}

	function testSortAndSortOn() {
		var nums = new ASArrayBase(3, 1, 2);
		nums.sort(ASCompat.ASArray.NUMERIC | ASCompat.ASArray.DESCENDING);
		equals(3, getAt(nums, 0));
		equals(2, getAt(nums, 1));
		equals(1, getAt(nums, 2));

		var items = new ASArrayBase({n: "b"}, {n: "A"}, {n: "c"});
		items.sortOn("n", ASCompat.ASArray.CASEINSENSITIVE);
		var first:Dynamic = getAt(items, 0);
		var second:Dynamic = getAt(items, 1);
		var third:Dynamic = getAt(items, 2);
		equals("A", first.n);
		equals("b", second.n);
		equals("c", third.n);
	}

	function testIndexOfLastIndexOfAndCallbacks() {
		var items = new ASArrayBase(1, 2, 3, 2);
		equals(1, items.indexOf(2));
		equals(3, items.lastIndexOf(2));
		equals(3, items.indexOf(2, 2));
		equals(0, items.indexOf(1, -10));

		var sum = 0;
		items.forEach(function(value, index, array) {
			sum += value;
		});
		equals(8, sum);

		var mapped = items.map(function(value, index, array) {
			return value * 2;
		});
		equals(4, mapped.length);
		equals(2, mapped[0]);
		equals(4, mapped[1]);

		var filtered = items.filter(function(value, index, array) {
			return value > 1;
		});
		equals(3, filtered.length);
		equals(2, filtered[0]);
		equals(3, filtered[1]);
		equals(2, filtered[2]);

		isTrue(items.every(function(value, index, array) {
			return value > 0;
		}));

		isTrue(items.some(function(value, index, array) {
			return value == 3;
		}));
	}

	function testArraySetThroughAny() {
		var items = new ASArrayBase(1);
		setAt(items, 1, 2);
		equals(2, getAt(items, 1));
		equals(2, items.length);
	}
}
