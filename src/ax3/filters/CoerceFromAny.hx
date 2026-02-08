package ax3.filters;

import ax3.TypedTree;
import ax3.Token;
import ax3.TokenTools;
import ax3.TypedTreeTools.*;

class CoerceFromAny extends AbstractFilter {
	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		if (!shouldCoerce(e)) {
			return e;
		}
		return switch e.expectedType {
			case TTFunction | TTFun(_):
				wrapAsFunction(e);
			case TTInst(cls) if (cls.name != "String"):
				wrapDynamicAs(e, cls, e.expectedType);
			case TTObject(TTAny): // ASObject
				wrapDynamicAsType(e, "ASObject", e.expectedType);
			case TTArray(_):
				wrapDynamicAsType(e, "Array", e.expectedType);
			case TTVector(_):
				// Vector cast is tricky, leaving as retype for now
				e.with(kind = TEHaxeRetype(e), type = e.expectedType, expectedType = e.expectedType);
			case _:
				e.with(kind = TEHaxeRetype(e), type = e.expectedType, expectedType = e.expectedType);
		}
	}

	function wrapAsFunction(e:TExpr):TExpr {
		var lead = removeLeadingTrivia(e);
		var trail = removeTrailingTrivia(e);
		var eMethod = mkBuiltin("ASCompat.asFunction", TTFunction, lead);
		return mk(TECall(eMethod, {
			openParen: mkOpenParen(),
			args: [{expr: e, comma: null}],
			closeParen: mkCloseParen(trail)
		}), e.expectedType, e.expectedType);
	}

	function wrapDynamicAs(inner:TExpr, targetClass:TClassOrInterfaceDecl, targetType:TType):TExpr {
		var lead = removeLeadingTrivia(inner);
		var trail = removeTrailingTrivia(inner);
		var eMethod = mkBuiltin("ASCompat.dynamicAs", TTFunction, lead);
		var fullName = targetClass.parentModule != null && targetClass.parentModule.path == currentPath
			? targetClass.name
			: (targetClass.parentModule.parentPack.name == "" ? targetClass.name : targetClass.parentModule.parentPack.name + "." + targetClass.name);
		var path = dotPathFromString(fullName, []);
		var eType = mkDeclRef(path, {name: targetClass.name, kind: TDClassOrInterface(targetClass)}, null);
		return mk(TECall(eMethod, {
			openParen: mkOpenParen(),
			args: [
				{expr: inner, comma: commaWithSpace},
				{expr: eType, comma: null}
			],
			closeParen: mkCloseParen(trail)
		}), targetType, targetType);
	}

	function wrapDynamicAsType(inner:TExpr, typeName:String, targetType:TType):TExpr {
		var lead = removeLeadingTrivia(inner);
		var trail = removeTrailingTrivia(inner);
		var eMethod = mkBuiltin("ASCompat.dynamicAs", TTFunction, lead);
		var path = dotPathFromString(typeName, []);
		var eType = mkBuiltin(typeName, TTClass, [], []);
		return mk(TECall(eMethod, {
			openParen: mkOpenParen(),
			args: [
				{expr: inner, comma: commaWithSpace},
				{expr: eType, comma: null}
			],
			closeParen: mkCloseParen(trail)
		}), targetType, targetType);
	}

	function dotPathFromString(path:String, lead:Array<Trivia>):DotPath {
		var parts = path.split(".");
		var first = mkIdent(parts[0], lead, []);
		var rest = [];
		for (i in 1...parts.length) {
			rest.push({sep: mkDot(), element: mkIdent(parts[i])});
		}
		return {first: first, rest: rest};
	}

	static function shouldCoerce(e:TExpr):Bool {
		if (!e.type.match(TTAny | TTObject(TTAny) | TTArray(_) | TTVector(_))) {
			return false;
		}

		if (isLiteral(e)) {
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

	static function isLiteral(e:TExpr):Bool {
		return switch skipParens(e).kind {
			case TELiteral(_): true;
			case _: false;
		}
	}
}
