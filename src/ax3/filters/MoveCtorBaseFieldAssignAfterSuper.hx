package ax3.filters;

class MoveCtorBaseFieldAssignAfterSuper extends AbstractFilter {
	override function processClass(c:TClassOrInterfaceDecl) {
		for (m in c.members) {
			switch (m) {
				case TMField({kind: TFFun(f)}) if (isCtorName(f.name, c.name)):
					if (f.fun.expr != null) {
						f.fun.expr = moveBaseAssignsAfterSuper(f.fun.expr, c);
					}
					break;
				case _:
			}
		}
	}

	static inline function isCtorName(name:String, className:String):Bool {
		return name == "new" || name == className;
	}

	function moveBaseAssignsAfterSuper(e:TExpr, currentClass:TClassOrInterfaceDecl):TExpr {
		return switch e.kind {
			case TEBlock(block):
				var superIndex = -1;
				for (i in 0...block.exprs.length) {
					if (isSuperCall(block.exprs[i].expr)) {
						superIndex = i;
						break;
					}
				}
				if (superIndex <= 0) {
					e;
				} else {
					var before = block.exprs.slice(0, superIndex);
					var after = block.exprs.slice(superIndex + 1);
					var keepBefore:Array<TBlockExpr> = [];
					var moveAfter:Array<TBlockExpr> = [];
					for (expr in before) {
						if (isAssignToBaseField(expr.expr, currentClass)) {
							moveAfter.push(expr);
						} else {
							keepBefore.push(expr);
						}
					}
					if (moveAfter.length == 0) {
						e;
					} else {
						var newExprs = keepBefore
							.concat([block.exprs[superIndex]])
							.concat(moveAfter)
							.concat(after);
						e.with(kind = TEBlock(block.with(exprs = newExprs)));
					}
				}
			case _:
				e;
		}
	}

	static function isSuperCall(e:TExpr):Bool {
		return switch e.kind {
			case TEParens(_, inner, _): isSuperCall(inner);
			case TECall({kind: TELiteral(TLSuper(_))}, _): true;
			case _: false;
		}
	}

	static function isAssignToBaseField(e:TExpr, currentClass:TClassOrInterfaceDecl):Bool {
		return switch e.kind {
			case TEParens(_, inner, _): isAssignToBaseField(inner, currentClass);
			case TEBinop(left, OpAssign(_), _):
				switch left.kind {
					case TEField(obj, name, _) if (isThisObject(obj)):
						var found = currentClass.findFieldInHierarchy(name, false);
						found != null && found.declaringClass != currentClass;
					case _:
						false;
				}
			case _:
				false;
		}
	}

	static inline function isThisObject(obj:TFieldObject):Bool {
		return switch obj.kind {
			case TOImplicitThis(_): true;
			case TOExplicit(_, {kind: TELiteral(TLThis(_) | TLSuper(_))}): true;
			case _:
				false;
		}
	}
}
