package ax3.filters;

import ax3.ParseTree.Binop;

class RewriteAssignOps extends AbstractFilter {
	var tempId:Int = 0;

	override function processExpr(e:TExpr):TExpr {
		e = mapExpr(processExpr, e);
		return switch e.kind {
			// int/uint /= int/uint/Number
			case TEBinop(a = {type: TTInt | TTUint}, OpAssignOp(AOpDiv(t)), b):
				if (!canBeRepeated(a)) {
					throwError(exprPos(a), "left side of `/=` must be safe to repeat");
				}

				var op:Binop = OpDiv(t.clone());

				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var eValue = mk(TEBinop(leftSide, op, b.with(expectedType = TTNumber)), TTNumber, a.type);

				e.with(kind = TEBinop(
					a,
					OpAssign(new Token(0, TkEquals, "=", [], [whitespace])),
					eValue
				));

			// int/uint %= Number
			// int/uint *= Number
			case TEBinop(a = {type: TTInt | TTUint}, OpAssignOp(aop = (AOpMod(_) | AOpMul(_))), b = {type: TTNumber}):
				if (!canBeRepeated(a)) {
					throwError(exprPos(a), "left side of `%=` and `*=` must be safe to repeat");
				}

				var op:Binop = switch aop {
					case AOpMod(t): OpMod(t.clone());
					case AOpMul(t): OpMul(t.clone());
					case _: throw "assert";
				}

				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var eValue = mk(TEBinop(leftSide, op, b.with(expectedType = TTNumber)), TTNumber, a.type);

				e.with(kind = TEBinop(
					a,
					OpAssign(new Token(0, TkEquals, "=", [], [whitespace])),
					eValue
				));

			// ||=
			// &&=
			case TEBinop(a, OpAssignOp(aop = (AOpAnd(_) | AOpOr(_))), b):
				if (!canBeRepeated(a)) {
					throwError(exprPos(a), "left side of `||=` and `&&=` must be safe to repeat");
				}

				var op:Binop = switch aop {
					case AOpAnd(t): OpAnd(t.clone());
					case AOpOr(t): OpOr(t.clone());
					case _: throw "assert";
				}

				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var eValue = mk(TEBinop(leftSide, op, b), a.type, a.expectedType);

				e.with(kind = TEBinop(
					a,
					OpAssign(new Token(0, TkEquals, "=", [], [whitespace])),
					eValue
				));

			// bitwise assign ops (|=, &=, ^=, <<=, >>=, >>>=)
			case TEBinop(a, OpAssignOp(aop = (AOpBitAnd(_) | AOpBitOr(_) | AOpBitXor(_) | AOpShl(_) | AOpShr(_) | AOpUshr(_))), b):
				if (!canBeRepeated(a)) {
					var rewritten = rewriteBitwiseAssignUnsafe(a, aop, b, e);
					if (rewritten != null) return rewritten;
					throwError(exprPos(a), "left side of bitwise assign ops must be safe to repeat");
				}

				var op:Binop = switch aop {
					case AOpBitAnd(t): OpBitAnd(t.clone());
					case AOpBitOr(t): OpBitOr(t.clone());
					case AOpBitXor(t): OpBitXor(t.clone());
					case AOpShl(t): OpShl(t.clone());
					case AOpShr(t): OpShr(t.clone());
					case AOpUshr(t): OpUshr(t.clone());
					case _: throw "assert";
				}

				var leftSide = cloneExpr(a);
				removeLeadingTrivia(leftSide);
				var leftValue = wrapToInt(leftSide);
				var rightValue = wrapToInt(b);

				var resultType = switch aop {
					case AOpUshr(_): TTUint;
					case _: TTInt;
				};

				var eValue = mk(TEBinop(leftValue, op, rightValue), resultType, a.type);
				if (a.type == TTUint && resultType == TTInt) {
					eValue = mk(TEHaxeRetype(eValue), TTUint, TTUint);
				}

				e.with(kind = TEBinop(
					a,
					OpAssign(new Token(0, TkEquals, "=", [], [whitespace])),
					eValue
				));

			case _:
				e;
		}
	}

	function rewriteBitwiseAssignUnsafe(a:TExpr, aop:AssignOp, b:TExpr, original:TExpr):Null<TExpr> {
		if (original.expectedType != TTVoid) {
			return null;
		}
		return switch a.kind {
			case TEArrayAccess(access):
				rewriteArrayAccessBitwiseAssign(access, a, aop, b, original);
			case _:
				null;
		}
	}

