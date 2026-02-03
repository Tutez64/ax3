package ax3.filters;

class CoerceToNumber extends AbstractFilter {
	static final tToInt = TTFun([TTAny], TTInt);
	static final tToNumber = TTFun([TTAny], TTNumber);
	static final tStdInt = TTFun([TTNumber], TTInt);

	override function processExpr(e:TExpr):TExpr {
		return switch e.kind {
			case TEPreUnop(PreIncr(_) | PreDecr(_), inner):
				var mappedInner = mapExpr(processExpr, inner);
				applyExpectedCoercion(e.with(kind = TEPreUnop(getPreUnopToken(e), mappedInner)));
			case TEPostUnop(inner, PostIncr(_) | PostDecr(_)):
				var mappedInner = mapExpr(processExpr, inner);
				applyExpectedCoercion(e.with(kind = TEPostUnop(mappedInner, getPostUnopToken(e))));
			case _:
				applyExpectedCoercion(mapExpr(processExpr, e));
		}
	}

	static function getPreUnopToken(e:TExpr):PreUnop {
		return switch e.kind {
			case TEPreUnop(op, _): op;
			case _: throw "assert";
		}
	}

	static function getPostUnopToken(e:TExpr):PostUnop {
		return switch e.kind {
			case TEPostUnop(_, op): op;
			case _: throw "assert";
		}
	}

	function applyExpectedCoercion(e:TExpr):TExpr {
		return switch e.expectedType {
			case TTInt:
				coerceToInt(e);
			case TTUint:
				coerceToUInt(e);
			case TTNumber:
				coerceToFloat(e);
			case _:
				e;
		}
	}

	function coerceToInt(e:TExpr):TExpr {
		return switch e.type {
			case TTInt:
				e;
			case TTUint:
				mk(TEHaxeRetype(e), TTInt, TTInt);
			case TTNumber:
				mkStdIntCall(e);
			case _:
				mkToIntCall(e);
		}
	}

	function coerceToUInt(e:TExpr):TExpr {
		return switch e.type {
			case TTUint:
				e;
			case TTInt:
				retypeToUInt(e);
			case TTNumber:
				retypeToUInt(mkStdIntCall(e));
			case _:
				retypeToUInt(mkToIntCall(e));
		}
	}

	function coerceToFloat(e:TExpr):TExpr {
		return switch e.type {
			case TTNumber:
				e;
			case TTInt | TTUint:
				e;
			case _:
				mkToNumberCall(e);
		}
	}

	static function mkStdIntCall(e:TExpr):TExpr {
		var stdInt = mkBuiltin("Std.int", tStdInt, removeLeadingTrivia(e));
		return mkCall(stdInt, [e.with(expectedType = TTNumber)], TTInt, removeTrailingTrivia(e));
	}

	static function mkToIntCall(e:TExpr):TExpr {
		var eToInt = mkBuiltin("ASCompat.toInt", tToInt, removeLeadingTrivia(e));
		return mkCall(eToInt, [e.with(expectedType = e.type)], TTInt, removeTrailingTrivia(e));
	}

	static function mkToNumberCall(e:TExpr):TExpr {
		var eToNumber = mkBuiltin("ASCompat.toNumber", tToNumber, removeLeadingTrivia(e));
		return mkCall(eToNumber, [e.with(expectedType = e.type)], TTNumber, removeTrailingTrivia(e));
	}

	static function retypeToUInt(e:TExpr):TExpr {
		return mk(TEHaxeRetype(e), TTUint, TTUint);
	}
}
