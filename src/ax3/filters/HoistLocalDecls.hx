package ax3.filters;

private typedef DeclInfo = {
	var decl:TVarDecl;
	var kind:VarDeclKind;
}

class HoistLocalDecls extends AbstractFilter {
	override function processExpr(e:TExpr):TExpr {
		return switch e.kind {
			case TEBlock(block):
				var updated = hoistBlock(block);
				if (updated == block) e else e.with(kind = TEBlock(updated));

			case _:
				mapExpr(processExpr, e);
		};
	}

	function hoistBlock(block:TBlock):TBlock {
		var declInfo = new Map<TVar, DeclInfo>();
		var declOrder:Array<TVar> = [];

		for (blockExpr in block.exprs) {
			switch blockExpr.expr.kind {
				case TEVars(kind, decls):
					for (decl in decls) {
						if (!declInfo.exists(decl.v)) {
							declInfo[decl.v] = {decl: decl, kind: kind};
							declOrder.push(decl.v);
						}
					}
				case _:
			}
		}

		if (declOrder.length == 0) {
			return block;
		}

		var declared = new Map<TVar, Bool>();
		var hoist = new Map<TVar, Bool>();

		for (blockExpr in block.exprs) {
			var expr = blockExpr.expr;

			function scan(e:TExpr) {
				switch e.kind {
					case TELocal(_, v):
						if (!declared.exists(v) && declInfo.exists(v)) {
							hoist[v] = true;
						}
					case _:
				}
				iterExpr(scan, e);
			}

			scan(expr);

			switch expr.kind {
				case TEVars(_, decls):
					for (decl in decls) {
						declared[decl.v] = true;
					}
				case _:
			}
		}

		var hasHoisted = false;
		for (_ in hoist.keys()) {
			hasHoisted = true;
			break;
		}
		if (!hasHoisted) {
			return block;
		}

		var hoistedDecls:Array<TVarDecl> = [];
		for (v in declOrder) {
			if (!hoist.exists(v)) continue;
			var info = declInfo[v];
			var nameToken = info.decl.syntax.name.clone();
			nameToken.leadTrivia = [];
			nameToken.trailTrivia = [];
			hoistedDecls.push({
				syntax: {name: nameToken, type: cloneTypeHint(info.decl.syntax.type)},
				v: v,
				init: null,
				comma: null,
			});
		}

		var hoistedExprs:Array<TBlockExpr> = [];
		if (hoistedDecls.length > 0) {
			var leadingTrivia =
				if (block.exprs.length > 0) processLeadingToken(t -> t.leadTrivia.copy(), block.exprs[0].expr) else [];
			var indentTrivia = extractIndent(leadingTrivia);
			var isFirst = true;
			for (decl in hoistedDecls) {
				var lead = isFirst ? leadingTrivia : cloneTrivia(indentTrivia);
				var varToken = mkIdent("var", lead, [whitespace]);
				var hoistDecl = mk(TEVars(VVar(varToken), [decl]), TTVoid, TTVoid);
				hoistedExprs.push({expr: hoistDecl, semicolon: addTrailingNewline(mkSemicolon())});
				isFirst = false;
			}
		}

		var newExprs = mapBlockExprs(function(e) {
			return processExpr(rewriteVars(e, hoist));
		}, block.exprs);

		if (hoistedExprs.length == 0) {
			return block;
		}

		return block.with(exprs = hoistedExprs.concat(newExprs));
	}

	function rewriteVars(expr:TExpr, hoist:Map<TVar, Bool>):TExpr {
		return switch expr.kind {
			case TEVars(kind, decls):
				var remaining:Array<TVarDecl> = [];
				var assignments:Array<TBlockExpr> = [];
				var lead = removeLeadingTrivia(expr);
				var trail = removeTrailingTrivia(expr);

				for (decl in decls) {
					if (!hoist.exists(decl.v)) {
						remaining.push(decl);
						continue;
					}
					if (decl.init != null) {
						assignments.push({expr: mkAssign(decl), semicolon: mkSemicolon()});
					}
				}

				var exprs:Array<TBlockExpr> = [];
				if (remaining.length > 0) {
					exprs.push({expr: mk(TEVars(kind, remaining), TTVoid, TTVoid), semicolon: mkSemicolon()});
				}
				exprs = exprs.concat(assignments);

				if (exprs.length == 0) {
					return mkMergedBlock([]);
				}
				if (exprs.length == 1) {
					processLeadingToken(t -> t.leadTrivia = lead.concat(t.leadTrivia), exprs[0].expr);
					processTrailingToken(t -> t.trailTrivia = t.trailTrivia.concat(trail), exprs[0].expr);
					return exprs[0].expr;
				}

				processLeadingToken(t -> t.leadTrivia = lead.concat(t.leadTrivia), exprs[0].expr);
				processTrailingToken(t -> t.trailTrivia = t.trailTrivia.concat(trail), exprs[exprs.length - 1].expr);
				return mkMergedBlock(exprs);

			case _:
				mapExpr(processExpr, expr);
		}
	}

	function mkAssign(decl:TVarDecl):TExpr {
		var nameToken = decl.syntax.name.clone();
		nameToken.leadTrivia = [];
		nameToken.trailTrivia = [];
		var left = mk(TELocal(nameToken, decl.v), decl.v.type, decl.v.type);
		var assignToken = new Token(0, TkEquals, "=", [whitespace], [whitespace]);
		return mk(TEBinop(left, OpAssign(assignToken), decl.init.expr), decl.v.type, TTVoid);
	}

	function cloneTypeHint(type:Null<TypeHint>):Null<TypeHint> {
		if (type == null) return null;
		return {
			colon: type.colon.clone(),
			type: cloneSyntaxType(type.type)
		};
	}

	function cloneSyntaxType(type:SyntaxType):SyntaxType {
		return switch (type) {
			case TAny(star):
				var cloned = star.clone();
				cloned.trimTrailingWhitespace();
				TAny(cloned);
			case TPath(path):
				var cloned = cloneDotPath(path);
				processDotPathTrailingToken(t -> t.trimTrailingWhitespace(), cloned);
				TPath(cloned);
			case TVector(v):
				var cloned = {
					name: v.name.clone(),
					dot: v.dot.clone(),
					t: {
						lt: v.t.lt.clone(),
						type: cloneSyntaxType(v.t.type),
						gt: v.t.gt.clone(),
					}
				};
				cloned.t.gt.trimTrailingWhitespace();
				TVector(cloned);
		}
	}

	function cloneDotPath(path:DotPath):DotPath {
		return {
			first: path.first.clone(),
			rest: [for (part in path.rest) {sep: part.sep.clone(), element: part.element.clone()}]
		};
	}

	function extractIndent(trivia:Array<Trivia>):Array<Trivia> {
		var result:Array<Trivia> = [];
		var hadOnlyWhitespace = true;
		for (item in trivia) {
			switch item.kind {
				case TrBlockComment | TrLineComment:
					result = [];
					hadOnlyWhitespace = false;
				case TrNewline:
					result = [];
					hadOnlyWhitespace = true;
				case TrWhitespace:
					result.push(item);
			}
		}
		return if (hadOnlyWhitespace) cloneTrivia(result) else [];
	}

	function cloneTrivia(trivia:Array<Trivia>):Array<Trivia> {
		return [for (item in trivia) new Trivia(item.kind, item.text)];
	}
}