	function rewriteArrayAccessBitwiseAssign(access:TArrayAccess, a:TExpr, aop:AssignOp, b:TExpr, original:TExpr):TExpr {
		var lead = removeLeadingTrivia(original);
		var trail = removeTrailingTrivia(original);

		var indent = extractIndent(lead);
		var tmpObjName = "__tmpAssignObj" + tempId++;
		var tmpIdxName = "__tmpAssignIdx" + tempId++;
		var tmpObjVar:TVar = {name: tmpObjName, type: access.eobj.type};
		var tmpIdxVar:TVar = {name: tmpIdxName, type: access.eindex.type};

		var declObj:TVarDecl = {
			syntax: {name: mkIdent(tmpObjName), type: null},
			v: tmpObjVar,
			init: {equalsToken: mkTokenWithSpaces(TkEquals, "="), expr: access.eobj},
			comma: null
		};
		var declIdx:TVarDecl = {
			syntax: {name: mkIdent(tmpIdxName), type: null},
			v: tmpIdxVar,
			init: {equalsToken: mkTokenWithSpaces(TkEquals, "="), expr: access.eindex},
			comma: null
		};

		var varTokenObj = mkIdent("var", lead, [whitespace]);
		var varTokenIdx = mkIdent("var", cloneTrivia(indent), [whitespace]);
		var declObjExpr = mk(TEVars(VVar(varTokenObj), [declObj]), TTVoid, TTVoid);
		var declIdxExpr = mk(TEVars(VVar(varTokenIdx), [declIdx]), TTVoid, TTVoid);

		var lhs = mk(TEArrayAccess({
			syntax: access.syntax,
			eobj: mk(TELocal(mkIdent(tmpObjName), tmpObjVar), tmpObjVar.type, tmpObjVar.type),
			eindex: mk(TELocal(mkIdent(tmpIdxName), tmpIdxVar), tmpIdxVar.type, tmpIdxVar.type)
		}), a.type, a.type);

		var rhsLeft = wrapToInt(cloneExpr(lhs));
		var rhsRight = wrapToInt(b);

		var op:Binop = switch aop {
			case AOpBitAnd(t): OpBitAnd(t.clone());
			case AOpBitOr(t): OpBitOr(t.clone());
			case AOpBitXor(t): OpBitXor(t.clone());
			case AOpShl(t): OpShl(t.clone());
			case AOpShr(t): OpShr(t.clone());
			case AOpUshr(t): OpUshr(t.clone());
			case _: throw "assert";
		}

		var resultType = switch aop {
			case AOpUshr(_): TTUint;
			case _: TTInt;
		};

		var rhsValue = mk(TEBinop(rhsLeft, op, rhsRight), resultType, a.type);
		if (a.type == TTUint && resultType == TTInt) {
			rhsValue = mk(TEHaxeRetype(rhsValue), TTUint, TTUint);
		}

		var assignExpr = mk(TEBinop(lhs, OpAssign(new Token(0, TkEquals, "=", [], [whitespace])), rhsValue), a.type, original.expectedType);

		var semiDecl = addTrailingNewline(mkSemicolon());
		var semiDecl2 = addTrailingNewline(mkSemicolon());
		var semiAssign = mkSemicolon();
		semiAssign.trailTrivia = trail;

		return mkMergedBlock([
			{expr: declObjExpr, semicolon: semiDecl},
			{expr: declIdxExpr, semicolon: semiDecl2},
			{expr: assignExpr, semicolon: semiAssign}
		]);
	}

	static function wrapToInt(e:TExpr):TExpr {
		return switch e.type {
			case TTInt | TTUint:
				e;
			case _:
				var lead = removeLeadingTrivia(e);
				var trail = removeTrailingTrivia(e);
				var toInt = mkBuiltin("ASCompat.toInt", TTFun([TTAny], TTInt), lead);
				mkCall(toInt, [e.with(expectedType = e.type)], TTInt, trail);
		}
	}

	static function extractIndent(trivia:Array<Trivia>):Array<Trivia> {
		var result:Array<Trivia> = [];
		for (item in trivia) {
			switch item.kind {
				case TrWhitespace:
					result.push(item);
				case TrNewline:
					result = [];
				case _:
			}
		}
		return result;
	}

	static function cloneTrivia(trivia:Array<Trivia>):Array<Trivia> {
		return [for (item in trivia) new Trivia(item.kind, item.text)];
	}
}
