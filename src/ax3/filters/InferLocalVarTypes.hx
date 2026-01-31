package ax3.filters;

import ax3.ParseTree.Binop;
import ax3.ParseTree.AssignOp;
import ax3.ParseTree.PreUnop;
import ax3.ParseTree.PostUnop;
import ax3.TypedTree.TType;
import ax3.TypedTreeTools;

private typedef VarInfo = {
	var decl:TVarDecl;
	var hint:TType;
	var incompatible:Bool;
}

class InferLocalVarTypes extends AbstractFilter {
	override function processFunction(fun:TFunction) {
		if (fun.expr == null) {
			return;
		}

		var infos = new Map<TVar, VarInfo>();

		function addCandidate(decl:TVarDecl) {
			if (decl.v.type != TTAny) {
				return;
			}
			var hint:TType = null;
			if (decl.init != null) {
				hint = hintFromExpr(decl.init.expr);
			}
			infos[decl.v] = {decl: decl, hint: hint, incompatible: false};
		}

		function noteHint(info:VarInfo, hint:TType) {
			if (info.incompatible) return;
			
			if (info.hint == null) {
				info.hint = hint;
			} else {
				var merged = mergeTypes(info.hint, hint);
				if (merged == null) {
					info.incompatible = true;
				} else {
					info.hint = merged;
				}
			}
		}

		function noteAssignOp(info:VarInfo, op:AssignOp, rhs:TExpr) {
			if (info.incompatible) {
				return;
			}

			if (info.hint == null) {
				if (isNumericAssignOp(op)) {
					noteHint(info, TTNumber);
				} else {
					if (op.match(AOpAdd(_))) {
						var rhsHint = hintFromExpr(rhs);
						if (typeEq(rhsHint, TTString)) {
							noteHint(info, TTString);
						} else if (isNumericType(rhsHint)) {
							noteHint(info, TTNumber);
						} else {
							info.incompatible = true;
						}
					} else {
						info.incompatible = true;
					}
				}
				return;
			}

			// Check compatibility
			if (typeEq(info.hint, TTString)) {
				switch op {
					case AOpAdd(_):
					case _: info.incompatible = true;
				}
			} else if (isNumericType(info.hint)) {
				if (!isNumericAssignOp(op)) {
					info.incompatible = true;
					return;
				}
				var hint = hintFromExpr(rhs);
				if (hint == null || !isNumericType(hint)) {
					// Allow if RHS is unknown? No, restrict.
					// But we should allow Int assigned to Number.
					// isNumericType checks Int/Number.
					info.incompatible = true;
				} else {
					noteHint(info, hint);
				}
			} else {
				// Other types usually don't support assign ops
				info.incompatible = true;
			}
		}

		function noteAssign(info:VarInfo, op:Binop, rhs:TExpr) {
			if (info.incompatible) {
				return;
			}

			switch op {
				case OpAssign(_):
					var hint = hintFromExpr(rhs);
					if (hint == null) {
						info.incompatible = true;
					} else {
						noteHint(info, hint);
					}
				case OpAssignOp(aop):
					noteAssignOp(info, aop, rhs);
				case _:
			}
		}

		function noteUnary(info:VarInfo) {
			if (info.incompatible) return;
			
			if (info.hint == null) {
				noteHint(info, TTInt); // Assume Int for ++/--
			} else {
				if (!isNumericType(info.hint)) {
					info.incompatible = true;
				}
			}
		}
		
		function noteUsage(info:VarInfo, impliedHint:TType) {
			if (info.incompatible) return;
			
			if (info.hint == null) {
				info.hint = impliedHint;
			} else {
				var merged = mergeTypes(info.hint, impliedHint);
				if (merged == null) {
					info.incompatible = true;
				}
			}
		}

		function checkUsage(e:TExpr, implied:TType) {
			switch e.kind {
				case TELocal(_, v):
					var info = infos[v];
					if (info != null) {
						noteUsage(info, implied);
					}
				case _:
			}
		}

		function loop(e:TExpr) {
			switch e.kind {
				case TEVars(_, vars):
					for (decl in vars) {
						addCandidate(decl);
						if (decl.init != null) {
							loop(decl.init.expr);
						}
					}

				case TEBinop(a, op = OpAssign(_) | OpAssignOp(_), b):
					var isLocalAssign = false;
					switch a.kind {
						case TELocal(_, v):
							isLocalAssign = true;
							var info = infos[v];
							if (info != null) {
								noteAssign(info, op, b);
							}
						case _:
					}
					if (!isLocalAssign) loop(a);
					loop(b);

				case TEPreUnop(PreIncr(_) | PreDecr(_), {kind: TELocal(_, v)})
				   | TEPostUnop({kind: TELocal(_, v)}, PostIncr(_) | PostDecr(_)):
					var info = infos[v];
					if (info != null) {
						noteUnary(info);
					}

				case TEBinop(a, op, b):
					if (isBitwiseOp(op)) {
						checkUsage(a, TTInt);
						checkUsage(b, TTInt);
					}
					else if (isArithmeticOp(op)) {
						checkUsage(a, TTNumber);
						checkUsage(b, TTNumber);
					}
					loop(a);
					loop(b);
				
				case TEArrayAccess(a):
					// Index usage implies Int
					checkUsage(a.eindex, TTInt);
					loop(a.eobj);
					loop(a.eindex);
					
				case TELocal(_, v):
					var info = infos[v];
					if (info != null) {
						if (info.hint == null) {
							info.incompatible = true;
						}
					}

				default:
					iterExpr(loop, e);
			}
		}

		loop(fun.expr);

		for (info in infos) {
			if (info.incompatible || info.hint == null) {
				continue;
			}
			// info.hint IS the TType now.
			var newType = info.hint;
			if (!typeEq(info.decl.v.type, newType)) {
				info.decl.v.type = newType;
				reportError(info.decl.syntax.name.pos, 'Inferred local var type "${info.decl.v.name}" as ${typeToString(newType)} (was ASAny)');
			}
		}
	}
	
