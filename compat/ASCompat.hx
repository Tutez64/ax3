#if macro
import haxe.macro.Expr;
#end

import haxe.Constraints.Function;

class ASCompat {
	public static inline final MAX_INT = 2147483647;
	public static inline final MIN_INT = -2147483648;

	public static inline final MAX_FLOAT = 1.79e+308;
	public static inline final MIN_FLOAT = -1.79E+308;

	public static inline function checkNullIteratee<T>(v:Null<T>, ?pos:haxe.PosInfos):Bool {
		if (v == null) {
			reportNullIteratee(pos);
			return false;
		}
		return true;
	}

	static function reportNullIteratee(pos:haxe.PosInfos) {
		haxe.Log.trace("FIXME: Null value passed as an iteratee for for-in/for-each expression!", pos);
	}

	public static inline function escape(s:String):String {
		#if flash
		return untyped __global__["escape"](s);
		#else
		return js.Lib.global.escape(s);
		#end
	}

	public static inline function unescape(s:String):String {
		#if flash
		return untyped __global__["unescape"](s);
		#else
		return js.Lib.global.unescape(s);
		#end
	}

	#if flash
	public static inline function describeType(value:Any):compat.XML {
		return flash.Lib.describeType(value);
	}

	// classObject is Any and not Class<Dynamic>, because in Flash we also want to pass Bool to it
	// this is also the reason this function is not automatically added to Globals.hx
	public static inline function registerClassAlias(aliasName:String, classObject:Any) {
		untyped __global__["flash.net.registerClassAlias"](aliasName, classObject);
	}
	#end

	// int(d), uint(d)
	public static inline function toInt(d:Dynamic):Int {
		#if flash
		return untyped __global__["int"](d);
		#else
		return Std.int(toNumber(d));
		#end
	}

	// Number(d)
	public static inline function toNumber(d:Dynamic):Float {
		#if flash
		return untyped __global__["Number"](d);
		#else
		return js.Syntax.code("Number")(d);
		#end
	}

	// Boolean(d)
	public static inline function toBool(d:Dynamic):Bool {
		#if flash
		return untyped __global__["Boolean"](d);
		#else
		return js.Syntax.code("Boolean")(d);
		#end
	}

	// String(d)
	public static inline function toString(d:Dynamic):String {
		#if flash
		return Std.string(d);
		#else
		return js.Syntax.code("String")(d);
		#end
	}

	public static inline function asString(v:Any):Null<String> {
		return if (Std.isOfType(v, String)) cast v else null;
	}

	public static inline function asNumber(v:Any):Null<Float> {
		return if (Std.isOfType(v, Float)) cast v else null;
	}

	public static inline function asInt(v:Any):Null<Int> {
		return if (Std.isOfType(v, Int)) cast v else null;
	}

	public static inline function asUint(v:Any):Null<Int> {
		#if flash
		return if (untyped __is__(v, untyped __global__["uint"])) cast v else null;
		#else
		return if (Std.isOfType(v, Int) && (cast v : Int) >= 0) cast v else null;
		#end
	}

	public static inline function asBool(v:Any):Null<Bool> {
		#if flash
		return if (untyped __is__(v, untyped __global__["Boolean"])) cast v else null;
		#elseif js
		return if (js.Syntax.typeof(v) == "boolean") cast v else null;
		#else
		return if (v == true || v == false) cast v else null;
		#end
	}

	public static inline function asXML(v:Any):Null<compat.XML> {
		#if flash
		return if (Std.isOfType(v, flash.xml.XML)) cast v else null;
		#else
		return if (Std.isOfType(v, Xml)) cast v else null;
		#end
	}

	public static inline function asXMLList(v:Any):Null<compat.XMLList> {
		#if flash
		return if (Std.isOfType(v, flash.xml.XMLList)) cast v else null;
		#else
		return if (Std.isOfType(v, Array)) cast v else null;
		#end
	}

	public static inline function typeof(value:Dynamic):String {
		#if js
		return js.Syntax.typeof(value);
		#else
		if (Std.isOfType(value, String)) {
			return "string";
		}
		return switch (Type.typeof(value)) {
			case TNull: "object";
			case TInt | TFloat: "number";
			case TBool: "boolean";
			case TObject | TClass(_) | TEnum(_): "object";
			case TFunction: "function";
			case TUnknown: "undefined";
		}
		#end
	}

