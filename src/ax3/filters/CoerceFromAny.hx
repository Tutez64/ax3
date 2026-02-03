package ax3.filters;

class CoerceFromAny extends AbstractFilter {
	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		if (!shouldCoerce(e)) {
			return e;
		}
		return e.with(kind = TEHaxeRetype(e), type = e.expectedType, expectedType = e.expectedType);
	}

	static function shouldCoerce(e:TExpr):Bool {
		if (!e.type.match(TTAny | TTObject(TTAny) | TTArray(_) | TTVector(_))) {
			return false;
		}

		return switch [e.type, e.expectedType] {
			case [TTAny | TTObject(TTAny), TTVoid | TTAny | TTObject(TTAny) | TTBoolean | TTString | TTInt | TTUint | TTNumber]:
				false;
			case [TTAny | TTObject(TTAny), _]:
				true;

			case [TTArray(t1), TTArray(t2)] if (isAnyLike(t1) && !isAnyLike(t2)):
				true;
			case [TTVector(t1), TTVector(t2)] if (isAnyLike(t1) && !isAnyLike(t2)):
				true;
			case _:
				false;
		}
	}

	static inline function isAnyLike(t:TType):Bool {
		return t.match(TTAny | TTObject(TTAny));
	}
}
