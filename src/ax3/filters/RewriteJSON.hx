package ax3.filters;

class RewriteJSON extends AbstractFilter {
	override function processExpr(e:TExpr):TExpr {
		return switch e.kind {
			case TEDeclRef(_, {kind: TDClassOrInterface({name: "JSON", parentModule: {parentPack: {name: ""}}})}):
				mkBuiltin("ASCompat", TTBuiltin, removeLeadingTrivia(e), removeTrailingTrivia(e));
			case _:
				mapExpr(processExpr, e);
		}
	}
}