	public static inline function as<T>(v:Dynamic, c:Class<T>):T {
		return flash.Lib.as(v, c);
	}

	public static inline function dynamicAs<T>(v:Dynamic, c:Class<T>):T {
		return flash.Lib.as(v, c);
	}

	public static inline function reinterpretAs<T>(v:Dynamic, c:Class<T>):T {
		return flash.Lib.as(v, c);
	}

	public static inline function toExponential(n:Float, ?digits:Int):String {
		return (cast n).toExponential(digits);
	}

	public static inline function toFixed(n:Float, ?digits:Int):String {
		return (cast n).toFixed(digits);
	}

	public static inline function toPrecision(n:Float, precision:Int):String {
		return (cast n).toPrecision(precision);
	}

	public static inline function toRadix(n:Float, radix:Int = 10):String {
		return (cast n).toString(radix);
	}

	public static inline function xmlToList(xml:compat.XML):compat.XMLList {
		#if flash
		var out:flash.xml.XMLList = new flash.xml.XMLList();
		if (xml != null) {
			untyped out[untyped out.length()] = xml;
		}
		return out;
		#else
		return if (xml == null) [] else [xml];
		#end
	}

	public static inline function filterXmlList(list:compat.XMLList, predicate:compat.XML->Bool):compat.XMLList {
		#if flash
		var out:flash.xml.XMLList = new flash.xml.XMLList();
		for (x in list) {
			if (predicate(x)) {
				untyped out[untyped out.length()] = x;
			}
		}
		return out;
		#else
		var out:Array<compat.XML> = [];
		for (x in list) {
			if (predicate(x)) {
				out.push(x);
			}
		}
		return out;
		#end
	}

	// TODO: this is temporary
	public static inline function thisOrDefault<T>(value:T, def:T):T {
		return if ((value : ASAny)) value else def;
	}

	public static inline function stringAsBool(s:Null<String>):Bool {
		return (s : ASAny);
	}

	public static inline function floatAsBool(f:Null<Float>):Bool {
		return (f : ASAny);
	}

	public static inline function intAsBool(i:Null<Int>):Bool {
		return (i : ASAny);
	}

	public static inline function allocArray<T>(length:Int):Array<T> {
		var a = new Array<T>();
		a.resize(length);
		return a;
	}

	public static inline function arraySetLength<T>(a:Array<T>, newLength:Int):Int {
		a.resize(newLength);
		return newLength;
	}

	public static inline function arraySpliceAll<T>(a:Array<T>, startIndex:Int):Array<T> {
		return a.splice(startIndex, a.length);
	}

	public static function arraySplice<T>(a:Array<T>, startIndex:Int, deleteCount:Int, ?values:Array<T>):Array<T> {
		var result = a.splice(startIndex, deleteCount);
		if (values != null) {
			for (i in 0...values.length) {
				a.insert(startIndex + i, values[i]);
			}
		}
		return result;
	}

	public static inline function vectorSpliceAll<T>(a:flash.Vector<T>, startIndex:Int):flash.Vector<T> {
		return a.splice(startIndex, a.length);
	}

	public static function vectorSplice<T>(a:flash.Vector<T>, startIndex:Int, deleteCount:Int, ?values:Array<T>):flash.Vector<T> {
		var result = a.splice(startIndex, deleteCount);
		if (values != null) {
			for (i in 0...values.length) {
				vectorInsertAt(a, startIndex + i, values[i]);
			}
		}
		return result;
	}

	static function vectorInsertAt<T>(a:flash.Vector<T>, index:Int, value:T):Void {
		var len = a.length;
		a.length = len + 1;
		var i = len;
		while (i > index) {
			a[i] = a[i - 1];
			i--;
		}
		a[index] = value;
	}

	public static macro function vectorClass<T>(typecheck:Expr):ExprOf<Class<flash.Vector<T>>>;
	public static macro function asVector<T>(value:Expr, typecheck:Expr):ExprOf<Null<flash.Vector<T>>>;
	public static macro function isVector<T>(value:Expr, typecheck:Expr):ExprOf<Bool>;

