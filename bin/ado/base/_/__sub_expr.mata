*! version 1.2.4  04sep2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __stparam_vector.matah
quietly include `"`r(fn)'"'

findfile __tempnames.matah
quietly include `"`r(fn)'"'

findfile __lvhierarchy.matah
quietly include `"`r(fn)'"'

findfile __component.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __sub_expr.matah
quietly include `"`r(fn)'"'

findfile nlparse_macros.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

/* implementation: __sub_expr						*/
void __sub_expr::new()
{
	m_C = NULL //asarray_create("string",2)	// container of components
	m_loc = NULL

	clear()
	m_exprdep.reinit("string")
	m_exprdep.notfound(J(1,0,NULL))	// empty pointer vector
	m_nodep = NULL

	/* public static constants					*/
	/* special handling, ::set_special()				*/
	SPECIAL_HIERARCHY_SYMBOLS = `SUBEXPR_SPECIAL_HSYMBOLS'
	SPECIAL_APP_REGRESS = `SUBEXPR_SPECIAL_APP_REG'
	SPECIAL_APP_BAYES = `SUBEXPR_SPECIAL_APP_BAYES'
	SPECIAL_APP_MENL = `SUBEXPR_SPECIAL_APP_MENL'

	/* expression display, ::equation() or ::expression()		*/
	EXPRESSION_FULL = `SUBEXPR_FULL'
	EXPRESSION_CONDENSED = `SUBEXPR_CONDENSED'
	EXPRESSION_SUBSTITUTED = `SUBEXPR_SUBSTITUTED'

	/* equation types						*/
	NULL_EXPRESSION = `SUBEXPR_NULL'
	NONLINEAR_EXPRESSION = `SUBEXPR_EQ_EXPRESSION'
	LINEAR_COMBINATION = `SUBEXPR_EQ_LC'

	m_application = `SUBEXPR_SPECIAL_APP_REG'	// default application

	if (!strlen(LATENT_VARIABLE)) {
		LATENT_VARIABLE = "latent variable"
	}

	if (!length(PT_TYPES)) {
		PT_TYPES = (`PT_STR_TYPES')
	}

	m_tnames.set_prefix("SUBEXPR")
	m_param_default_val = 0
}

void __sub_expr::destroy()
{
	clear()
	m_C = NULL
}

void __sub_expr::clear()
{
	real scalar allcaps, i, j, k, kg, ivar
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pE

	m_dirty = `SUBEXPR_DIRTY_UNDEFINED'	// very dirty
	if (length(m_tlhs)) {
		if (strlen(m_tlhs[`SUBEXPR_LHS_OWN'])) {
			ivar = _st_varindex(m_tlhs[`SUBEXPR_LHS_OWN'])
			if (!missing(ivar)) {
				st_dropvar(ivar)
			}
		}
	}
	m_exprdep.clear()
	m_parse_origin = `SUBEXPR_PARSE_NONE'
	m_tlhs = J(1,0,"")
	m_touse = ""				// sample indicator name
	/* clear LV names, names must be capitalized			*/
	allcaps = `SUBEXPR_ALLCAPS'
	(void)_lvset(J(1,0,""),allcaps) 
	m_loc = NULL				// iterator location
	set_trace_off()
	clear_warnings()
	m_errmsg = m_message = ""
	m_param.erase()

	k = length(m_LVs)
	for (i=1; i<=k; i++) {
		m_LVs[i] = NULL
	}
	m_LVs = J(1,0,NULL)

	k = length(m_RE.b)
	m_RE.lohi.erase()
	m_RE.names = J(1,0,"")
	for (i=1; i<=k; i++) {
		m_RE.b[i] = NULL	// decrement reference counter
	}
	m_RE.b = J(1,0,NULL)
	m_hierarchy.clear()

	if (m_C != NULL) {
		k = length(m_equations)
		for (i=1; i<=k; i++) {
			pG = lookup_component((`SUBEXPR_GROUP_SYMBOL',
				m_equations[i]))
			if (pG == NULL) {
				continue
			}
			/* can only be one equation in group		*/
			kg = pG->group_count()
			for (j=1; j<=kg; j++) {
				pE = pG->get_object(j)
				if (pE != NULL) {
					pE->clear()
				}
				pE = NULL
			}
			pG = NULL
		}
		pC = iterator_init()
		while (pC) {
			if (pC->type() == `SUBEXPR_GROUP') {
				/* bayes has named expressions not in
				 *  equations and will not be cleared
				 *  above				*/
				pG = pC
				k = pG->group_count()
				/* if k > 0 object was not in an
				 *  equation				*/
				for (i=1; i<=k; i++) {
					pE = pG->get_object(i)
					/* NULL if we terminate before
					 *  resolve_expressions()	*/
					if (pE != NULL) {
						pE->clear()
						pE = NULL
					}
				}
				pG = NULL
			}
			if (remove_component(pC)) {
				pC = iterator_init()
			}
			else {
				/* something wrong, break out		*/
				pC = NULL
			}
/*
			if (sys_linkcount(*pC) > 1) {
				while (sys_linkcount(*pC)>1) {
					sys_decrlinkcount(*pC)
				}
			}
*/
		}
	}
	m_C = asarray_create("string",2) // container of components
	m_equations = J(1,0,"")
	m_loc = NULL
	asarray_notfound(m_C,NULL)
	m_tnames.clear()	// remove all temporary vars and matrices
	m_markout_depvar = `SUBEXPR_TRUE'
	m_base_eq = ""
	m_multi_eq = .
	m_panelvar = ""
	m_n = 0
}

void __sub_expr::set_trace_off()
{
	m_trace = `SUBEXPR_OFF'
}

void __sub_expr::set_trace_on()
{
	m_trace = `SUBEXPR_ON'
}

real scalar __sub_expr::trace()
{
	return(m_trace)
}

real scalar __sub_expr::sample_size()
{
	return(m_n)
}

real scalar __sub_expr::application()
{
	return(m_application)
}

real scalar __sub_expr::parse_origin()
{
	return(m_parse_origin)
}

string scalar __sub_expr::new_tempname(real scalar type)
{
	return(m_tnames.new_name(type))
}

real scalar __sub_expr::markout_depvar()
{
	return(m_markout_depvar)
}

void __sub_expr::set_markout_depvar(real scalar mark_depvar)
{
	m_markout_depvar = (mark_depvar!=`SUBEXPR_FALSE')
}

void __sub_expr::set_stata_tsvar(string scalar tsvar)
{
	m_tsvar = tsvar
}

string scalar __sub_expr::stata_tsvar()
{
	return(m_tsvar)
}

void __sub_expr::set_stata_panelvar(string scalar panelvar)
{
	m_panelvar = panelvar
}

string scalar __sub_expr::stata_panelvar()
{
	return(m_panelvar)
}

void __sub_expr::dirty_message()
{
	/* add error specifics						*/
	if (m_dirty > `SUBEXPR_DIRTY_PARSED') {
		set_errmsg(sprintf("%s; expressions and equations need to " +
			"be parsed",errmsg()))
	}
	else if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		set_errmsg(sprintf("%s; expressions need to be resolved",
			errmsg()))
	}
	else if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_COV') {
		set_errmsg(sprintf("%s; %s covariances need to be resolved",
			errmsg(),LATENT_VARIABLE))
	}
}	

void __sub_expr::error_and_exit(real scalar rc)
{
	errprintf("{p}%s{p_end}\n",m_errmsg)
	if (strlen(m_message)) {
		errprintf("{p 4 4 2}%s{p_end}\n",m_message)
	}
	exit(rc)
}

string scalar __sub_expr::pt_node_type(struct nlparse_node scalar node)
{
	if (node.type<`CONSTANT' | node.type>`OPTIONS') {
		return("unknown")
	}
	return(PT_TYPES[node.type+1])
}

void __sub_expr::set_touse(string scalar touse)
{
	real scalar rc

	rc = _set_touse(touse)
	if (rc) {
		error_and_exit(rc)	// back hole
	}
}

real scalar __sub_expr::_set_touse(string scalar touse, |real scalar force)
{
	real scalar rc
	string scalar errmsg

	pragma unset errmsg

	force = (missing(force)?0:(force!=0))
	rc = 0

	if (!force) {
		if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
			set_errmsg("setting the estimation sample indicator " +
				"variable too late in the expression parsing")
			return(498)
		}
	}
	/* assumption: not abbreviated					*/
	if (rc=__sub_expr_validate_touse(touse,errmsg,`SUBEXP_FALSE')) {
		set_errmsg(errmsg)
		return(rc)
	}
	m_n = sum(st_data(.,touse))
	m_touse = touse

	return(0)
}

real scalar __sub_expr::create_touse()
{
	real scalar nooutput
	string scalar cmd, mac

	if (ustrlen(m_touse)) {
		/* programmer set or already created			*/
		return(0)
	}
	m_touse = new_tempname(m_tnames.VARIABLE)
	if (missing(st_addvar("byte",m_touse))) {
		/* should not happen					*/
		set_errmsg("failed to generate overall estimation sample")
		return(498)
	}
	/* generate estimation sample for all expressions that do not
	 *  have an estimation sample indicator				*/
	mac = st_tempname()
	/* include Stata syntax [if][in], if exists			*/
	if (application() == SPECIAL_APP_BAYES) {
		cmd = sprintf("marksample %s,strok",mac)
	}
	else {
		cmd = sprintf("marksample %s",mac)
	}
	nooutput = `SUBEXPR_FALSE'
	if (_stata(cmd,nooutput)) {
		st_store(.,m_touse,J(st_nobs(),1,1))
	}
	else {
		mac = st_local(mac)	// contents of touse macro
		st_store(.,m_touse,st_data(.,mac))
	}
	return(0)
}

string scalar __sub_expr::touse(|string scalar name)
{
	string scalar touse
	pointer (class __component_group) scalar pC
	pointer (class __sub_expr_group) scalar pG

	if (!ustrlen(name)) {
		return(m_touse)
	}
	/* markout flag indicates that the caller is in the process of
	 *  marking out the estimation samples				*/
	touse = ""
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',name))
	if (pC != NULL) {
		pG = get_defined_expr(pC)	// first should do
		touse = pG->touse()
		pG = NULL
		pC = NULL
	}
	return(touse)
}

real scalar __sub_expr::eq_count()
{
	return(length(m_equations))
}

pointer (class __sub_expr_group) scalar __sub_expr::new_group()
{
	if ((application()==SPECIAL_APP_BAYES)) {
		return(&__bayes_expr_group(1))
	}
	return(&__sub_expr_group(1))
}

real scalar __sub_expr::_get_group(name, 
			pointer (class __sub_expr_group) scalar pE)
{
	real scalar slash, k, unique
	string scalar namen
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG

	pE = NULL
	k = ustrlen(name)
	slash = `SUBEXPR_FALSE'
	if (usubstr(name,1,1) == "/") {
		slash = `SUBEXPR_TRUE'
		if (k == 1) {
			set_errmsg(sprintf("invalid expression name {bf:%s}",
				name))
			return(498)
		}
		namen = usubstr(name,2,k-1)
	}
	else {
		namen = name
	}
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',namen))
	if (pC == NULL) {
		if (!slash) {
			namen = "/"+name
			pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',namen))
		}
		if (pC == NULL) {
			set_errmsg(sprintf("object {bf:%s} not found",namen))
			return(111)
		}
	}
	if (pC->type() != `SUBEXPR_GROUP') {
		set_errmsg(sprintf("object %s is not an expression or " +
			"linear combination object",pC->name()))
		pC = NULL
		return(498)
	}
	pG = pC
	pC = NULL
	unique = `SUBEXPR_TRUE'
	if ((k=pG->group_count(unique))>1) {
		name = __sub_expr_name_no_slash(pG->name())
		set_errmsg(sprintf("cannot evaluate %s object {bf:%s}; it " +
			"has %g different forms",pG->sgroup_type(),name,k))
		return(322)
	}
	pE = get_defined_expr(pG)
	pG = NULL

	return(0)
}

pointer (class __sub_expr_group) scalar __sub_expr::get_group(
			string scalar name)
{
	pointer (class __sub_expr_group) scalar pE

	pragma unset pE

	(void)_get_group(name,pE)

	return(pE)
}	

real scalar __sub_expr::_parse(string scalar expression,
		|real scalar ktok)
{
	real scalar i, rc
	string scalar tok, expr, expr0, subexpr
	string vector tokens
	transmorphic tb

	pragma unset subexpr

	expr = ustrtrim(expression)
	expr0 = ""

	/* break expression up by groups {...}				*/
	rc = 0
	/* pchar includes space as a token, qchar arg matches braces	*/
	tb = tokeninit("",(" "),("{}"))
	tokenset(tb, expr)
	tokens = tokengetall(tb)
	ktok = length(tokens)
	for (i=1; i<=ktok; i++) {
		tok = ustrtrim(tokens[i])
		if (!ustrlen(tok)) {
			expr0 = expr0 + " "
			continue
		}
		if (tok=="}" | tok=="{") {
			set_errmsg(sprintf("invalid expression {bf:%s}: " +
				"unmatched brace %s",expr,tok))
			rc = 132
		}
		else if (usubstr(tok,1,1) == "{") {
			/* {...}					*/
			rc = parse_braces(tok,subexpr)

			expr0 = expr0 + subexpr
		}
		else {
			expr0 = expr0 + tok
		}
		if (rc) {
			return(rc)
		}
	}
	expression = expr0
	return(rc)
}

real scalar __sub_expr::parse(string scalar expression, string scalar name,
		real scalar gtype, string scalar touse, 
		pointer (class __sub_expr_group) scalar pG,
		|string vector options)
{
	real scalar ktok, rc, type
	string scalar expr, expr0, expr1
	string scalar errmsg, sextype
	struct nlparse_node scalar tree, node
	pointer (class __sub_expr_group) scalar pEQ
// real scalar lsize

	pragma unset errmsg
	pragma unset pEQ
	pragma unset pG
	pragma unset ktok

	expr = ustrtrim(expression)
	expr0 = expr

	/* break expression up by groups {...}				*/
	if (rc=_parse(expr0,ktok)) {
		return(rc)
	}
	if (gtype == `SUBEXPR_EQ_EXPRESSION') {
		sextype = "equation"
	}
	else if (gtype == `SUBEXPR_EQ_LC') {
		sextype = "Stata variable list"
	}
	else if (gtype == `SUBEXPR_GROUP_LC') {
		sextype = "Stata variable list"
	}
	else {	// SUBEXPR_GROUP_EXPRESSION
		sextype = "expression"
	}
	if (!strlen(expr0)) {
		if (__sub_expr_has_option(options,"xb")) {
			if (rc=__sub_expr_validate_options(options,"xb",2,
				errmsg)) {
				set_errmsg(sprintf("invalid expression " +
					"expression {bf:{%s, %s}}; %s",name,
					invtokens(options),errmsg))
				return(rc)
			}
			/* hand roll					*/
			tree.type = `LINCOM'
			tree.symb = ":"
			tree.narg = 2
			tree.arg = nlparse_node(2)

			node = nlparse_node(1)
			node.type = `SYMBOL'
			node.symb = name
			node.narg = 0
			tree.arg[1] = node	// copy

			node = nlparse_node(1)
			node.type = `VARLIST'
			node.symb = "..."
			node.narg = 1
			node.arg = nlparse_node(1)
			/* implied constant				*/
			node.arg[1].symb = "_cons"
			node.arg[1].type = `SYMBOL'
			node.arg[1].narg = 0
	
			tree.arg[2] = node	// copy
		}
		else {
			/* should no get here, hand roll in case	*/
			tree.type = `SUBEXPR'
			tree.symb = name
			tree.narg = 0
		}
	}
	else {
		if (gtype == `SUBEXPR_EQ_EXPRESSION') {
			expr1 = sprintf("%s=%s",name,expr0)
		}
		else if (gtype == `SUBEXPR_EQ_LC') {
			/* expression is in Stata linear form		*/
			expr1 = sprintf("%s %s",name,expr0)
		}
		else {	// SUBEXPR_GROUP_EXPRESSION | SUBEXPR_GROUP_LC
			expr1 = sprintf("%s:%s",name,expr0)
		}
		if (rc=_nlparse(expr1,tree,errmsg)) {
			set_errmsg(sprintf("invalid %s {bf:%s}: %s",sextype,
				expr0,errmsg))
			return(rc)
		}
	}
/*
 lsize = st_numscalar("c(linesize)")
 pt_string_type(tree.type)
 pt_display(tree,100,lsize)
*/
	type = tree.type
	if (type!=`EXPRESSION' & type!=`LINCOM' & type!=`EQUATION') { 
		/* programmer error					*/
		set_errmsg(sprintf("invalid %s {bf:%s:%s}: a %s not " +
			"allowed",sextype,name,expr0,pt_node_type(tree)))
		return(499)
	}
	if (tree.narg != 2) {
		/* programmer error					*/
		set_errmsg(sprintf("bad %s parse tree for {bf:%s:%s}",
			pt_node_type(tree),name,expr0))
		return(499)
	}
	if (type==`LINCOM' & gtype==`SUBEXPR_GROUP_EXPRESSION' & ktok==1) {
		/* could be a parameter specified in a define() option
		 * e.g. define(name:param)				*/
		if (!__sub_expr_has_option(options,"xb")) {
			if (rc=create_param_from_LC(tree,pG)) {
				return(rc)
			}
			if (pG != NULL) {
				/* converted to parameter group		*/
				return(rc)
			}
		}
	}
	if (type == `LINCOM') {
		/* convert linear combination with factor variables to
		 *  Stata canonical form 
		 *  e.g. 1.f 2.f -> i(1 2).f -> 1b.f 2.f		*/
		if (rc=__sub_expr_stata_LC(tree,errmsg)) {
			set_errmsg(errmsg)
			return(rc)
		}
		/* include SUBEXPR_EQ_EXPRESSION incase depvar = varlist
		 *  specified						*/
		if (gtype==`SUBEXPR_EQ_LC' | gtype==`SUBEXPR_EQ_EXPRESSION') {
			if (ktok <= 1) {
				/* linear form, xb implied		*/
				if (!__sub_expr_has_option(options,"xb")) {
					options = (options,"xb")
				}
			}
			gtype = `SUBEXPR_EQ_LC'
			rc = register_equation(name,pEQ,gtype)
			pG = pEQ
			pEQ = NULL
		}
		else {
			gtype = `SUBEXPR_GROUP_LC'
			rc = register_group(name,pG,gtype)
		}
		if (!rc) {
			pG->set_options(options)
			pG->set_expression(expr)
			if (strlen(touse)) {
				rc = pG->set_touse(touse)
			}
			if (!rc) {
				rc = pG->traverse_LC_tree(tree)
			}
		}
	}
	else if (rc=__sub_expr_validate_options(options,J(1,0,""),0,errmsg)) {
		set_errmsg(sprintf("invalid %s {bf:%s}: %s",sextype,name,
			errmsg))
	}
	else {
		if (gtype == `SUBEXPR_EQ_EXPRESSION') {
			rc = register_equation(name,pEQ,gtype)
			pG = pEQ
			pEQ = NULL
		}
		else {	// SUBEXPR_GROUP_EXPRESSION
			rc = register_group(name,pG,gtype)
		}
		if (!rc) {
			pG->set_options(options)
			pG->set_expression(expr)
			if (strlen(touse)) {
				rc = pG->set_touse(touse)
			}
			if (!rc) {
				rc = pG->traverse_expr_tree(tree)
			}
		}
	}
	return(rc)
}

/* parse contents of {...}						*/
real scalar __sub_expr::parse_braces(string scalar expr,
		string scalar subexpr)
{
	real scalar rc, k, index, gtype, bayes, menl
	real vector ko
	string scalar expr1, expr2, name, group, errmsg
	string vector tokens, options, opts
	pointer (class __sub_expr_group) scalar pSE
	transmorphic te

	pragma unset errmsg
	pragma unset options
	pragma unset pSE

	rc = 0
	expr = ustrtrim(expr)
	k = ustrlen(expr)
	/* remove outer braces, no need to check			*/
	expr1 = usubstr(expr,2,k-2)

	/* check for options, trims expr1				*/
	if (rc=__sub_expr_get_options(expr1,options,errmsg)) {
		set_errmsg(sprintf("invalid specification {{bf:%s}}: %s",
			expr,errmsg))
		return(rc)
	}
	te = tokeninit("",":")
	tokenset(te, expr1)
	tokens = tokengetall(te)
	if ((k=length(tokens)) > 3) {
		/* could be a named expression nested in this
		 * expression						*/
		tokens[3] = invtokens(tokens[|3\k|])
		tokens = tokens[|1\3|]
		k = 3
	}
	if (k == 3) {
		if (!ustrlen(ustrtrim(tokens[3]))) {
			k = 2
			tokens = tokens[|1\k|]
		}
	}
	tokens[1] = ustrtrim(tokens[1])
	if (tokens[1] == ":") {
		set_errmsg("expression is required within {bf:{}}")
		return(198)
	}
	name = tokens[1]
	bayes = (application()==SPECIAL_APP_BAYES)
	menl = (application() == SPECIAL_APP_MENL)
	if (k == 1) {
		rc = 0
		if (length(options)) {
			/* check for any outlandish options		*/
			if (menl) {
				opts = ("xb","noconstant")
				ko = (2,6)
			}
			else {
				opts = ("xb","noconstant","matrix")
				ko = (2,6,1)
			}
			rc = __sub_expr_validate_options(options,opts,ko,errmsg)
			if (rc) {
				set_errmsg(sprintf("invalid expression " +
					"{bf:{%s, %s}}; %s",expr1,
					invtokens(options),errmsg))
				return(rc)
			}
		}
		expr2 = expr1
		/* now trigger error for xb and noconstant options	*/
		if (__sub_expr_has_option(options,"xb") |
			__sub_expr_has_option(options,"noconstant",6)) {
			set_errmsg(sprintf("invalid expression " +
				"{bf:{%s, %s}}",expr1,invtokens(options)))
			return(198)
		}
		opts = ""
		if (bayes) {
			if (__sub_expr_has_option(options,"matrix",1)) {
				expr2 = sprintf("%s,matrix",expr2)
			}
			opts = "matrix"
		}
		if (!(rc=parse_param(expr2))) {
			/* expr2 updated from parse tree		*/
			if (rc=__sub_expr_validate_options(options,
				opts,0,errmsg)) {
				set_errmsg(sprintf("invalid expression " +
					"{bf:{%s, %s}}: %s",expr1,
					invtokens(options),errmsg))
			}
			else {
				subexpr = expr2
			}
		}
		return(rc)
	}
	group = name
	name = ""
	pSE = NULL
	if (k == 2) {
		/* referencing a named expression
		 * handle at resolve stage				*/
		if (__sub_expr_has_option(options,"xb")) {
			if (rc=__sub_expr_validate_options(options,"xb",2,
				errmsg)) {
				set_errmsg(sprintf("invalid expression " +
					"expression {bf:{%s, %s}}; %s",expr1,
					invtokens(options),errmsg))
				return(rc)
			}
			/* linear combination, constant only		*/
			rc = parse("",group,`SUBEXPR_GROUP_EXPRESSION',"",
				pSE,options)
		}
		else if (rc=__sub_expr_validate_options(options,J(1,0,""),0,
				errmsg)) {
			set_errmsg(sprintf("invalid expression " +
				"{bf:{%s, %s}}: %s",expr1,invtokens(options),
				errmsg))
		}
		else {
			subexpr = sprintf("{%s:}",group)
		}
		if (pSE==NULL | rc) {
			pSE = NULL
			return(rc)
		}
	}
	else { // (k == 3) 
		expr2 = expr1
		expr1 = ustrtrim(tokens[3])
		if (expr1 == "*") {
			/* all variables? mistake			*/
			set_errmsg(sprintf("invalid expression {{bf:%s}}; " +
				"variable list wild card not allowed",expr))
			return(198)
		}
		gtype = `SUBEXPR_GROUP_EXPRESSION'
		if (__sub_expr_has_option(options,"xb")) {
			gtype = `SUBEXPR_GROUP_LC'
		}
		else if (!(rc=parse_param(expr2))) {
			/* expr2 updated from parse tree		*/
			if (bayes) {
				if (__sub_expr_has_option(options,"matrix",1)) {
					k = ustrpos(expr2,"}")
					if (k) {	// always
						expr2 = usubstr(expr2,1,k-1)
					}
					subexpr = sprintf("%s,matrix}",expr2)
				}
				else {
					subexpr = expr2
				}
			}
			else if (rc=__sub_expr_validate_options(options,
				J(1,0,""),0,errmsg)) {
				set_errmsg(sprintf("invalid expression " +
					"{bf:{%s, %s}}: %s",expr1,
					invtokens(options),errmsg))
			}
			else {
				subexpr = expr2
			}
			return(rc)
		}
		else {
			/* clear error from parse_param()		*/
			set_errmsg("")
		}
		/* recursive parse, create a
		 *  SUBEXPR_GROUP_EXPRESSION or SUBEXPR_GROUP LC	*/
		if (rc=parse(expr1,group,gtype,"",pSE,options)) {
			pSE = NULL
			return(rc)
		}
	}
	if (pSE->group_type() == `SUBEXPR_GROUP_LC') {
		/* can be multiple instances;  get group instance	*/
		index = pSE->instance()
		if (missing(index)) {
			/* programmer error				*/
			set_errmsg(sprintf("linear combination instance " +
				"{bf:%s} containing {bf:%s} not found in " +
				"its container; parsing cannot proceed",group,
				pSE->traverse_expr(`SUBEXPR_FULL')))
			rc = 499
		}
		else {
			subexpr = sprintf("{%s:@%g}",group,index)
		}
	}
	else {
		subexpr = sprintf("{%s:}",group)
	}
	pSE = NULL

	return(rc)
}

