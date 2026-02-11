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
				var inferred = inferExprType(updatedExpr);
				var objType = inferred != null ? inferred : (updatedExpr.type != TTAny ? updatedExpr.type : obj.type);
				if (needsDynamicFieldAccess(objType, fieldName)) {
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
		return switch e.kind {
			case TEHaxeRetype(_):
				if (e.type == TTAny) e else e.with(kind = TEHaxeRetype(e), type = TTAny);
			case _:
				e.with(kind = TEHaxeRetype(e), type = TTAny);
		}
	}

	function inferExprType(e:TExpr):Null<TType> {
		return switch e.kind {
			case TEField(obj, name, _):
				var baseType = obj.type;
				if (baseType == TTAny) {
					baseType = switch obj.kind {
						case TOExplicit(_, inner): inferExprType(inner);
						case TOImplicitThis(cls): TTInst(cls);
						case TOImplicitClass(cls): TTStatic(cls);
					};
				}
				var fieldType = if (baseType == null) {
					null;
				} else {
					switch baseType {
						case TTInst(cls): getFieldType(cls, name, false);
						case TTStatic(cls): getFieldType(cls, name, true);
						case _: null;
					}
				};
				if (fieldType != null) fieldType else (e.type != TTAny ? e.type : null);
			case TELocal(_, v):
				v.type;
			case TEHaxeRetype(inner):
				e.type != TTAny ? e.type : inferExprType(inner);
			case _:
				e.type != TTAny ? e.type : null;
		}
	}

	function getFieldType(cls:TClassOrInterfaceDecl, name:String, isStatic:Bool):Null<TType> {
		var found = cls.findFieldInHierarchy(name, isStatic);
		if (found == null) {
			return null;
		}
		return switch found.field.kind {
			case TFVar(v): v.type;
			case TFFun(f): f.type;
			case TFGetter(f): f.propertyType;
			case TFSetter(f): f.propertyType;
		}
	}

	function needsDynamicFieldAccess(t:TType, fieldName:String):Bool {
		if (fieldName == "constructor") return true;
		return switch t {
			case TTInst(cls):
				if (!isAs3DynamicClass(cls)) false else cls.findFieldInHierarchy(fieldName, false) == null;
			case TTStatic(cls):
				if (!isAs3DynamicClass(cls)) false else cls.findFieldInHierarchy(fieldName, true) == null;
			case _:
				false;
		}
	}

	function fieldExistsOnType(t:TType, fieldName:String):Bool {
		return switch t {
			case TTInst(cls):
				cls.findFieldInHierarchy(fieldName, false) != null;
			case TTStatic(cls):
				cls.findFieldInHierarchy(fieldName, true) != null;
			case _:
				false;
		}
	}

	static function isAs3DynamicClass(cls:TClassOrInterfaceDecl):Bool {
		if (isDynamicClass(cls)) return true;
		return extendsFlashMovieClip(cls);
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

	static function extendsFlashMovieClip(cls:TClassOrInterfaceDecl):Bool {
		if (cls.name == "MovieClip" && cls.parentModule.parentPack.name == "flash.display") {
			return true;
		}
		return switch cls.kind {
			case TClass(info):
				if (info.extend == null) {
					false;
				} else {
					var parent = info.extend.superClass;
					if (parent.name == "MovieClip" && parent.parentModule.parentPack.name == "flash.display") {
						true;
					} else {
						extendsFlashMovieClip(parent);
					}
				}
			case _:
				false;
		}
	}
}