	@:noCompletion public static inline function _asVector<T>(value:Any):Null<flash.Vector<T>> return if (_isVector(value)) value else null;
	@:noCompletion public static inline function _isVector(value:Any):Bool
	return Reflect.hasField(value, '__array') && Reflect.hasField(value, 'fixed');

	public static inline function asFunction(v:Any):Null<ASFunction> {
		return if (Reflect.isFunction(v)) v else null;
	}

	public static macro function setTimeout(closure:ExprOf<haxe.Constraints.Function>, delay:ExprOf<Float>, arguments:Array<Expr>):ExprOf<UInt>;

	public static inline function clearTimeout(id:UInt):Void {
		#if flash
		untyped __global__["flash.utils.clearTimeout"](id);
		#else
		js.Browser.window.clearTimeout(id);
		#end
	}

	public static macro function setInterval(closure:ExprOf<haxe.Constraints.Function>, delay:ExprOf<Float>, arguments:Array<Expr>):ExprOf<UInt>;

	public static inline function clearInterval(id:UInt):Void {
		#if flash
		untyped __global__["flash.utils.clearInterval"](id);
		#else
		js.Browser.window.clearInterval(id);
		#end
	}

	public static inline function textFieldGetXMLText(field:flash.text.TextField, ?beginIndex:Int, ?endIndex:Int):String {
		#if flash
		if (beginIndex == null) {
			return untyped field.getXMLText();
		}
		if (endIndex == null) {
			return untyped field.getXMLText(beginIndex);
		}
		return untyped field.getXMLText(beginIndex, endIndex);
		#else
		var text = field.text;
		if (beginIndex == null) return text;
		if (endIndex == null) return text.substr(beginIndex);
		return text.substring(beginIndex, endIndex);
		#end
	}

	public static macro function processNull<T>(e:ExprOf<Null<T>>):ExprOf<T>;

	public static inline function processNullInt(v:Null<Int>):Int {
		#if flash
		return v;
		#else
		return cast v | 0;
		#end
	}

	public static inline function processNullFloat(v:Null<Float>):Float {
		#if flash
		return v;
		#else
		return js.Syntax.code("Number")(v);
		#end
	}

	public static inline function processNullBool(v:Null<Bool>):Bool {
		#if flash
		return v;
		#else
		return !!v;
		#end
	}

	/**
	 * https://github.com/HaxeFoundation/as3hx/blob/829f661777d0458c7902c4235a4c944de4c8cc6d/src/as3hx/Compat.hx#L114
	 */
	public static function parseInt(s:String, ?base:Int):Null<Int> {
		#if js
		if (base == null) base = s.indexOf("0x") == 0 ? 16 : 10;
		var v:Int = js.Syntax.code("parseInt({0}, {1})", s, base);
		return Math.isNaN(v) ? null : v;
		#elseif flash
		if (base == null) base = 0;
		var v:Int = untyped __global__["parseInt"](s, base);
		return Math.isNaN(v) ? null : v;
		#else
		var BASE = "0123456789abcdefghijklmnopqrstuvwxyz";
		if (base != null && (base < 2 || base > BASE.length))
			return throw 'invalid base ${base}, it must be between 2 and ${BASE.length}';
		s = s.trim().toLowerCase();
		var sign = if (s.startsWith("+")) {
			s = s.substring(1);
			1;
		} else if (s.startsWith("-")) {
			s = s.substring(1);
			-1;
		} else {
			1;
		};
		if (s.length == 0) return null;
		if (s.startsWith('0x')) {
			if (base != null && base != 16) return null; // attempting at converting a hex using a different base
			base = 16;
			s = s.substring(2);
		} else if (base == null) {
			base = 10;
		}
		var acc = 0;
		try s.split('').map(function(c) {
			var i = BASE.indexOf(c);
			if(i < 0 || i >= base) throw 'invalid';
			acc = (acc * base) + i;
		}) catch(e:Dynamic) {};
		return acc * sign;
		#end
	}

}

class ASArray {
	public static inline final CASEINSENSITIVE = 1;
	public static inline final DESCENDING = 2;
	public static inline final NUMERIC = 16;
	public static inline final RETURNINDEXEDARRAY = 8;
	public static inline final UNIQUESORT = 4;

