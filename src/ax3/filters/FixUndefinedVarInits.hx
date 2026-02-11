package ax3.filters;

class FixUndefinedVarInits extends AbstractFilter {
	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		return switch e.kind {
			case TEVars(kind, vars):
				var changed = false;
				for (v in vars) {
					if (v.init != null && isUndefinedLiteral(v.init.expr) && shouldNull(v.v.type)) {
						var lead = removeLeadingTrivia(v.init.expr);
						var trail = removeTrailingTrivia(v.init.expr);
						v.init = {equalsToken: v.init.equalsToken, expr: mkNullExpr(v.v.type, lead, trail)};
						changed = true;
					}
				}
				if (changed) e.with(kind = TEVars(kind, vars)) else e;
			case _:
				e;
		}
	}

	static function isUndefinedLiteral(e:TExpr):Bool {
		return switch skipParens(e).kind {
			case TELiteral(TLUndefined(_)): true;
			case _: false;
		}
	}

	static function shouldNull(t:TType):Bool {
		return switch t {
			case TTAny | TTObject(TTAny): false;
			case TTBoolean | TTInt | TTUint | TTNumber: false;
			case _: true;
		}
	}
}