	static function hintFromExpr(e:TExpr):Null<TType> {
		if (e.type != TTAny) {
			return e.type;
		}
		
		// Structural inference for untyped expressions
		switch e.kind {
			case TEBinop(a, op, b):
				if (isBitwiseOp(op)) return TTInt;
				if (isArithmeticOp(op)) return TTNumber;
				if (isComparisonOp(op)) return TTBoolean;
				if (isBoolOp(op)) return TTBoolean;
				
				if (op.match(OpAdd(_))) {
					var ha = hintFromExpr(a);
					var hb = hintFromExpr(b);
					// If any is String, result is String
					if ((ha != null && typeEq(ha, TTString)) || (hb != null && typeEq(hb, TTString))) return TTString;
					
					// Refined numeric logic:
					// If either is explicitly Number, result is Number
					if ((ha != null && ha.match(TTNumber)) || (hb != null && hb.match(TTNumber))) return TTNumber;
					// If either is Int (and other is not Number/String), result is Int (Int + Unknown -> Int)
					if (isNumericType(ha) || isNumericType(hb)) return TTInt;
				}

			case TECast(c):
				return hintFromExpr(c.expr);
			
			case TEPreUnop(op, _):
				if (op.match(PreBitNeg(_))) return TTInt;
				if (op.match(PreNeg(_))) return TTNumber;
				if (op.match(PreNot(_))) return TTBoolean;
				if (op.match(PreIncr(_) | PreDecr(_))) return TTNumber;

			case TEPostUnop(_, op):
				return TTNumber;
				
			case TEArrayDecl(_):
				return TypedTreeTools.tUntypedArray; // Array<Any>
				
			case TENew(_, cls, _):
				switch cls {
					case TNType(t): return t.type;
					case _:
				}
				
			case TECall(eobj, args):
				switch eobj.kind {
					case TEField(o, "round" | "floor" | "ceil", _):
						return TTInt;
					case TEField(o, "fround" | "acos" | "asin" | "atan" | "atan2" | "cos" | "exp" | "log" | "pow" | "random" | "sin" | "sqrt" | "tan", _):
						return TTNumber;
					case TEField(o, "abs" | "max" | "min", _):
						// Check args for these polymorphic functions
						var hasFloat = false;
						var hasInt = false;
						for (arg in args.args) {
							var h = hintFromExpr(arg.expr);
							if (h != null) {
								if (h.match(TTNumber)) hasFloat = true;
								else if (isNumericType(h)) hasInt = true;
							}
						}
						if (hasFloat) return TTNumber;
						if (hasInt) return TTInt;
						return null; // Unknown args
					case _:
				}
				
			case _:
		}
		
		return null;
	}

	static function isNumericType(t:TType):Bool {
		if (t == null) return false;
		return switch t {
			case TTInt | TTUint | TTNumber: true;
			case _: false;
		}
	}

	static function mergeTypes(current:TType, next:TType):Null<TType> {
		if (typeEq(current, next)) return current;
		
		// Int/UInt upgrade to Number
		if (isNumericType(current) && isNumericType(next)) {
			// If either is Number, result is Number.
			// If both are Int/UInt, result is Int/UInt (prefer Int?).
			// Simplification: Always Number if mixed?
			if (current.match(TTNumber) || next.match(TTNumber)) return TTNumber;
			return TTInt; // Both are Int-like
		}
		
		// Unification for classes?
		// e.g. Sprite and Sprite -> Sprite (handled by typeEq)
		// Sprite and MovieClip -> Incompatible for now (requires class hierarchy)
		
		return null;
	}

	static function typeToString(t:TType):String {
		// Simple stringifier for logging
		return switch t {
			case TTInt: "Int";
			case TTNumber: "Number";
			case TTBoolean: "Bool";
			case TTString: "String";
			case TTArray(_): "Array";
			case TTInst(c): c.name;
			case _: Std.string(t);
		}
	}

	static function isNumericAssignOp(op:AssignOp):Bool {
		return switch op {
			case AOpAdd(_) | AOpSub(_) | AOpMul(_) | AOpDiv(_) | AOpMod(_)
			   | AOpBitAnd(_) | AOpBitOr(_) | AOpBitXor(_)
			   | AOpShl(_) | AOpShr(_) | AOpUshr(_):
				true;
			case AOpAnd(_) | AOpOr(_):
				false;
		}
	}
	
	static function isBitwiseOp(op:Binop):Bool {
		return switch op {
			case OpShl(_) | OpShr(_) | OpUshr(_) | OpBitAnd(_) | OpBitOr(_) | OpBitXor(_): true;
			case _: false;
		}
	}
	
	static function isArithmeticOp(op:Binop):Bool {
		return switch op {
			case OpSub(_) | OpMul(_) | OpDiv(_) | OpMod(_): true;
			// OpAdd is ambiguous
			case _: false;
		}
	}
	
	static function isComparisonOp(op:Binop):Bool {
		return switch op {
			case OpEquals(_) | OpNotEquals(_) | OpStrictEquals(_) | OpNotStrictEquals(_) | OpGt(_) | OpGte(_) | OpLt(_) | OpLte(_): true;
			case _: false;
		}
	}
	
	static function isBoolOp(op:Binop):Bool {
		return switch op {
			case OpAnd(_) | OpOr(_): true;
			case _: false;
		}
	}
}
