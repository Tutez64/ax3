package ax3.filters;

class RewriteDynamicFieldAccess extends AbstractFilter {
	override function processExpr(e:TExpr):TExpr {
		return switch e.kind {
			case TEField(obj, fieldName, fieldToken):
				var updatedObj = rewriteFieldObject(obj, fieldName, fieldToken);
				if (updatedObj == obj) e else e.with(kind = TEField(updatedObj, fieldName, fieldToken));
			case _:
				mapExpr(processExpr, e);
		}
	}

	function rewriteFieldObject(obj:TFieldObject, fieldName:String, fieldToken:Token):TFieldObject {
		return switch obj.kind {
			case TOExplicit(dot, eobj):
				var updatedExpr = processExpr(eobj);
				if (needsDynamicFieldAccess(obj.type, fieldName)) {
					updatedExpr = retypeToAny(updatedExpr);
					obj.with(kind = TOExplicit(dot, updatedExpr), type = TTAny);
				} else if (updatedExpr == eobj) {
					obj;
				} else {
					obj.with(kind = TOExplicit(dot, updatedExpr));
				}

			case TOImplicitThis(cls):
				if (!needsDynamicFieldAccess(TTInst(cls), fieldName)) {
					obj;
				} else {
					var eThis = mk(TELiteral(TLThis(mkIdent("this", fieldToken.leadTrivia, []))), obj.type, obj.type);
					fieldToken.leadTrivia = [];
					{kind: TOExplicit(mkDot(), retypeToAny(eThis)), type: TTAny};
				}

			case TOImplicitClass(_):
				obj;
		}
	}

	function retypeToAny(e:TExpr):TExpr {
		return if (e.type == TTAny) e else e.with(kind = TEHaxeRetype(e), type = TTAny);
	}

	function needsDynamicFieldAccess(t:TType, fieldName:String):Bool {
		return switch t {
			case TTInst(cls):
				if (!isDynamicClass(cls)) false else cls.findFieldInHierarchy(fieldName, false) == null;
			case TTStatic(cls):
				if (!isDynamicClass(cls)) false else cls.findFieldInHierarchy(fieldName, true) == null;
			case _:
				false;
		}
	}

	static function isDynamicClass(cls:TClassOrInterfaceDecl):Bool {
		for (m in cls.modifiers) {
			switch m {
				case DMDynamic(_):
					return true;
				case _:
			}
		}
		return false;
	}
}
