package ax3.filters;

import haxe.ds.ObjectMap;

class FixNonInlineableDefaultArgs extends AbstractFilter {
	static inline final undefinedIdent = "ASCompat.UNDEFINED";

	final funDefaults = new ObjectMap<TFunctionDecl, DefaultInfo>();
	final methodDefaults = new ObjectMap<TFunctionField, DefaultInfo>();

	override public function run(tree:TypedTree) {
		this.tree = tree;
		collectDefaults(tree);
		super.run(tree);
	}

	override function processFunction(fun:TFunction) {
		var initExprs = [];
		var indent = fun.expr == null ? [] : getInnerIndent(fun.expr);
		for (arg in fun.sig.args) {
			switch arg.kind {
				case TArgNormal(type, init = {expr: initExpr}):
					if (fun.expr != null) {
						var eLocal = mk(TELocal(mkIdent(arg.name), arg.v), arg.v.type, arg.v.type);
						var eUndefined = mkBuiltin(undefinedIdent, arg.type);
						var check = mk(TEIf({
							syntax: {
								keyword: mkIdent("if", indent, [whitespace]),
								openParen: mkOpenParen(),
								closeParen: addTrailingWhitespace(mkCloseParen())
							},
							econd: mk(TEBinop(eLocal, OpEquals(mkEqualsEqualsToken()), eUndefined), TTBoolean, TTBoolean),
							ethen: mk(TEBinop(eLocal, OpAssign(new Token(0, TkEquals, "=", [whitespace], [whitespace])), cloneExpr(initExpr)), eLocal.type, eLocal.type),
							eelse: null
						}), TTVoid, TTVoid);
						initExprs.push({
							expr: check,
							semicolon: addTrailingNewline(mkSemicolon()),
						});
					}
					if (!isConstantExpr(initExpr)) {
						arg.kind = TArgNormal(type, init.with(expr = mkNullExpr(arg.type)));
					}
				case _:
			}
		}
		if (fun.expr != null && initExprs.length > 0) {
			var initBlock = mk(TEBlock({
				syntax: {
					openBrace: addTrailingNewline(mkOpenBrace()),
					closeBrace: mkCloseBrace()
				},
				exprs: initExprs,
			}), TTVoid, TTVoid);
			fun.expr = concatExprs(initBlock, fun.expr);
		}
	}

	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		return switch e.kind {
			case TECall(eobj, args):
				switch getDefaultInfoForCall(eobj) {
					case null: e;
					case info:
						var newArgs = padArgs(args, info);
						if (newArgs == args) e else e.with(kind = TECall(eobj, newArgs));
				}

			case TENew(keyword, newObject, args):
				switch getDefaultInfoForCtor(newObject) {
					case null: e;
					case info:
						var callArgs = if (args == null) {
							{openParen: mkOpenParen(), args: [], closeParen: mkCloseParen()};
						} else {
							args;
						};
						var newArgs = padArgs(callArgs, info);
						if (newArgs == callArgs && args != null) e else e.with(kind = TENew(keyword, newObject, newArgs));
				}

			case _:
				e;
		}
	}

	function collectDefaults(tree:TypedTree) {
		for (pack in tree.packages) {
			for (mod in pack) {
				if (mod.isExtern) {
					continue;
				}
				collectFromDecl(mod.pack.decl);
				for (decl in mod.privateDecls) {
					collectFromDecl(decl);
				}
			}
		}
	}

	function collectFromDecl(decl:TDecl) {
		switch decl.kind {
			case TDFunction(f):
				var info = getDefaultInfo(f.fun.sig);
				if (info.defaultCount > 0) funDefaults.set(f, info);
			case TDClassOrInterface(c):
				for (m in c.members) {
					switch m {
						case TMField(field):
							switch field.kind {
								case TFFun(funField):
									var info = getDefaultInfo(funField.fun.sig);
									if (info.defaultCount > 0) methodDefaults.set(funField, info);
								case _:
							}
						case _:
					}
				}
			case TDVar(_) | TDNamespace(_):
		}
	}

	function getDefaultInfo(sig:TFunctionSignature):DefaultInfo {
		var normalArgs:Array<TFunctionArg> = [];
		var argTypes:Array<TType> = [];
		var defaultKinds:Array<DefaultKind> = [];
		for (arg in sig.args) {
			switch arg.kind {
				case TArgNormal(_, _):
					normalArgs.push(arg);
					argTypes.push(arg.type);
					defaultKinds.push(getDefaultKind(arg));
				case TArgRest(_):
			}
		}

		var defaultCount = 0;
		var i = normalArgs.length - 1;
		while (i >= 0) {
			switch normalArgs[i].kind {
				case TArgNormal(_, init) if (init != null):
					defaultCount++;
					i--;
				case _:
					i = -1;
			}
		}

		return {argTypes: argTypes, defaultCount: defaultCount, defaultKinds: defaultKinds};
	}

	function getDefaultInfoForCall(eobj:TExpr):Null<DefaultInfo> {
		return switch eobj.kind {
			case TEDeclRef(_, decl):
				switch decl.kind {
					case TDFunction(f):
						funDefaults.get(f);
					case _:
						null;
				}
			case TEField(obj, fieldName, _):
				var clsInfo = getClassFromFieldObj(obj);
				if (clsInfo == null) {
					null;
				} else {
					var found = clsInfo.cls.findFieldInHierarchy(fieldName, clsInfo.isStatic);
					if (found == null) {
						null;
					} else {
						switch found.field.kind {
							case TFFun(funField):
								methodDefaults.get(funField);
							case _:
								null;
						}
					}
				}
			case _:
				null;
		};
	}

	function getDefaultInfoForCtor(newObject:TNewObject):Null<DefaultInfo> {
		return switch newObject {
			case TNType({type: TTInst(cls)}):
				var ctor = getConstructor(cls);
				if (ctor == null) null else methodDefaults.get(ctor);
			case _:
				null;
		};
	}

	function getClassFromFieldObj(obj:TFieldObject):Null<{cls:TClassOrInterfaceDecl, isStatic:Bool}> {
		return switch obj.kind {
			case TOImplicitThis(c): {cls: c, isStatic: false};
			case TOImplicitClass(c): {cls: c, isStatic: true};
			case TOExplicit(_, _):
				switch obj.type {
					case TTInst(c): {cls: c, isStatic: false};
					case TTStatic(c): {cls: c, isStatic: true};
					case _: null;
				}
		};
	}

	function padArgs(args:TCallArgs, info:DefaultInfo):TCallArgs {
		var provided = args.args.length;
		var total = info.argTypes.length;
		if (info.defaultCount == 0 || provided >= total) {
			return args;
		}
		var missing = total - provided;
		if (missing > info.defaultCount) {
			return args;
		}

		var newArgs = [];
		for (i in 0...provided) {
			var arg = args.args[i];
			newArgs.push(arg.with(comma = commaWithSpace));
		}
		for (i in provided...total) {
			var filler = getMissingArgExpr(info.argTypes[i], info.defaultKinds[i]);
			newArgs.push({expr: filler, comma: commaWithSpace});
		}
		if (newArgs.length > 0) {
			newArgs[newArgs.length - 1].comma = null;
		}
		return args.with(args = newArgs);
	}

	function getMissingArgExpr(argType:TType, defaultKind:DefaultKind):TExpr {
		return if (defaultKind == DUndefined) {
			mkBuiltin(undefinedIdent, argType);
		} else if (shouldPadWithNull(argType)) {
			mkNullExpr(argType);
		} else {
			mkBuiltin(undefinedIdent, argType);
		}
	}

	function getDefaultKind(arg:TFunctionArg):DefaultKind {
		return switch arg.kind {
			case TArgNormal(_, init) if (init != null && isUndefinedLiteral(init.expr)):
				DUndefined;
			case TArgNormal(_, init) if (init != null):
				DOther;
			case _:
				DNone;
		}
	}

	static function isUndefinedLiteral(e:TExpr):Bool {
		return switch e.kind {
			case TEParens(_, e2, _):
				isUndefinedLiteral(e2);
			case TEHaxeRetype(e2):
				isUndefinedLiteral(e2);
			case TELiteral(TLUndefined(_)):
				true;
			case _:
				false;
		}
	}

	static function shouldPadWithNull(t:TType):Bool {
		return switch t {
			case TTInst(_) | TTStatic(_) | TTClass | TTFunction | TTFun(_, _, _)
				| TTArray(_) | TTDictionary(_, _) | TTVector(_) | TTObject(_)
				| TTXML | TTXMLList | TTRegExp | TTBuiltin:
				true;
			case _:
				false;
		}
	}

	static function isConstantExpr(e:TExpr):Bool {
		return switch e.kind {
			case TEParens(_, e2, _):
				isConstantExpr(e2);
			case TEHaxeRetype(e2):
				isConstantExpr(e2);

			case TEField(obj, fieldName, _):
				switch obj.type {
					case TTStatic(cls):
						var f = cls.findFieldInHierarchy(fieldName, true);
						(f != null) && f.field.kind.match(TFVar({kind: VConst(_)}));
					case _:
						false;
				}

			case TEDeclRef(_):
				true;

			case TELiteral(TLBool(_) | TLNull(_) | TLInt(_) | TLNumber(_) | TLString(_)):
				true;

			case _:
				false;
		}
	}
}

enum DefaultKind {
	DNone;
	DUndefined;
	DOther;
}

typedef DefaultInfo = {
	var argTypes:Array<TType>;
	var defaultCount:Int;
	var defaultKinds:Array<DefaultKind>;
}