real scalar __sub_expr::parse_param(string scalar expr)
{
	real scalar rc, lcmsg
	string scalar pexpr, errmsg, errmsg1, vlist, type, name
	struct nlparse_node scalar ptree, tsop
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_elem) scalar pE, pE1
	class __sub_expr_group scalar grp

	pragma unset errmsg1
	pragma unset vlist
	pragma unset pG

	lcmsg = `SUBEXPR_FALSE'
	m_errmsg = errmsg = ""
	type = ""
	pexpr = sprintf("parameter:{%s}",expr)
	
	if (rc=_nlparse(pexpr,ptree,errmsg)) {
		pexpr = sprintf("parameter:%s",expr)
		ptree = nlparse_node(1)
		if (!_nlparse(pexpr,ptree,errmsg1)) {
			if (ptree.type == `LINCOM') {
				if (m_application==SPECIAL_APP_BAYES) {
					rc = 0
					errmsg = ""
				}
				else {
					lcmsg = `SUBEXPR_TRUE'
				}
			}
		}
		if (rc) {
			goto Exit
		}
	}
	pexpr = ""
	ptree = ptree.arg[2]
 	if (ptree.type == `VARLIST') {
		/* Bayes allows TS ops on scalar parameters		*/
 		ptree = ptree.arg[1]
		if (ptree.type == `TSOP') {
			/* type should be PARAMETER but this will fail
			 *  in _nlparse() because of the TSOP, use SYMBOL
			 *  for now and fix it up after _nlparse()	*/
			tsop = ptree
			ptree = tsop.arg[1]
			ptree.symb = tsop.symb + ptree.symb
		}
	}
	if (ptree.type == `OPERATOR') {
		name = new_tempname(m_tnames.GENERIC)
		if (rc=register_group(name,pG,`SUBEXPR_GROUP_LC')) {
			return(rc)
		}
		grp.set_dataobj(&this)
		if (rc=grp.set_component(pG)) {
			pG = NULL
			return(rc)
		}
		if (!(rc=grp.traverse_LC_operator(ptree,vlist))) {
			rc = _pt_node2expr(ptree,ptree,ptree,pexpr,errmsg)
			if (rc) {
				m_errmsg = errmsg
			}
		}
		pE = grp.first()
		while (pE != NULL) {
			pC = pE->component()
			if (pC) {
				(void)remove_component(pC)
				pC = NULL
			}
			pE1 = grp.next()
			pE->clear()
			pE = pE1
			pE1 = NULL
		}
		(void)remove_component(pG)
		grp.clear()
		pG = NULL
	}
	else if (ptree.type == `LVPARAM') {
		rc = _pt_node2expr(ptree,ptree,ptree,pexpr,errmsg)
		type = LATENT_VARIABLE
	}
	else if (ptree.type == `PARAMETER') {
		if (__sub_expr_isLVsymbol(ptree.symb)) {
			type = LATENT_VARIABLE
		}
		else {
			type = `SUBEXPR_STR_PARAM'
		}
		rc = _pt_node2expr(ptree,ptree,ptree,pexpr,errmsg)
	}
	else if (ptree.type == `PARGROUP') {
		type = `SUBEXPR_STR_PARAM'
		rc = _pt_node2expr(ptree,ptree,ptree,pexpr,errmsg)
	}
	else if (ptree.type == `SYMBOL') {
		pexpr = ptree.symb
	}
	if (!rc) {
		expr = pexpr
	}
	Exit:

	if (rc) {
		if (!strlen(m_errmsg)) {
			if (strlen(type)) {
				set_errmsg(sprintf("invalid %s specification " +
					"{bf:{%s}}",type,expr))
			}
			else {
				set_errmsg(sprintf("invalid specification " +
					"{bf:{%s}}",expr))
			}
			if (strlen(errmsg)) {
				set_errmsg(sprintf("%s: %s",m_errmsg,errmsg))
			}
		}
		if (lcmsg) {
			set_message(sprintf("If you are specifying a linear " +
				"combination, you must include a name for " +
				"it such as {bf:lc} in {bf:{lc:%s}}.",expr))
		}
	}
	return(rc)
}

real scalar __sub_expr::create_param_from_LC(struct nlparse_node tree,
			pointer (class __sub_expr_group) scalar pG)
{
	real scalar rc, gtype
	string scalar group
	struct nlparse_node scalar node, gnode, tsnode
	pointer (class __sub_expr_elem) scalar pE

	/* convert a parsed LINCOM in form group:param to a parameter
	 * in a group							*/
	rc = 0
	pG = NULL
	if (tree.type != `LINCOM') {
		return(rc)
	}
	gnode = tree.arg[1]	// group name
	if (gnode.type != `SYMBOL') {
		return(rc)
	}
	node = tree.arg[2]
	/* should be a VARLIST						*/
	if (node.type!=`VARLIST' | node.narg!=1) {
		return(rc)
	}
	node = node.arg[1]
	if (node.type != `SYMBOL') {
		if (m_application==SPECIAL_APP_BAYES) {
			/* Bayes allows TS operations on scalars	*/
			if (node.type!=`TSOP' | !node.narg) {
				return(0)
			}
			tsnode = node
			node = tsnode.arg[1]
			node.symb = tsnode.symb + node.symb
		}
		else {
			return(0)
		}
	}
	node.type = `PARAMETER'
	gtype = `SUBEXPR_GROUP_PARAM'
	if (rc=register_group(gnode.symb,pG,gtype)) {
		pG = NULL
		return(rc)
	}
	group = pG->name()
	pE = &__sub_expr_elem(1)
	pE->set_dataobj(&this)
	if (!(rc=pE->traverse_param(node,group))) {
		rc = pG->add_object(pE);
	}
	pE = NULL
	return(rc)
}

string scalar _sub_expr_curly_braces(string scalar expr)
{
	real scalar k
	string scalar expr1, tok, tok1
	transmorphic te

	expr1 = ""
	te = tokeninit("","","{}")
	tokenset(te,expr)
	tok = tokenget(te)
	while (ustrlen(tok)) {
		if (ustrleft(tok,1) == "{") {
			k = ustrlen(tok)
			tok1 = ustrright(ustrleft(tok,k-1),k-2)
			expr1 = expr1 + "{c 123}" + tok1 + "{c 125}"
		}
		else {
			expr1 = expr1 + tok
		}
		tok = tokenget(te)
	}
	return(expr1)
}

/* parse an equation:
 * 	depvar varlist
 * 	depvarlist = varlist
 * 	depvar = expression						*/
void __sub_expr::parse_equation(string scalar expression, |string scalar eqname,
			string scalar touse)
{
	real scalar rc

	rc = _parse_equation(expression,eqname,touse)
	if (rc) {
		error_and_exit(rc)	// back hole
	}
}

real scalar __sub_expr::_parse_equation(string scalar expression,
			|string scalar eqname, string scalar touse)
{
	real scalar rc, k, i, gtype
	string scalar expr, expr0, eq, tok
	string scalar msg
	string vector eqs
	string colvector voptions
	pointer (class __sub_expr_group) scalar pEQ
	pointer (class __component_base) scalar pC
	transmorphic te

	pragma unset eqs
	pragma unset pEQ
	pragma unset voptions
	pragma unset msg
	pragma unset pC

	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		/* programmer error					*/
		set_errmsg("expressions have already been resolved; cannot " +
			"parse after resolving expressions")
		return(498)
	}
	rc = 0
	if (!ustrlen(touse())) {
		(void)create_touse()
	}
	/* parsing new equation, undefined until parse is successful	*/
	m_dirty = `SUBEXPR_DIRTY_UNDEFINED'

	expr = ustrtrim(expression)
	if (!ustrlen(expr)) {
		set_errmsg("no equation to parse")
		return(198)
	}
	expr0 = expr
	if (rc=__sub_expr_get_options(expr,voptions,msg)) {
		set_errmsg(sprintf("invalid specification {bf:%s}; %s",expr0,
			msg))
		return(rc)
	}

	te = tokeninit("","",("{}"))
	tokenset(te,expr)
	tok = tokenget(te)
	if (ustrpos(tok,"=")>0) {
		/* equal sign: expression
		 * strips depvars and = from expr			*/
		if (rc=parse_depvars(expr,eqs)) {
			return(rc)
		}
		m_parse_origin = `SUBEXPR_PARSE_EQUATION'
		gtype = `SUBEXPR_EQ_EXPRESSION'
	}
	else {
		/* must be a linear combination
		 * first variable names the group (equation)		*/
		te = tokeninit(" "," ")
		tokenset(te, expr)
		eqs = J(1,1,ustrtrim(tokenget(te)))
		eq = eqs[1]
		if (ustrpos(eq, ".")) {
			set_errmsg(sprintf("invalid specification {bf:%s}: " +
				"operators are not allowed on the dependent " +
				"variable",eq))
			return(198)
		}
		if (!__sub_expr_isvariable(eq)) {	// unabbrev
			if (st_isname(eqs[1])) {
				set_errmsg(sprintf("dependent variable " +
					"{bf:%s} not found", eqs[1]))
				rc = 111
			}
			else {
				set_errmsg(sprintf("invalid specification" +
					" {bf:%s}", 
					_sub_expr_curly_braces(expr)))
				m_message = "A nonlinear model is specified " +
					"as {it:depvar} {bf:=} " +
					"<{it:menlepr}>. A linear " +
					"combination may be specified as " +
					"{it:depvar} {it:varlist}."
				rc = 198
			}
			return(198)
		}
		eqs[1] = eq	// unabbreviated depvar
		expr = ustrtrim(tokenrest(te))
		if (!ustrlen(expr)) {
			if (!__sub_expr_has_option(voptions,"xb")) {
				set_errmsg("nonlinear specification required")
				return(198)
			}
			if (__sub_expr_has_option(voptions,"noconstant",6)) {
				set_errmsg("options {bf:xb} and " +
					"{bf:noconstant} may not be " +
					"combined; no expression specified")
				return(184)
			}
		}
		m_parse_origin = `SUBEXPR_PARSE_EQUATION_LC'
		gtype = `SUBEXPR_EQ_LC'
	}

	if (rc=parse(expr,eqs[1],gtype,touse,pEQ,voptions)) {
		return(rc)
	}
	/* include depvar in ::varlist()				*/
	pC = NULL
	(void)register_component(eqs[1],`SUBEXPR_VAR_GROUP',`SUBEXPR_VARIABLE',
			pC)
	k = length(eqs)
	for (i=2; i<=k; i++) {
		pEQ = NULL
		if (rc=parse(expr,eqs[i],gtype,touse,pEQ,voptions)) {
			break;
		}
		pC = NULL
		/* include depvar in ::varlist()			*/
		(void)register_component(eqs[i],`SUBEXPR_VAR_GROUP',
				`SUBEXPR_VARIABLE',pC)
	}
	pC = NULL
	pEQ = NULL
	if (!rc) {
		eqname = invtokens(eqs)
		if (!length(m_equations)) {
			m_equations = eqs
		}
		k = length(eqs)
		for (i=1; i<=k; i++) {
			/* check for reparsed equations			*/
			if (!any(strmatch(m_equations,eqs[i]))) {
				m_equations = (m_equations, eqs[i])
			}
		}
		/* successfully parsed at least one equation		*/
		m_dirty = `SUBEXPR_DIRTY_PARSED'
	}
	m_parse_origin = `SUBEXPR_PARSE_NONE'

	return(rc)
}

/* parse a named expression that does not have dependent variables	
 * e.g. define(name: expression)					*/
void __sub_expr::parse_expression(string scalar expression,
			|string scalar exname, string scalar touse)
{
	real scalar rc

	rc = _parse_expression(expression,exname,touse)
	if (rc) {
		error_and_exit(rc)	// back hole
	}
}

/* parse a named expression that does not have dependent variables
 * e.g. define(name: expression)					*/
real scalar __sub_expr::_parse_expression(string scalar expression,
			|string scalar exname, string scalar touse)
{
	real scalar rc, k
	string scalar expr, group, errmsg
	string colvector options
	string vector tokens
	pointer (class __sub_expr_group) scalar pSE
	transmorphic te

	pragma unset errmsg
	pragma unset options

	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		/* programmer error					*/
		set_errmsg("expressions have already been resolved; cannot " +
			"parse after resolving expressions")
		return(498)
	}
	rc = 0
	m_dirty = `SUBEXPR_DIRTY_UNDEFINED'
	expr = ustrtrim(expression)
	if (!ustrlen(expr)) {
		set_errmsg("no expression to parse")
		return(198)
	}
	if (!ustrlen(touse())) {
		(void)create_touse()
	}
	k = ustrlen(expr)
	if (usubstr(expr,1,1)=="{" & usubstr(expr,k,1)=="}") {
		/* strip out leading/trailing {}			*/
		k = k-2
		expr = usubstr(expr,2,k)
	}
	/* white space is a token: could be a varlist			*/
	te = tokeninit("",(":"," "),"{}")
	tokenset(te, expr)
	tokens = tokengetall(te)

	k = length(tokens)
	if (k == 1) {
		set_errmsg("expression name separated by a colon ({bf::}) " +
			"is required: {it:name}{bf::} {it:expression}")
		return(198)
	}
	group = ustrtrim(tokens[1])
	if (k == 2) {
		if (group == ":") {
			set_errmsg("expression name required to the left of " +
				"the colon")
		}
		else {
			set_errmsg(sprintf("invalid expression {bf:%s}; " +
				"right side of the colon is empty", group))
		}
		return(198)
	}
	if (!st_isname(group)) {
		set_errmsg(sprintf("expression name {bf:%s} is invalid; " +
			"expression name is specified first separated by " +
			"a colon {bf::}",group))
		return(198)
	}
	expr = invtokens(tokens[|3\k|],"")
	if (rc=__sub_expr_get_options(expr,options,errmsg)) {
		set_errmsg(sprintf("invalid specification {bf:%s}; %s",expr,
			errmsg))
		return(rc)
	}
	m_parse_origin = `SUBEXPR_PARSE_EXPRESSION'
	pSE = NULL

	/* could be a SUBEXPR_GROUP_EXPRESSION or SUBEXPR_GROUP_LC
	 *  if user specified -define(group:param)-, returned object,
	 *  pSE, will be a SUBEXPR_GROUP_PARAM				*/
	rc = parse(expr,group,`SUBEXPR_GROUP_EXPRESSION',touse,pSE,options)
	if (!rc) {
		/* successfully parsed at least one expression		*/
		m_dirty = `SUBEXPR_DIRTY_PARSED'
		exname = pSE->name()
	}
	pSE = NULL
	m_parse_origin = `SUBEXPR_PARSE_NONE'

	return(rc)
}

void __sub_expr::parse_expr_init(string scalar exinit)
{
	real scalar rc

	rc = _parse_expr_init(exinit)
	if (rc) {
		errprintf("{p}%s{p_end}",errmsg())
		exit(rc)
	}
}

real scalar __sub_expr::_parse_expr_init(string scalar exinit)
{
	real scalar rc
	string scalar msg, expr
	struct nlparse_node scalar tree

	pragma unset msg

	expr = ustrtrim(exinit)

	/* break expression up by groups {...}				*/
	if (rc=_parse(expr)) {
		return(rc)
	}
	if (rc=_nlparse(expr,tree,msg)) {
		set_errmsg(sprintf("invalid expression initialization " +
			"{bf:%s}: %s",exinit,msg))
		return(rc)
	}
	return(traverse_expr_init(tree))
}

real scalar __sub_expr::traverse_expr_init(struct nlparse_node scalar tree)
{
	real scalar rc, gtype
	string scalar msg
	string vector node_types
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pS
	struct nlparse_node scalar node

	node_types = (`PT_STR_TYPES')

	rc = 0
	msg = "invalid expression initialization tree"
	if (tree.type!=`EQUATION' & tree.type!=`EXPRESSION' & 
		tree.type!=`LINCOM') {
		rc = 498
		/* try to fix up linear combination below		*/
		set_errmsg(sprintf("%s {bf:%s}: expected an equation or an " +
			"expression but got a %s",msg,tree.arg[1].symb,
			node_types[tree.type]))
		return(rc)
	}
	pG = lookup_component((`SUBEXPR_GROUP_SYMBOL',tree.arg[1].symb))
	if (pG == NULL) {
		rc = 111
		set_errmsg(sprintf("%s {bf:%s}: expression not found",msg,
			tree.arg[1].symb))
		return(rc)
	}
	gtype = pG->group_type()
	if (gtype==`SUBEXPR_GROUP_LC' | gtype==`SUBEXPR_EQ_LC') {
		rc = 498
		set_errmsg(sprintf("time-series initialization expression " +
			"for a %s is not allowed",pG->sgroup_type()))
		return(rc)
	}
	pS = new_group()
	pS->set_dataobj(&this)
	/* set flag that this object is for initializing a recursive
	 *   expression							*/
	pS->add_property(`SUBEXPR_PROP_TS_INIT')
	if (rc=pS->set_component(pG)) {
		return(rc)
	}
	/* initialization expression must be compatible to the group 
	 *  type since they share the same component object		*/
	if (tree.type == `LINCOM') {
		/* node is an arglist					*/
		node = tree.arg[2]
		if (node.type != `VARLIST' | node.narg>1) {
			rc = 498
			set_errmsg(sprintf("invalid initialization " +
				"expression for %s {bf:%s}; linear " +
				"combinations are not allowed",
				pG->sgroup_type(),pG->name()))
			return(rc)
		}
		/* single symbol, convert to expression			*/
		if (gtype==`SUBEXPR_GROUP_EXPRESSION' | 
			gtype==`SUBEXPR_EQ_EXPRESSION') {
			tree.type = `EXPRESSION'
			/* careful with recursive structures		*/
			tree.arg[2] = node.arg[1]
		}
	}
	if (rc=pS->traverse_expr_tree(tree)) {
		return(rc)
	}
	if (max(pS->TS_order()) > 0) {
		rc = 498
		set_errmsg(sprintf("%s for {bf:%s}: attempting to initialize " +
			"a recursive %s with an expression containing " +
			"time-series operators",msg,pG->name(),
			pG->sgroup_type()))
	}
	return(rc)
}

void __sub_expr::set_param_default_value(real scalar val)
{
	m_param_default_val = val
}

real scalar __sub_expr::param_default_value()
{
	return(m_param_default_val)
}

void __sub_expr::check_ref()
{
	real scalar ref
	pointer (class __component_base) scalar pC

	pC = iterator_init()
	printf("\n")	
	while (pC != NULL) {
		ref = pC->refcount()
		printf("%s:%s (%s) {col 50}ref = %g\n",pC->group(),pC->name(),
				pC->stype(),ref)
		pC = iterator_next()
	}
}

real scalar __sub_expr::TS_init_markout()
{
	real scalar rc, hassample
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) pSE

	pragma unset hassample

	rc = 0
	pC = iterator_init()
	while (pC) {
		if (pC->type() != `SUBEXPR_GROUP') {
			goto Next
		}
		pG = pC
		if (pG->group_type() == `SUBEXPR_GROUP_PARAM') {
			goto Next
		}
		if (pG->TS_init_req()) {
			pSE = pG->TS_initobj()

			if (rc=pSE->markout(hassample)) {
				goto Exit
			}
			if (!hassample) {
				set_errmsg(sprintf("no estimation sample for " +
					"time-series initialization %s {bf:%s}",
					pG->sgroup_type(),pG->name()))
				rc = 111
				goto Exit
			}
		}
		Next: pC = iterator_next()
	}
	Exit:
	pG = NULL
	pSE = NULL

	return(rc)
}

