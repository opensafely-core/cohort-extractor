*! version 1.1.7  05feb2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile nlparse_macros.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __sub_expr.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_cov.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on


void __menl_expr::new()
{
	clear()
	set_special(NULL,SPECIAL_APP_MENL)
}

void __menl_expr::destroy()
{
	clear()
}

void __menl_expr::clear()
{
	real scalar k, i

	k = length(m_seRE)
	for (i=1; i<=k; i++) {
		m_seRE[i] = NULL
	}
	m_seRE = J(1,0,NULL)

	super.clear()
}

real scalar __menl_expr::_parse_expression(string scalar expression)
{
	return(super._parse_expression(expression))
}

real scalar __menl_expr::_parse_equation(string scalar expression,
			|string scalar eqname)
{
	return(super._parse_equation(expression,eqname))
}

real scalar __menl_expr::parse_equation(string scalar expression,
		|real scalar noconst, real scalar xb)
{
	real scalar rc, type
	string scalar depvar
	class __menl_expr scalar expr

	pragma unset depvar

	noconst  = (missing(noconst)?`SUBEXPR_FALSE':(noconst!=`SUBEXPR_FALSE'))
	xb  = (missing(xb)?`SUBEXPR_FALSE':(xb!=`SUBEXPR_FALSE'))
	if (noconst | xb) {
		if (rc=expr._set_touse(touse(),`SUBEXPR_TRUE')) {
			/* should not happen				*/
			m_errmsg = expr.errmsg()
			return(rc)
		}
		if (xb) {
			expression = expression + ", xb"
		}
		if (rc=expr._parse_equation(expression,depvar)) {
			m_errmsg = expr.errmsg()
			expr.clear()
			return(rc)
		}
		type = expr.equation_type(depvar)
		if (type != LINEAR_COMBINATION) {
			m_errmsg = "option {bf:noconstant} not allowed; " +
				"equation must have a linear form"
			expr.clear()
			return(198)
		}
		expr.clear()
		if (noconst) {
			if (xb) {
				expression = expression + " noconstant"
			}
			else {
				expression = expression + ", noconstant"
			}
		}
	}
	return(super._parse_equation(expression,depvar))
}

real scalar __menl_expr::_parse_expr_init(string scalar exinit)
{
	return(super._parse_expr_init(exinit))
}


real scalar __menl_expr::parse_expr_init(string scalar exinit)
{
	real scalar rc, k, state, type
	string scalar tok, name, msg, msg1, expr
	pointer (class __component_group) scalar pG
	transmorphic t

	msg = "invalid expression initialization"

	expr = ""
	t = tokeninit(" ","=",("{}"))
	tokenset(t,exinit)
	tok = tokenget(t)
	state = 0	// go nothing
	while (ustrlen(tok)) {
		if (state == 0) {
			if (ustrleft(tok,1) == "{") {
				k = ustrlen(tok)-2
				if (k<=1) {
					set_errmsg(sprintf("%s {bf:%s}: " + 
						"substitutable expression " + 
						"name required",msg,exinit))
					return(198)
				}
				name = usubstr(tok,2,k)
				if (ustrright(name,1) != ":") {
					set_errmsg(sprintf("%s {bf:%s}: " +
						"parameter name not allowed; " +
						"substitutable expression " +
						"name required",msg,tok))
					return(198)
				}
				name = ustrleft(name,--k)
				state = 1	// got name
			}
			else if (tok == "_yhat") {
				k = eq_count()
				if (k != 1) {
					msg1 = "cannot use equation synonym " +
						"{bf:_yhat}"
					if (!k) {
						set_errmsg(sprintf("%s: " +
						 	"synonym {bf:_yhat} " +
							"undefined, no " +
							"equations defined",
							msg1))
					}
					else {
						set_errmsg(sprintf("%s: " +
							"synonym {bf:_yhat} " +
							"ambiguous, %g " +
							"equations defined",
							msg1,k))
					}
					return(111)
				}
				name = eq_names()[1]
				state = 1	// got name
			}
		}
		else if (state = 1) {
			if (tok != "=") {
				set_errmsg(sprintf("%s {bf:%s}: " +
					"substitutable expression name " +
					"required",msg,exinit))
				return(198)
			}
			state = 2	// got equal
			break
		}
		tok = tokenget(t)
	}
	if (state == 2) {
		expr = ustrtrim(tokenrest(t))
	}
	if (!ustrlen(expr)) {
		set_errmsg(sprintf("%s {bf:%s}",msg,exinit))
		return(198)
	}
	pG = lookup_component((`SUBEXPR_GROUP_SYMBOL',name))
	if (pG == NULL) {
		rc = 111
		set_errmsg(sprintf("%s {bf:%s}: expression %s not found",msg1,
			exinit,name))
		return(rc)
	}
	type = pG->group_type()
	if (type==`SUBEXPR_EQ_EXPRESSION' | type==`SUBEXPR_EQ_LC') {
		/* equation that -_nlparse- recognizes			*/
		expr = sprintf("%s = %s",name,expr)
		msg1 = "equation"
	}
	else if (type==`SUBEXPR_GROUP_EXPRESSION' | type==`SUBEXPR_GROUP_LC') {
		/* named expression that -_nlparse- recognizes		*/
		expr = sprintf("%s: %s",name,expr)
		msg1 = "expression"
	}
	else {
		rc = 498
		set_errmsg(sprintf("%s {bf:%s}: %s not allowed",msg,exinit,
			pG->sgroup_type()))
		return(rc)
	}
	rc = _parse_expr_init(expr)

	return(rc)
}

/* virtual function for special resolve handling 			*/
real scalar __menl_expr::_resolve_group(
		pointer (class __component_group) scalar pG,
		pointer (class __component_group) vector pargrps)
{
	real scalar i, k, kr, kp, ke, gtype, rc, rc1
	string scalar expr, msg 
	pointer (class __sub_expr_group) scalar pSE
	pointer (class __sub_expr_group) vector rdef
	struct nlparse_node scalar tree

	pragma unset msg

	rc = 0
	gtype = pG->group_type()
	if (gtype==`SUBEXPR_GROUP_PARAM' | gtype==`SUBEXPR_GROUP_EXPRESSION'
		| gtype==`SUBEXPR_GROUP_LC') {
		/* remove unused objects: not in a linked list		*/
		kr = 0
		rdef = J(1,0,NULL)
		k = pG->group_count()
		for (i=1; i<=k; i++) {
			pSE = pG->get_object(i)
			if (!pSE->has_property(`SUBEXPR_PROP_TEMPLATE')) {
				if (pSE->prev()==NULL & pSE->next()==NULL) {
 					/* not part of any expression;
					 *  que for removal		*/
					kr++
					rdef = (rdef,pSE)
				}
			}
		}
		pSE = NULL
		if (kr == k) {
			/* all are not used				*/
			set_errmsg(sprintf("%s {bf:%s} not used in any " +
				"expression or equation",
				 pG->sgroup_type(),pG->name()))
			m_message = sprintf("Reference the %s in an " +
				"expression or equation as {bf:{%s:}}. " +
				"Perhaps you have omitted the colon.",
				pG->sgroup_type(),pG->name())

			return(498)
		}
		if (kr & gtype!=`SUBEXPR_GROUP_PARAM') {
			if (kr > 1) {
				add_warning(sprintf("%g %ss with name " +
					"{bf:%s} are defined but not used; " +
					"removing them",kr,pG->sgroup_type(),
					pG->name()))
			}
			else {
				add_warning(sprintf("a %s with name {bf:%s} " +
					"is defined but not used; removing it",
					pG->sgroup_type(),pG->name()))
			}
		}
		for (i=1; i<=kr; i++) {
 			/* not part of any expression; remove notifies
			 *  group component				*/
			if (rc1=remove_group(rdef[i])) {
				rc = rc1
			}
			rdef[i] = NULL
		}
		rdef = J(1,0,NULL)
		if (rc) {
			return(rc)
		}
	}
	if (gtype == `SUBEXPR_GROUP_LC') {
		k = pG->group_count()	// new count
		if (k == 1) {
			if (kp=length(pargrps)) {
				if (pargrps[kp] == pG) {
					/* prevent GROUP_LC to GROUP_PARAM
					 * conversion			*/
					if (kp > 1) {
						pargrps[kp] = NULL
						pargrps = pargrps[|1\--kp|]
					}
					else {
						pargrps = J(1,0,NULL)
					}
				}
			}
		}
		k = pG->group_count()
		for (i=1; i<=k; i++) {
			pSE = pG->get_object(i)
			tree = pSE->parse_tree()
			if (tree.type == `NULL') {
				/* construct a parse tree for LC
				 *  needed for null model computation	*/
				expr = pSE->traverse_expr(`SUBEXPR_FULL')
				ke = 0
				if (length(pSE->options())) {
					/* remove outer braces and 
					 * options			*/
					ke = max((ustrrpos(expr,",")-2,0))
				}
				if (!ke) {
					/* remove outer braces		*/
					ke = ustrlen(expr)-2
				}
				expr = usubstr(expr,2,ke)
				if (rc=_nlparse(expr,tree,msg)) {
					/* should not happen		*/
					pSE = NULL
					set_errmsg(sprintf("failed to " +
						"construct parse tree " +
						"for linear combination " +
						"{bf:%s}: %s",expr,msg))
					return(rc)
				}
				pSE->set_parse_tree(tree)
			}
			pSE = NULL
		}
	}
	return(rc)
}

real scalar __menl_expr::_resolve_expressions(|string scalar tvar,
			string scalar gvar)
{
	return(super._resolve_expressions(tvar,gvar))
}

real scalar __menl_expr::_gen_hierarchy_panel_info(string scalar eq,
		|string vector path, real scalar noegen)
{
	return(super._gen_hierarchy_panel_info(eq,path,noegen))
}

real scalar __menl_expr::set_param_from_spec(string scalar init, 
			|real scalar skip)
{
	return(super.set_param_from_spec(init,skip))
}

real scalar __menl_expr::set_param_from_vec(real vector b)
{
	return(super.set_param_from_vec(b))
}

real scalar __menl_expr::set_param_by_stripe(real vector b, string matrix spec)
{
	return(super.set_param_by_stripe(b,spec))
}

real scalar __menl_expr::set_param_by_index(real vector b, real vector index)
{
	return(super.set_param_by_index(b,index))
}

real scalar __menl_expr::_set_RE_parameters(real vector b, string scalar REname)
{
	return(super._set_LV_parameters(b,REname))
}

real vector __menl_expr::RE_parameters(string scalar REname)
{
	return(super.LV_parameters(REname))
}

real scalar __menl_expr::_set_RE_stderr(pointer (real matrix) vector seRE)
{
	real scalar i, j, klev, ih, klv, k
	string scalar path
	string vector lvs
	string matrix paths
	pointer (struct _lvhinfo) scalar hinfo


	paths = m_hierarchy.paths()
	ih = 1				// only 1 hierarch, no crossed effects
	hinfo = m_hierarchy.hinfo(ih)
	i = hinfo->hrange[1]
	j = hinfo->hrange[2]
	hinfo = NULL
	paths = paths[|i,1\j,cols(paths)|]
	klev = rows(paths)

	if (length(seRE) != klev) {
		m_errmsg = sprintf("failed to set RE standard errors; " +
			"hierarchy has %g levels but standard error " +
			"structure has only %g",klev,length(seRE))
		return(498)
	}
	m_seRE = J(1,klev,NULL)
	for (i=1; i<=klev; i++) {
		lvs = tokens(paths[i,`MENL_HIER_LV_NAMES'])
		klv = length(lvs)
		path = paths[i,`MENL_HIER_PATH']
		k = cols(*seRE[i])
		if (k != klv) {
			m_errmsg = sprintf("failed to set RE standard " +
				"errors; expected standard errors for %g " +
				"random variables for path {bf:%s}, but got %g",
				klv,path,k)
			return(498)
		}
		m_seRE[i] = &J(1,1,*seRE[i])
	}
	return(0)
}

string vector __menl_expr::varlist(|string scalar ename, real scalar nameonly)
{
	return(super.varlist(ename,nameonly))
}

pointer (real matrix) vector __menl_expr::RE_stderr()
{
	return(m_seRE)
}

void __menl_expr::expr_covariates(
		pointer (class __sub_expr_group) scalar pG,
		string vector covariates)
{
	real scalar type
	string scalar param, var
	string vector cov1
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_elem) scalar pE

	pE = pG->first()
	while (pE != NULL) {

		pC = pE->component()
		if (pC == NULL) { // string expression if NULL
			goto Next
		}
		type = pC->type()
		if (type == `SUBEXPR_GROUP') {
			expr_covariates(pE,covariates)
		}
		else if (type==`SUBEXPR_LC_PARAM' | type==`SUBEXPR_FV_PARAM') {
			param = pC->name()
			if (param != "_cons") {
				if (length(covariates)) {
					if (!any(covariates:==param)) {
						covariates = (covariates,param)
					}
				}
				else {
					covariates = param
				}
			}
		}
		else if (type == `SUBEXPR_FV') {
			cov1 = pC->data(`SUBEXPR_HINT_FV_NAMES')
			if (length(covariates)) {
				if (!any(covariates:==cov1[1])) {
					covariates = (covariates,cov1)
				}
			}
			else {
				covariates = cov1
			}
		}
		else if (type == `SUBEXPR_VARIABLE') {
			var = pC->name()
			__sub_expr_drop_TS_op(var)
			if (length(covariates)) {
				if (!any(covariates:==var)) {
					covariates = (covariates,var)
				}
			}
			else {
				covariates = var
			}
		}
		pC = NULL

		Next: pE = pE->next()
	}
}

string vector __menl_expr::covariates()
{
	real scalar k, m, i, j
	string vector covariates
	pointer (class __component_group) scalar pC
	pointer (class __sub_expr_group) scalar pE

	covariates = J(1,0,"")
	k = length(m_equations)
	for (i=1; i<=k; i++) {
		pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',
				m_equations[i]))
		m = pC->group_count()
		for (j=1; j<=m; j++) {
			pE = pC->get_object(j)
			if (pE->first() == NULL) {
				/* recursive model, skip this object	*/
			}
			expr_covariates(pE,covariates)
		}
	}
	pE = NULL
	pC = NULL

	return(covariates)
}

class __stmatrix scalar __menl_expr::stparameters()
{
	return(super.stparameters())
}

real scalar __menl_expr::equation_type(string scalar eqname)
{
	real scalar k, ieq, type
	real vector jeq
	pointer (class __component_group) scalar pC

	type = NULL_EXPRESSION
	k = length(m_equations)
	if (!k) {
		m_errmsg = "no equations exist"
		return(type)
	}
	jeq = (eqname:==m_equations)
	if (!any(jeq)) {
		m_errmsg = sprintf("equation {bf:%s} not found",eqname)
		return(type)
	}
	if (k > 1) {
		ieq = select(1..k,jeq)[1]
	}
	else {
		ieq = 1
	}
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',m_equations[ieq]))
	type = pC->group_type()
	pC = NULL

	return(type)
}

real scalar __menl_expr::is_linear_equation(string scalar eq)
{
	real scalar lc
	string vector key
	pointer (class __component_group) scalar pC

	lc = `SUBEXPR_FALSE'

	key = (`SUBEXPR_GROUP_SYMBOL',eq)
	pC = lookup_component(key)
	if (pC == NULL) {
		return(lc)
	}
	lc = (pC->group_type()==`SUBEXPR_EQ_LC')
	pC = NULL

	return(lc)
}


real scalar _menl_varlist_node_has_LV(struct nlparse_node scalar node)
{
	real scalar i

	if (_menl_is_LV_node(node)) {
		return(`SUBEXPR_TRUE')
	}
	if (node.type != `OPERATOR') {
		return(`SUBEXPR_FALSE')
	}
	for (i=1; i<=node.narg; i++) {
		if (_menl_varlist_node_has_LV(node.arg[i])) {
			return(`SUBEXPR_TRUE')
		}
	}
	return(`SUBEXPR_FALSE')
}

real scalar _menl_is_LV_node(struct nlparse_node scalar node)
{
	return(node.type==`LATENTVAR'|node.type==`LVPARAM')
}

real scalar _menl_prune_tree_LV(struct nlparse_node scalar node,
			struct nlparse_node scalar pnode)
{
	real scalar i, j, prune
	struct nlparse_node scalar nodei

// pt_dump_node(node)
	prune = `SUBEXPR_FALSE'
	if (node.type == `SYMBOL') {
		return(prune)
	}
	if (_menl_is_LV_node(node)) {
		node = pnode	// prune, set to parent node
		prune = `SUBEXPR_TRUE'
	}
	else if (node.type == `OPERATOR') {
		if (node.narg == 2) {
			if (_menl_is_LV_node(node.arg[1]) & 
				_menl_is_LV_node(node.arg[2])) {
				node = pnode	// set to parent
				prune = `SUBEXPR_TRUE'
			}
			else if (_menl_is_LV_node(node.arg[1])) {
				node = node.arg[2]	// set to right node
				prune = `SUBEXPR_TRUE'
			}
			else if (_menl_is_LV_node(node.arg[2])) {
				node = node.arg[1]	// set to left node
				prune = `SUBEXPR_TRUE'
			}
		}
	}
	else if (node.type == `VARLIST') {
		i = 1
		while (i<=node.narg) {
			if (_menl_varlist_node_has_LV(node.arg[i])) {
				if (node.narg == 1) {
					/* create a constant node to
					 *  retain linear combination	*/
					node.arg[i].symb = "_cons"
					node.arg[i].type = `SYMBOL'
					node.arg[i].narg = 0
					node.arg[i].arg = nlparse_node(0)
					i++
				}
				else {
					/* prune			*/
					for (j=i; j<node.narg; j++) {
						node.arg[j] = node.arg[j+1]
					}
					node.arg[node.narg] = nlparse_node()
					node.narg = node.narg-1
				}
				prune = `SUBEXPR_TRUE'
			}
			else {
				i++
			}
		}		
		return(prune)
	}
	if (!prune) {
		i = 1
		while (i<=node.narg) {
 			/* make copies for safe Mata recursive tree 
			 * pruning					*/
			nodei = pt_clone_tree(node.arg[i])
			if (_menl_prune_tree_LV(nodei,pnode)) {
				/* copy	again				*/
				node.arg[i] = pt_clone_tree(nodei)
				/* recursive function; set prune	*/
				prune = `SUBEXPR_TRUE'
			}
			i++
		}
	}
	return(prune)
}

real scalar __menl_expr::null_model(class __menl_expr scalar nullmodel,
			real scalar hasnull, string vector touse)
{
	real scalar type, gtype, i, k, rc, prune, kobj
	real scalar notemplate
	string scalar expr, group, msg, tsvar, panelvar, eq
	string vector options
	class __ecovmatrix scalar evar
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pSE, pSE1
	struct nlparse_node scalar tree, null, vlist

	pragma unset msg
	pragma unset pSE

	rc = 0
	hasnull = `SUBEXPR_FALSE'
	if (!has_LVs()) {
		if (m_var.vtype()==m_var.HOMOSKEDASTIC & 
			m_var.ctype()==m_var.INDEPENDENT) {
			return(rc)
		}
	}

	null.type = `NULL'
	null.symb = ""
	null.narg = 0
	null.arg = nlparse_node(0)

	if (rc=_stata(sprintf("gen byte %s = %s",touse[1],touse()))) {
		set_errmsg("failed to create NULL model")
		return(rc)
	}
	nullmodel.set_touse(touse[1])
	prune = kobj = 0
	pC = iterator_init()
	while (pC != NULL) {
		type = pC->type()
		if (type != `SUBEXPR_GROUP') {
			if (type != `SUBEXPR_PARAM') {
				goto Next
			}
			/* free parameter; check if in a group		*/
			group = pC->group()
			if (group == "/") {
				goto Next
			}
			if (usubstr(group,1,1) == "/") {	// should be
				group = ustrright(group,ustrlen(group)-1)
			}
			/* create a LINCOM tree				*/
			expr = sprintf("%s:%s",group,pC->name())
			if (rc=_nlparse(expr,tree,msg)) {
				set_errmsg(sprintf("failed to create NULL " +
					"model: %s",msg))
				pC = NULL
				return(rc)
			}
			/* will convert to a free parameter in group
			 *  required hack to allow the Stata define()
			 *  option define a free parameter in a group
			 *  there is a corresponding hack in 
			 *  __sub_expr::parse()				*/
			if (rc=nullmodel.create_param_from_LC(tree,pSE)) {
				set_errmsg(sprintf("failed to create NULL " +
					"model: %s",nullmodel.errmsg()))
				pC = NULL
				return(rc)
			}
			kobj++
			goto Next
		}
		pG = pC
		gtype = pG->group_type()
		if (gtype == `SUBEXPR_GROUP_PARAM') {
			/* collection of parameters, no parse tree	*/
			goto Next
		}
		k = pG->group_count()
		if (gtype != `SUBEXPR_GROUP_LC') {
			/* any duplicates are copies referenced
			 *  multiple times				*/
			k = 1
		}
		notemplate = `SUBEXPR_TRUE'
		for (i=1; i<=k; i++) {
			pSE = pG->get_object(i)
			pE = pSE->first(notemplate)
			if (pE != NULL) {
				if (pE->has_property(`SUBEXPR_PROP_TEMPLATE') &
					all(pE->key():==pSE->key())) {
					/* use template object		*/
					pSE = pE
				}
			}
			tree = pSE->parse_tree()
			if (tree.type == `NULL') {
				set_errmsg(sprintf("object {bf:%s} has no " +
					"parse tree",pSE->name()))
				pG = NULL
				pSE = NULL
				return(498)
			}
			prune = prune + _menl_prune_tree_LV(tree,null)
			if (tree.arg[2].type == `NULL') {
				/* expression only had a LVPARAM and
				 *  the pnode=null is in its place	*/
				continue
			}
 			options = pSE->options()
			if (gtype==`SUBEXPR_GROUP_LC' | 
				gtype==`SUBEXPR_EQ_LC') {
				vlist = tree.arg[2]
				if (vlist.arg[1].symb=="_cons" &
					__sub_expr_has_option(options,
						"noconstant",6)) {
					/* no null model; pruned off LV and
					 *  added _cons but noconst was
					 *  specified
					 * expression or equation no longer
					 *  exists			*/
					kobj = 0
					break
				}
				/* set xb option in case LC is stripped
				 *  to a single variable or _cons	*/
				if (!length(options)) {
					options = ("xb")
				}
				else if (!any(options:=="xb")) {
					options = (options,"xb")
				}
			}
			if (rc=nullmodel.traverse_tree(tree,pG->name(),gtype,
				options)) {
				set_errmsg(sprintf("failed to create NULL " +
					"model: %s",nullmodel.errmsg()))
				pC = NULL
				pG = NULL
				pSE = NULL
				return(rc)
			}
			kobj++
			pSE1 = pSE->component()->data(`SUBEXPR_HINT_INITOBJ')
			if (pSE1 != NULL) {
			/* has a TS initialization expression		*/
				tree = pSE1->parse_tree()
				if (tree.type == `NULL') {
					rc = 498
					set_errmsg(sprintf("{bf:tsinit()} " +
						"object for {bf:%s} has no " +
						"parse tree",pSE->name()))
					return(rc)
				}
				/* should not have anything to prune?	*/
				prune = prune + _menl_prune_tree_LV(tree,null)
				if (tree.arg[2].type != `NULL') {
					rc = nullmodel.traverse_expr_init(tree)
				}
			}
		}
		Next: pC = iterator_next()
	}
	pG = NULL
	pSE = NULL
	if (kobj) {
		eq = nullmodel.eq_names()[1]
		nullmodel.set_markout_depvar(markout_depvar())
		tsvar = stata_tsvar()
		if (ustrlen(tsvar)) {
			nullmodel.set_stata_tsvar(tsvar)
		}
		panelvar = stata_panelvar()
		if (ustrlen(panelvar)) {
			nullmodel.set_stata_panelvar(panelvar)
		}

		/* homoskedastic residual structure is the default	*/
		if (rc=nullmodel._resolve_expressions()) {
			set_errmsg(sprintf("failed to create NULL model: %s",
				nullmodel.errmsg()))
			return(rc)
		}
		if (nullmodel.TS_recursive(eq)) {
			/* cache name of equation estimation sample	*/
			st_local(touse[2],nullmodel.touse(eq))
		}
		if (rc=nullmodel._set_res_covariance(eq,
			evar.HOMOSKEDASTIC)) {
			set_errmsg(sprintf("failed to create NULL model: %s",
				nullmodel.errmsg()))
			return(rc)
		}
		if (rc=nullmodel._resolve_covariances()) {
			set_errmsg(sprintf("failed to create NULL model: %s",
				nullmodel.errmsg()))
			return(rc)
		}
		hasnull = !rc
	}
	return(rc)
}

real scalar __menl_expr::traverse_tree(struct nlparse_node tree,
			string scalar group, real scalar gtype,
			string vector options)
{
	real scalar rc, i, k, found, gtype1, traverse
	struct nlparse_node node
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE

// pt_display(tree)
	pSE = NULL
	traverse = `SUBEXPR_TRUE'
	rc = 0
	if (gtype==`SUBEXPR_EQ_LC' | gtype==`SUBEXPR_EQ_EXPRESSION') {
		rc = register_equation(group,pSE,gtype)
	}
	else if (gtype == `SUBEXPR_GROUP_EXPRESSION') {
		rc = register_group(group,pSE,gtype)
	}
	else if (gtype == `SUBEXPR_GROUP_LC') {
		node = tree.arg[1]
// pt_dump_node(node)
		if (!missing(node.val)) {
			/* instance number, check if an equation tree
			 *  has already encountered it and created a
			 *  place holder				*/
			pG = lookup_component((`SUBEXPR_GROUP_SYMBOL',
					node.symb))
			if (pG) {
				gtype1 = pG->group_type()
				found = `SUBEXPR_FALSE'
				k = pG->group_count()
				i = 0
				while (!found & i<k) {
					pSE = pG->get_object(++i)
					if (pSE->instance() == node.val) {
						found = `SUBEXPR_TRUE'
					}
				}
				if (!found) {
					pSE = NULL
				}
				else if (gtype1 == `SUBEXPR_UNDEFINED') {
					(void)pG->set_group_type(gtype)
				}
				else if (gtype1 != gtype) {
					set_errmsg(sprintf("could not cast " +
						"not cast to %s object",
						pG->sgroup_type()))
					rc = 498
				}
				else if (pSE->first() != NULL) {
					/* already parsed		*/
					traverse = `SUBEXPR_FALSE'
				}
			}
		}

		if (pSE == NULL) {
			rc = register_group(group,pSE,gtype)
		}
	}
	else {
		/* should not happen					*/
		set_errmsg("invalid group type %s for parse tree %s\n",
			pSE->sgroup_type(),group)
		rc = 498
	}
	if (rc) {
		pSE = NULL
		pG = NULL
		return(rc)
	}
	if (length(options)) {
		pSE->set_options(options)
	}
	if (gtype==`SUBEXPR_GROUP_EXPRESSION' | 
		gtype==`SUBEXPR_EQ_EXPRESSION') {
		rc = pSE->traverse_expr_tree(tree)
	}
	else if (traverse) {
		/* gtype==`SUBEXPR_GROUP_LC' | gtype==`SUBEXPR_EQ_LC'	*/
		rc = pSE->traverse_LC_tree(tree)
	}
	if (!rc) {
		if (gtype==`SUBEXPR_EQ_LC' | gtype==`SUBEXPR_EQ_EXPRESSION') {
			m_equations = (m_equations,group)
		}
		m_dirty = `SUBEXPR_DIRTY_PARSED'
	}
	pG = NULL
	pSE = NULL

	return(rc)
}

void __menl_expr::display_equations()
{
	super.display_equations()
}

void __menl_expr::display_expressions()
{
	super.display_expressions()
}

void __menl_expr::update_dirty_ready()
{
	super.update_dirty_ready()
}

void __menl_expr::error_code(real scalar ec, |transmorphic arg1, 
		transmorphic arg2, transmorphic arg3, transmorphic arg4,
		transmorphic arg5)
{
	string scalar expr, stype

	if (ec == `SUBEXPR_ERROR_TSINIT') {
		expr = arg1
		set_errmsg("option {bf:tsinit()} required with lagged " +
			"named expressions")
		set_message(sprintf("You used the lag operator {bf:L.} with " +
			"expression {bf:{%s:}}. This requires that you also " +
			"specify an initial condition for {bf:{%s:}} in " +
			"option {bf:tsinit()}.",expr,expr))
		return
	}
	if (ec == `SUBEXPR_ERROR_LAG_EQ') {
		expr = arg1
		set_errmsg(sprintf("invalid definition of named expression " +
			"{bf:%s}",expr))
		set_message("You cannot use the lagged predicted mean " + 
			"function to define other expressions in option " +
			"{bf:define()}. You can specify the lagged predicted " +
			"mean function only in the main nonlinear " +
			"specification")
		return
	}
	if (ec == `SUBEXPR_ERROR_RECURSIVE') {
		expr = arg1
		stype = arg2
		set_errmsg(sprintf("could not evaluate expression {bf:%s}: " +
			"recursive call detected",expr))
		set_message(sprintf("You specified a time-series operator on " +
			"%s {bf:%s}, but we are currently evaluating it.  " +
			"This is a recursive condition.  Try specifying " +
			"option {bf:subexprtrace} to see an execution trace.",
			stype,expr))
		return
	}
	if (ec == `SUBEXPR_ERROR_EXECUTION_FAILURE') {
		expr = arg1
		stype = arg2
		set_errmsg(sprintf("failed to evaluate %s {bf:%s}",stype,expr))
		set_message("Try specifying option {bf:subexprtrace} to see " +
			"an execution trace.")
		return
	}
	super.error_code(ec,arg1,arg2,arg3,arg4,arg5)
}

void __menl_expr::return_post()
{
	real scalar i, j, i1, i2, j1, kcov, k, kf, kr, krs, krc, kres
	real scalar kfeq, kreseq, kreq, keq, ks, kc, ereturn
	real scalar vtype, ctype
	real matrix pstr, cind, bytable, itable
	string scalar path, vstruct, hier, hierarchy, byvar, ivar
	string scalar name, expri, post, expr, exfull
	string vector lvnames, vexpr, covariates
	string matrix stripe, cstripe
	class __recovmatrix scalar cov
	class __stmatrix scalar fixpat, sdpar, corpar

	ereturn = `SUBEXPR_TRUE'

	name = depvars()[1]
	super.return_post(ereturn,name)
	
	/* menl specific posting					*/
	kf = m_param.cols()		// # fixed-effects parameters
	st_numscalar("e(k_f)",kf)
	stripe = m_param.colstripe()
	pstr = panelsetup(stripe,1)
	kfeq = rows(pstr)	// # fixed-effects equations
	st_numscalar("e(k_feq)",kfeq)

	kr = krc = krs = 0
	kcov = length(m_covs)
	cstripe = J(kcov+2,2,"")
	hierarchy = ""
	kf = m_param.cols()
	i2 = kf
	cind = (1,i2)	// fix effects
	cstripe = ("","_fixed")
	for (i=1; i<=kcov; i++) {
		ks = m_covs[i]->ksdpar()
		kc = m_covs[i]->kcorpar()
		krs = krs + ks
		krc = krc + kc
		path = m_covs[i]->path()
		lvnames = m_covs[i]->LVnames()
		vtype = m_covs[i]->vtype()	// var structure
		ctype = m_covs[i]->ctype()	// cor structure
		vstruct = ""
		/* translate var/cor structures to menl structures	*/
		if (vtype == cov.HOMOSKEDASTIC) {
			if (ctype == cov.INDEPENDENT) {
				vstruct = "identity"
			}
			else if (ctype == cov.EXCHANGEABLE) {
				vstruct = "exchangeable"
			}
		}
		else if (vtype == cov.HETEROSKEDASTIC) {
			if (ctype == cov.INDEPENDENT) {
				vstruct = "independent"
			}
			else if (ctype == cov.UNSTRUCTURED) {
				vstruct = "unstructured"
			}
		}
		else if (vtype == cov.FIXED) {
			vstruct = "fixed"
			fixpat = m_covs[i]->fixpat()
			name = sprintf("e(fixed_%s)",
				invtokens(lvnames,"_"))
			fixpat.st_matrix(name)			

		}
		else if (vtype == cov.PATTERN) {
			vstruct = "pattern"
			fixpat = m_covs[i]->fixpat()
			name = sprintf("e(pattern_%s)",
				invtokens(lvnames,"_"))
			fixpat.st_matrix(name)			
		}
		if (!strlen(vstruct)) {
			/* unreachable				*/
			errprintf("unknown random effect covariance type\n")
			exit(498)
		}
		/* coefficient vector index range
		 * 	coefficient group name is by path not by the 
		 * 	covariance name. There can be multiple covariances
		 * 	per path. e.g. cov(U1,U2) cov(U3,U4) and U1-U4 
		 * 	have the same path				*/
		i1 = i2 + 1
		i2 = i2 + ks + kc
		cind = (cind\(i1,i2))
		cstripe = (cstripe\(path,invtokens(lvnames)))
		hier = sprintf("(%s: %s: %s)",path,vstruct,invtokens(lvnames))
		if (i == 1) {
			hierarchy = hier
		}
		else {
			hierarchy = hierarchy + " " + hier
		}
	}
	kreq = kcov
	kr = krs + m_var.ksdpar() + 1
	kr = kr + krc + m_var.kcorpar()
	krs = krs + m_var.ksd() + 1
	krc = krc + m_var.kcor()
	sdpar = m_var.sd_parameters()
	corpar = m_var.cor_parameters()
	kreseq = 1	// residual
	i1 = i2 + 1
	j1 = i1
	cind = (cind\(i1,++i2))
	cstripe = (cstripe\("Residual","_scale"))
	if (sdpar.cols()) {
		stripe = sdpar.colstripe()
		pstr = panelsetup(stripe,1)
		kreseq = rows(pstr)
 		i1 = i2 + 1
		k = sdpar.cols()
		i2 = i2 + k
		cind = (cind\(i1,i2))
		cstripe = (cstripe\("Residual","_sd"))
		byvar = m_var.byvarname(m_var.STDDEV)
		if (ustrlen(byvar)) {
			bytable = m_var.bytable(m_var.STDDEV)
			st_matrix("e(stratavals)",bytable,"hidden")
			st_matrixcolstripe("e(stratavals)",
				(("","strata")\("","count")))
		}
		ivar = m_var.indvarname(m_var.STDDEV)
		if (ustrlen(ivar)) {
			itable = m_var.indtable(m_var.STDDEV)
			st_matrix("e(indexvals)",itable,"hidden")
			st_matrixcolstripe("e(indexvals)",
				(("","index")\("","count")))
		}
	}
	if (corpar.cols()) {
		stripe = corpar.colstripe()
		pstr = panelsetup(stripe,1)
		kreseq = kreseq + rows(pstr)
 		i1 = i2 + 1
		k = corpar.cols()
		i2 = i2 + k
		cind = (cind\(i1,i2))
		cstripe = (cstripe\("Residual","_cor"))
		byvar = m_var.byvarname(m_var.CORR)
		if (ustrlen(byvar)) {
			bytable = m_var.bytable(m_var.CORR)
			st_matrix("e(byvals)",bytable,"hidden")
			st_matrixcolstripe("e(byvals)",
				(("","by")\("","count")))
		}
		ivar = m_var.indvarname(m_var.CORR)
		if (ustrlen(ivar)) {
			/* table will contain the same values as the
			 *  std.dev. index table, menl requires it	*/
			itable = m_var.indtable(m_var.CORR)
			st_matrix("e(indexvals)",itable,"hidden")
			st_matrixcolstripe("e(indexvals)",
				(("","index")\("","count")))
		}
	}
	cind = (cind\(j1,i2))
	cstripe = (cstripe\("Residual","_all"))

	st_numscalar("e(k_f)",kf)	// # fixed-effect parameters
	st_numscalar("e(k_r)",kr)	// # random-effect parameters
	st_numscalar("e(k_rs)",krs)	// # variances
	st_numscalar("e(k_rc)",krc)	// # correlations

	st_numscalar("e(k_req)",kreq)	// # random-effects equations
	st_numscalar("e(k_reseq)",kreseq)	// # residual equations
	keq = kfeq + kreseq + kreq	// # equations
	st_numscalar("e(k_eq)",keq)

	/* residual structures					*/
	kres = 1 + m_var.ksdpar() + m_var.kcorpar()
	
	st_numscalar("e(k_res)",kres)	// # residual-error parameters

	/* overwrite e(hierarchy) set by super.return_post()		*/
	st_global("e(hierarchy)",hierarchy)
	st_matrix("e(bindex)",cind,"hidden")
	st_matrixrowstripe("e(bindex)",cstripe)

	/* path covariances: a hierarchy path can have a block diagonal
	 *  covariance structure, class __pathcovmatrix manages the 
	 *  __recovmatrix's						*/
	kcov = length(m_pcovs)
	for (i=1; i<=kcov; i++) {
		m_pcovs[i]->compute_V()
		m_pcovs[i]->st_matrix(sprintf("e(cov_%g)",i))
	}
	/* expressions							*/
	vexpr = expr_names()
	k = length(vexpr)
	for (i=k; i>=1; i--) {
		expri = vexpr[i]

		expr = expression(expri,`SUBEXPR_DISPLAY')
		if (expr == ", xb") {
			continue
		}
		if (usubstr(expri,1,1) == "/") {
			j = ustrlen(expri)
			if (j > 1) {
				expri = usubstr(expri,2,j-1)
				vexpr[i] = expri
			}
		}
		post = sprintf("e(ex_%s)",expri)
		/* full expression posted by parent			*/
		exfull = st_global(post)
		/* repost as hidden					*/
		st_global(post,exfull,"hidden")

		post = sprintf("e(expr_%s)",expri)
		st_global(post,expr)
	}
	/* e(covariates) for margins					*/
	covariates = covariates()
	if (length(covariates)) {
		st_global("e(covariates)",invtokens(covariates),"hidden")
	}
	else {
		st_global("e(covariates)","_NONE","hidden")
	}
}

void _menl_concat_name(string scalar list, string scalar name)
{
	if (!strlen(list)) {
		list = name
	}
	else {
		list = list + " " + name
	}
}

real scalar _menl_subtract_names(string vector lvs, string vector clv)
{
	real scalar i, k
	real vector io

	if (!length(lvs)) {
		return(0)
	}
	k = length(clv)
	for (i=1; i<=k; i++) {
		if (any(io=strmatch(lvs,clv[i]))) {
			io = 1:-io
			lvs = select(lvs,io)
			if (!length(lvs)) {
				return(0)
			}
		}
	}
	return(length(lvs))
}

void __menl_expr::cert_post()
{
	super.cert_post()
}

void __menl_expr::expression_sreturn()
{
	real scalar type, gtype, i, k, def
	real vector ieq
	string scalar undef_expr, exprs, lcs, pars, ecov
	string vector eq, par
	string matrix stripe
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pE
	class __stmatrix scalar b

	pC = iterator_init()
	undef_expr = exprs = lcs = pars = ""
	while (pC) {
		type = pC->type()
		if (type == `SUBEXPR_PARAM') {
			_menl_concat_name(pars, pC->name())
		}
		if (type != `SUBEXPR_GROUP') {
			goto Next
		}
		pG = pC
		gtype = pG->group_type()
		if (gtype == `SUBEXPR_GROUP_EXPRESSION') {
			_menl_concat_name(exprs, pG->name())
		}
		else if (gtype == `SUBEXPR_GROUP_LC') {
			_menl_concat_name(lcs, pG->name())
		}
		else if (gtype!=`SUBEXPR_UNDEFINED') {
			goto Next
		}
		def = 0
		k = pG->group_count()
		for (i=1; i<=k; i++) {
			pE = pG->get_object(i)
			if (def=(pE->first()!=NULL)) {
				break
			}
		}
		if (!def) {
			if (!strlen(undef_expr)) {
				undef_expr = pG->name()
			}
			else {
				undef_expr = undef_expr + " " + pG->name()
			}
		}
		Next: pC = iterator_next()
	}
	if (ustrlen(pars)) {
		pars = invtokens(sort(tokens(pars)',1)')
	}
	if (ustrlen(exprs)) {
		exprs = invtokens(sort(tokens(exprs)',1)')
	}
	if (ustrlen(undef_expr)) {
		undef_expr = invtokens(sort(tokens(undef_expr)',1)')
	}
	if (ustrlen(lcs)) {
		lcs = invtokens(sort(tokens(lcs)',1)')
	}
	pC = NULL
	pG = NULL
	pE = NULL
	st_global("s(undefined_expr)",undef_expr)
	st_global("s(expressions)",exprs)
	st_global("s(linear_comb)",lcs)
	b = stparameters()
	if (k=b.cols()) {
		stripe = b.colstripe()
		eq = usubinstr(stripe[.,1],"/","",.)'
		ieq = (ustrlen(eq):>0)
		ieq = select(1..k,ieq)
		eq[ieq] = eq[ieq]:+":"
		par = usubinstr(stripe[.,2],"/","",.)'
		if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
			pars = invtokens(eq:+par)
		}
		else {
			pars = pars + " " + invtokens(eq:+par)
		}
	}
	st_global("s(parameters)",pars)

	LV_sreturn()

	ecov = m_var.svtype()
	st_global("s(rescov)",ecov)

	ecov = m_var.sctype()
	st_global("s(rescor)",ecov)
}

void __menl_expr::LV_sreturn()
{
	real scalar i, j, k, kpath, found, kcov
	string scalar path, lv, lvp, sp
	string vector lvs, paths, lvi, clv, cpath
	pointer (class __component_base) scalar pC

	pC = iterator_init()
	lvs = paths = J(1,0,"")
	while (pC) {
		if (pC->type() != `SUBEXPR_LV') {
			goto Next
		}
		lv = pC->name()
		cpath = pC->data(`SUBEXPR_HINT_HIERARCHY')
		k = length(cpath)
		if (!k) {
			/* not well formed, dialog errored		*/
			goto Next
		}
		if (length(cpath) > 1) {
			path = invtokens(cpath,">")
		}
		else {
			path = cpath[1]
		}
		kpath = length(paths)
		found = 0
		for (i=1; i<=kpath; i++) {
			if (paths[i] == path) {
				lvs[i] = lvs[i] + " " + lv
				found = 1
				break
			}
		}
		if (!found) {
			paths = (paths,path)
			lvs = (lvs,lv)
		}
		Next: pC = iterator_next()
	}
	kpath = length(paths)
	if (kpath) {
		sp = lvp = ""
		kcov = length(m_covs)
		for (i=1; i<=kpath; i++) {
			st_global(sprintf("s(path_%g)",i),
				sprintf("%s",paths[i]))
			lvs[i] = invtokens(sort(tokens(lvs[i])',1)')
			st_global(sprintf("s(RE_%g)",i),
				sprintf("%s",lvs[i]))
			lvi = tokens(lvs[i])
			if (length(lvi) == 1) {
				/* single LV no need to define cov	*/
				continue
			}
			for (j=1; j<=kcov; j++) {
				path = m_covs[j]->path()
				if (paths[i] == path) {
					clv = m_covs[j]->LVnames()
					if (!_menl_subtract_names(lvi,clv)) {
						break
					}
				}
			}
			if (length(lvi)) {
				st_global(sprintf("s(undef_path_%g)",i),
					paths[i])
				st_global(sprintf("s(undef_RE_%g)",i),
					invtokens(lvi))
				lvp = lvp + sprintf("%s%s: %s",sp,paths[i],
					invtokens(lvi))
				sp = "| "
			}
		}
		st_global("s(kpath)",strofreal(kpath))
		st_global("s(undefined_LV)",lvp)
	}
}

real scalar _menl_node_has_tsop(struct nlparse_node scalar node)
{
	real scalar i, k

	if (node.type == `TSOP') {
		return(`SUBEXPR_TRUE')
	}
	k = node.narg
	for (i=1; i<=k; i++) {
		if (_menl_node_has_tsop(node.arg[i])) {
			return(`SUBEXPR_TRUE')
		}
	}
	return(`SUBEXPR_FALSE')
}

real vector __menl_expr::TS_order_expr(string vector tsvars,
			string vector exprs)
{
	real scalar i, j, k, kv, nameonly
	real vector tsorder, tso
	string scalar errmsg
	string vector vars
	struct nlparse_node scalar node
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE

	pragma unset errmsg

	tsvars = exprs = J(1,0,"")
	/* first element is lag order and second element is forward
	 *  order							*/
	tsorder = J(1,3,0)
	nameonly = `SUBEXPR_FALSE'
	pC = iterator_init()
	while (pC != NULL) {
		if (pC->type() != `SUBEXPR_GROUP') {
			goto Next
		}
		pG = pC
		k = pG->group_count()
		for (i=1; i<=k; i++) {
			pSE = pG->get_object(i)
			if (pSE->has_property(`SUBEXPR_PROP_TS_OP')) {
				exprs = (exprs,pG->name())
			}
			/* maximum TS lag and forward order		*/
			tso = pSE->TS_order()
			if (!sum(tso)) {
				continue
			}
			if (tso[`TS_LORDER'] > tsorder[`TS_LORDER']) {
				tsorder[`TS_LORDER'] = tso[`TS_LORDER']
			}
			if (tso[`TS_FORDER'] > tsorder[`TS_FORDER']) {
				tsorder[`TS_FORDER'] = tso[`TS_FORDER']
			}
			if (tso[`TS_EXPR_LORDER'] > tsorder[`TS_EXPR_LORDER']) {
				tsorder[`TS_EXPR_LORDER'] = 
					tso[`TS_EXPR_LORDER']
			}
			vars = pSE->varlist(nameonly)
			kv = length(vars)
			for (j=1; j<=kv; j++) {
				node = nlparse_node(1)
				if (_nlparse(sprintf("__tmp: %s",vars[j]),node,
					errmsg)) {
					/* should not happen		*/
					continue
				}
				/* bypass LC and varlist		*/
				node = node.arg[2].arg[1]
				if (_menl_node_has_tsop(node)) {
					tsvars = (tsvars,vars[j])
				}
			}
		}
		Next: pC = iterator_next()
	}
	tsvars = uniqrows(tsvars')'
	exprs = uniqrows(exprs')'

	return(tsorder)
}

pointer (class __component_base) scalar __menl_expr::lookup_component(
			string vector key)
{
	return(super.lookup_component(key))
}

end
exit
