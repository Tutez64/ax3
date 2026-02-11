package ax3.filters;

import ax3.TypedTree;
import ax3.TypedTreeTools.*;

class MapItemForUndefinedToNull extends AbstractFilter {
	override function processClass(c:TClassOrInterfaceDecl) {
		if (!isTargetMap(c)) {
			return;
		}
		for (m in c.members) {
			switch m {
				case TMField(f):
					switch f.kind {
						case TFFun(fn) if (fn.name == "itemFor"):
							fn.fun = fn.fun.with(expr = wrapReturns(fn.fun.expr));
						case _:
					}
				case _:
			}
		}
	}

	function wrapReturns(e:TExpr):TExpr {
		e = mapExpr(wrapReturns, e);
		return switch e.kind {
			case TEReturn(keyword, retExpr) if (retExpr != null):
				var wrapped = wrapUndefinedToNull(retExpr);
				e.with(kind = TEReturn(keyword, wrapped));
			case _:
				e;
		}
	}

	function wrapUndefinedToNull(e:TExpr):TExpr {
		var lead = removeLeadingTrivia(e);
		var trail = removeTrailingTrivia(e);
		var eMethod = mkBuiltin("ASCompat.undefinedToNull", TTFunction, lead);
		return mk(TECall(eMethod, {
			openParen: mkOpenParen(),
			args: [{expr: e, comma: null}],
			closeParen: mkCloseParen(trail)
		}), e.type, e.expectedType);
	}

	function isTargetMap(c:TClassOrInterfaceDecl):Bool {
		if (c.name != "Map") {
			return false;
		}
		var pack = c.parentModule.parentPack.name;
		return pack == "org.as3commons.collections";
	}
}