real scalar __sub_expr::_markout()
{
	real scalar rc, i, k, nooutput, gtype, markout, hassample
	real scalar uptouse, tsset, hastsops, tsop, nameonly
	real scalar dchkl, dchkf
	real vector itouse, itouse1, itouse0
	string scalar touse1, mac, cmd
	string vector vlist, vlist1
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE, pSE1

	pragma unset hassample

	rc = 0
	/* construct overall estimation sample indicator, if needed	*/
	/*  use OR operator (union) to merge eq/expr estimation samples
	 *  use AND operator (intersection) to merge overall estimation
	 *  sample with merged eq/expr estimation sample		*/
	if (st_nobs() == 0) {
		/* nothing to do					*/
		return(rc)
	}
	if (rc=create_touse()) {
		return(rc)
	}
	itouse = st_data(.,m_touse)
	m_n = sum(itouse)
	itouse0 = J(st_nobs(),1,0)
	markout = `SUBEXPR_TRUE'
	nooutput = `SUBEXPR_TRUE'
	uptouse = `SUBEXPR_FALSE'
	hastsops = `SUBEXPR_FALSE'

	tsset = (_stata("tsset",nooutput)==0)
	vlist = J(1,0,"")
	/* Bayes allows repeated parse-resolve sequences; estimation
	 *  samples will be recomputed using the indicator vector 
	 *  computed at the last resolve				*/
	pC = iterator_init()
	while (pC != NULL) {
		if (pC->type() != `SUBEXPR_GROUP') {
			goto Next
		}
		pG = pC
		gtype = pG->group_type()
		if (gtype == `SUBEXPR_GROUP_PARAM') {
			goto Next
		}
		k = pG->group_count()
		for (i=1; i<=k; i++) {
			pSE = pG->get_object(i)
			dchkl = dchkf = 1
			tsop = (pSE->TS_order(`TS_LORDER',dchkl)|
				pSE->TS_order(`TS_FORDER',dchkf))
			if (!tsset & tsop) {
				set_errmsg(sprintf("%s {bf:%s} has " +
				 "time-series operators, but the data is not " +
				 "{helpb tsset}",pG->sgroup_type(),pG->name()))
				return(111)
			}
			if (rc=pSE->markout(hassample)) {
				pG = NULL
				pSE = NULL
				return(rc)
			}
			hastsops = (hastsops | tsop)
			if (!hassample) {
				nameonly = `SUBEXPR_FALSE' 
				vlist1 = pSE->varlist(nameonly)
				if (length(vlist1)) {
					vlist = uniqrows((vlist,vlist1)')'
				}
			}
			else if (!pG->TS_init_req()) {	// done below
				/* has its own estimation sample
				 *  union eq/expr estimation samples	*/
				touse1 = pSE->touse(markout)
				itouse1 = st_data(.,touse1)
				itouse0 = itouse0 :| itouse1
				uptouse = `SUBEXPR_TRUE'
			}
		}
		Next:
		pG = NULL
		pSE = NULL
		pC = iterator_next()
	}
	/* markout time-series initialization expressions		*/
	pC = iterator_init()
	while (pC) {
		if (pC->type() != `SUBEXPR_GROUP') {
			goto Next1
		}
		pG = pC
		if (pG->group_type() == `SUBEXPR_GROUP_PARAM') {
			goto Next1
		}
		if (pG->TS_init_req()) {
			pSE = pG->TS_initobj()
			pSE1 = pG->get_object(1)	// should only be 1

			pG = NULL
			if (rc=pSE->markout(hassample)) {
				pSE = NULL
				return(rc)
			}
			if (!hassample) {
				set_errmsg(sprintf("no estimation sample for " +
					"time-series initialization %s {bf:%s}",
					pG->sgroup_type(),pG->name()))
				pSE = NULL
				return(111)
			}
			/*  union eq/expr estimation samples		*/
			touse1 = pSE->touse(markout)
			itouse1 = st_data(.,touse1)
			itouse0 = itouse0 :| itouse1

			touse1 = pSE1->touse(markout)
			itouse1 = st_data(.,touse1)
			itouse0 = itouse0 :| itouse1

			uptouse = `SUBEXPR_TRUE'
		}
		pG = NULL
		pSE = NULL
		Next1: pC = iterator_next()
	}
	if (k=length(vlist)) {
		/* generate estimation sample for all expressions that
		 *  do not have an estimation sample indicator		*/
		mac = st_tempname()
		/* include Stata syntax [if][in], if exists		*/
		if (application() == SPECIAL_APP_BAYES) {
			cmd = sprintf("marksample %s,strok",mac)
		}
		else {
			cmd = sprintf("marksample %s",mac)
		}
		if (rc=_stata(cmd,nooutput)) {
			if (rc=_st_addvar("byte",mac)) {
				/* should not happen			*/
				set_errmsg("failed to compute estimation " +
					"sample")
				return(498)
			}
			st_store(.,mac,J(st_nobs(),1,1))
		}
		else {
			mac = st_local(mac)	// contents of touse macro
		}
		if (application() == SPECIAL_APP_BAYES) {
			/* strings okay					*/
			cmd = sprintf("markout %s %s,strok",mac,
				invtokens(vlist))
		}
		else {
			cmd = sprintf("markout %s %s",mac,invtokens(vlist))
		}
		if (rc=_stata(cmd,nooutput)) {
			/* should not happen				*/
			set_errmsg("failed to markout sample")
			return(498)
		}
		itouse1 = st_data(.,mac)
		/* union estimation samples				*/
		itouse0 = itouse0 :| itouse1
		st_dropvar(mac)
		uptouse = `SUBEXPR_TRUE'
	}
	if (uptouse) {
		/* intersection with main estimation sample		*/
		itouse = itouse :& itouse0
	}
	m_n = sum(itouse)
	if (!m_n) {
		set_errmsg("no estimation sample remains after excluding " +
			"missing observations")
		if (hastsops) {
			set_message("Check that your time-series operations " +
				"can properly initialize.")
		}
		return(2000)
	}
	st_store(.,m_touse,itouse)
	return(0)
}

void __sub_expr::resolve_LV_base_equation(|string scalar prefeq)
{
	real scalar rc

	if (rc=_resolve_LV_base_equation(prefeq)) {
		error_and_exit(rc)
	}
}

real scalar __sub_expr::_resolve_LV_base_equation(|string scalar prefeq)
{
	real scalar i, k, type, hasfixed, iprefeq, ib
	real vector io
	real matrix ieq
	pointer (class __component_base) scalar pC
	pointer (class __component_param) vector vpar
	pointer (class __component_param) scalar eqpar

	k = eq_count()
	if (!k) {
		set_errmsg(sprintf("cannot resolve %s base equation: " +
			"no equations parsed",LATENT_VARIABLE))
		return(498)
	}
	if (!has_multi_eq()) {	// use multiple equation flag, not eq_count()
		/* multiple equation flag is FALSE or eq count is 1	*/
		return(0)
	}
	if (!ustrlen(prefeq)) {
		prefeq = m_base_eq
	}
	iprefeq = 1
	if (ustrlen(prefeq)) {
		io = (prefeq:==m_equations)
		if (!any(io)) {
			set_errmsg(sprintf("equation {bf:%s} not found",prefeq))
			return(111)
		}
		iprefeq = selectindex(io)[1]
	}
	m_base_eq = m_equations[iprefeq]
	if (m_dirty > `SUBEXPR_DIRTY_RESOLVE') {
		set_errmsg(sprintf("not in the proper state to set the %s(s) " +
			"base equation",LATENT_VARIABLE))
		dirty_message()	// specifics
		return(322)
	}
	pC = iterator_init()
	while (pC != NULL) {
		type = pC->type()
		if (type != `SUBEXPR_LV') {
			goto Next
		}
		vpar = pC->data(`SUBEXPR_HINT_PARAM_VEC')
		k = length(vpar)
		if (!k) {
			goto Next
		}
		ieq = J(0,2,0)
		hasfixed = `SUBEXPR_FALSE'
		for (i=1; i<=k; i++) {
			if (vpar[i]->is_fixed()) {
				/* nothing to do			*/
				hasfixed = `SUBEXPR_TRUE'
				break
			}
			io = (vpar[i]->group():==m_equations)
			if (!any(io)) {
				/* should not happen			*/
				set_errmsg(sprintf("equation {bf:%s} not " +
					"found",vpar[i]->group()))
				return(111)
			}
			ieq = (ieq\(selectindex(io),i))
		}
		k = rows(ieq)
		if (!k | hasfixed) {
			goto Next
		}
		/* equations in parse order				*/
		ieq = sort(ieq,1)
		
		io = (iprefeq:==ieq[.,1])
		if (any(io)) {
			/* programmer's preference			*/
			eqpar = vpar[ieq[iprefeq,2]]
		}
		else {
			/* choose one equation, pref top in parse order	*/
			eqpar = vpar[ieq[1,2]]
		}
		eqpar->set_value(1.0)
		eqpar->set_fixed(`SUBEXPR_TRUE')
		if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
			/* param vector already built; update with 
			 *  scale					*/
			ib = eqpar->param_index()
			if (ib>=1 & ib<=m_param.cols()) {
				(void)m_param.set_el(1,ib,1.0)
			}
		}
		Next: 
		eqpar = NULL
		k = length(vpar)
		for (i=1; i<=k; i++) {
			vpar[i] = NULL
		}
		vpar = J(1,0,NULL)

		pC = iterator_next()
	}
	return(0)	
}

void __sub_expr::resolve_expressions()
{
	real scalar rc

	rc = _resolve_expressions()
	if (rc) {
		error_and_exit(rc)	// back hole
	}
}

real scalar _sub_expr_count_evaluable_expr(
		pointer (class __component_group) scalar pG)
{
	real scalar i, k, m, notemplate
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pSE

	m = 0
	notemplate = `SUBEXPR_TRUE'
	k = pG->group_count()
	for (i=1; i<=k; i++) {
		pSE = pG->get_object(i)
		pE = pSE->first(notemplate)
		if (pE != NULL) {
			if (!pE->has_property(`SUBEXPR_PROP_TEMPLATE')) {
				/* evaluatable expression		*/
				m++
			}
		}
		else if (pSE->has_property(`SUBEXPR_PROP_TEMPLATE')) {
			/* include template expression			*/
			m++
		}
	}
	return(m)
}
	
real scalar __sub_expr::_resolve_expressions(|string scalar tvar,
			string scalar gvar)
{
	real scalar i, j, k, kg, rc, type, neq, multi_eq
	string scalar eq
	pointer (class __component_base) scalar pC
	pointer (class __component_param) vector pars, allpars
	pointer (class __component_group) scalar pG
	pointer (class __component_group) vector grps, pargrps
	pointer (class __sub_expr_group) scalar pSE

	rc = 0
	if (m_dirty > `SUBEXPR_DIRTY_PARSED') {
		set_errmsg("not ready to resolve expressions")
		dirty_message()
		return(498)
	}
	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		/* programmer error					*/
		set_errmsg("expressions are already resolved; resolving " +
			"expressions more than once is not allowed")
		return(498)
	}
	pargrps = grps = J(1,0,NULL)
	allpars = J(1,0,NULL)

	pC = iterator_init()
	while (pC != NULL) {
		type = pC->type()
		if (type != `SUBEXPR_GROUP') {
			goto Next
		}
		pG = pC
		if (rc=resolve_group(pG,pargrps)) {
			goto Exit
		}
		grps = (grps,pG)
		Next: pC = iterator_next()
	}
	k = length(pargrps)
	/* resolved parameter groups, rename to /group			*/
	for (i=1; i<=k; i++) {
		pG = pargrps[i]
		if (rc=resolve_param_group(pG)) {
			goto Exit
		}
	}
	/* generate Stata LHS tempname 					*/
	m_tlhs = new_tempname(m_tnames.VARIABLE)
	multi_eq = has_multi_eq()

	pC = iterator_init()
	while (pC != NULL) {
		type = pC->type()
		if (type == `SUBEXPR_GROUP') {
			pG = pC
			k = pG->group_count()

			for (i=1; i<=k; i++) {
				pSE = pG->get_object(i)
				/* allow group object to assess itself	*/
				if (rc=pSE->post_resolve()) {
					return(rc)
				}
			}
			pG = pC
			if (pG->TS_init_req()) {
				if (_sub_expr_count_evaluable_expr(pG) > 1) {
					/* multiple instances of expression
					 *  that are evaluable		*/
					set_errmsg(sprintf("multiple " +
						"evaluable instances of %s " +
						"{bf:%s} exist; expression " +
						"cannot be recursive using a " +
						"lag operator on itself",
						pG->sgroup_type(),pG->name()))
					pG = NULL
					pC = NULL
					return(498)
				}
				if (pG->TS_initobj() == NULL) {
					set_errmsg(sprintf("time-series " +
						"initialization expression " +
						"required for %s {bf:%s}",
						pG->sgroup_type(),pG->name()))
					error_code(`SUBEXPR_ERROR_TSINIT',
						pG->name())
					pG = NULL
					pC = NULL
					return(498)
				}
			}
			else if (pG->TS_initobj() != NULL) {
				set_errmsg(sprintf("time-series " +
					"initialization expression not " +
					"necessary for %s {bf:%s}",
					pG->sgroup_type(),pG->name()))
				set_message("A time-series initialization " +
					"expression is only required for " +
					"expressions that include a lag of " +
					"itself.")
				pG = NULL
				pC = NULL
				return(498)
			}
		}
		else if (type==`SUBEXPR_LV' & !multi_eq) {
			/* remove LV scale parameters			*/
			pars = pC->data(`SUBEXPR_HINT_PARAM_VEC')
			if (length(pars)) {
				/* que up scaling parameters for removal;
				 *  cannot do it while iterating	*/
				allpars = (allpars,pars)
			}
			(void)pC->update(NULL,`SUBEXPR_HINT_PARAM_CLEAR')
		}
		pC = iterator_next()
	}
	/* create and markout estimation sample; required for hierarchy	*/
	if (rc=_markout()) {
		goto Exit
	}
	kg = length(grps)
	for (i=1; i<=kg; i++) {
		pG = grps[i]
		k = pG->group_count()
		for (j=1; j<=k; j++) {
			pSE = pG->get_object(j)
			if (rc=pSE->expand_FVs()) {
				goto Exit
			}
		}
	}
	if (rc=resolve_lvhierarchy(tvar,gvar)) {
		goto Exit
	}

	/* intermediate state: resolved expr, but have not built the
	 *  parameter vector; tells _resolve_LV_base_equation() that it
	 *  does not need to update param vector with scaling constants	*/
	m_dirty = `SUBEXPR_DIRTY_RESOLVE'
	if (multi_eq) {
		/* resolve LV scale parameters; must be done after all
		 *  group objects are resolved				*/
		neq = length(m_equations)
		for (i=1; i<=neq; i++) {
			eq = m_equations[i]
			pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',eq))
			if (pC == NULL) {
				/* should not happen			*/
				set_errmsg(sprintf("equation {bf:%s} not found",
					eq))
				m_dirty = `SUBEXPR_DIRTY_PARSED'
				rc = 111
				goto Exit
			}
			pG = pC
			pSE = get_defined_expr(pG)	// there can only be 1
			if (rc=resolve_equation_LVs(eq,pSE)) {
				goto Exit
			}
			pSE->resolve_TS_order()
		}
		/* make sure there is a base equation for each LV where,
		 *  LV param = 1 (or user specified @#)			*/
		if (application() != SPECIAL_APP_BAYES) {
			/* Bayes allows multiple parse/resolve cycles,
			 *  programmer must resolve LV base equations
			 *  after cycles are done			*/
			if (rc=_resolve_LV_base_equation()) {
				m_dirty = `SUBEXPR_DIRTY_PARSED'
				goto Exit
			}
		}
	}
	else {
		/* only 1 equation: remove LV scaling parameters	*/
		k = length(allpars)
		for (i=1; i<=k; i++) {
			if (!remove_component(allpars[i])) {
				add_warning(sprintf("could not remove " +
					"component {bf:%s:%s}",
					allpars[i]->group(),allpars[i]->name()))
			}
		}
		k = length(m_equations)
		if (k == 1) {
			eq = m_equations[1]
			pG = lookup_component((`SUBEXPR_GROUP_SYMBOL',eq))
			pSE = get_defined_expr(pG)	// there can only be 1
			pSE->resolve_TS_order()
			pG = NULL
			pSE = NULL
		}
	}
	/* check for collinearity in LC equations and LC expressions
	 *  with reference count 1; add o. operators before making 
	 *  parameter vector						*/
	if (rc=mark_collinear_omit()) {
		goto Exit
	}
	if (rc=make_param_vec()) {
		m_dirty = `SUBEXPR_DIRTY_PARSED'
		goto Exit
	}
	/* generate Stata LHS tempname 					*/
	m_tlhs = (new_tempname(m_tnames.VARIABLE),"")
	m_ilhs = `SUBEXPR_LHS_OWN'

	/* setup dependency lists					*/
	construct_depend()
	// dump_expr_depend()

	m_dirty = `SUBEXPR_DIRTY_RESOLVED_EXP'

	Exit:		// memory cleanup
	pC = NULL
	pG = NULL
	pSE = NULL
	/* clean up reference counters					*/
	k = length(grps)
	for (i=1; i<=k; i++) {
		grps[i] = NULL
	}
	grps = J(1,0,NULL)

	k = length(pargrps)
	for (i=1; i<=k; i++) {
		pargrps[i] = NULL
	}
	pargrps = J(1,0,NULL)

	k = length(allpars)
	for (i=1; i<=k; i++) {
		allpars[i] = NULL
	}
	allpars = J(1,0,NULL)

	k = length(pars)
	for (i=1; i<=k; i++) {
		pars[i] = NULL
	}
	pars = J(1,0,NULL)

	return(rc)
}

real scalar __sub_expr::mark_collinear_omit()
{
	real scalar i, k, ko, rc, type, nooutput, rename, unique
	real vector io
	string scalar cmd, var, group, name
	string vector vlist, olist, ovars
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pSE

	rc = 0
	nooutput = `SUBEXPR_TRUE'
	unique = `SUBEXPR_TRUE'

	pC = iterator_init()
	while (pC != NULL) {
		type = pC->type()
		if (type != `SUBEXPR_GROUP') {
			goto Next
		}
		pG = pC
		type = pG->group_type()
		if (type!=`SUBEXPR_GROUP_LC' & type!=`SUBEXPR_EQ_LC') {
			goto Next
		}
		k = pG->group_count(unique)
		if (k != 1) {
			/* cannot determine collinearity		*/
			goto Next
		}
		pSE = get_defined_expr(pG)
		vlist = J(1,0,"")
		pE = pSE->first()
		while (pE != NULL) {
			type = pE->type()
			if (type == `SUBEXPR_LV') {
				/* no latent variables			*/
				goto NextE
			}
			name = pE->name()
			if (name == "_cons") {
				goto NextE
			}
			pC = pE->component()

			vlist = (vlist,name)

			NextE: pE = pE->next()
		}
		group = pG->name()
		cmd = sprintf("fvexpand %s",invtokens(vlist))
		if (rc=_stata(cmd,nooutput)) {
			set_errmsg(sprintf("failed to mark omitted collinear " +
				"variables for %s {bf:%s}",pG->sgroup_type(),
				group))
			rc = 498
			goto Exit
		}
		olist = tokens(st_global("r(varlist)"))
		io = (ustrpos(olist,"o."):>0)
		if (!any(io)) {
			/* nothing to do				*/
			goto Next
		}
		olist = olist[selectindex(io)]
		vlist = olist
		ovars = usubinstr(olist,"o.",".",.)
		ko = length(olist)
		for (i=1; i<=ko; i++) {
			rename = `SUBEXPR_TRUE'
			/* variable without o. operators		*/
			var = ovars[i]
			pC = lookup_component((group,var))
			if (pC == NULL) {
				rename = `SUBEXPR_FALSE'
				var = vlist[i]
				pC = lookup_component((group,var))
			}
			if (pC == NULL) {
				set_errmsg(sprintf("failed to mark omitted " +
					"collinear variables for %s " +
					"{bf:%s}: variable {bf:%s} not found",
					pG->sgroup_type(),group,var))
				rc = 111
				goto Exit
			}
			if (!rename) {
				continue
			}
			(void)remove_component(pC)
			pC->set_name(olist[i])
			if (rc=add_component(pC)) {
				set_errmsg(sprintf("failed to mark omitted " +
					"collinear variables for %s " +
					"{bf:%s}: %s",
					pG->sgroup_type(),group,errmsg()))
				goto Exit
			}
			/* pointer to the parameter component has not
			 *  changed; any object holding onto the component
			 *  is automatically 'updated'			*/
		}
		Next: pC = iterator_next()
	}
	Exit:	// release pointers
	pC = NULL
	pG = NULL
	pE = NULL
	pSE = NULL

	return(rc)
}

void __sub_expr::construct_expr_depend(
		pointer (class __sub_expr_group) scalar pSE,
		pointer (class __sub_expr_group) vector dep)
{
	real scalar i, k, inst
	string scalar key, key1, name
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pSE1
	pointer (class __sub_expr_group) vector dep1
	pointer (class __component_group) scalar pG

	pG = pSE->component()
	key = name = pSE->name()
	inst = pSE->instance()
	if (!missing(inst)) {	// SUBEXPR_GROUP_LC
		key = sprintf("%s@%g",key,inst)
	}
	dep = m_exprdep.get(key)
	if (length(dep)) {
		pG = NULL
		return
	}
	if (pG->eval_status() == `SUBEXPR_EVAL_DEPENDENCY') {
		/* let TS initialization expression through		*/
		if (!pSE->has_property(`SUBEXPR_PROP_TS_INIT')) { 
			/* user defined a recursive condition in their 
			 *  expressions: e.g. a->b->a			*/
			dep = J(1,1,m_nodep)
			pG = NULL
			return
		}
	}
	if (pSE->group_type() == `SUBEXPR_GROUP_PARAM') {
		pG = NULL
		return
	}
	pG->set_eval_status(`SUBEXPR_EVAL_DEPENDENCY')
	pE = pSE->first()
	while (pE) {
		if (pE->type() != `SUBEXPR_GROUP') {
			goto Next
		}
		pSE1 = pE
		if (pSE1->group_type() == `SUBEXPR_GROUP_PARAM') {
			goto Next
		}
		key1 = pSE1->name()
		if (key1 == name) {
			/* recursive with lag				*/
			goto Next
		}
		inst = pSE1->instance()
		if (!missing(inst)) { 	// SUBEXPR_GROUP_LC
			key1 = sprintf("%s@%g",key1,inst)
		}
		dep = (dep,pSE1)
		dep1 = m_exprdep.get(key1)
		if (!(k=length(dep1))) {
			construct_expr_depend(pSE1,dep1)
			k = length(dep1)
		}
		if (k==1 & dep1[1]==m_nodep) {
			goto Next
		}
		else {
			dep = (dep,dep1)
		}
		Next: pE = pE->next()
	}
	if (!pSE->has_property(`SUBEXPR_PROP_TS_INIT')) { // not TS init expr
		pSE1 = pG->TS_initobj()
		if (pSE1 != NULL) {
			key1 = pSE1->name()
			inst = pSE1->instance()
			if (!missing(inst)) { 	// SUBEXPR_GROUP_LC
				key1 = sprintf("%s@%g",key1,inst)
			}
			dep = (dep,pSE1)
			dep1 = m_exprdep.get(key1)
			if (!(k=length(dep1))) {
				construct_expr_depend(pSE1,dep1)
				k = length(dep1)
			}
			if (!(k==1 & dep1[1]==m_nodep)) {
				dep = (dep,dep1)
			}
		}
	}
	if (length(dep) == 0) {
		/* m_nodep __sub_expr_group pointer to denote no
		 *  dependencies					*/
		dep = J(1,1,m_nodep)
	}
	m_exprdep.put(key,dep)

	/* memory cleanup						*/
	k = length(dep1)
	for (i=1; i<=k; i++) {
		dep1[i] = NULL
	}
	pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
	dep1 = J(1,0,NULL)
	pE = NULL
	pSE1 = NULL
}

void __sub_expr::dump_expr_depend()
{
	real scalar i, k, inst
	string scalar key
	pointer (class __sub_expr_group) vector dep
	pointer (class __sub_expr_group) scalar pSE

	printf("\nEquation/expression downward dependencies")
	dep = m_exprdep.firstval()
	while ((k=length(dep))) {
		key = m_exprdep.key()
		printf("\nkey {bf:%s}\n\t",key)
		if (dep[1] == m_nodep) {
			printf("no dependencies")
		}
		else {
			for (i=1; i<=k; i++) {
				pSE = dep[i]
				inst = pSE->instance()
				if (!missing(inst)) {
					printf(" %s@%g",pSE->name(),inst)
				}
				else {
					printf(" %s",pSE->name())
				}
			}
		}
		dep = m_exprdep.nextval()
	}
	/* decrement reference counts					*/
	k = length(dep)
	for (i=1; i<=k; i++) {
		dep[i] = NULL
	}
	dep = J(1,0,NULL)
}

void __sub_expr::construct_depend()
{
	real scalar i, k
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE
	pointer (class __sub_expr_group) vector dep

	m_exprdep.clear()
	pC = iterator_init()
	while (pC) {
		if (pC->type() != `SUBEXPR_GROUP') {
			goto Next
		}
		pG = pC
		if (pG->group_type() == `SUBEXPR_GROUP_LC') {
			k = pG->group_count()
			for (i=1; i<=k; i++) {
				pSE = pG->get_object(i)

				dep = J(0,1,"")
				construct_expr_depend(pSE,dep)
			}
		}
		else {
			pSE = get_defined_expr(pG)
			dep = J(0,1,"")
			construct_expr_depend(pSE,dep)
		}
		Next: pC = iterator_next()
	}
	/* decrement reference counts					*/
	k = length(dep)
	for (i=1; i<=k; i++) {
		dep[i] = NULL
	}
	dep = J(1,0,NULL)
	pC = NULL
	pG = NULL
	pSE = NULL
}

real scalar __sub_expr::resolve_group(
		pointer (class __component_group) scalar pG,
		pointer (class __component_group) vector pargrps)
{
	real scalar rc, i, j, kv, kd, kn, alleq, gtype
	real vector def, ndef
	string vector opts
	pointer (class __sub_expr_group) scalar pSE, pSE1, pT
	pointer (class __sub_expr_group) vector eqto
	pointer (class __sub_expr_elem) scalar pEf, pEl
	pointer (struct __component_state) scalar pstate

	rc = 0
	kd = kn = 0

	if (kv=pG->group_count()) {
		def = ndef = J(1,kv,0)
		for (i=1; i<=kv; i++) {
			pSE = pG->get_object(i)
			if (pSE->isdefined()) {
				def[++kd] = i
			}
			else {
				ndef[++kn] = i
			}
		}
		pSE = NULL
	}
	if (!kd) {
		(void)remove_component(pG)
		set_errmsg(sprintf("expression {bf:{%s:}} is not defined",
			pG->name()))
		return(111)
	}
	def = def[|1\kd|]
	if (kn) {
		ndef = ndef[|1\kn|]
	}
	else {
		ndef = J(1,0,0)
	}
	/* look for defined group to use as template for undefined
	 *  groups							*/
	pT = pG->get_object(def[1])
	alleq = `SUBEXPR_TRUE'
	/* check that all expressions of this group are equivalent	*/
	for (i=kd; i>1; i--) {
		pSE = pG->get_object(def[i])
		alleq = alleq & (pT->isequal(pSE))
		if (!alleq) {
			break
		}
	}
	pSE = NULL
	gtype = pG->group_type()
	if (gtype == `SUBEXPR_GROUP_PARAM') {
		/* que up to rename group to /group			*/
		pargrps = (pargrps,pG)
		pEf = pT->first()
		pEl = pT->last()
		if (pEf != pEl) {
			/* programmer error				*/
			set_errmsg(sprintf("invalid %s group {bf:%s}",
				pG->sgroup_type(),pT->traverse_expr()))
			rc = 198
		}
		pEf = NULL
		pEl = NULL
		if (rc) {
			return(rc)
		}
	}
	if (!alleq) {
		if (gtype==`SUBEXPR_GROUP_EXPRESSION' | gtype==`SUBEXPR_EQ_LC' |
			gtype==`SUBEXPR_EQ_EXPRESSION') {
			set_errmsg(sprintf("%s {bf:{%s:}} has multiple " +
				"definitions; this is not allowed",
				pG->sgroup_type(),pG->name()))
			return(110)
		}
		if (gtype == `SUBEXPR_GROUP_LC') {
			/* linear form is lost
			 * que up to rename group to /group		*/
			pargrps = (pargrps,pG)
			/* LC must have their own eval state object	*/
			eqto = J(1,kd,NULL)
			for (i=1; i<=kd; i++) {
				pSE = pG->get_object(def[i])
				if (eqto[i] == NULL) {
					/* not equal to anyone yet	*/
					eqto[i] = pSE
					pstate = &__component_state(1)	
					pstate->subexpr = 
					   new_tempname(m_tnames.VARIABLE)
					pstate->estate = `SUBEXPR_EVAL_DIRTY'
					pstate->lhstype = `SUBEXPR_EVAL_VECTOR'
					pSE->set_state(pstate)
				}
				for (j=i+1; j<=kd; j++) {
					if (eqto[j] == NULL) {
						pSE1 = pG->get_object(def[j])
						if (pSE->isequal(pSE1)) {
							/* share state	*/
							eqto[j] = pSE
							pSE1->set_state(
								pSE->state())
						}
					}
				}
			}
			for (i=1; i<=kd; i++) {
				eqto[i] = NULL
			}
			eqto = J(1,0,NULL)
			pSE = NULL
			pSE1 = NULL
		}
		else if (kn) {
			set_errmsg(sprintf("ambiguous definition of group " +
				"{bf:%s}; no substitute for {bf:%s:}",
				pG->name(),pG->name()))
			set_message(sprintf("Any reference of group {bf:%s} " +
				"is ambiguous since the group has more than " +
				"one parameter.",pG->name()))
			return(498)
		}
	}		
	else if (kn) {
		if (kd>1 & gtype==`SUBEXPR_GROUP_PARAM') {
			/* programmer error. Cannot happen?		*/
			set_errmsg(sprintf("%s {bf:%s} has %g undefined " +
				"objects; this is not allowed",
				pG->sgroup_type(),pG->name(),kn))
			return(498)
		}
		if (gtype==`SUBEXPR_EQ_EXPRESSION' | gtype==`SUBEXPR_EQ_LC') {
			/* must be a lagged reference to the equation	*/
			for (i=1; i<=kn; i++) {
				pSE = pG->get_object(ndef[i])
				if (!pSE->has_property(`SUBEXPR_PROP_TS_OP')) {
					set_errmsg(sprintf("invalid %s " +
						"reference {bf:%s}; lag " +
						"operator is required when " +
						"referencing a %s within a %s",
						pG->sgroup_type(),pG->name(),
						pG->sgroup_type(),
						pG->sgroup_type()))
					pSE = NULL
					return(498)
				}
			}
		}
		else if (!has_multi_eq() & (gtype==`SUBEXPR_GROUP_EXPRESSION' |
			gtype==`SUBEXPR_GROUP_LC')) {
			/* cannot use a template object for expression
			 *  references with multiple equations; expressions
			 *  could have LV's that require scaling factor	*/
			pT->add_property(`SUBEXPR_PROP_TEMPLATE')
			opts = pT->options()
			for (i=1; i<=kn; i++) {
				pSE = pG->get_object(ndef[i])
				pSE1 = pSE->groupobj()
				if (!pSE->has_property(`SUBEXPR_PROP_TS_OP')) {
					/* link to template object	*/
					if (rc=pSE->add_object(pT)) {
						return(rc)
					}
					pSE->set_options(opts)
					pSE->set_parse_tree(pT->parse_tree())
				}
				else if (pSE1 != NULL) {
					/* lagged within itself 
					 *  i.e. recursive		*/
					if (!all(pSE->key():==pSE1->key())) {
						/* link to template 
						 * object		*/
						if (rc=pSE->add_object(pT)) {
							return(rc)
						}
				
					}
					pSE->set_options(opts)
					pSE->set_parse_tree(pT->parse_tree())
				}
			}
		}
		else {
			/* now resolve expression references {group:}
			 *  clone contents of__sub_expr_group object,
			 *  pSE share the state object from the group 
			 *  component					*/
			for (i=1; i<=kn; i++) {
				pSE = pG->get_object(ndef[i])
				/* clone the contents of template pT
				 *  pSE remains the same pointer	*/
				(void)pT->clone(pSE)
			}
		}
		pSE = NULL
		alleq = 1
		kn = 0
	}
	if (alleq | kn==0) { 
		if (gtype == `SUBEXPR_UNDEFINED') {
			/* programmer error				*/
			set_errmsg(sprintf("%s group {bf:%s} after " +
				"resolving; this is not allowed",
				pG->sgroup_type(),pG->name()))
			return(111)
		}
		if (gtype==`SUBEXPR_GROUP_LC') {
			/* linear combination is linear form if they
			 * are all the same				*/
			kd = pG->group_count()
			for (i=1; i<=kd; i++) {
				pT = pG->get_object(i)
				pT->add_property(`SUBEXPR_PROP_LINEAR_FORM')
			}
		}
		else if (gtype==`SUBEXPR_EQ_LC') {
			/* only 1 equation linear combination and 
			 * must be linear form				*/
			pT = get_defined_expr(pG)
			pT->add_property(`SUBEXPR_PROP_LINEAR_FORM')
		}
		pT = NULL
	}
	else { 
		pT = NULL
		rc = resolve_LC_group(pG,def,ndef)
	}
	if (!rc) {
		rc = _resolve_group(pG,pargrps)
	}
	return(rc)
}

real scalar __sub_expr::resolve_LC_group(
		pointer (class __component_group) scalar pG, 
		real vector def, real vector ndef)
{
	real scalar i, j, k, kv, kd, kn, rc, cons, type, xb
	real matrix match
	string scalar vname, group 
	string vector vlist, kill, opts, key
	string matrix vlc, vlv
	pointer (class __component_base) scalar pC
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pSE, pT

	rc = 0
	if (pG->group_type() != `SUBEXPR_GROUP_LC') {
		return(rc)
	}
	kd = length(def)
	if (!kd) {
		set_errmsg(sprintf("expression {bf:{%s:}} is not defined",
			pG->name()))
		return(111)
	}
	kn = length(ndef)
	if (!kn) {
		/* nothing to do					*/
		return(0)
	}
	/* LC group, tally all the parameter names used by all 
	 *  sub-expressions with this group name			*/
	vlist = J(0,2,"")
	kill = J(0,2,"")	// objects to destroy
	for (i=1; i<=kd; i++) {
		pSE = pG->get_object(def[i])
		vlc = pSE->element_names()
		if (!(k=rows(vlc))) {
			continue
		}
		/* unabbreviate names that were interpreted as 
		 *  free parameters at parse time			*/
		for (j=1; j<=k; j++) {
			vname = vlc[j,2]
			if (__sub_expr_isvariable(vname)) {	// unabbr
				if (vname != vlc[j,2]) {
					if (rc=resolve_replace_LC_param(pSE,
						vlc[j,2],vname)) {
						return(rc)
					}
					kill = (kill\(pSE->name(),vlc[j,2]))

					vlc[j,2] = vname
				}
			}
		}
		if (!rows(vlist)) {	
			vlist = vlc
			continue
		}
		for (j=1; j<=k; j++) {
			match = (vlc[j,.]:==vlist)
			if (!(cross(match[.,1],match[.,2]))) {
				vlist = (vlist\vlc[j,.])
			}
		}
	}
	pSE = NULL
	k = rows(vlist)
	if (!k) {
		/* not possible						*/
		set_errmsg(sprintf("%s %s has no parameters",pG->sgroup_type(),
				pG->name()))
		return(498)
	}
	vlc = J(0,2,"")	// LC parameters
	vlv = J(0,2,"")	// LV 
	cons = 0	// constant
	for (j=1; j<=k; j++) {
		if (vlist[j,2] == "_cons") {
			cons = 1
			continue
		}
		key = vlist[j,.]
		pC = lookup_component(key)
		type = pC->type()
		if (type==`SUBEXPR_LC_PARAM' | type==`SUBEXPR_FV') {
			vlc = (vlc\key)
		}
		else if (type == `SUBEXPR_LV') {
			vlv = (vlv\key)
		}
		else {
			group = __sub_expr_name_no_slash(key[1])
			set_errmsg(sprintf("attempting to include %s {bf:%s} " +
				"into %s {bf:%s}; this is not allowed",
				pC->stype(),key[2],pG->sgroup_type(),group))
			pC = NULL
			return(109)
		}
		pC = NULL
	}
	if (k=rows(kill)) {
		/* free parameter objects converted to LC parameters	*/
		for (i=1; i<=k; i++) {
			pC = lookup_component(kill[i,.])
			if (pC != NULL) {
				(void)remove_component(pC)
			}
		}
	}
	if (rows(vlc)) {
		vlc = sort(vlc,2)
	}
	if (rows(vlv)) {
		vlv = sort(vlv,2)
	}
	vlist = (vlc\vlv)
	if (cons) {
		vlist = (vlist\(pG->name(),"_cons"))
	}
	/* expression references {group:}, add all parameters 		*/
	k = rows(vlist)
	for (j=1; j<=k; j++) {
		key = vlist[j,.]
		pC = lookup_component(key)
		for (i=1; i<=kn; i++) {
			pSE = pG->get_object(ndef[i])
			pE = &__sub_expr_elem(1)
			/* `this' is not the correct pointer; use the
			 *  pointer of `this'				*/
			pE->set_dataobj(&this)
			if (rc=pE->set_component(pC)){
				break
			}
			if (rc=pSE->add_object(pE)) {
				break
			}
		}
		if (rc) {
			break
		}
	}
	pC = NULL
	pSE = NULL
	pE = NULL
	if (rc) {
		return(rc)
	}
	/* new template with all variables				*/
	pT = pG->get_object(ndef[1])
	/* determine if an xb option needs to be added			*/
	xb = `SUBEXPR_FALSE'
	if (k == 1) {
		/* _cons or single varname				*/
		xb = `SUBEXPR_TRUE'
	}
	else if (k==2 & vlist[2,2]=="_cons") {
		xb = `SUBEXPR_TRUE'
	}
	if (xb == `SUBEXPR_TRUE') {
		for (i=1; i<=kn; i++) {
			pSE = pG->get_object(ndef[i])
			opts = pSE->options()
			if (!any(opts:=="xb")) {
				opts = (opts,"xb")
				pSE->set_options(opts)
			}
		}
		pSE = NULL
	}
	/* update group count						*/
	kv = pG->group_count()
	for (i=1; i<=kv; i++) {
		pSE = pG->get_object(i)
		if (pSE != pT) {
			if (pT->isequal(pSE)) {
				/* use shared component state object	*/
				pSE->set_state(pT->state())
			}
		}
	}
	pT = NULL
	pSE = NULL

	return(rc)
}

/* virtual function for special resolve handling 			*/
real scalar __sub_expr::_resolve_group(
		pointer (class __sub_expr_group) scalar pG,
		pointer (class __component_group) vector pargrps)
{
	pragma unused pG
	pragma unused pargrps

	return(0)
}

real scalar __sub_expr::resolve_equation_LVs(string scalar eq,
			pointer (class __sub_expr_group) scalar pSE)
{
	real scalar rc, val, val1, type, fixed
	string scalar group, name
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pG
	pointer (class __component_base) scalar pC, pC1, pLV

	rc = 0
	pE = pSE->first()
	while (pE != NULL) {
		type = pE->type()
		if (type == `SUBEXPR_GROUP') {
			if (rc=resolve_equation_LVs(eq,pE)) {
				return(rc)
			}
		}
		if (type != `SUBEXPR_LV') {
			goto Next
		}
		/* LV's return the name of groupobj()->name() instead of
		 *  common LV group symbol `SUBEXPR_LV_GROUP		*/
		group = pE->group()
		if (group == eq) {
			/* constructed at parse-time; nothing to do	*/
			goto Next
		}
		name = pE->name()
		pG = pE->groupobj()
		if (pG == NULL) {
			/* should not happen				*/
			set_errmsg(sprintf("invalid %s {bf:%s:%s}",
				LATENT_VARIABLE,eq,name))
			rc = 499
			break
		}
		/* look up associated scaling parameter			*/
		pC = lookup_component((group,name))
		if (pC==NULL & usubstr(group,1,1)=="/") {
			/* parameter group or broken up linear form	*/
			group = usubstr(group,2,ustrlen(group)-1)
			pC = lookup_component((group,name))
		}
		if (pC == NULL) {
			group = eq
			pC = lookup_component((eq,name))
		}
		if (pC == NULL) {
			set_errmsg(sprintf("%s scaling parameter {bf:%s:%s} " +
				"not found",LATENT_VARIABLE,group,name))
			rc = 111
			break
		}
		if (pC->type() != `SUBEXPR_LV_PARAM') {
			/* programmer error				*/
			set_errmsg(sprintf("expected {bf:%s:%s} to be a " +
				"%s but got a %s",group,name,
				`SUBEXPR_STR_LV_PARAM',pC->stype()))
			rc = 499
			break
		}
		if (pC->group() != eq) {
			/* group:name created at parse time to retain
			 *  @ value					*/
			(void)remove_component(pC)
			/* check that (eq,name) already exists
			 *  should have been created in 
			 *  __sub_expr_eq::post_resolve()		*/
			pC1 = lookup_component((eq,name))
			if (pC1 == NULL) {
				pC->set_group(eq)
				if (rc=add_component(pC)) {
					break
				}
			}
			else if (pC != pC1) {
				val1 = pC1->data(`SUBEXPR_HINT_VALUE')
				/* saved value from parsed @#		*/
				val = pC->data(`SUBEXPR_HINT_VALUE')
				if (val!=param_default_value() &
					val1==param_default_value()) {
					(void)pC1->update(val,
						`SUBEXPR_HINT_VALUE')
				}
				fixed = pC->data(`SUBEXPR_HINT_FIXED_PARAM')
				(void)pC1->update(fixed,
					`SUBEXPR_HINT_FIXED_PARAM')
				pLV = pE->component()
				(void)pLV->update(pC,
					`SUBEXPR_HINT_REMOVE_PARAM')
			}
			pC = pC1 = NULL
		}
		Next: pE = pE->next()
	}
	pE = NULL
	pG = NULL
	pC = NULL
	pC1 = NULL
	pLV = NULL

	return(rc)
}

real scalar __sub_expr::resolve_replace_LC_param(
		pointer (class __sub_expr_group) scalar pSE,
		string scalar oldn, string scalar newn)
{
	real scalar rc
	string scalar group
	pointer (class __component_base) scalar pCo, pCn, pC
	pointer (class __sub_expr_elem) scalar pE

	pragma unset pCn

	group = pSE->name()
	pCo = lookup_component((group,oldn))
	if (pCo == NULL) {
		/* should not happen					*/
		set_errmsg(sprintf("object {bf:%s:%s} not found",group,oldn))
		return(111)
	}
	if (rc=register_component(newn,group,`SUBEXPR_LC_PARAM',pCn)) {
		pCo = NULL
		pCn = NULL
		return(rc)
	}
	pE = pSE->first()
	while(pE) {
		pC = pE->component()
		if (pC == pCo) {
			if (rc=pE->set_component(pCn)) {
				break
			}
		}
		pE = pE->next()
	}
	pE = NULL
	pC = NULL
	pCn = NULL
	pCo = NULL

	return(rc)
}

real scalar __sub_expr::resolve_param_group(
			pointer (class __component_group) scalar pG)
{
	real scalar i, k, rc
	string scalar group
	string vector key
	pointer (class __component_group) scalar pG1
	pointer (class __sub_expr_group) scalar pSE

	rc = 0
	key = pG->key()
	group = key[2]
	if (usubstr(group,1,1)==`SUBEXPR_PARAM_GROUP') {
		/* should not happen					*/
		return(0)		// nothing to do
	}
	pG1 = lookup_component(key)
	if (pG1 != pG) {
		pG1 = NULL
		/* programmer error					*/
		set_errmsg(sprintf("multiple instances of group {bf:%s:} exist",
			pG->name()))
		return(110)
	}
	pG1 = NULL
	/* remove 'group' from asarray					*/
	(void)remove_component(pG)

	key[2] = "/" + key[2]
	pG1 = lookup_component(key)
	group = key[2]
	if (pG1 != NULL) {
		pG1 = NULL
		set_errmsg(sprintf("multiple instances of group {bf:%s:} exist",
			group))
		return(110)
	}
	/* new group							*/
	pG->set_name(group) 
	/* add to `/group' asarray					*/
	if (rc=add_component(pG)) {
		return(rc)
	}
	/* rename components of the group: group:name -> /group:name	*/
	k = pG->group_count()
	for (i=1; i<=k; i++) {
		pSE = pG->get_object(i)
		if (rc=resolve_param_expr_group(pSE)) {
			break
		}
	}
	pSE = NULL

	return(rc)
}

real scalar __sub_expr::resolve_param_expr_group(
			pointer (class __sub_expr_group) scalar pSE)
{
	real scalar rc, i, kfv, type, gtype, noisily, omit
	real scalar nofv, fatal
	string scalar name, group, group1
	pointer (class __component_base) scalar pC, pC1
	pointer (class __component_param) vector pFV
	pointer (class __sub_expr_elem) scalar pE

	/* rename components of the group: group:name -> /group:name	*/
	gtype = pSE->group_type()
	group = __sub_expr_name_no_slash(pSE->name())
	rc = 0
	pE = pSE->first()
	while (pE != NULL) {
		pC = pE->component()
		if (pC == NULL) {
			/* string expression				*/
			pE = pE->next()
			continue
		}
		type = pC->type()
		name = pC->name()
		fatal = `SUBEXPR_FALSE'
		if (type == `SUBEXPR_MATRIX') {
			/* check for a matrix parameter			*/
			group1 = __sub_expr_name_no_slash(pC->group())
			fatal = (group1!=group)
		}
		else if (type!=`SUBEXPR_LC_PARAM' & type!=`SUBEXPR_FV' &
			type!=`SUBEXPR_PARAM' & type!=`SUBEXPR_LV') {
			fatal = `SUBEXPR_TRUE'
		}
		if (fatal) {
			/* programmer error				*/
			set_errmsg(sprintf("%s object {bf:%s} found in a %s; " +
				"this should not happen",pC->stype(),pC->name(),
				pSE->sgroup_type()))
			rc = 119
			break
		}
		if (gtype == `SUBEXPR_GROUP_LC') {
			if (type == `SUBEXPR_PARAM') {
				if (!missing(_st_varindex(name))) {
					/* convert component		*/
					type = `SUBEXPR_LC_PARAM'
					(void)pC->update(type,
						`SUBEXPR_HINT_PARAMTYPE')
				}
				else if (name != "_cons") {
					rc = 109
				}
			}
		}
		else if (gtype == `SUBEXPR_GROUP_PARAM') {
			if (type==`SUBEXPR_LC_PARAM' | type==`SUBEXPR_FV') {
				rc = 109
			}
			else if (type==`SUBEXPR_PARAM' & 
				(i=ustrpos(name,"."))) {
				rc = 498
				if (m_application == SPECIAL_APP_BAYES) {
					/* TS ops allowed on free param	*/
					noisily = `SUBEXPR_FALSE'
					omit = `SUBEXPR_FALSE'
					nofv = `SUBEXPR_TRUE'
					rc = ::_msparse(name,omit,noisily,nofv)
				}
				if (rc) {
					set_errmsg(sprintf("invalid free " +
						"parameter specification " +
						"{bf:%s:%s}; operator " +
						"{bf:%s} not allowed",group,
						name,usubstr(name,1,i)))
					break
				}
			}
		}
		if (rc) {
			set_errmsg(sprintf("attempting to include %s {bf:%s} " +
				"into %s {bf:%s}; this is not allowed",
				pC->stype(),pC->name(),pSE->sgroup_type(),
				group))
			break
		}
		pC1 = pC
		if (rc=resolve_param_component(pC)) {
			break
		}
		if (pC1 != pC) {
			/* new or existing /group object		*/
			if (rc=pE->set_component(pC)) {
				break
			}
		}
		if (pC->type() == `SUBEXPR_FV') {
			/* update names of the expanded FV components	*/
			pFV = pC->data(`SUBEXPR_HINT_FV')
			kfv = length(pFV)
			(void)pC->update(NULL,`SUBEXPR_HINT_FV_CLEAR')
			for (i=1; i<=kfv; i++) {
				pC1 = pFV[i]
				if (rc=resolve_param_component(pC1)) {
					break
				}
				if (rc=pC->update(pC1,`SUBEXPR_HINT_FV')) {
					set_errmsg(pC->errmsg())
					break
				}
			}
			for (i=1; i<=kfv; i++) {
				pFV[i] = NULL
			}
			pFV = J(1,0,NULL)
		}
		if (rc) {
			break
		}
		pE = pE->next()
	}
	pC = NULL
	pC1 = NULL
	pE = NULL

	return(rc)
}

real scalar __sub_expr::resolve_param_component(
		pointer (class __component_base) scalar pC)
{
	real scalar type, rc
	string vector key
	pointer (class __component_base) scalar pC1

	rc = 0
	key = pC->key()
	pC1 = lookup_component(key)
	if (pC1 != pC) {
		/* programmer error					*/
		set_errmsg(sprintf("multiple instances of {bf:%s:%s}\n",
			pC1->group(),pC1->name()))
		pC1 = NULL
		return(110)
	}
	pC1 = NULL
	if (usubstr(key[1],1,1) == `SUBEXPR_LV_GROUP') {
		/* no conversion required				*/
		return(0)
	}
	if (usubstr(key[1],1,1) == `SUBEXPR_PARAM_GROUP') {
		/* already been converted				*/
		return(0)
	}
	type = pC->type()
	(void)remove_component(pC)
	key[1] = "/" + key[1]
	pC1 = lookup_component(key)
	if (pC1 != NULL) {
		if (pC1->type() != type) {
			set_errmsg(sprintf("conflicting types %s and %s for " +
				"{bf:%s:%s}",pC->stype(),pC1->stype(),key[1],
				key[2]))
			pC1 = NULL
			return(109)
		}
		/* calling program will update the _sub_expr_elem 	*/
		/*  container						*/
		pC = pC1
	}
	else {
		pC->set_group(key[1])
		rc = add_component(pC)
	}
	pC1 = NULL

	return(rc)
}

real scalar __sub_expr::reinit_hierarchy(|string scalar tvar,string scalar gvar)
{
	real scalar rc, ih, dirty

	dirty = m_dirty
	if (!(m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP')) {
		set_errmsg(sprintf("cannot reinitialize the %s hierarchy",
			LATENT_VARIABLE))
		dirty_message()
		return(498)
	}
	ih = m_hierarchy.current_hierarchy_index()
	rc = resolve_lvhierarchy(tvar,gvar)
	if (!rc & ih) {
		rc = m_hierarchy.set_current_hierarchy_index(ih)
	}
	if (rc) {
		set_errmsg(m_hierarchy.errmsg())
	}
	else if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_HIER') {
		/* put back original state flag				*/
		m_dirty = dirty
	}
	return(rc)
}

real scalar __sub_expr::resolve_lvhierarchy(|string scalar tvar,
			string scalar gvar)
{
	real scalar rc, strict_hier, i, k
	string vector Lv
	string scalar Lv1	
	pointer (class __lvpath) scalar tpath
	pointer (class __component_base) scalar pC
	pointer (class __component_lv) scalar pLV

	rc = 0
	m_hierarchy.clear()

	strict_hier = (m_application!=SPECIAL_APP_BAYES)
	pC = iterator_init()
	m_LVs = J(1,0,NULL)
	while (pC != NULL) {
		if (pC->type() != `SUBEXPR_LV') {
			goto Next
		}
		if (!ustrlen(m_touse)) {
			set_errmsg(sprintf("failed to resolve %s hierarchy; " +
				"estimation sample indicator is not set",
				LATENT_VARIABLE))
			rc = 111
			break
		}
		pLV = pC
		tpath = pLV->path_tree()
		if (tpath == NULL) {	//later on : define variable
					// level vs path depending on context
			set_errmsg(sprintf("no level specified for %s {bf:%s}",
				LATENT_VARIABLE,pLV->name()))
			Lv = tokens(LATENT_VARIABLE)
			Lv[1] = strproper(Lv[1])
			Lv =  subinstr(Lv[1]+" "+Lv[2], " ", "-")
			Lv1 = subinstr(LATENT_VARIABLE, " ", "-")
			set_message(sprintf("%s's levels must be specified " +
				"in brackets following the %s's name such " +
				"as {bf:U[id]}, {bf:V[id1>id2]}, etc.",Lv,Lv1))
			rc = 198
			break
		}
		if (rc=m_hierarchy.add_path(tpath,touse(),strict_hier)) {
			set_errmsg(m_hierarchy.errmsg())
			break
		}
		m_LVs = (m_LVs,pLV)

		Next: pC = iterator_next()
	}
	pC = NULL
	pLV = NULL
	if (rc) {
		k = length(m_LVs)
		for (i=1; i<=k; i++) {
			m_LVs[i] = NULL
		}
		m_LVs = J(1,0,NULL)
		return(rc)
	}
	if (rc=m_hierarchy.resolve_paths()) {
		set_errmsg(m_hierarchy.errmsg())
		return(rc)
	}
	if (m_hierarchy.path_count()) {
		/* latent variables in specification, order hierarchy 
		 * by paths e.g. LV1[id1] LV2[id1>id2] ...		*/
		/* sets hierarchy estimation sample			*/
		if (rc=gen_LV_indices()) {
			return(rc)
		}
	}
	else {
		/* need to set hierarchy estimation sample		*/
		m_hierarchy.set_touse(touse())
	}
	if (ustrlen(tvar)) {
		if (missing(st_varindex(tvar))) {
			set_errmsg(sprintf("time variable {bf:%s} not found",
				tvar))
			return(111)
		}
	}
	if (ustrlen(gvar)) {
		if (missing(st_varindex(gvar))) {
			set_errmsg(sprintf("group (panel) variable {bf:%s} " +
				"not found",gvar))
			return(111)
		}
	}
	/* create a sort order vector for each hierarchy or for
	 *  specified group an time variables				*/
	if (rc=m_hierarchy.gen_sort_order(tvar,gvar)) {
		set_errmsg(m_hierarchy.errmsg())
	}
	m_dirty = `SUBEXPR_DIRTY_RESOLVED_HIER'

	return(rc)
}

void __sub_expr_init_RE_struct(struct __RE_vectors scalar RE, real scalar sz)
{
	real scalar i, k

	k = length(RE.b)
	for (i=1; i<=k; i++) {
		RE.b = NULL
	}
	RE.b = J(1,sz,NULL)		// ragged array of RE coefficients
	RE.names = J(1,sz,"")		// LV names associated with m_REb's
	RE.lohi.erase()
}

real scalar __sub_expr::gen_LV_indices()
{
	real scalar i, j, k, ko, rc, kRE, xvar
	string scalar stvar, LVname, subexpr, lo, hi, tlohi
	string matrix stripe
	real vector vlh
	real matrix lohi
	pointer (class __component_lv) scalar pLV
	struct __RE_vectors scalar oRE

	if (m_dirty > `SUBEXPR_DIRTY_PARSED') {
		/* programmer error					*/
		set_errmsg(sprintf("expressions are not resolved; must " +
			"resolve expressions and build %s hierarchy before " +
			"creating %s index vectors",
			LATENT_VARIABLE,LATENT_VARIABLE))
		return(498)
	}
	/* use -egen, group()- to generate RE index vectors containing
	 *  indices into RE parameter vectors				*/
	rc = 0
	if (!(k=length(m_LVs))) {
		return(rc)	// nothing to do
	}
	if (m_application == SPECIAL_APP_MENL) {
		/* Lindstrom & Bates menl application
		 *   -egen group()- single index base on LV path	*/
		if (rc=m_hierarchy.gen_LV_indices(touse())) {
			set_errmsg(m_hierarchy.errmsg())
		}
	}
	else if (m_application == SPECIAL_APP_BAYES) {
		/* Bayes application
		 *   -egen group()- single index base on LV path	*/
		if (rc=m_hierarchy.gen_LV_indices(touse())) {
			set_errmsg(m_hierarchy.errmsg())
		}
	}
	else {	// m_application == SPECIAL_APP_REGRESS
		/* default application
 		 *  -egen group()- single index base on LV path	*/
		if (rc=m_hierarchy.gen_LV_indices(touse())) {
			set_errmsg(m_hierarchy.errmsg())
		}
	}
	if (rc) {
		return(rc)
	}
	oRE = m_RE	// multiple parse: copy old RE coefficients
	ko = length(oRE.b)
	__sub_expr_init_RE_struct(m_RE, k)

	/* update LV's with index variable names			*/
	stripe = J(k,2,"")
	lohi = J(k,2,0)
	tlohi = new_tempname(m_tnames.MATRIX)
	for (i=1; i<=k; i++) {
		pLV = m_LVs[i]
		LVname = pLV->name()
		stripe[i,2] = LVname
		stvar = m_hierarchy.LV_index_stvar(LVname)

		if (!ustrlen(stvar)) {
			/* should not happen				*/
			set_errmsg(sprintf("%s index variable for %s not found",
				LATENT_VARIABLE,LVname))
			pLV = NULL
			return(111) 
		}
		m_RE.names[i] = LVname
		kRE = m_hierarchy.LV_index_count(LVname)
		if (!kRE | missing(kRE)) {
			/* should not happen				*/
			set_errmsg(sprintf("%s {bf:%s} index vector is empty",
				LATENT_VARIABLE,LVname))
			pLV = NULL
			__sub_expr_init_RE_struct(m_RE, 0)
			__sub_expr_init_RE_struct(oRE, 0)
			return(111)
		}
		for (j=1; j<=ko; j++) {
			if (oRE.names[j] == LVname) {
				/* previous parsed eq has LV		*/
				if (length(*(oRE.b[j])) == kRE) {
					/* copy pointer to previous
					 *  values; increments vector
					 *  reference count?		*/
					m_RE.b[i] = oRE.b[j]
				}
				break
			}
		}
		if (m_RE.b[i] == NULL) {
			m_RE.b[i] = &J(1,kRE,0)		// RE coefficients
		}
		vlh = __word_of_mokeyaddr(m_RE.b[i])
		if (vlh[4] != kRE) {
			/* should not happen				*/
			set_errmsg(sprintf("%s {bf:%s} index vector has a " +
				"maximum of %g but the coefficient vector is " +
				"of length %g",LATENT_VARIABLE,LVname,kRE,
				vlh[4]))
			pLV = NULL
			__sub_expr_init_RE_struct(m_RE, 0)
			__sub_expr_init_RE_struct(oRE, 0)
			return(498)
		}
		lohi[i,.] = vlh[|1\2|]
		lo = sprintf("%s[%g,1]",tlohi,i)
		hi = sprintf("%s[%g,2]",tlohi,i)
		xvar = pLV->data(`SUBEXPR_HINT_COVARIATE')
		if (ustrlen(xvar)) {
			if (ustrpos(xvar,"#")) {
				subexpr = sprintf("(%s)*matael(%s,%s,1,%s)",
					xvar,lo,hi,stvar)
			}
			else {
				subexpr = sprintf("%s*matael(%s,%s,1,%s)",
					xvar,lo,hi,stvar)
			}
		}
		else {
			subexpr = sprintf("matael(%s,%s,1,%s)",lo,hi,stvar)
		}
		(void)pLV->update(stvar,`SUBEXPR_HINT_TNAME')
		(void)pLV->update(subexpr,`SUBEXPR_HINT_SUBEXPR')
	}
	pLV = NULL
	if (ko) {
		__sub_expr_init_RE_struct(oRE, 0)
	}
	if (rc=m_RE.lohi.set_matrix(lohi,tlohi)) {
		set_errmsg(m_RE.lohi.errmsg())
		__sub_expr_init_RE_struct(m_RE, 0)
	}
	(void)m_RE.lohi.set_rowstripe(stripe)

	return(rc)
}

real scalar __sub_expr::register_equation(string scalar name, 
		pointer (class __sub_expr_group) scalar pE, real scalar gtype)
{
	real scalar rc, i, k, gtype0
	pointer (class __component_group) scalar pC
	pointer (class __sub_expr_group) scalar pG

	rc = 0
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',name))
	if (pC != NULL) {
		if (m_application != SPECIAL_APP_BAYES) {
			gtype0 = pC->group_type()
			if (gtype0==`SUBEXPR_EQ_LC' | 
				gtype0==`SUBEXPR_EQ_EXPRESSION') {
				rc = 110
			}
			else {
				k = pC->group_count()
				for (i=1; i<=k; i++) {
					pG = pC->get_object(i)
					if (pG->first() != NULL) {
						/* expression already 
						 * defined		*/
						rc = 110
						break
					}
				}
			}
			pG = NULL
			if (rc) {
				set_errmsg(sprintf("attempting to create " +
					"equation {bf:%s}, but a %s exists " +
					"with the same name; this is not " +
					"allowed",name,pC->sgroup_type()))
				return(rc)
			}
		}
		else {
			if (!remove_component(pC)) {
				/* Bayes allows redefining an equation	*/
				set_errmsg(sprintf("failed to remove " + 
					"existing %s {bf:%s} so that it " +
					"can be redefined",pC->sgroup_type(),
					name))
				rc = 498
				return(rc)
			}
			pC = NULL
		}
		
	}
	if (pC == NULL) {
		pC = &__component_group(1)
		pC->set_name(name)
		pC->set_group(`SUBEXPR_GROUP_SYMBOL')
	}
	if (rc=pC->set_group_type(gtype)) {
		set_errmsg(pC->errmsg())
		return(rc)
	}
	if (k=pC->group_count()) {
		if (k > 1) {
			set_errmsg(sprintf("multiple instances of equation " +
				"{bf:%s} exist; this is not allwed",pC->name()))
			return(489)
		}
		pE = pC->get_object(1)
		if (pE->first() != NULL) {
			/* equation already defined			*/
			pE = NULL
			set_errmsg(sprintf("attempting to create equation " +
					"{bf:%s}, but a %s exists with the " +
					"same name; this is not allowed",name,
					pC->sgroup_type()))
			return(110)
		}
	}
	else {
		pE = new_group()
		pE->set_dataobj(&this)
		if (rc=add_component(pC)) {
			return(rc)
		}
		if (rc=pE->set_component(pC)) {	
			return(rc)
		}
	}
	pC = NULL

	return(rc)
}

real scalar __sub_expr::register_group(string scalar group, 
		pointer (class __sub_expr_group) scalar pSE,
		|real scalar gtype)
{
	real scalar rc, gtype0
	string scalar name, name0
	pointer (class __component_group) scalar pC

	pSE = NULL
	name = group
	if (usubstr(name,1,1) == "/") {
		name = usubstr(name,2,ustrlen(name)-1)
	}
	if (args() < 3) {
		gtype = `SUBEXPR_UNDEFINED'
	}
	rc = 0
	gtype0 = `SUBEXPR_UNDEFINED'
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',name))
	if (pC == NULL) {
		if (m_application == SPECIAL_APP_BAYES) {
			/* allows repetitive parse/resolve operations
			 *  may be already marked as a free parameter
			 *  group					*/
			name0 = "/"+name
			pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',name0))
			if (pC != NULL) {
				name = name0
			}
		}
		if (pC == NULL) { 
			pC = &__component_group(1)
			pC->set_name(name)
			pC->set_group(`SUBEXPR_GROUP_SYMBOL')
		}
	}
	else {
		if (pC->type() != `SUBEXPR_GROUP') {
			set_errmsg(sprintf("attempting to create a group " +
				"named {bf:%s} but a %s exists with that name",
				group,pC->sgroup_type()))
			pC = NULL
			return(110)
		}
		gtype0 = pC->group_type()
		if (gtype0==`SUBEXPR_EQ_EXPRESSION' | gtype0==`SUBEXPR_EQ_LC') {
			set_errmsg(sprintf("attempting to create a group " +
				"named {bf:%s} but a %s exists with that name",
				group,pC->sgroup_type()))
			pC = NULL
			return(110)
		}
		else if (gtype!=`SUBEXPR_UNDEFINED' & 
			gtype0!=`SUBEXPR_UNDEFINED') {
			if (gtype0==`SUBEXPR_GROUP_EXPRESSION' & 
				gtype==`SUBEXPR_GROUP_LC') {
				rc = 110
			}
			if (gtype==`SUBEXPR_GROUP_EXPRESSION' & 
				gtype0==`SUBEXPR_GROUP_LC') {
				rc = 110
			}
			if (rc) {
				set_errmsg(sprintf("attempting to create a " +
					"%s named {bf:%s} but a %s exists " +
					"with that name",
					pC->m_sgroup_types[gtype],group,
					pC->sgroup_type()))
				pC = NULL
				return(rc)
			}
		}
	}
	if (args()>2 & gtype0==`SUBEXPR_UNDEFINED') {
		/* new group or referenced in earlier parse		*/
		if (rc=pC->set_group_type(gtype)) {
			set_errmsg(pC->errmsg())
			pC = NULL
			return(rc)
		}
	}
	pSE = new_group()
	pSE->set_dataobj(&this)
	if (!(rc=add_component(pC))) {	// no harm if already exists
		rc = pSE->set_component(pC)
	}
	pC = NULL

	return(rc)
}

real scalar __sub_expr::_msparse(string scalar name)
{
	real scalar k, rc, omit, noisily, nofv, bn
	string scalar op, name0

	noisily = nofv = omit = 0
	
	bn = 0
	if (k=ustrpos(name,".")) {
		op = usubstr(name,1,k-1)
		/* prevent 1bn.f morphing to 1.f
		 * component name is use in st_matrix() and we do not 
		 * want st_matrix() to force a base column		*/
		bn = (ustrpos(op,"bn")>0)
	}
	name0 = name
	/* _msparse will morph i1.f to 1.f, c.x to c.x, 1bn.f to 1.f	*/
	if (rc=::_msparse(name,omit,noisily,nofv)) {
		set_errmsg(sprintf("invalid name {bf:%s}",name0))
		return(rc)
	}
	if (bn) {
		k = ustrpos(name,".")
		op = usubstr(name,1,k-1)
		name = op + "bn" + usubstr(name,k,ustrlen(name))
	}
	return(0)
}

real scalar __sub_expr::register_component(string scalar name,
			string scalar group, real scalar type, 
			pointer (class __component_base) scalar pC,
			|real scalar existed)
{
	real scalar rc, type0
	string scalar name0
	pointer (class __component_base) scalar pC0

	existed = `SUBEXPR_FALSE'
	pC = NULL
	if (type == `SUBEXPR_VARIABLE') {
		pC = &__component_var(1)
		if (rc=_msparse(name)) {
		 	/* ignore error? 
			 * may not be in matrix stripe form		*/
			return(rc)
		}
	}
	else if (type == `SUBEXPR_LV') {
		pC = &__component_lv(1)
	}
	else if (type == `SUBEXPR_PARAM') {
		pC = &__component_param(1)
	}
	else if (type==`SUBEXPR_LC_PARAM' | type==`SUBEXPR_FV' | 
			type==`SUBEXPR_FV_PARAM' | type==`SUBEXPR_LV_PARAM') {
		pC = &__component_param(1)
		rc = pC->update(type,`SUBEXPR_HINT_PARAMTYPE')
		if (rc) {
			set_errmsg(pC->errmsg())
			return(rc)
		}
		if (type != `SUBEXPR_FV') {
			if (rc=_msparse(name,)) {
				return(rc)
			}
		}
	}
	else if (type == `SUBEXPR_MATRIX') {
		pC = &__component_matrix(1)
	}
	else if (type == `SUBEXPR_UNDEFINED') {
		pC = &__component_base(1)
	}
	else {
		/* programmer error					*/
		set_errmsg(sprintf("invalid component object type: index %g",
			type))
		return(498)
	}
	pC0 = lookup_component((group,name))
	if (pC0 == NULL) {
		if (ustrlen(group)) {
			pC->set_group(group)
		}
		pC->set_name(name)
		rc = add_component(pC)
		return(rc)
	}
	type0 = pC0->type()
	if (type == type0) {
		existed = `SUBEXPR_TRUE'
		pC = pC0
		pC0 = NULL
		return(0)
	}
	if (type0==`SUBEXPR_PARAM' & type==`SUBEXPR_LC_PARAM') {
		/* parameters can morph to LC parameters		*/
		if (rc=pC0->update(type,`SUBEXPR_HINT_PARAMTYPE')) {
			set_errmsg(pC->errmsg())
			return(rc)
		}
		existed = `SUBEXPR_TRUE'
		pC = pC0
		pC0 = NULL
		return(0)
	}
	if (type0==`SUBEXPR_LC_PARAM' & type==`SUBEXPR_PARAM') {
		/* LC parameter with this name already exists		*/
		existed = `SUBEXPR_TRUE'
		pC = pC0
		pC0 = NULL
		return(0)
	}
	if (type0 == `SUBEXPR_GROUP') {
		name0 = pC0->name()
	}
	else {
		name0 = sprintf("%s:%s",pC0->group(),pC0->name())	
	}
	set_errmsg(sprintf("attempting to redefine %s object {bf:%s} to " +
		"a %s object; this is not allowed",pC0->stype(),name0,
		pC->stype()))
	pC0 = NULL

	return(110)
}

real scalar __sub_expr::add_component(
			pointer (class __component_base) scalar pC)
{
	string vector key
	pointer (class __component_base) scalar pC1
	pointer (class __component_group) scalar pCG, pCG1

	key = pC->key()

	pC1 = lookup_component(key)
	if (pC1 == NULL) {
		asarray(m_C, key, pC)
		return(0)
	}
	else if (pC1 == pC) {
		pC1 = NULL
		return(0)
	}
	if (pC1->isequal(pC)) {
		pC = pC1
		pC1 = NULL
		return(0)
	}
	if (pC1->type() == `SUBEXPR_GROUP') {
		if (pC->type() == `SUBEXPR_GROUP') {
			/* can only have one group object with this
			 * name						*/
			pC = pC1
			pC1 = NULL
			return(0)
		}
		pCG = pC
		pCG1 = pC1
		set_errmsg(sprintf("group {bf:%s:} has multiple " + 
			"definitions: '%s' and '%s'",pCG1->name(),
			pCG1->sgroup_type(),pCG->sgroup_type()))
	}
	else {
		set_errmsg(sprintf("object {bf:%s:%s} has multiple " + 
			"definitions: '%s' and '%s'",pC1->group(),pC1->name(),
			pC1->stype(),pC->stype()))
	}
	pCG = pCG1 = NULL
	pC1 = NULL

	return(110)
}

real scalar __sub_expr::remove_component(
			pointer (class __component_base) scalar pC)
{
	string vector key
	pointer (class __component_base) scalar pC1

	key = pC->key()
	pC1 = lookup_component(key)
	if (pC1 == pC) {
		asarray_remove(m_C,key)
		pC1 = NULL
		return(`SUBEXPR_TRUE')
	}
	else {
		add_warning(sprintf("two objects with the same key exist: " +
			"{bf:%s:%s}",key[1],key[2]))
	}
	pC1 = NULL

	return(`SUBEXPR_FALSE')
}

pointer (class __component_base) scalar __sub_expr::lookup_component(
			string vector key)
{
	pointer (class __component_base) scalar pC

	pC = asarray(m_C,key)

	return(pC)
}

pointer (class __component_group) scalar __sub_expr::lookup_expression(
			string scalar name)
{
	real scalar gtype, islc, isex
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG

	pG = NULL
	if (!ustrlen(name)) {
		return(pG)
	}
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',name))
	if (pC == NULL) {
		if (usubstr(name,1,1) != "/") {
			name = "/"+name
			pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',name))
		}
	}
	if (pC == NULL) {
		set_errmsg(sprintf("expression {bf:%s} not found",name))
		pC = NULL
		error_and_exit(111)	// back hole
	}
	if (pC->type() != `SUBEXPR_GROUP') {
		set_errmsg(sprintf("object {bf:%s} is not an expression",name))
		pC = NULL
		error_and_exit(109)	// back hole
	}
	pG = pC
	pC = NULL
	gtype = pG->group_type()
	islc = (gtype==`SUBEXPR_GROUP_LC' | gtype==`SUBEXPR_EQ_LC')
	isex = (gtype==`SUBEXPR_GROUP_EXPRESSION' |
		gtype==`SUBEXPR_EQ_EXPRESSION')
	if (!islc & !isex) {
		set_errmsg(sprintf("object {bf:%s} is not an expression " +
				"or a linear combination",name))
		pG = NULL
		error_and_exit(109)	// back hole
	}
	return(pG)
}

real scalar __sub_expr::remove_group(
			pointer (class __sub_expr_group) scalar pSE)
{
	if (pSE->next()!=NULL | pSE->prev()!=NULL) {
		/* programmer error					*/
		set_errmsg(sprintf("attempting to remove sub-expression " +
			"{bf:%s} that is a component of an expression",
			pSE->name()))
		return(498)
	}
	pSE->clear()

	return(0)
}

/* parse left hand side of =						*/
real scalar __sub_expr::parse_depvars(string scalar expr,
			string vector depvars)
{
	real scalar k, i
	string scalar var, eq
	transmorphic te

	te = tokeninit("","=",("{}"))
	tokenset(te, expr)

	depvars = ustrtrim(tokenget(te))
	if (depvars == "=") {
		set_errmsg("dependent variable(s) required on the left " +
			"hand side of the {bf:=}")
		return(198)
	}
	eq = ustrtrim(tokenget(te))
	if (eq != "=") {
		m_equations = J(1,0,"")
		return(0)
	}
	expr = ustrtrim(tokenrest(te))

	depvars = tokens(depvars)
	k = length(depvars)
	for (i=1; i<=k; i++) {
		var = depvars[i]
		if (ustrpos(var, ".")) {
			set_errmsg(sprintf("invalid specification {bf:%s}: " +
				"operators are not allowed on the left hand " +
				"side of the equals sign",var))
			return(198)
		}
		if (!__sub_expr_isvariable(var)) {  // unabbreviate
			set_errmsg(sprintf("dependent variable {bf:%s} not " +
				"found", depvars[i]))
			return(111)
		}
		depvars[i] = var
	}
	return(0)
}

void __sub_expr::set_parameters(transmorphic vals, |transmorphic option)
{
	real scalar rc

	if (args() > 1) {
		rc = _set_parameters(vals,option)
	}
	else {
		rc = _set_parameters(vals)
	}
	if (rc) {
		error_and_exit(rc)	// back hole
	}
}

real scalar __sub_expr::_set_parameters(transmorphic vals,
			|transmorphic spec)
{
	real scalar rc

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		set_errmsg("parameter vector is not ready to be initialized")
		dirty_message()	// add error specifics
		return(301)
	}
	if (isreal(vals)) {
		/* real vector b					*/
		if (args() > 1) {
			if (isstring(spec)) {
				/* spec is a stripe matrix or equation
				 *  name				*/
				rc = set_param_by_stripe(vals,spec)
			}
			else {
				set_errmsg(sprintf("expected a stripe matrix" +
					"but got %s",eltype(spec)))
				rc = 498
			}
		}
		else {
			/* copy						*/
			rc = set_param_from_vec(vals)
		}
	}
	else if (isstring(vals)) {
		/* string scalar init, real scalar skip			*/
		if (args() > 1) {
			rc = set_param_from_spec(vals,spec[1,1])
		}
		else {
			rc = set_param_from_spec(vals)
		}
	}
	else {
		set_errmsg("invalid parameter initialization; argument " +
			"must be a real vector or a string")
		rc = 498
	}
	return(rc)
}

real scalar __sub_expr::set_param_from_spec(string scalar init, 
			|real scalar skip)
{
	real scalar rc
	string scalar errmsg
	real rowvector b
	string matrix stripe

	pragma unset errmsg

	skip = (missing(skip)?`SUBEXPR_FALSE':(skip!=`SUBEXPR_FALSE'))
	b = m_param.m()
	stripe = m_param.colstripe()
	rc = _parse_initial_vector(init,b,stripe,skip,errmsg)
	if (rc) {
		set_errmsg(errmsg)
		return(rc)
	}
	(void)m_param.set_matrix(b)

	return(0)
}

real scalar __sub_expr::set_param_from_vec(real vector b)
{
	real scalar rc, kp

	kp = m_param.cols()
	if (kp != length(b)) {
		set_errmsg(sprintf("failed to initialize parameter vector; " +
			"expected a vector of length %g but got %g",
			kp,length(b)))
		return(503)
	}
	if (kp) {
		if (rows(b) == 1) {
			rc = m_param.set_matrix(b)
		}
		else {
			rc = m_param.set_matrix(b')
		}
	}
	return(rc)
}

real scalar __sub_expr::set_param_by_stripe(real vector b, string matrix spec)
{
	real scalar rc

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		set_errmsg("parameter vector is not ready to be initialized")
		dirty_message()	// specifics

		return(301)
	}
	rc = 0
	if (rows(b) == 1) {
		rc = m_param.set_coefficients(b,spec)
	}
	else {
		rc = m_param.set_coefficients(b',spec)
	}
	if (rc) {
		set_errmsg(sprintf("failed to initialize parameter vector: " +
			"%s",m_param.errmsg()))
	}
	return(rc)
}

real scalar __sub_expr::set_param_by_index(real vector b, real vector index)
{
	real scalar rc

	if (rows(b) == 1) {
		rc = m_param.set_coefficients(b,index)
	}
	else {
		rc = m_param.set_coefficients(b',index)
	}
	if (rc) {
		set_errmsg(sprintf("failed to initialize parameter vector: " +
			"%s",m_param.errmsg()))
	}
	return(rc)
}

void __sub_expr::set_LV_parameters(real vector b, string scalar LVname)
{
	real scalar rc

	rc = _set_LV_parameters(b,LVname)
	if (rc) {
		error_and_exit(rc)	// back hole
	}
}

real scalar __sub_expr::_set_LV_parameters(real vector b, string scalar LVname)
{
	real scalar i, k
	real vector in

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		set_errmsg("random effects parameter vector is not ready " +
			"to be initialized")
		dirty_message() 	// specifics

		return(301)
	}
	if (!ustrlen(LVname)) {
		set_errmsg(sprintf("initializing %s vector failed; %s name " +
			"is required",LATENT_VARIABLE,LATENT_VARIABLE))
		return(198)
	}
	k = length(m_RE.b)
	if (!k) {
		set_errmsg(sprintf("initializing %s vector failed; no %s",
			LATENT_VARIABLE,LATENT_VARIABLE))
		return(198)
	}
	in = (LVname:==m_RE.names)
	if (!any(in)) {
		set_errmsg(sprintf("initializing %s vector failed; %s " +
			"{bf:%s} not found",LATENT_VARIABLE,LATENT_VARIABLE,
			LVname))
		return(111)
	}
	i = selectindex(in)[1]
	if ((k=length(*m_RE.b[i])) != length(b)) {
		set_errmsg(sprintf("initializing random effects vector " +
			"failed; %s {bf:%s} requires a vector of length %g " +
			"but got %g",LATENT_VARIABLE,LVname,k,length(b)))
		return(503)
	}
	/* DO NOT change the address of the *m_RE.b[i] vector
	 *  the address of *m_RE.b[i], stored in m_RE.hilo[i,.], is used
	 *  in Stata function matael() when evaluating the expressions	*/
	if (rows(b) == 1) {
		(*m_RE.b[i])[.] = b
	}
	else {
		(*m_RE.b[i])[.] = b'
	}
	return(0)
}

string matrix __sub_expr::param_stripe(|string scalar eq0)
{
	real colvector io
	string scalar eq
	string matrix stripe, stripe0
	pointer (class __component_group) scalar pC

	eq = eq0
	stripe = m_param.colstripe()
	if (!rows(stripe)) {
		return(stripe)
	}
	if (!ustrlen(eq)) {
		return(stripe)
	}
	stripe0 = J(0,2,"")
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',eq))
        if (pC == NULL) {
		if (usubstr(eq,1,1) != "/") {
			eq = "/"+eq
			pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',eq))
		}
	}
	if (pC == NULL) {
		return(stripe0)
	}
	io = strmatch(stripe[.,1],eq)
	if (any(io)) {
		io = selectindex(io)
		stripe0 = stripe[io,.]
	}
	return(stripe0)
}

class __stmatrix scalar __sub_expr::stparameters()
{
	return(m_param)
}

real rowvector __sub_expr::parameters()
{
	real scalar k
	real rowvector b

	/* must save in matrix before return				*/
	k = m_param.cols()
	if (k) {
		b = m_param.m()
	}
	else {
		b = J(1,0,0)
	}
	return(b)
}

real rowvector __sub_expr::LV_parameters(string scalar LVname)
{
	real scalar i, k
	real vector in

	if (!(m_dirty<=`SUBEXPR_DIRTY_RESOLVED_EXP')) {
		return(J(1,0,0))
	}
	k = length(m_RE.b)
	if (!k) {
		return(J(1,0,0))
	}
	in = (LVname:==m_RE.names)
	if (!any(in)) {
		set_errmsg(sprintf("RE parameter vector for %s {bf:%s} not " +
			"found",LATENT_VARIABLE,LVname))
		return(J(1,0,0))
	}
	i = selectindex(in)[1]

	return(*m_RE.b[i])
}

real rowvector __sub_expr::fixed_parameters(|string matrix stripe)
{
	real scalar i, k, fix
	real rowvector fixed
	string vector key
	pointer (class __component_base) scalar pC

	stripe = J(0,2,"")
	fixed = J(1,0,0)
	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		/* must resolve expressions				*/
		add_warning("must resolve expressions before determining " +
			"fixed/free parameters")
		return(fixed)
	}
	if (!(k=m_param.cols())) {
		return(fixed)
	}
	stripe = m_param.colstripe()
	fixed = J(1,k,0)
	for (i=1; i<=k; i++) {
		key = stripe[i,.]
		pC = lookup_component(key)
		fix = `SUBEXPR_FALSE'
		if (pC == NULL) {
			/* huh?	should not happen			*/
			add_warning(sprintf("could not find component for " +
				"{bf:%s:%s}",key[1],key[2]))
			continue
		}
		fix = pC->data(`SUBEXPR_HINT_FIXED_PARAM')
		if (!missing(fix)) {
			fixed[i] = fix
		}
	}
	return(fixed)		
}

class __stmatrix __sub_expr::stfixed_parameters()
{
	real rowvector fixed
	string matrix stripe
	class __stmatrix scalar stfixed

	pragma unset stripe

	fixed = fixed_parameters(stripe)

	(void)stfixed.set_matrix(fixed)
	(void)stfixed.set_colstripe(stripe)

	return(stfixed)
}

pointer (class __lvhierarchy) scalar __sub_expr::hierarchy()
{
	return(&m_hierarchy)
}

real scalar __sub_expr::hier_count()
{
	return(m_hierarchy.hier_count())
}

pointer (struct _lvhinfo) scalar __sub_expr::hier_info(real scalar ih)
{
	if (ih<1 | ih>hier_count()) {
		return(NULL)
	}
	return(m_hierarchy.hinfo(ih))
}

string vector __sub_expr::hier_paths(real scalar ih)
{
	return(m_hierarchy.hier_paths(ih))
}

string vector __sub_expr::hier_LVs(real scalar ih)
{
	return(m_hierarchy.hier_LVs(ih))
}

string vector __sub_expr::param_names(|string scalar group)
{
	real scalar i, k
	string vector params
	string matrix stripe

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		add_warning("must resolve expressions before querying the " +
			"parameter names")
		return(J(1,0,""))
	}
	group = ustrtrim(group)
	stripe = m_param.colstripe()
	if (ustrlen(group)) {
		stripe = select(stripe,stripe[.,1]:==group)
	}
	k = rows(stripe)
	params = J(1,k,"")
	for (i=1; i<=k; i++) {
		params[i] = invtokens(stripe[i,.],":")
	}
	return(params)
}

void __sub_expr_decompose_name(string name, string group)
{
	real scalar i, k

	group = ""
	if (i=ustrpos(name,":")) {
		k = ustrlen(name)
		if (i < k) {
			group = usubstr(name,1,i-1)
			k = k-i
			name = usubstr(name,i+1,k)
		}
	}
}

real scalar __sub_expr::_set_LVnames(string vector LVnames)
{
	real scalar rc, allcaps

	allcaps = `SUBEXPR_ALLCAPS'
	if (rc=_lvset(LVnames,allcaps)) {
		set_errmsg(sprintf("one or more of the %s names {bf:%s} are " +
			"invalid",LATENT_VARIABLE,invtokens(LVnames)))
	}
	return(rc)
}

real colvector __sub_expr::path_index_vector(string scalar spath,
			|string scalar exname)
{
	real scalar rc
	class __lvpath scalar path

	/* returns the -egen group()- generated vector			*/
	if (!ustrlen(spath)) {
		return(J(0,1,0))
	}
	if (!m_hierarchy.path_count()) {
		return(J(0,1,0))
	}
	if (rc=path.init("__temp",spath)) {
		set_errmsg(sprintf("invalid path {bf:%s}: %s",spath,
				path.errmsg()))
		error_and_exit(rc)	// back hole
	}
	return(m_hierarchy.path_index_vector(path,touse(exname)))
}

real colvector __sub_expr::LV_index_vector(string scalar LVname,
			|string scalar exname)
{
	if (!ustrlen(LVname)) {
		return(J(1,0,0))
	}
	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		set_errmsg(sprintf("index vector for %s %s does not exist",
			LATENT_VARIABLE,LVname))
		dirty_message()	// specifics

		exit(498)
	}
	/* vector is a st_view						*/
	return(m_hierarchy.LV_index_vector(LVname,touse(exname)))
}

string scalar __sub_expr::LV_path(string scalar LV)
{
	real scalar i, k
	string vector LVs
	string matrix paths

	LV = ustrtrim(LV)
	paths = m_hierarchy.paths()
	k = rows(paths)
	for (i=1; i<=k; i++) {
		LVs = tokens(paths[i,`HIERARCHY_LV_NAMES'])
		if (any(strmatch(LVs,LV))) {
			return(paths[i,`HIERARCHY_PATH'])
		}
	}
	return("")	
}

string scalar __sub_expr::LV_covariate(string scalar LV)
{
	string scalar covariate
	pointer (class __component_base) scalar pC

	covariate = ""
	pC = lookup_component((`SUBEXPR_LV_GROUP',LV))
	if (pC != NULL) {
		covariate = pC->data(`SUBEXPR_HINT_COVARIATE')
	}
	pC = NULL

	return(covariate)
}

real scalar __sub_expr::path_hierarchy_index(string scalar spath)
{
	real scalar ih
	class __lvpath scalar path

	path.init("__tmp",spath)
	ih = m_hierarchy.path_hierarchy_index(path)

	return(ih)
}

real colvector __sub_expr::path_sort_order(string scalar spath)
{
	real scalar rc, ih
	real colvector order
	class __lvpath scalar path

	pragma unset order

	/* returns the sort order for the hierarchy containing spath
	 *  must resolve hierarchy first				*/
	if (!ustrlen(spath)) {
		return(J(0,1,0))
	}
	if (!m_hierarchy.path_count()) {
		return(J(0,1,0))
	}
	if (rc=path.init("__temp",spath)) {
		set_errmsg(sprintf("invalid path {bf:%s}: %s",spath,
			path.errmsg()))
		error_and_exit(rc)	// back hole
	}
	if (!(ih=m_hierarchy.path_hierarchy_index(path))) {
		set_errmsg("no hierarchy contains path {bf:%s}",path.path())
		error_and_exit(498)	// back hole
	}
	if (rc=_hierarchy_sort_order(ih,order)) {
		error_and_exit(rc)	// back hole
	}
	return(order)
}

real scalar __sub_expr::_hierarchy_sort_order(real scalar ih,
			real colvector order)
{
	real scalar rc

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_HIER') {
		set_errmsg(sprintf("%s hierarchy has not been resolved",
			LATENT_VARIABLE))
		return(498)
	}
	if (rc=m_hierarchy.set_current_hierarchy_index(ih)) {
		set_errmsg(m_hierarchy.errmsg())
		return(rc)
	}
	order = m_hierarchy.current_sort_order()
	if (!length(order)) {
		/* nothing to sort on					*/
		return(0)
	}
	order = invorder(order)

	return(0)
}

real matrix __sub_expr::gen_hierarchy_panel_info(real scalar ih,
			|string scalar exname)
{
	real scalar rc, nooutput, ivar
	real colvector order
	string scalar cmd, vord

	pragma unset order

	/* Stata data will be sorted by ::_hierarchy_sort_order()	*/
	m_hierarchy.set_current_hierarchy_index(ih)
	if (rc=_hierarchy_sort_order(ih,order)) {
		return(rc)
	}
	if (length(order)) {	// something to sort on
		nooutput = `SUBEXPR_TRUE'
		vord = st_tempname()
		ivar = st_addvar("long",vord)
		st_store(.,vord,touse(),order)
		cmd = sprintf("sort %s",vord)
		if (rc=_stata(cmd,nooutput)) {
			set_errmsg("data could not be sorted; execution " +
				"cannot proceed")
			error_and_exit(rc)	// back hole
		}
		st_dropvar(ivar)
	}
	if (rc=_gen_hierarchy_panel_info(exname)) {
		error_and_exit(rc)	// back hole
	}
	return(m_hierarchy.current_panel_info())
}

real scalar __sub_expr::_gen_hierarchy_panel_info(|string scalar exname,
			string vector path)
{
	real scalar rc
	string scalar path0, group

	pragma unset path0
	pragma unset group

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_HIER') {
		set_errmsg(sprintf("%s hierarchy has not been resolved",
			LATENT_VARIABLE))
		return(498)
	}
	/* assumption: Stata data is sorted by ::hierarchy_sort_order()	*/
	/* generate panel and panel info for each level of the current
	 *  hierarchy							*/
	if (rc=m_hierarchy.gen_current_panel_info(touse(exname),path0,group)) {
		set_errmsg(m_hierarchy.errmsg())
	}
	if (ustrlen(group)) {
		path = (path0,group)
	}
	else {
		path = (path0)
	}
	return(rc)
}

real scalar __sub_expr::_hierarchy_panel_vector(real colvector panels)
{
	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_HIER') {
		set_errmsg(sprintf("%s hierarchy has not been resolved",
			LATENT_VARIABLE))
		return(498)
	}
	/*  assumption: generated panel information using 
	 *  ::_gen_hierarchy_panel_info()				*/
	panels = m_hierarchy.current_panel_vector()

	return(0)
}

real scalar __sub_expr::_hierarchy_panel_info(real matrix pinfo)
{
	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		set_errmsg(sprintf("%s hierarchy has not been resolved",
			LATENT_VARIABLE))
		return(498)
	}
	/*  assumption: generated panel information using 
	 *  ::_gen_hierarchy_panel_info()				*/
	pinfo = m_hierarchy.current_panel_info()

	return(0)
}

void __sub_expr::display_equations()
{
	real scalar i, k, lev
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		set_errmsg("cannot display equations")
		dirty_message()	// specifics
		error_and_exit(498)	// back hole
	}
	lev = 0
	printf("{txt}\n\nSubstitutable equations\n")
	k = length(m_equations)
	for (i=1; i<=k; i++) {
		pG = lookup_component((`SUBEXPR_GROUP_SYMBOL',m_equations[i]))
		if (pG->group_count()) {	// should be 1
			pSE = get_defined_expr(pG)
			pSE->pt_display()
			pSE->display(lev)
			printf("{hline 78}\n")
		}
	}
	m_hierarchy.display()
	pG = NULL
	pSE = NULL
}

void __sub_expr::display_expressions()
{
	real scalar lev, gtype
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		set_errmsg("cannot display expressions")
		dirty_message()	// specifics
		error_and_exit(498)	// back hole
	}
	pC = iterator_init()
	printf("{txt}\n\nSubstitutable expressions")
	while (pC != NULL) {
		if (pC->type() != `SUBEXPR_GROUP') {
			goto Next
		}
		pG = pC
		pC = NULL
		gtype = pG->group_type()
		if ((gtype!=`SUBEXPR_GROUP_EXPRESSION') & 
			(gtype != `SUBEXPR_GROUP_LC')) {
			goto Next
		}
		pSE = get_defined_expr(pG)
		if (pSE == NULL) {
			/* should not happen				*/
			set_errmsg(sprintf("named expression {bf:%s} is empty",
				pG->name()))
			pG = NULL
			error_and_exit(111)	// black hole
		}
		printf("\n")
		lev = 0
		pSE->pt_display()
		pSE->display(lev)
		printf("{hline 78}\n")
		Next: pC = iterator_next()
	}
	pG = NULL
	pSE = NULL
	m_hierarchy.display()
}

void __sub_expr::dump_components()
{
	real scalar n, i, type, tn
	string scalar fmt, name, group, top, tname
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG

	tn = 1
	fmt = "{res}%g{col 8}%s{col 20}%s{col 38}%s{col 58}%s{col 75}%g\n"
	n = asarray_elements(m_C)
	printf("{txt}\nComponents container contains %g elements\n",n)
	i = 0
	top = "\n{txt}{ul on}object{col 8}group{col 20}name{col 38}" +
		"type{col 58}tempname{col 75}ref{ul off}\n"
	printf(top)
	pC = iterator_init()
	while (pC != NULL) {
		name = pC->name()
		if (ustrlen(name) > 19) {
			name = usubstr(name,1,18)+"~"
		}
		tname = pC->name(tn)
		group = pC->group()
		if (ustrlen(group) > 19) {
			group = usubstr(group,1,11)+"~"
		}
		type = pC->type()
		if (type == `SUBEXPR_GROUP') {
			pG = pC
			printf(fmt,++i,group,name,pG->sgroup_type(),
				tname,pC->refcount())
			pG = NULL
		}
		else {
			printf(fmt,++i,group,name,pC->stype(),tname,
				pC->refcount())
		}
		pC = iterator_next()
	}
}

string matrix __sub_expr::components()
{
	real scalar n, i
	string scalar group, name
	string matrix C
	pointer (class __component_base) scalar pC

	n = asarray_elements(m_C)
	C = J(n+1,5,"")
	pC = iterator_init()
	i = 1
	C[1,.] =("object","group","name","type","tempname")
	while (pC != NULL) {
		name = pC->name()
		group = pC->group()
		i++
		C[i,.] = (strofreal(i-1),group,name,pC->stype(),pC->subexpr())

		pC = iterator_next()
	}
	return(C)
}

void __sub_expr::cert_post()
{
	real scalar k, i, type, gtype, mxnlen
	string scalar mac, stype, name, name0, group, expr
	string vector vexpr, rnames
	class __stmatrix scalar b
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE

	mxnlen = st_numscalar("c(namelenchar)")
	vexpr = depvars()
	st_rclear()
	if (k=length(vexpr)) {
		if (k > 1) {
			st_global("r(depvars)",invtokens(vexpr," "))
		}
		else {
			st_global("r(depvar)",vexpr[1])
		}
	}
	vexpr = varlist()
	if (k=length(vexpr)) {
		st_global("r(varlist)",invtokens(vexpr," "))
	}
	vexpr = latentvars()
	if (k=length(vexpr)) {
		st_global("r(latentvars)",invtokens(vexpr," "))
	}
	rnames = J(1,0,"")
	k = 0
	pC = iterator_init()
	while (pC != NULL) {
		name = pC->name()
		type = pC->type()
		stype = pC->stype()

		if (type != `SUBEXPR_MATRIX') {
			if (type==`SUBEXPR_LC_PARAM' | 
				type==`SUBEXPR_PARAM' |
				type==`SUBEXPR_VARIABLE' |
				type==`SUBEXPR_FV' |
				type==`SUBEXPR_FV_PARAM' |
				type==`SUBEXPR_LV_PARAM') {
				name = subinstr(name,".","_")
				name = subinstr(name,"#","_")
				name = subinstr(name,"(","_")
				name = subinstr(name,")","_")
				name = subinstr(name," ","_")
				if (!missing(strtoreal(usubstr(name,1,1)))) {
					name = "_" + name
				}
			}
			group = pC->group()
			if (group == `SUBEXPR_VAR_GROUP') {
				group = "var"
			}
			else if (group == `SUBEXPR_LV_GROUP') {
				group = ""
			}
			else if (group == `SUBEXPR_GROUP_SYMBOL') {
				group = ""
				i = ustrlen(name)
				if (usubstr(name,1,1) == "/") {
					if (i == 1) {
						name = "_"
					}
					else {
						name = usubstr(name,2,i-1)
					}
				}
			}
			else {
				i = ustrlen(group)
				if (usubstr(group,1,1) == "/") {
					if (i == 1) {
						group = ""
					}
					else {
						group = usubstr(group,2,i-1)
					}
				}
			}
			if (ustrlen(group)) {
				name = sprintf("%s_%s",group,name)
			}

			if (type == `SUBEXPR_GROUP') {
				pG = pC
				stype = pG->sgroup_type()
				pG = NULL
			}
		}
		if (ustrlen(name) > mxnlen) {
			name = usubstr(name,1,mxnlen)
		}
		if (any(rnames:==name)) {
			name0 = sprintf("%s %s",name,stype)
			if (any(rnames:==name0)) {
				add_warning(sprintf("return name conflict " +
					"for %s {bf:r(%s)}\n",name,stype))
				goto Next
			}
			name = name0
		}

		rnames = (rnames,name)
		mac = sprintf("r(%s)",name)
		st_global(mac,stype)

		Next: k++
		pC = iterator_next()
	}
	st_numscalar("r(k)",k)

	/* named expression and linear combinations (form)		*/
	pC = iterator_init()
	i = 0
	while (pC != NULL) {
		if (pC->type() != `SUBEXPR_GROUP') {
			pC = iterator_next()
			continue
		}
		pG = pC
		gtype = pG->group_type()
		name = pG->name()
		if (usubstr(name,1,1)=="/") {
			k = ustrlen(name)-1
			name = usubstr(name,2,k)
		}
		if (gtype == `SUBEXPR_GROUP_EXPRESSION') {
			st_global(sprintf("r(expr_%s)",name),expression(name))
			pSE = pG->TS_initobj()
			if (pSE != NULL) {
				/* initialization expression		*/
				expr = pSE->traverse_expr(`SUBEXPR_FULL')
				st_global(sprintf("r(init_%s)",name),expr)
			}
		}
		else if (gtype==`SUBEXPR_GROUP_LC') {
			vexpr = linear_combination(name)
			k = length(vexpr)
			if (k == 1) {
				st_global(sprintf("r(lc_%s)",name),vexpr[1])
			}
			else {
				for (i=k; i>=1; i--) {
					st_global(sprintf("r(lc_%s_%g)",
						name,i),vexpr[i])
				}
			}
		}
		pC = iterator_next()
	}
	pG = NULL
	/* equations							*/
	k = length(m_equations)
	for (i=1; i<=k; i++) {
		st_global(sprintf("r(eq_%s)",m_equations[i]),
				equation(m_equations[i]))

		pG = lookup_component((`SUBEXPR_GROUP_SYMBOL',m_equations[i]))
		pSE = pG->TS_initobj()
		if (pSE == NULL) {
			continue	// no initialization expression
		}
		expr = pSE->traverse_expr(`SUBEXPR_FULL')
		st_global(sprintf("r(init_%s)",m_equations[i]),expr)
	}
	if (m_param.cols()) {
		b = stparameters()
		b.st_matrix("r(b)")
	}
}

void __sub_expr::return_post(|real scalar ereturn, string scalar eq)
{
	real scalar k, kg, i, j, idvars, top, nameonly
	string scalar expri, expr, post, re
	string vector vexpr, vlist, tsexpr
	pointer (class __sub_expr_group) scalar pSE
	pointer (class __component_group) scalar pG

	ereturn = (missing(ereturn)?`SUBEXPR_FALSE':(ereturn!=`SUBEXPR_FALSE'))
	if (ereturn) {
		re = "e"
	}
	else {
		re = "r"
	}
	vlist = depvars()
	if (k=length(vlist)) {
		if (k > 1) {
			st_global(sprintf("%s(depvars)",re),
				invtokens(vlist," "))
		}
		else {
			st_global(sprintf("%s(depvar)",re),vlist[1])
		}
	}
	nameonly = `SUBEXPR_TRUE'
	vlist = varlist("",nameonly)
	if (k=length(vlist)) {
		st_global(sprintf("%s(varlist)",re),invtokens(vlist," "))
	}
	vlist = latentvars()
	if (k=length(vlist)) {
		if (m_application == SPECIAL_APP_MENL) {
			st_global(sprintf("%s(revars)",re),invtokens(vlist," "))
		}
		else {
			st_global(sprintf("%s(latentvars)",re),
				invtokens(vlist," "))
		}
	}
	idvars = 1
	vlist = latentvars(idvars)
	if (k=length(vlist)) {
		st_global(sprintf("%s(ivars)",re),invtokens(vlist," "))
	}
	/* expressions							*/
	tsexpr = J(1,0,"")
	vexpr = expr_names()
	k = length(vexpr)
	for (i=k; i>=1; i--) {
		expri = vexpr[i]
		expr = expression(expri)
		if (usubstr(expri,1,1) == "/") {
			j = ustrlen(expri)
			if (j > 1) {
				expri = usubstr(expri,2,j-1)
				vexpr[i] = expri
			}
		}
		post = sprintf("%s(ex_%s)",re,expri)
		j = ustrlen(expr)
		expr = usubstr(expr,2,j-2)	// strip out {}
		if (usubstr(expr,1,1) == "/") {
			j = ustrlen(expr)
			if (j > 1) {
				expr = usubstr(expr,2,j-1)
			}
		}
		st_global(post,expr)

		pG = lookup_expression(expri)
		if (pG == NULL) {
			continue	// should not happen
		}
		pSE = pG->TS_initobj()
		if (pSE == NULL) {
			/* no initialization expression (no recursion);
			 *  check for a TS op on an expression		*/
			kg = pG->group_count()
			for (j=1; j<=kg; j++) {
				pSE = pG->get_object(j)
				if (pSE->has_property(`SUBEXPR_PROP_TS_OP')) {
					tsexpr = (tsexpr,pG->name())
					break
				}
			}
			continue
		}
		top = `SUBEXPR_TRUE'
		expr = pSE->traverse_expr(`SUBEXPR_DISPLAY',top)
		/* expri ts initialization expression 			*/
		post = sprintf("%s(tsinit_%s)",re,expri)
		st_global(post,expr)
		tsexpr = (tsexpr,pG->name())
	}
	st_global(sprintf("%s(expressions)",re),invtokens(sort(vexpr',1)'," "))

	/* equations							*/
	k = length(m_equations)
	for (i=1; i<=k; i++) {
		st_global(sprintf("%s(eq_%s)",re,m_equations[i]),
				equation(m_equations[i],EXPRESSION_CONDENSED))

		pG = lookup_expression(m_equations[i])
		if (pG == NULL) {
			continue	// should not happen
		}
		pSE = pG->TS_initobj()
		if (pSE == NULL) {
			continue	// no initialization expression
		}
		top = `SUBEXPR_TRUE'
		expr = pSE->traverse_expr(`SUBEXPR_DISPLAY',top)
		/* equation ts initialization expression 		*/
		post = sprintf("%s(tsinit_%s)",re,m_equations[i])
		st_global(post,expr)
		tsexpr = (tsexpr,pG->name())
	}
	if (length(tsexpr)) {
		/* list of expressions/equations that have a ts
		 *  initialization expression				*/
		st_global(sprintf("%s(ts_expr)",re),
			invtokens(sort(tsexpr',1)'," "),"hidden")
	}
	m_hierarchy.return_post(ereturn,touse(eq))
}

string scalar _sub_expr_strip_dot_op(string scalar symbol0)
{
	real scalar j, m
	string scalar symbol	

	symbol = symbol0
	if (j=ustrpos(symbol,".")) {
		m = ustrlen(symbol)-j
		symbol = usubstr(symbol,++j,m)
	}
	return(symbol)
}

string vector _sub_expr_varnames(pointer(class __component_base) scalar pC,
			|real scalar nameonly)
{
	real scalar i, k, type
	string scalar covariate
	string vector names, path, hpath, tokens
	class __lvpath scalar lvpath
	transmorphic te

	names = J(1,0,"")
	if (pC == NULL) {
		return(names)
	}
	nameonly = (missing(nameonly)?`SUBEXPR_TRUE':
			(nameonly!=`SUBEXPR_FALSE'))
	type = pC->type()
	path = J(1,0,"")
	covariate = ""
	if (type == `SUBEXPR_VARIABLE') { 
		/* every variable in the expressions has a component	*/
		names = pC->name()
		if (names[1] == "_cons") {
			names = J(1,0,"")
		}
		else if (nameonly) {
			names = _sub_expr_strip_dot_op(names[1])
		}
	}
	else if (type == `SUBEXPR_LV') {
		/* path variables					*/
		hpath = pC->data(`SUBEXPR_HINT_HIERARCHY')
		if (k=length(hpath)) {
			for (i=1; i<=k; i++) {
				path = (path,tokens(hpath[i]))
			}	
			/* check for special symbols, e.g. _n _all	*/
			if (length(lvpath.m_hsyms)) {
				if (any(path[1]:==lvpath.m_hsyms)) {
					path = J(1,0,"")
				}
			}
		}
		/* random slope variable				*/
		covariate = pC->data(`SUBEXPR_HINT_COVARIATE')
		if (length(path)) {
			names = (names,path)
		}
	}
	else if (type == `SUBEXPR_LC_PARAM') {
		covariate = pC->name()
		if (covariate == "_cons") {
			covariate = ""
		}
	}
	else if (type == `SUBEXPR_FV') {
		/* e.g. i.varname or ib1.var1#ib1.var2			*/
		covariate = pC->name()
	}
	else if (type == `SUBEXPR_FV_PARAM') {
		/* e.g. 1.varname or 1.var1#1.var2 etc.			*/
		covariate = pC->name()
	}
	if (ustrlen(covariate)) {
		te = tokeninit("","#")
		tokenset(te,covariate)
		tokens = tokengetall(te)
		for (i=1; i<=length(tokens); i++) {
			if (tokens[i]!="#" & tokens[i]!="_cons") {
				if (nameonly) {
					tokens[i] = _sub_expr_strip_dot_op(
						tokens[i])
				}
				names = (names,tokens[i])
			}
		}
	}
	if (length(names)) {
		names = uniqrows(names')'
	}
	return(names)
}

string vector __sub_expr::expr_varlist(string scalar ename, 
			|real scalar nameonly)
{
	real scalar i, k
	string vector vlist, names
	pointer (class __component_group) scalar pC
	pointer (class __sub_expr_group) scalar pG

	nameonly = (missing(nameonly)?`SUBEXPR_TRUE':
		(nameonly!=`SUBEXPR_FALSE'))

	vlist = J(1,0,"")
	if (!ustrlen(ename)) {
		return(vlist)
	}
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',ename))
	if (pC == NULL) {
		return(vlist)
	}
	if (pC->group_type() == `SUBEXPR_GROUP_PARAM') {
		pC = NULL
		return(vlist)
	}
	k = pC->group_count()
	for (i=1; i<=k; i++) {
		pG = pC->get_object(i)
		names = pG->varlist(nameonly)
		if (length(names)) {
			vlist = uniqrows((vlist,names)')'
		}
	}
	pC = NULL
	pG = NULL
	if (length(vlist)) {
		vlist = sort(vlist',1)'
	}
	return(vlist)
}

string vector __sub_expr::varlist(|string scalar ename, real scalar nameonly)
{
	string vector vlist, names
	pointer (class __component_base) scalar pC

	nameonly = (missing(nameonly)?`SUBEXPR_TRUE':
		(nameonly!=`SUBEXPR_FALSE'))

	if (ustrlen(ename)) {
		return(expr_varlist(ename,nameonly))
	}
	vlist = J(1,0,"")
	/* variable names only, exclude TS & factor operators		*/
	pC = iterator_init()
	vlist = J(1,0,"")
	while (pC != NULL) {
		names = _sub_expr_varnames(pC,nameonly)
		if (length(names)) {
			vlist = uniqrows((vlist,names)')'
		}
		pC = iterator_next()
	}
	if (length(vlist)) {
		vlist = sort(vlist',1)'
	}
	return(vlist)
}

string vector __sub_expr::depvars()
{
	real scalar i, k
	string vector vlist

	vlist = J(1,0,"")
	k = length(m_equations)
	for (i=1; i<=k; i++) {
		if (__sub_expr_isvariable(m_equations[i])) {
			vlist = (vlist,m_equations[i])
		}
	}
	return(vlist)
}

string vector __sub_expr::expr_latentvars(string scalar expr)
{
	real scalar i, k, type
	string scalar name
	string vector vlist, vlist1
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pG
	pointer (class __component_group) scalar pC

	vlist = J(1,0,"")
	if (!ustrlen(expr)) {
		return(vlist)
	}
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',expr))
	if (pC == NULL) {
		return(vlist)
	}
	k = pC->group_count()
	for (i=1; i<=k; i++) {
		pG = pC->get_object(i)
		pE = pG->first()
		while (pE != NULL) {
			type = pE->type()
			if (type == `SUBEXPR_GROUP') {
				name = pE->name()
				if (name != expr) {	// block inf recursion
					vlist1 = expr_latentvars(name)
					vlist = (vlist,vlist1)
				}
			}
			else if (pE->type() == `SUBEXPR_LV') {
				vlist = (vlist,pE->name())
			}
			
			pE = pE->next()
		}
	}
	pC = NULL
	pE = NULL

	return(vlist)
}

string vector __sub_expr::latentvars(|real scalar idvars)
{
	real scalar i, k, type
	string scalar vars
	string vector vlist, v
	pointer (class __component_base) scalar pC

	idvars = (missing(idvars)?0:(idvars!=0))
	k = 1
	vlist = J(1,0,"")
	pC = iterator_init()
	while (pC != NULL) {
		type = pC->type()
		if (type != `SUBEXPR_LV') {
			goto Next
		}
		if (idvars) {
			v = J(1,0,"")
			vars = pC->data(`SUBEXPR_HINT_VARLIST')
			if (ustrlen(vars)) {
				v = tokens(vars)
			}
			k = length(v)
		}
		else {
			v = pC->name()
		}
		for (i=1; i<=k; i++) {
			if (!any(v[i]:==vlist)) {
				/* should all be unique		*/
				vlist = (vlist,v[i])
			}
		}
		Next: pC = iterator_next()
	}
	vlist = sort(vlist',1)'

	return(vlist)
}

string vector __sub_expr::eq_names()
{
	return(m_equations)
}

void __sub_expr::set_multi_eq_on()
{
	m_multi_eq = `SUBEXPR_TRUE'
}

real scalar __sub_expr::has_multi_eq()
{
	if (missing(m_multi_eq)) {
		m_multi_eq = (length(m_equations)>1)
	}
	return(m_multi_eq)
}

void __sub_expr::set_base_eq(string scalar eq)
{
	m_base_eq = eq		// do not check any(m_equations:==eq)
}

string scalar __sub_expr::base_eq()
{
	return(m_base_eq)
}

real scalar __sub_expr::_TS_recursive(
		pointer (class __sub_expr_group) scalar pSE, 
		string vector names)
{
	real scalar recur
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_elem) scalar pE

	recur = `SUBEXPR_FALSE'

	if (pSE == NULL) {
		return(recur)
	}
	pG = pSE->component()
	if (pG->eval_status() == `SUBEXPR_EVAL_TS_RECURSIVE') {
		pG = NULL
		return(recur)
	}
	pG->set_eval_status(`SUBEXPR_EVAL_TS_RECURSIVE')
	if (recur=pG->TS_init_req()) {
		names = (names,pG->name())
	}
	pE = pSE->first()
	while (pE != NULL) {
		if (pE->type() == `SUBEXPR_GROUP') {
			recur = recur | _TS_recursive(pE,names)
		}
		pE = pE->next()
	}
	Exit:
	pG->set_eval_status(`SUBEXPR_EVAL_IDLE')
	pE = NULL
	pG = NULL
	names = uniqrows(names')'

	return(recur)
}

real scalar __sub_expr::TS_recursive(string scalar expr,
		|string vector names, 
		pointer (class __sub_expr_group) scalar pSE1)
{
	real scalar recur, i, k
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE

	pSE1 = (args()>2?pSE1:NULL)
	recur = `SUBEXPR_FALSE'
	names = J(1,0,"")
	pG = lookup_component((`SUBEXPR_GROUP_SYMBOL',expr))
	if (pG == NULL) {
		goto Exit
	}
	if (_sub_expr_count_evaluable_expr(pG) > 1) {
		goto Exit
	}
	if (recur=pG->TS_init_req()) {
		names = pG->name()
	}
	k = pG->group_count()
	for (i=1; i<=k; i++) {
		pSE = pG->get_object(i)
		recur = recur | _TS_recursive(pSE,names)
	}
	Exit:
	pSE = NULL
	pG = NULL

	return(recur)
}

real vector __sub_expr::_TS_order(
		pointer (class __sub_expr_group) scalar pSE)
{
	real vector order, order1
	pointer (class __sub_expr_elem) scalar pE

	order = J(1,3,0)
	if (pSE == NULL) {
		return(order)
	}
	order = pSE->TS_order()
	pE = pSE->first()
	while (pE != NULL) {
		if (pE->type() == `SUBEXPR_GROUP') {
			order1 = pE->data(`SUBEXPR_HINT_TS_ORDER')
			order[1] = max((order[1],order1[1]))
			order[2] = max((order[2],order1[2]))
			order[3] = max((order[3],order1[3]))
		}
		pE = pE->next()
	}
	return(order)
}

real vector __sub_expr::TS_order(string scalar exname)
{
	real scalar i, k
	real vector order, order1
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE

	order = J(1,3,0)
	pG = lookup_component((`SUBEXPR_GROUP_SYMBOL',exname))
	if (pG == NULL) {
		return(order)
	}
	k = pG->group_count()
	for (i=1; i<=k; i++) {
		pSE = pG->get_object(i)
		if (pSE->first() != NULL) {
			/* evaluatable					*/
			order1 = _TS_order(pSE) 
			order[1] = max((order[1],order1[1]))
			order[2] = max((order[2],order1[2]))
			order[3] = max((order[3],order1[3]))
		}
	}
	pSE = NULL
	pG = NULL

	return(order)
}

string scalar __sub_expr::equation(|transmorphic eq, real scalar hint)
{
	real scalar k, ieq
	real vector jeq
	string scalar expr, seq
	pointer (class __component_group) scalar pC
	pointer (class __sub_expr_group) scalar pE

	k = length(m_equations)
	if (args()) {
		if (isreal(eq)) {
			ieq = eq
		}
		else if (isstring(eq)) {
			seq = eq
			jeq = (seq:==m_equations)
			if (!any(jeq)) {
				set_errmsg(sprintf("equation {bf:%s} not found",
					seq))
				error_and_exit(111)	// black hole
			}
			if (k > 1) {
				ieq = select(1..k,jeq)[1]
			}
			else {
				ieq = 1
			}
		}
	}
	else {
		ieq = 1
	}
	if (ieq<1 | ieq>k) {
		set_errmsg(sprintf("invalid equation number %g",ieq))
		error_and_exit(111)	// black hole
	}
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',m_equations[ieq]))
	pE = get_defined_expr(pC)
	pC = NULL
	if (pE == NULL) {
		/* should not happen					*/
		set_errmsg(sprintf("equation %g not found",ieq))
		error_and_exit(111)	// black hole
	}
	hint = (missing(hint)?EXPRESSION_FULL:hint)
	if (hint!=EXPRESSION_FULL & hint!=EXPRESSION_CONDENSED &
		hint!=EXPRESSION_SUBSTITUTED) {
		set_errmsg("expression hint must be " +
			"__sub_expr::EXPRESSION_FULL, " +
			"__sub_expr::EXPRESSION_CONDENSED, or " +
			"__sub_expr::EXPRESSION_SUBSTITUTED")
		error_and_exit(198)	// black hole
	}
	expr = pE->traverse_expr(hint)

	return(expr)
}

string vector __sub_expr::expr_names(|real scalar nolincom)
{
	real scalar type, gtype
	string scalar name
	string vector names
	pointer (class __component_base) scalar pC
	pointer (class __component_group) scalar pG

	nolincom = (missing(nolincom)?`SUBEXPR_FALSE':
		(nolincom!=`SUBEXPR_FALSE'))
	pC = iterator_init()
	names = J(1,0,"")
	while (pC != NULL) {
		type = pC->type()
		if (type == `SUBEXPR_GROUP') {
			pG = pC
			gtype = pG->group_type()
			if (nolincom == `SUBEXPR_TRUE') {
				if (gtype==`SUBEXPR_GROUP_EXPRESSION') {
					name = pG->name()
					if (!any(name:==names)) {
						names= (names,pC->name())
					}
				}
			}
			else {
				if (gtype==`SUBEXPR_GROUP_EXPRESSION' |
					gtype==`SUBEXPR_GROUP_LC') {
					name = pG->name()
					if (!any(name:==names)) {
						names= (names,pC->name())
					}
				}
			}
			pG = NULL
		}
		pC = iterator_next()
	}
	return(names)
}

string scalar __sub_expr::expression(scalar which, |real scalar hint)
{
	real scalar ie, top
	string scalar name, expr, ty
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSE

	ty = eltype(which)
	if (ty == "real") {
		ie = which
	}
	else if (ty == "string") {
		name = which
	}
	else {
		set_errmsg("expression identifier must be a name or an index")
		error_and_exit(198)	// black hole
	}
	hint =(missing(hint)?EXPRESSION_FULL:hint)
	if (hint!=`SUBEXPR_FULL' & hint!=`SUBEXPR_DISPLAY' & 
		hint!=`SUBEXPR_CONDENSED' & hint!=`SUBEXPR_SUBSTITUTED') {
		set_errmsg("expression hint must be " +
			"__sub_expr::EXPRESSION_FULL, " +
			"__sub_expr::EXPRESSION_CONDENSED, or " +
			"__sub_expr::EXPRESSION_SUBSTITUTED")
		error_and_exit(198)	// black hole
	}
	ie = (missing(ie)?1:ie)
	expr = ""
	pG = lookup_expression(name)
	if (pG == NULL) {
		return(expr)
	}
	pSE = pG->get_object(ie)
	pG = NULL
	if (pSE == NULL) {
		/* should not happen					*/
		set_errmsg(sprintf("expression {bf:%s} at index %g not found",
			name,ie))
		error_and_exit(111)	// black hole
	}
	top = `SUBEXPR_TRUE'  // top level, produce more than {name:}
	expr = pSE->traverse_expr(hint,top)
	pSE = NULL

	return(expr)
}

string vector __sub_expr::linear_combination(name0)
{
	real scalar i, j, k, gtype, equal, unique
	string scalar name
	string vector expr
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __sub_expr_group) scalar pSE

	expr = J(1,0,"")
	name = name0
	pG = lookup_expression(name)
	if (pG == NULL) {
		return(expr)
	}
	gtype = pG->group_type()
	if (gtype != `SUBEXPR_GROUP_LC' & gtype!=`SUBEXPR_EQ_LC') {
		pG = NULL
		return(expr)
	}
	unique = `SUBEXPR_TRUE'
	k = pG->group_count(unique)
	if (k == 1) {
		pSE = get_defined_expr(pG)
		expr = pSE->traverse_expr(`SUBEXPR_FULL')

		return(expr)
	}
	k = pG->group_count()
	for (i=1; i<=k; i++) {
		pSE = pG->get_object(i)

		if (!pSE->isdefined()) {	// before resolving
			continue
		}
		if (pSE->kexpr() == 1) {
			/* check for LC parameter reference		*/
			pE = pSE->first()
			if (pE->info() == `SUBEXPR_PARAM') {
				continue
			}
		}
		equal = 0
		for (j=i-1; j>=1; j--) {
			if (equal=pSE->isequal(pG->get_object(j))) {
				break
			}
		}
		if (!equal) {
			expr = (expr,pSE->traverse_expr(`SUBEXPR_FULL'))
		}
	}
	pSE = NULL
	pG = NULL

	return(expr)
}

pointer (class __sub_expr_group) scalar __sub_expr::get_defined_expr(
			pointer (class __component_group) scalar pG)
{
	real scalar i, k
	pointer (class __sub_expr_group) scalar pSE

	/* return first defined expression
	 *  can reference a lagged equation or expression within an
	 *  equation or in an expression
	 *  lagged expressions have no m_first and m_last (not defined),
	 *  but have a m_next (contained in an expression)		*/
	k = pG->group_count()
	for (i=1; i<=k; i++) {
		pSE = pG->get_object(i)
		if (pSE->isdefined()) {
			/* has m_first and m_last			*/
			return(pSE)
		}
	}
	return(NULL)
}

void __sub_expr::mark_dirty(pointer (class __sub_expr_group) scalar pSE,
			|string vector marked)
{
	real scalar j, k, inst, debug
	string scalar key
	pointer (class __sub_expr_group) scalar pSE1
	pointer (class __sub_expr_group) vector dep

	if (debug=(args()>1)) {
		marked = J(1,0,"")
	}
	pSE->mark_dirty()
	key = pSE->name()
	inst = pSE->instance()
	if (!missing(inst)) {
		key = sprintf("%s@%g",key,inst)
	}
	if (debug) {
		marked = (marked,key)
	}
	dep = m_exprdep.get(key)
	k = length(dep)
	for (j=1; j<=k; j++) {
		pSE1 = dep[j]
		if (pSE1 == m_nodep) {
			break
		}
		pSE1->mark_dirty()
		if (debug) {
			key = pSE1->name()
			inst = pSE->instance()
			if (!missing(inst)) {
				key = sprintf("%s@%g",key,inst)
			}
			marked = (marked,key)
		}
	}
	pSE1 = NULL
	for (j=1; j<=k; j++) {
		dep[j] = NULL
	}
	dep = J(1,0,NULL)
	if (debug) {
		marked = uniqrows(marked')'
	}
}

real colvector __sub_expr::eval_equation(|string scalar eq)
{
	real scalar rc
	real colvector yhat

	pragma unset yhat

	if (rc=_eval_equation(yhat,eq)) {
		error_and_exit(rc)	// black hole
	}
	return(yhat)
}

void __sub_expr::update_dirty_ready()
{
	/* generic behavior						*/
	if (m_dirty <= `SUBEXPR_DIRTY_RESOLVED_EXP') {
		m_dirty = `SUBEXPR_DIRTY_READY'
	}
}

/* subclass error handling						*/
void __sub_expr::error_code(real scalar ec, |transmorphic arg1, 
		transmorphic arg2, transmorphic arg3, transmorphic arg4,
		transmorphic arg5)
{
	pragma unused ec
	pragma unused arg1
	pragma unused arg2
	pragma unused arg3
	pragma unused arg4
	pragma unused arg5
}

real scalar __sub_expr::_eval_equation(real colvector yhat, |string scalar eq,
			real scalar all)
{
	real scalar k, ieq, rc, lhstype
	real vector jeq
	string scalar touse
	pointer (class __component_group) scalar pC
	pointer (class __sub_expr_group) scalar pE

	update_dirty_ready()
	if (m_dirty != `SUBEXPR_DIRTY_READY') {
		set_errmsg("not in the proper state to evaluate an equation")
		dirty_message()	// specifics
		return(322)
	}
	ieq = 1
	if (ustrlen(eq)) {
		jeq = (eq:==m_equations)
		if (!any(jeq)) {
			set_errmsg(sprintf("equation %s not found",eq))
			return(111)
		}
		k = length(m_equations)
		ieq = select(1..k,jeq)[1]
	}
	lhstype = `SUBEXPR_EVAL_VECTOR'
	pC = lookup_component((`SUBEXPR_GROUP_SYMBOL',m_equations[ieq]))
	pE = get_defined_expr(pC)	// can only be one equation in group
	pC = NULL
	if (rc=_evaluate(pE,lhstype)) {
		pE = NULL
		return(rc)
	}
	/* equation can have its own estimation sample indicator	*/
	all = (missing(all)?`SUBEXPR_FALSE':(all!=`SUBEXPR_FALSE'))
	if (all) {
		touse = touse()
	}
	else {
		touse = pE->touse()
	}
	/* result cached in Stata tempvar m_tlhs; assign to LHS		*/
	yhat = st_data(.,m_tlhs[m_ilhs],touse)
	pE = NULL

	return(0)
}

real matrix __sub_expr::eval_expression(string scalar ex)
{
	real scalar rc
	real matrix result

	pragma unset result

	if (rc=_eval_expression(result,ex)) {
		error_and_exit(rc)	// black hole
	}
	return(result)
}

real scalar __sub_expr::_eval_expression(real matrix result, string scalar ex,
			|real scalar all)
{
	real scalar rc, lhstype
	string scalar touse
	pointer (class __sub_expr_group) scalar pE

	pragma unset pE

	update_dirty_ready()
	if (m_dirty != `SUBEXPR_DIRTY_READY') {
		set_errmsg("not in the proper state to evaluate an expression")
		dirty_message()	// specifics
		return(322)
	}
	if (rc=_get_group(ex,pE)) {
		return(rc)
	}
	lhstype = `SUBEXPR_EVAL_NULL'
	if (rc=_evaluate(pE,lhstype)) {
		pE = NULL
		return(rc)
	}
	if (lhstype == `SUBEXPR_EVAL_NULL') {
		/* should not happen					*/
		set_errmsg(sprintf("failed to evaluate expression/equation " +
			"{bf:%s}",pE->name()))
		/* original user expression before parsing		*/
		m_message = pE->expression()
		pE = NULL
		return(498)
	}
	if (lhstype == `SUBEXPR_EVAL_VECTOR') {
		/* expression can have its own estimation sample
		 * indicator						*/
		all = (missing(all)?`SUBEXPR_FALSE':(all!=`SUBEXPR_FALSE'))
		if (all) {
			touse = touse()
		}
		else {
			touse = pE->touse()
		}
		/* result cached in Stata tempvar m_tlhs; assign to LHS	*/
		if (ustrlen(touse)) {
			result = st_data(.,m_tlhs[m_ilhs],touse)
		}
		else {
			result = st_data(.,m_tlhs[m_ilhs])
		}
	}
	else if (lhstype == `SUBEXPR_EVAL_MATRIX') {
		result = st_matrix(m_tlhs[m_ilhs])
	}
	else {	// SUBEXPR_EVAL_SCALAR
		result = st_numscalar(m_tlhs[m_ilhs])
	}
	pE = NULL

	return(0)
}

real scalar __sub_expr::_evaluate(pointer (class __sub_expr_group) scalar pE,
			real scalar lhstype)
{
	real scalar rc, nooutput, eval
	string scalar expr, expr0, gen

	pragma unset expr

	if (m_dirty != `SUBEXPR_DIRTY_READY') {
		set_errmsg("not in the proper state to evaluate an expression")
		dirty_message()	// specifics

		return(322)
	}
	m_param.st_matrix_ns()
	if (length(m_RE.b)) {
		m_RE.lohi.st_matrix_ns()
	}

	if (lhstype == `SUBEXPR_EVAL_NULL') {
		lhstype = pE->lhstype()
	}
	if (m_trace == `SUBEXPR_ON') {
		printf("\n{bf:%s} {txt}evaluation trace:\n",pE->name())
	}
	/* mark all downward dependencies dirty so they evaluate once	*/
	mark_dirty(pE)
	if (rc=pE->_evaluate(expr)) {
		return(rc)
	}
	/* check if it is a single tempvar, expression is a LC		*/
	if (missing(_st_varindex(expr))) {
		m_ilhs = `SUBEXPR_LHS_OWN'
		/* Stata evaluated expression				*/
		eval = `SUBEXPR_TRUE'
		expr0 = expr
		while (eval) {
			if (lhstype==`SUBEXPR_EVAL_SCALAR' |
				lhstype==`SUBEXPR_EVAL_NULL') {
				expr = sprintf("scalar %s = %s",m_tlhs[m_ilhs],
					expr0)
				lhstype = `SUBEXPR_EVAL_SCALAR'
			}
			else if (lhstype == `SUBEXPR_EVAL_MATRIX') {
				expr = sprintf("matrix %s = %s",m_tlhs[m_ilhs],
					expr0)
			}
			else if (lhstype == `SUBEXPR_EVAL_VECTOR') {
				if (missing(_st_varindex(m_tlhs[m_ilhs]))) {
					gen = "gen double"
				}
				else {
					gen = "replace"
				}
				expr = sprintf("%s %s = %s if %s",gen,
					m_tlhs[m_ilhs],expr0,pE->touse())
			}
			else {	
				/* expression does not evaluate to
				 *  anything				*/
				set_errmsg(sprintf("expression {bf:%s} is " +
					"poorly specified",pE->name()))
				return(498)
			}
			if (m_trace == `SUBEXPR_ON') {
				printf("\n{txt}__sub_expr: {bf:%s}\n",expr)
			}
			/* do not show Stata output, it will involve
			 *  tempnames					*/
			nooutput = `SUBEXPR_TRUE'	// output
			rc = _stata(expr,nooutput)
			if (rc) {
				if (lhstype == `SUBEXPR_EVAL_SCALAR') {
					if (rc == 109) {
						lhstype = `SUBEXPR_EVAL_MATRIX'
						rc = 0
					}
				}
				else if (lhstype == `SUBEXPR_EVAL_MATRIX') {
					lhstype = `SUBEXPR_EVAL_VECTOR'
					rc = 0
				}
				if (rc) {
					set_errmsg(sprintf("failed to " +
						"evaluate expression {bf:%s}",
						pE->name()))
					/* original user expression
					 *  before parsing		*/
					m_message = pE->expression()
					return(rc)
				}
			}
			else {
				eval = `SUBEXPR_FALSE'
			}
		}
	}
	else {
		/* linear combination LHS				*/
		m_ilhs = `SUBEXPR_LHS_SHARED'
		m_tlhs[m_ilhs] = expr	// expr is a tempvar
		lhstype = `SUBEXPR_EVAL_VECTOR'
	}
	return(0)
}

string scalar __sub_expr::errmsg()
{
	return(m_errmsg)
}

string scalar __sub_expr::message()
{
	return(m_message)
}

void __sub_expr::set_errmsg(string scalar errmsg)
{
	m_errmsg = errmsg
}

void __sub_expr::set_message(string scalar message)
{
	m_message = message
}

string vector __sub_expr::warnings()
{
	return(m_warnings)
}

void __sub_expr::add_warning(string scalar warning)
{
	/* top warning is most recent					*/
	m_warnings = (warning\m_warnings)
}

void __sub_expr::clear_warnings()
{
	m_warnings = J(0,1,"")
}

real scalar __sub_expr::warning_count()
{
	return(length(m_warnings))
}

void __sub_expr::set_special(transmorphic spec, real scalar hint)
{
	if (hint == SPECIAL_HIERARCHY_SYMBOLS) {
		/* save special symbols allowed in LV[..] hierarchy
		 *  specification					*/
		if (isstring(spec)) {
			m_lvtree.m_hsyms = spec
		}
		return
	}
	if (hint == SPECIAL_APP_REGRESS) {
		m_application = hint
	}
	if (hint == SPECIAL_APP_MENL) {
		LATENT_VARIABLE = "random effect"
		m_lvtree.LATENT_VARIABLE = LATENT_VARIABLE
		m_application = hint
	}
	if (hint == SPECIAL_APP_BAYES) {
		m_application = hint
		m_lvtree.m_hsyms = ("_n","_all")
		m_param_default_val = .
	}
}

real scalar __sub_expr::make_param_vec()
{
	real scalar i, k, type, rc
	real rowvector b
	string scalar subexpr
	string vector key
	string matrix stripe
	pointer (class __component_base) scalar pC

	pragma unset stripe

	m_param.erase()
	if (rc = make_param_stripe(stripe)) {
		return(rc)
	}
	k = rows(stripe)
	if (!k) {
		return(0)
	}
	(void)m_param.set_name(new_tempname(m_tnames.MATRIX))
	b = J(1,k,0)

	for (i=1; i<=k; i++) {
		key = stripe[i,.]
		pC = lookup_component(key)
		if (pC == NULL) {
			/* should not happen				*/
			set_errmsg(sprintf("component %s:%s not found",key[1],
				key[2]))
			return(111)
		}
		type = pC->type()
		if (type!=`SUBEXPR_PARAM' & type!=`SUBEXPR_LC_PARAM' &
			type!=`SUBEXPR_FV_PARAM' & type!=`SUBEXPR_LV_PARAM') {
			/* should not happen				*/
			set_errmsg(sprintf("component {bf:%s:%s} is of type " +
				"%s, but free parameter, LC parameter, FV " +
				"parameter, or LV parameter expected\n",key[1],
				key[2],pC->stype()))
			pC = NULL
			return(109)
		}
		/* initial values stored from parsing expression	*/
		b[i] = pC->data(`SUBEXPR_HINT_VALUE')
		/* substitutable parameter element			*/
		subexpr = sprintf("%s[1,%g]",m_param.name(),i)
		(void)pC->update(subexpr,`SUBEXPR_HINT_SUBEXPR')
		(void)pC->update(i,`SUBEXPR_HINT_COEF_INDEX')
	}
	pC = NULL
	(void)m_param.set_matrix(b)
	(void)m_param.set_colstripe(stripe)
	if (length(m_equations) == 1) {
		(void)m_param.set_rowstripe(("",m_equations[1]))
	}
	return(0)
}

real scalar __sub_expr::make_param_stripe(string matrix stripe)
{
	real scalar i, j, k, kg, ks, kfv, type, gtype
	real scalar lvparam
	real vector ieq
	real colvector io, ij
	string scalar group, name
	string vector groups, gnames
	string matrix fpstripe, istripe, lvstripe
	pointer (class __component_param) vector params
	pointer (string matrix) vector vstripe
	pointer (class __component_base) scalar pC, pC0
	pointer (class __component_param) vector pFV
	pointer (class __component_group) scalar pG
	pointer (class __sub_expr_group) scalar pSG
	pointer (class __sub_expr_elem) scalar pE

	/* add LV scaling parameters if there is more than one 
	 *  equation							*/
	lvparam = has_multi_eq()

	fpstripe = J(0,2,"")	// stripe for /:param	
	lvstripe = J(0,2,"")	// stripe for eq:LV
	groups = J(1,0,"")
	vstripe = J(1,0,NULL)
	pC = iterator_init()
	while (pC != NULL) {
		type = pC->type()
		group = pC->group()
		if (type==`SUBEXPR_PARAM' & group=="/") {
			/* free parameter with no group			*/
			fpstripe = (fpstripe\(group,pC->name()))
			goto NextC
		}
		if (lvparam & type==`SUBEXPR_LV') {
			params = pC->data(`SUBEXPR_HINT_PARAM_VEC')
			k = length(params)
			for (i=1; i<=k; i++) {
				lvstripe = (lvstripe\
					(params[i]->group(),params[i]->name()))
			}
			goto NextC
		}
		else if (type != `SUBEXPR_GROUP') {
			goto NextC
		}
		group = pC->name()	// group name
		pG = pC
		gtype = pG->group_type()
		if (gtype==`SUBEXPR_GROUP_EXPRESSION' | ///
			gtype==`SUBEXPR_EQ_EXPRESSION') {
			goto NextC
		}
		/* gtype ==`SUBEXPR_GROUP_LC' 
		 * 	  `SUBEXPR_EQ_LC'
		 * 	  `SUBEXPR_GROUP_PARAM'				*/
		gnames = J(1,0,"")
		istripe = J(0,2,"")
		kg = pG->group_count()
		for (i=1; i<=kg; i++) {
			pSG = pG->get_object(i)
			pE = pSG->first()
			while (pE != NULL) {
				name = pE->name()
				type = pE->type()
				if (type == `SUBEXPR_LV') {
					goto NextE
				}
				else if (type ==  `SUBEXPR_MATRIX') {
					goto NextE
				}
				else if (type == `SUBEXPR_EXPRESSION') {
					goto NextE
				}
				if (any(name:==gnames)) {
					goto NextE
				}
				gnames = (gnames,name)
				if (type != `SUBEXPR_FV') {
					istripe = (istripe\(group,name))
					goto NextE
				}
				pC = pE->component()
				/* expand factor variable		*/
				pFV = pC->data(`SUBEXPR_HINT_FV')
				kfv = length(pFV)
				for (j=1; j<=kfv; j++) {
					pC0 = pFV[j]
					istripe = (istripe\(group,pC0->name()))
					pFV[j] = NULL
				}
				pFV = J(1,0,NULL)

				NextE: pE = pE->next()
			}
		}
		if (rows(istripe) == 0) {
			/* all matrix parameters (Bayes)		*/
			goto NextC
		}
		groups = (groups,group)
		ieq = ("_cons":==istripe[.,2])'
		if (any(ieq)) {
			/* put the constant at the end			*/
			ks = rows(istripe)
			j = selectindex(ieq)[1]
			if (j <  ks) {
				if (j == 1) {
					istripe = (istripe[|2,1\ks,2|]\
						istripe[1,.])
				}
				else {
					istripe = (istripe[|1,1\j-1,2|]\
						istripe[|j+1,1\ks,2|]\
						istripe[j,.])
				}
			}
		}
		vstripe = (vstripe,&J(1,1,istripe))

		NextC: pC = iterator_next()
	}
	pC = NULL
	pG = NULL
	pC0 = NULL
	pSG = NULL
	pE = NULL
	if (lvparam=(lvparam & rows(lvstripe))) {
		_sort(lvstripe,(1,2))
	}
	stripe = J(0,2,"")
	if (length(groups)) {
		ieq = order(groups',1)
		ks = length(vstripe)
		for (i=1; i<=ks; i++) {
			istripe = *vstripe[ieq[i]]
			if (!lvparam) {
				goto Append
			}
			k = rows(istripe)
			io = (lvstripe[.,1]:==groups[ieq[i]])
			if (!any(io)) {
				goto Append
			}
			ij = selectindex(io)
			if (istripe[k,2] == "_cons") {
				if (k > 1) {
					istripe = (istripe[|1,1\k-1,2|]\
						lvstripe[ij,.]\istripe[k,.])
				}
				else {
					istripe = (lvstripe[ij,.]\istripe[1,.])
				}
			}
			else {
				istripe = (istripe\lvstripe[ij,.])
			}
			io = 1:-io
			if (any(io)) {
				ij = selectindex(io)
				lvstripe = lvstripe[ij,.]
			}
			else {
				lvstripe = J(0,2,"")
				lvparam = `SUBEXPR_FALSE'
			}
			Append: stripe = (stripe\istripe)
		}
	}
	if (lvparam) {
		/* remaining latent variable parameters			*/
		stripe = (stripe\lvstripe)
	}
	if (rows(fpstripe)) {
		_sort(fpstripe,2)
		stripe = (stripe\fpstripe)
	}
	return(0)
}

/* user access to the components container				*/
pointer (class __component_base) scalar __sub_expr::iterator_init()
{
	pointer (class __component_base) scalar pC

	pC = NULL
	m_loc = asarray_first(m_C)
	if (m_loc != NULL) {
		pC = asarray_contents(m_C,m_loc)
	}
	return(pC)
}

pointer (class __component_base) scalar __sub_expr::iterator_next()
{
	pointer (class __component_base) scalar pC

	pC = NULL
	if (m_loc != NULL) {
		m_loc = asarray_next(m_C,m_loc)
	}
	if (m_loc != NULL) {
		pC = asarray_contents(m_C,m_loc)
	}
	return(pC)
}

real scalar __sub_expr::container_count()
{
	return(asarray_elements(m_C))
}

end
exit