	public static inline function reverse<T>(a:Array<T>):Array<T> {
		a.reverse();
		return a;
	}

	public static function some<T>(a:Array<T>, callback:(item:T, index:Int, array:Array<T>)->Bool, ?thisObj:Dynamic):Bool {
		for (i in 0...a.length) {
			var result:Bool =
				if (thisObj != null) Reflect.callMethod(thisObj, callback, [a[i], i, a])
				else Reflect.callMethod(null, callback, [a[i], i, a]);
			if (result) {
				return true;
			}
		}
		return false;
	}

	public static function forEach<T>(a:Array<T>, callback:(item:T, index:Int, array:Array<T>)->Void, ?thisObj:Dynamic):Void {
		for (i in 0...a.length) {
			if (thisObj != null) Reflect.callMethod(thisObj, callback, [a[i], i, a])
			else Reflect.callMethod(null, callback, [a[i], i, a]);
		}
	}

	public static inline function map<T, U>(a:Array<T>, callback:(item:T, index:Int, array:Array<T>)->U, ?thisObj:Dynamic):Array<U> {
		var out:Array<U> = [];
		for (i in 0...a.length) {
			var value:U =
				if (thisObj != null) Reflect.callMethod(thisObj, callback, [a[i], i, a])
				else Reflect.callMethod(null, callback, [a[i], i, a]);
			out.push(value);
		}
		return out;
	}

	public static function sort<T>(a:Array<T>, f:Dynamic):Array<T> {
		if (f == null) {
			a.sort(Reflect.compare);
			return a;
		}
		a.sort(function(x, y) {
			var result:Dynamic = Reflect.callMethod(null, f, [x, y]);
			return coerceSortResult(result);
		});
		return a;
	}

	static inline function coerceSortResult(value:Dynamic):Int {
		if (Std.isOfType(value, Int)) return value;
		if (Std.isOfType(value, Float)) return Std.int(value);
		if (Std.isOfType(value, Bool)) return value ? 1 : 0;
		return Std.int(ASCompat.toNumber(value));
	}

	public static inline function sortOn<T>(a:Array<T>, fieldName:Dynamic, options:Dynamic):Array<T> {
		#if flash
		return (cast a).sortOn(fieldName, options);
		#else
		return ASSortTools.sortOn(a, fieldName, options);
		#end
	}

	public static inline function sortWithOptions<T>(a:Array<T>, options:Int):Array<T> {
		#if flash
		return (cast a).sort(options);
		#else
		return ASSortTools.sortWithOptions(a, options, function(v) return v);
		#end
	}

	public static macro function pushMultiple<T>(a:ExprOf<Array<T>>, first:ExprOf<T>, rest:Array<ExprOf<T>>):ExprOf<Int>;
	public static macro function unshiftMultiple<T>(a:ExprOf<Array<T>>, first:ExprOf<T>, rest:Array<ExprOf<T>>):ExprOf<Int>;
}


class ASVector {
	public static inline function reverse<T>(a:flash.Vector<T>):flash.Vector<T> {
		#if flash
		return (cast a).reverse();
		#else
		var items = [for (i in 0...a.length) a[i]];
		items.reverse();
		for (i in 0...items.length) {
			a[i] = items[i];
		}
		return a;
		#end
	}

	public static function forEach<T>(a:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->Void, ?thisObj:Dynamic):Void {
		for (i in 0...a.length) {
			if (thisObj != null) Reflect.callMethod(thisObj, callback, [a[i], i, a])
			else Reflect.callMethod(null, callback, [a[i], i, a]);
		}
	}

	public static inline function map<T, U>(a:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->U, ?thisObj:Dynamic):flash.Vector<U> {
		var out = new flash.Vector<U>();
		for (i in 0...a.length) {
			var value:U =
				if (thisObj != null) Reflect.callMethod(thisObj, callback, [a[i], i, a])
				else Reflect.callMethod(null, callback, [a[i], i, a]);
			out.push(value);
		}
		return out;
	}

	public static function sort<T>(a:flash.Vector<T>, f:Dynamic):flash.Vector<T> {
		if (f == null) {
			a.sort(Reflect.compare);
			return a;
		}
		a.sort(function(x, y) {
			var result:Dynamic = Reflect.callMethod(null, f, [x, y]);
			return coerceSortResult(result);
		});
		return a;
	}

	static inline function coerceSortResult(value:Dynamic):Int {
		if (Std.isOfType(value, Int)) return value;
		if (Std.isOfType(value, Float)) return Std.int(value);
		if (Std.isOfType(value, Bool)) return value ? 1 : 0;
		return Std.int(ASCompat.toNumber(value));
	}

	public static inline function sortWithOptions<T>(a:flash.Vector<T>, options:Int):flash.Vector<T> {
		#if flash
		return (cast a).sort(options);
		#else
		if ((options & ASArray.RETURNINDEXEDARRAY) != 0) {
			return a;
		}
		var items = [for (i in 0...a.length) a[i]];
		ASSortTools.sortWithOptions(items, options, function(v) return v);
		for (i in 0...items.length) {
			a[i] = items[i];
		}
		return a;
		#end
	}
}

class ASVectorTools {
	#if flash inline #end
	public static function forEach<T>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->Void):Void {
		#if flash
		(cast v).forEach(callback);
		#else
		for (i in 0...v.length) {
			callback(v[i], i, v);
		}
		#end
	}

	#if flash inline #end
	public static function filter<T>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->Bool):flash.Vector<T> {
		#if flash
		return (cast v).filter(callback);
		#else
		var result = new flash.Vector<T>();
		for (i in 0...v.length) {
			var item = v[i];
			if (callback(item, i, v)) {
				result.push(item);
			}
		}
		return result;
		#end
	}

	#if flash inline #end
	public static function map<T,T2>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->T2):flash.Vector<T2> {
		#if flash
		return (cast v).map(callback);
		#else
		var result = new flash.Vector<T2>(v.length);
		for (i in 0...v.length) {
			result[i] = callback(v[i], i, v);
		}
		return result;
		#end
	}

	#if flash inline #end
	public static function every<T>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->Bool):Bool {
		#if flash
		return (cast v).every(callback);
		#else
		for (i in 0...v.length) {
			if (!callback(v[i], i, v)) {
				return false;
			}
		}
		return true;
		#end
	}

	#if flash inline #end
	public static function some<T>(v:flash.Vector<T>, callback:(item:T, index:Int, vector:flash.Vector<T>)->Bool):Bool {
		#if flash
		return (cast v).some(callback);
		#else
		for (i in 0...v.length) {
			if (callback(v[i], i, v)) {
				return true;
			}
		}
		return false;
		#end
	}
}

private class ASSortTools {
	public static function sortOn<T>(a:Array<T>, fieldName:Dynamic, options:Dynamic):Array<T> {
		var fields = normalizeFieldNames(fieldName);
		var opts = normalizeOptions(options, fields.length);
		var fieldOptions = opts.fieldOptions;
		var globalOptions = opts.globalOptions;

		if (fields.length == 0) {
			return a;
		}

		if ((globalOptions & ASArray.RETURNINDEXEDARRAY) != 0) {
			var indices = [for (i in 0...a.length) i];
			indices.sort(function(i, j) {
				return compareByFields(a[i], a[j], fields, fieldOptions);
			});
			if ((globalOptions & ASArray.UNIQUESORT) != 0 && hasDuplicateIndicesByFields(indices, a, fields, fieldOptions)) {
				return a;
			}
			return cast indices;
		}

		var sorted = a.copy();
		sorted.sort(function(x, y) {
			return compareByFields(x, y, fields, fieldOptions);
		});
		if ((globalOptions & ASArray.UNIQUESORT) != 0 && hasDuplicateValuesByFields(sorted, fields, fieldOptions)) {
			return a;
		}
		for (i in 0...sorted.length) {
			a[i] = sorted[i];
		}
		return a;
	}

	public static function sortWithOptions<T>(a:Array<T>, options:Int, valueFn:T->Dynamic):Array<T> {
		if ((options & ASArray.RETURNINDEXEDARRAY) != 0) {
			var indices = [for (i in 0...a.length) i];
			indices.sort(function(i, j) {
				return compareValues(valueFn(a[i]), valueFn(a[j]), options);
			});
			if ((options & ASArray.UNIQUESORT) != 0 && hasDuplicateIndices(indices, a, valueFn, options)) {
				return a;
			}
			return cast indices;
		}

		var sorted = a.copy();
		sorted.sort(function(x, y) {
			return compareValues(valueFn(x), valueFn(y), options);
		});
		if ((options & ASArray.UNIQUESORT) != 0 && hasDuplicateValues(sorted, valueFn, options)) {
			return a;
		}
		for (i in 0...sorted.length) {
			a[i] = sorted[i];
		}
		return a;
	}

	static function normalizeFieldNames(fieldName:Dynamic):Array<String> {
		if (fieldName == null) {
			return [];
		}
		if (Std.isOfType(fieldName, Array)) {
			var values:Array<Dynamic> = cast fieldName;
			return [for (v in values) Std.string(v)];
		}
		return [Std.string(fieldName)];
	}

	static function normalizeOptions(options:Dynamic, fieldCount:Int):{fieldOptions:Array<Int>, globalOptions:Int} {
		var fieldOptions:Array<Int> = [];
		var globalOptions = 0;
		if (options == null) {
			for (i in 0...fieldCount) {
				fieldOptions.push(0);
			}
			return {fieldOptions: fieldOptions, globalOptions: 0};
		}

		if (Std.isOfType(options, Array)) {
			var values:Array<Dynamic> = cast options;
			for (i in 0...fieldCount) {
				var v = if (i < values.length && values[i] != null) Std.int(values[i]) else 0;
				fieldOptions.push(v);
				globalOptions |= v;
			}
			return {fieldOptions: fieldOptions, globalOptions: globalOptions};
		}

		var v = Std.int(options);
		for (i in 0...fieldCount) {
			fieldOptions.push(v);
		}
		return {fieldOptions: fieldOptions, globalOptions: v};
	}

	static function compareByFields(a:Dynamic, b:Dynamic, fields:Array<String>, options:Array<Int>):Int {
		for (i in 0...fields.length) {
			var key = fields[i];
			var opts = if (i < options.length) options[i] else 0;
			var left = Reflect.getProperty(a, key);
			var right = Reflect.getProperty(b, key);
			var result = compareValues(left, right, opts);
			if (result != 0) {
				return result;
			}
		}
		return 0;
	}

	static function hasDuplicateValuesByFields<T>(sorted:Array<T>, fields:Array<String>, options:Array<Int>):Bool {
		if (sorted.length < 2) {
			return false;
		}
		var prev = sorted[0];
		for (i in 1...sorted.length) {
			var cur = sorted[i];
			if (compareByFields(prev, cur, fields, options) == 0) {
				return true;
			}
			prev = cur;
		}
		return false;
	}

	static function hasDuplicateIndicesByFields<T>(indices:Array<Int>, a:Array<T>, fields:Array<String>, options:Array<Int>):Bool {
		if (indices.length < 2) {
			return false;
		}
		var prev = indices[0];
		for (i in 1...indices.length) {
			var cur = indices[i];
			if (compareByFields(a[prev], a[cur], fields, options) == 0) {
				return true;
			}
			prev = cur;
		}
		return false;
	}

	static function hasDuplicateValues<T>(sorted:Array<T>, valueFn:T->Dynamic, options:Int):Bool {
		if (sorted.length < 2) {
			return false;
		}
		var prev = valueFn(sorted[0]);
		for (i in 1...sorted.length) {
			var cur = valueFn(sorted[i]);
			if (compareValues(prev, cur, options) == 0) {
				return true;
			}
			prev = cur;
		}
		return false;
	}

	static function hasDuplicateIndices<T>(indices:Array<Int>, a:Array<T>, valueFn:T->Dynamic, options:Int):Bool {
		if (indices.length < 2) {
			return false;
		}
		var prev = valueFn(a[indices[0]]);
		for (i in 1...indices.length) {
			var cur = valueFn(a[indices[i]]);
			if (compareValues(prev, cur, options) == 0) {
				return true;
			}
			prev = cur;
		}
		return false;
	}

	static function compareValues(a:Dynamic, b:Dynamic, options:Int):Int {
		if (a == b) {
			return 0;
		}
		if (a == null) {
			return -1;
		}
		if (b == null) {
			return 1;
		}

		var result = if ((options & ASArray.NUMERIC) != 0) {
			compareNumeric(a, b, options);
		} else {
			compareStrings(Std.string(a), Std.string(b), (options & ASArray.CASEINSENSITIVE) != 0);
		}

		if ((options & ASArray.DESCENDING) != 0) {
			result = -result;
		}
		return result;
	}

	static function compareNumeric(a:Dynamic, b:Dynamic, options:Int):Int {
		var fa = Std.parseFloat(Std.string(a));
		var fb = Std.parseFloat(Std.string(b));
		if (Math.isNaN(fa) || Math.isNaN(fb)) {
			return compareStrings(Std.string(a), Std.string(b), (options & ASArray.CASEINSENSITIVE) != 0);
		}
		return if (fa < fb) -1 else if (fa > fb) 1 else 0;
	}

	static function compareStrings(a:String, b:String, caseInsensitive:Bool):Int {
		if (caseInsensitive) {
			a = a.toLowerCase();
			b = b.toLowerCase();
		}
		return if (a < b) -1 else if (a > b) 1 else 0;
	}
}

class ASDate {
	public static inline function toDateString(d:Date):String {
		return DateTools.format(Date.fromTime(0), "%a %b %d %Y");
	}

	public static inline function setTime(d:Date, millisecond:Float):Float {
		#if (js || flash || python)
		return (cast d).setTime(millisecond);
		#else
		return millisecond;
		#end
	}

	public static inline function setDate(d:Date, day:Float):Float {
		return setTime(d, DateTools.makeUtc(d.getUTCFullYear(), d.getUTCMonth(), Std.int(day), d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds()));
	}

	public static inline function setMonth(d:Date, month:Float, ?day:Float):Float {
		#if (js || flash || python)
		return (cast d).setMonth(month, day);
		#else
		var dayValue = if (day == null) d.getUTCDate() else Std.int(day);
		return setTime(d, DateTools.makeUtc(d.getUTCFullYear(), Std.int(month), dayValue, d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds()));
		#end
	}

	public static inline function setHours(d:Date, hour:Float, ?minute:Int, ?second:Int, ?millisecond:Int):Float {
		#if (js || flash || python)
		return (cast d).setHours(hour, minute, second, millisecond);
		#else
		var minValue = if (minute == null) d.getUTCMinutes() else minute;
		var secValue = if (second == null) d.getUTCSeconds() else second;
		var base = DateTools.makeUtc(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), Std.int(hour), minValue, secValue);
		return setTime(d, base + if (millisecond == null) 0 else millisecond);
		#end
	}

	public static inline function setMinutes(d:Date, minute:Float, ?second:Float, ?millisecond:Float):Float {
		#if (js || flash || python)
		return (cast d).setMinutes(minute, second, millisecond);
		#else
		var secValue = if (second == null) d.getUTCSeconds() else Std.int(second);
		var base = DateTools.makeUtc(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), d.getUTCHours(), Std.int(minute), secValue);
		return setTime(d, base + if (millisecond == null) 0 else millisecond);
		#end
	}

	public static inline function setSeconds(d:Date, second:Float, ?millisecond:Float):Float {
		#if (js || flash || python)
		return (cast d).setSeconds(second, millisecond);
		#else
		var base = DateTools.makeUtc(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), d.getUTCHours(), d.getUTCMinutes(), Std.int(second));
		return setTime(d, base + if (millisecond == null) 0 else millisecond);
		#end
	}

	public static inline function getMilliseconds(d:Date):Float {
		#if (js || flash || python)
		return (cast d).getMilliseconds();
		#else
		var ms = Std.int(d.getTime() % 1000);
		return if (ms < 0) ms + 1000 else ms;
		#end
	}

	public static inline function setMilliseconds(d:Date, millisecond:Float):Float {
		#if (js || flash || python)
		return (cast d).setMilliseconds(millisecond);
		#else
		return setTime(d, d.getTime() - getMilliseconds(d) + millisecond);
		#end
	}

	public static inline function setUTCDate(d:Date, day:Float):Float {
		#if (js || flash || python)
		return (cast d).setUTCDate(day);
		#else
		return setTime(d, DateTools.makeUtc(d.getUTCFullYear(), d.getUTCMonth(), Std.int(day), d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds()));
		#end
	}

	public static inline function setFullYear(d:Date, year:Float, ?month:Float, ?day:Float):Float {
		#if (js || flash || python)
		return (cast d).setFullYear(year, month, day);
		#else
		var monthValue = if (month == null) d.getUTCMonth() else Std.int(month);
		var dayValue = if (day == null) d.getUTCDate() else Std.int(day);
		return setTime(d, DateTools.makeUtc(Std.int(year), monthValue, dayValue, d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds()));
		#end
	}

	public static inline function setUTCFullYear(d:Date, year:Float, ?month:Float, ?day:Float):Float {
		#if (js || flash || python)
		return (cast d).setUTCFullYear(year, month, day);
		#else
		var monthValue = if (month == null) d.getUTCMonth() else Std.int(month);
		var dayValue = if (day == null) d.getUTCDate() else Std.int(day);
		return setTime(d, DateTools.makeUtc(Std.int(year), monthValue, dayValue, d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds()));
		#end
	}

	public static inline function setUTCHours(d:Date, hour:Float, ?minute:Float, ?second:Float, ?millisecond:Float):Float {
		#if (js || flash || python)
		return (cast d).setUTCHours(hour, minute, second, millisecond);
		#else
		var minValue = if (minute == null) d.getUTCMinutes() else Std.int(minute);
		var secValue = if (second == null) d.getUTCSeconds() else Std.int(second);
		var base = DateTools.makeUtc(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), Std.int(hour), minValue, secValue);
		return setTime(d, base + if (millisecond == null) 0 else millisecond);
		#end
	}

	public static inline function getUTCMilliseconds(d:Date):Float {
		#if (js || flash || python)
		return (cast d).getUTCMilliseconds();
		#else
		return getMilliseconds(d);
		#end
	}

	public static inline function setUTCMilliseconds(d:Date, millisecond:Float):Float {
		#if (js || flash || python)
		return (cast d).setUTCMilliseconds(millisecond);
		#else
		return setMilliseconds(d, millisecond);
		#end
	}

	public static inline function setUTCMinutes(d:Date, minute:Float, ?second:Float, ?millisecond:Float):Float {
		#if (js || flash || python)
		return (cast d).setUTCMinutes(minute, second, millisecond);
		#else
		var secValue = if (second == null) d.getUTCSeconds() else Std.int(second);
		var base = DateTools.makeUtc(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), d.getUTCHours(), Std.int(minute), secValue);
		return setTime(d, base + if (millisecond == null) 0 else millisecond);
		#end
	}

	public static inline function setUTCMonth(d:Date, month:Float, ?day:Float):Float {
		#if (js || flash || python)
		return (cast d).setUTCMonth(month, day);
		#else
		var dayValue = if (day == null) d.getUTCDate() else Std.int(day);
		return setTime(d, DateTools.makeUtc(d.getUTCFullYear(), Std.int(month), dayValue, d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds()));
		#end
	}

	public static inline function setUTCSeconds(d:Date, second:Float, ?millisecond:Float):Float {
		#if (js || flash || python)
		return (cast d).setUTCSeconds(second, millisecond);
		#else
		var base = DateTools.makeUtc(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), d.getUTCHours(), d.getUTCMinutes(), Std.int(second));
		return setTime(d, base + if (millisecond == null) 0 else millisecond);
		#end
	}

	public static inline function UTC(year:Float, month:Float, ?day:Float, ?hour:Float, ?minute:Float, ?second:Float, ?millisecond:Float):Float {
		#if (js || flash || python)
		return (cast Date).UTC(year, month, day, hour, minute, second, millisecond);
		#elseif (php || cpp)
		var dayValue = if (day == null) 1 else Std.int(day);
		var hourValue = if (hour == null) 0 else Std.int(hour);
		var minuteValue = if (minute == null) 0 else Std.int(minute);
		var secondValue = if (second == null) 0 else Std.int(second);
		var base = DateTools.makeUtc(Std.int(year), Std.int(month), dayValue, hourValue, minuteValue, secondValue);
		return base + if (millisecond == null) 0 else millisecond;
		#else
		return 0.;
		#end
	}
}
