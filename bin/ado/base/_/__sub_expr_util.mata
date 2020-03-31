*! version 1.1.3  22apr2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile nlparse_macros.matah
quietly include `"`r(fn)'"'

findfile __sub_expr.matah
quietly include `"`r(fn)'"'

/*
 * string scalar __sub_expr_traverse_LC_tree(struct nlparse_node scalar node,
 *		real scalar depth)
 *
 * real scalar __sub_expr_lvparse_convert_LC(string scalar expr)
 *
 * real scalar __sub_expr_lvparse(string scalar vlist, string vector vars,
 *			string matrix lvars)
 *
 * real scalar __sub_expr_isvariable(string scalar var)
 *
 * real scalar __sub_expr_isLVsymbol(string scalar lv)
 *
 * real scalar __sub_expr_islatentvar(string scalar lv, |real scalar strict)
 *
 * real scalar __sub_expr_isstrvar(string scalar varname)
 *
 * real scalar __sub_expr_islinearcomb(string scalar vlist)
 *
 * string vector __sub_expr_linearcomb_vars(string scalar vlist)
 *
 * real scalar __sub_expr_get_options(string scalar expr, string vector options,
 * 			string scalar errmsg)
 *
 * real scalar __sub_expr_parse_options(string scalar sopts, 
 * 			string vector options)
 *
 * real scalar __sub_expr_validate_options(string vector options,
 *			string vector opts, real vector kmin,
 *			string scalar errmsg)
 *
 * real scalar __sub_expr_get_value(string scalar sval)
 *
 * real scalar __sub_expr_name_index(string scalar name, string vector names)
 *
 * string scalar __sub_expr_name_no_slash(string scalar name0)
 *
 * real scalar __sub_expr_validate_var(string scalar varname,
 * 			string scalar errmsg)
 *
 * real scalar __sub_expr_validate_touse(string scalar touse,
 * 			string scalar errmsg, |real scalar existonly)
 *
 * real vector __sub_expr_test_option(string vector options, string scalar opt,
 * 			|real scalar k)
 *
 * real vector __sub_expr_isparam(string scalar expr)
 *
 * real scalar __sub_expr_as_numeric(string scalar snumber)
 *
 * real scalar __sub_expr_prune_TS_op(struct nlparse_node scalar node, 
 * 		struct nlparse_node scalar pnode, real scalar ind)
 *
 * void __sub_expr_drop_TS_op(string scalar name)
 *
*/

mata:

mata set matastrict on

string scalar __sub_expr_traverse_LC_tree(struct nlparse_node scalar node,
		real scalar depth)
{
	real scalar i, k, parenth
	string scalar expr, expri

	k = node.narg
	if (!k) {
		if (node.type == `CONSTANT') {
			/* potential precision loss			*/
			expr = sprintf("%g",node.val)
		}
		else {
			expr = node.symb
		}
		return(expr)
	}
	parenth = `SUBEXPR_FALSE'
	depth++
	if (node.type==`VARLIST' & depth>1) {
		expr = "("
		parenth = `SUBEXPR_TRUE'
	}
	else {
		expr = ""
	}
	for (i=1; i<=k; i++) {
		expri = __sub_expr_traverse_LC_tree(node.arg[i],depth)
		if (i > 1) {
			if (node.type == `OPERATOR') {
				expri = node.symb + expri
			}
			else if (node.type == `PATHOP') {
				if (node.symb != ".") {
					expri = node.symb + expri
				}
			}
		}
		if (!ustrlen(expr)) {
			expr = expri
		}
		else {
			if (node.type == `OPERATOR') {
				expr = expr + expri
			}
			else if (node.type == `PATHOP') {
				expr = expr + expri
			}
			else if (node.type == `VARLIST') {
				if (expr == "(") {
					expr = expr + expri
				}
				else {
					expr = expr + " " + expri
				}
			}
		}
	}
	if (node.type==`FACTOROP' | node.type==`TSOP') {
		expr = node.symb + expr
	}
	else if (node.type == `ATOP') {
		expr = node.symb + expr
	}
	else if (node.type == `LATENTVAR') {
		expr = node.symb + "[" + expr + "]"
		if (strlen(expri) & k>1) {
			expr = expr + expri	// @ operator
		}
	}
	else if (parenth == `SUBEXPR_TRUE') {
		expr = expr + ")"
	}
	depth--
	return(expr)
}

real scalar __sub_expr_stata_LC(struct nlparse_node scalar tree, 
		string scalar errmsg)
{
	real scalar rc, depth
	string scalar expr
	struct nlparse_node scalar node

	if (tree.type!=`LINCOM' | tree.narg!=2) {
		/* programmer error					*/
		errmsg = "{bf:LINCOM} tree required"
		return(498)
	}
	node = tree.arg[2]
	if (node.type!=`VARLIST' | !tree.narg) {
		/* programmer error					*/
		errmsg = "{bf:LINCOM} tree required"
		return(498)
	}
	depth = 0
	expr = __sub_expr_traverse_LC_tree(node,depth)
	if (rc=__sub_expr_lvparse_convert_LC(expr)) {
		/* ignore error and use the original expression;
		 * issue an informative error in
		 *  __sub_expr_group::traverse_LC_tree()		*/
		return(0)
	}
	expr = tree.arg[1].symb + tree.symb + expr
	tree = nlparse_node(1)
	if (rc=_nlparse(expr,tree,errmsg)) {
		errmsg = sprintf("invalid linear combination {bf:%s}: %s",
			expr,errmsg)
	}
	return(rc)
}

real scalar __sub_expr_lvparse_convert_LC(string expr)
{
	/* maintain Stata parental handling of base groups for linear
	 * combinations, e.g. convert -1.f 2.f 3.f- to i(1 2 3).f
	 * If not converted, _nlparse(), adds each indicator operator
	 * #. individually in the parse tree				*/
	real scalar rc, noisily, i, k
	string scalar expr0
	string vector vars, lv
	string matrix lvars

	pragma unset vars
	pragma unset lvars

	if (ustrpos(expr,"*")) { 	// no wild cards
		return(198)
	}
	expr0 = expr
	noisily = `SUBEXPR_FALSE'

	/* _lvparse() will accept
	 * 		_cons	: lvars = _cons 
	 * 		I(id)	: lvars = I, vars = id
	 * 								*/
	if (rc=_lvparse(expr0,noisily,vars,lvars)) {
		/* not a linear form or linear form incorrectly 
		 * specified						*/
		return(rc)
	}
	if (cols(lvars)) {
		if (any(lvars[1,.]:=="_cons")) {
			/* _lvparse identifies special symbol _cons as
			 * a latent variable				*/
			return(-1)
		}
	}
	/* recompose linear combination expression in condensed form	*/
	k = cols(lvars)
	lv = J(1,k,"")
	for (i=k; i>=1; i--) {
		if (usubstr(lvars[1,i],1,1)=="_") {	// includes _cons
			return(198)
		}
		if (ustrlen(lvars[2,i])) {
			lv[i] = lvars[2,i]+"#"+lvars[1,i]
		}
		else {
			lv[i] = lvars[1,i]
		}
	}
	if (length(vars) & k) {
		expr = invtokens(vars) + " " + invtokens(lv)
	}
	else if (k) {
		expr = invtokens(lv)
	}
	else {
		expr = invtokens(vars)
	}
	return(rc)
}

real scalar __sub_expr_lvparse(string scalar vlist, string vector vars,
			string matrix lvars)
{
	real scalar rc, noisily, hasbase, i, k
	string vector tokens
	transmorphic te

	pragma unset vars
	pragma unset lvars

	hasbase = `SUBEXPR_FALSE'
	if (ustrpos(vlist,"#")) {
		/* hack to prevent _lvparse() morphing base operator, b.,
		 * to the omitted operator, o., or dropping completely	*/
		hasbase = (ustrpos(vlist,"b.")>0)
	}
	noisily = `SUBEXPR_FALSE'
	/* expand abbreviations						*/
	if (rc=_lvparse(vlist,noisily,vars,lvars)) {
		return(rc)
	}
	if (cols(lvars)) {
		return(rc)
	}
	if (cols(vars) != 1) {
		return(rc)
	}
	if (!hasbase) {
		return(rc)
	}
	/* put back base operators				*/
	te = tokeninit("",("b.","o.","co.","c.","#"))	// other tokens?
	tokenset(te,vlist)
	tokens = tokengetall(te)
	k = length(tokens)
	vlist = ""
	for (i=1; i<=k; i++) {
		if (tokens[i] == "b.") {
			vlist = vlist + tokens[i]
		}
		else if (tokens[i] == "o.") {
			vlist = vlist + tokens[i]
		}
		else if (tokens[i] == "co.") {
			vlist = vlist + tokens[i]
		}
		else if (tokens[i] == "c.") {
			vlist = vlist + tokens[i]
		}
		else if (tokens[i] == "#") {
			vlist = vlist + tokens[i]
		}
		else if (!missing(strtoreal(tokens[i]))) {
			vlist = vlist + tokens[i]
		}
		else if (!missing(_st_varindex(tokens[i]))) {
			vlist = vlist + tokens[i]
		}
		else {
			/* unabbreviate varname				*/
			if (rc=_lvparse(tokens[i],noisily,vars,lvars)) {
				break
			}
			vlist = vlist + vars[1]
		}
	}
	if (!rc) {
		vars = vlist
	}
	return(rc)
}

real scalar __sub_expr_isvariable(string scalar var, |real scalar fvstrip)
{
	real scalar omit, nofv, noisily
	string vector obs
	string matrix lat

	pragma unset obs
	pragma unset lat

	if (__sub_expr_lvparse(var,obs,lat)) {
		return(`SUBEXPR_FALSE')
	}
	if (cols(lat)) {
		return(`SUBEXPR_FALSE')
	}
	if (cols(obs)!=1) {
		return(`SUBEXPR_FALSE')
	}
	var = obs[1]	// unabbreviated
	fvstrip = (missing(fvstrip)?`SUBEXPR_FALSE':(fvstrip!=`SUBEXPR_FALSE'))
	if (fvstrip) {
		omit = `SUBEXPR_FALSE'
		nofv = `SUBEXPR_FALSE'
		noisily = `SUBEXPR_FALSE'
		/* if a factor spec, make sure it is a single factor, 
		 * e.g. i1.f _msparse() morphs i1.f to 1.f
		 *  _msparse() strips out c. from c.x
		 *  error for non-matrix stripe specs, e.g. i.varname	*/
		(void)_msparse(var,omit,noisily,nofv) // ignore error
	}
	return(`SUBEXPR_TRUE')
}

real scalar __sub_expr_isLVsymbol(string scalar lv)
{
	real scalar k
	string scalar c1

	k = ustrlen(lv)
	if (!k) {
		return(`SUBEXPR_FALSE')
	}
	c1 = usubstr(lv,1,1)
	if (c1 == "_") {
		if (k==1) {
			return(`SUBEXPR_FALSE')
		}
		c1 = usubstr(lv,2,1)
	}
	return(c1>="A" & c1<="Z") 
}

real scalar __sub_expr_islatentvar(string scalar lv, |real scalar strict)
{
	real scalar noisily
	string vector tokens, vars, c
	string matrix lvars
	transmorphic te

	pragma unset vars
	pragma unset lvars

	strict = (missing(strict)?0:(strict!=0))
	if (!strict) {
		/* just check if it smells like a lV
		 *  check for proper structure and ID variables 
		 *  exist later						*/
		te = tokeninit("","",("[]"))	// qchar arg matches brackets
		tokenset(te,lv)
		tokens = tokengetall(te)
		if (length(tokens) != 2) {
			return(`SUBEXPR_FALSE')
		}
		c = usubstr(tokens[1],1,1)
		if (c == "[") {
			return(`SUBEXPR_FALSE')
		}
		/* must begin with caps					*/
		if (!missing(strtoreal(c))) {
			return(`SUBEXPR_FALSE')
		}
		return(ustrupper(c)==c)
	}
	noisily = `SUBEXPR_FALSE'
	if (_lvparse(lv,noisily,vars,lvars)) {
		return(`SUBEXPR_FALSE')
	}
	if (length(vars)) {
		return(`SUBEXPR_FALSE')
	}
	if (cols(lvars) != 1) {
		return(`SUBEXPR_FALSE')
	}
	if (lvars[1,1] == "_cons") {
		return(`SUBEXPR_FALSE')
	}
	return(lvars[1,1]==lv)
}

real scalar __sub_expr_isstrvar(string scalar varname)
{
	if (!st_isname(varname)) {
		return(0)
	}
	return(st_isstrvar(varname))
}

real scalar __sub_expr_islinearcomb(string scalar vlist)
{
	real scalar rc, noisily
	string vector vars
	string matrix lvars

	pragma unset vars
	pragma unset lvars

	noisily = `SUBEXPR_FALSE'
	rc = _lvparse(vlist,noisily,vars,lvars)

	return(rc==0)
}

string vector __sub_expr_linearcomb_vars(string scalar vlist)
{
	real scalar noisily, i, k
	real vector ik
	string vector vars
	string matrix lvars

	pragma unset vars
	pragma unset lvars

	noisily = `SUBEXPR_FALSE'
	if (_lvparse(vlist,noisily,vars,lvars)) {
		return(J(1,0,""))
	}
	k = cols(lvars)
	for (i=1; i<=k; i++) {
		ik = ustrlen(lvars[.,i])
		if (!any(ik)) {
			continue
		}
		ik = select(1::rows(lvars),ik)
		if (length(ik) == 1) {
			vars = (vars,lvars[ik[1],i])
		}
		else {
			vars = (vars,invtokens(lvars[ik,i]',"#"))
		}
	}
	return(vars)
}

real scalar __sub_expr_get_options(string scalar expr, string vector options,
		string scalar errmsg)
{
	real scalar k, rc
	string scalar tokens
	transmorphic te

	rc = 0
	options = J(1,0,"")
	if (strlen(strtrim(expr)) == 0) {
		return(0)
	}
	/* check for options						*/
	te = tokeninit("",",",("{}","()"))
	tokenset(te, expr)
	tokens = tokengetall(te)
	k = length(tokens)
	if (tokens[k] == ",") {
		errmsg = "options required after the comma"
		return(198)
	}
	if (k < 2) {
		return(rc)
	}
	if (tokens[k-1] != ",") {
		return(rc)
	}
	if (rc=__sub_expr_parse_options(tokens[k],options)) {
		errmsg = sprintf("invalid suboptions {bf:%s}",tokens[k])
		return(rc)
	}
	if (k >= 3) {
		expr = invtokens(tokens[|1\k-2|],"")
	}
	else {
		expr = ""
	}
	if (!length(options)) {
		errmsg = "options required if a comma is specified"
		rc = 198
	}
	return(rc)
}

real scalar __sub_expr_parse_options(string scalar sopts, string vector options)
{
	sopts = ustrtrim(sopts)

	options = J(1,0,"")
	if (!ustrlen(sopts)) {
		return(0)
	}
	options = tokens(sopts)
	return(0)
}

real scalar __sub_expr_validate_options(string vector options,
		string vector opts, real vector kmin, string scalar errmsg)
{
	real scalar i, k, kopt, rc
	real vector mopt, iopt, jopt
	string scalar bopt

	if (!(kopt=length(options))) {
		return(0)
	}
	k = length(opts)
	mopt = J(1,kopt,0)
	rc = 0
	for (i=1; i<=k; i++) {
		if (!strlen(opts[i])) {
			continue
		}
		if (length(kmin) < i) {
			iopt = __sub_expr_test_option(options,opts[i])
		}
		else {
			iopt = __sub_expr_test_option(options,opts[i],kmin[i])
			if (any(iopt)) {
				/* unabbreviate				*/
				jopt = select(1..kopt,iopt)[1]
				options[jopt[1]] = opts[i]
			}
		}
		mopt = mopt :| iopt
	}
	if (!all(mopt)) {
		mopt = !mopt
		bopt = invtokens(select(options,mopt),", ")
		errmsg = sprintf("option%s {bf:%s} not allowed",
			(sum(mopt)>1?"s":""),bopt)
		rc = 198
	}
	return(rc)
}

real scalar __sub_expr_has_option(string vector options, string scalar opt,
			|real scalar k)
{
	return(any(__sub_expr_test_option(options,opt,k)))
}

real vector __sub_expr_test_option(string vector options, string scalar opt,
			|real scalar k)
{
	real scalar n, m

	m = length(options)
	if (!ustrlen(opt) | !m) {
		return(0)
	}
	if (missing(k)) {
		return(opt:==options)
	}
	n = colmin((J(1,m,k)\ustrlen(options)))

	return(usubstr(J(1,m,opt),1,n):==usubstr(options,1,n))
}

real scalar __sub_expr_get_value(string scalar sval)
{
	real scalar val

	val = .
	val = strtoreal(sval)
	if (missing(val) & st_isname(sval)) {
		val = st_numscalar(sval)
		if (!length(val)) {
			/* deal with weirdness, val[0,0]		*/
			val = .
		}
	}
	return(val)
}

real scalar __sub_expr_name_index(string scalar name, string vector names)
{
	real scalar nl, slash
	real vector i
	string scalar name0

	i = (name:==names)
	if (any(i)) {
		return(selectindex(i)[1])
	}
	slash = (usubstr(name,1,1)=="/")
	nl = ustrlen(name)
	if (slash) {
		if (nl > 1) {
			name0 = usubstr(name,2,nl-1)
		}
		nl--
	}
	else {
		name0 = "/"+name
		nl++
	}
	if (!nl) {
		return(0)
	}
	i = (name0:==names)
	if (!any(i)) {
		return(0)
	}
	return(selectindex(i)[1])
}	

string scalar __sub_expr_name_no_slash(string scalar name0)
{
	real scalar k
	string scalar name

	if (!(k=ustrlen(name0))) {
		return(name0)
	}
	if (usubstr(name0,1,1) != "/") {
		return(name0)
	}
	name = name0
	if ((k=ustrlen(name)) == 1) {
		name = ""
	}
	else {
		name = usubstr(name,2,--k)
	}
	return(name)
}

real scalar __sub_expr_validate_var(string scalar varname,
			|string scalar errmsg)
{
	real scalar rc

	rc = 0
	if (!__sub_expr_isvariable(varname)) {	// unabbreviate
		 errmsg = sprintf("variable {bf:%s} not found",varname)
		rc = 111
	}
	return(rc)
}

real scalar __sub_expr_validate_touse(string scalar touse,
			string scalar errmsg, |real scalar existonly)
{
	real scalar rc
	string scalar type

	existonly = (missing(existonly)?`SUBEXPR_FALSE':
		(existonly!=`SUBEXPR_FALSE'))
	/* assumption: touse is not abbreviated				*/
	rc = 0
	if (!strlen(touse)) {
		errmsg = "estimation sample indicator variable required"
		rc = 198
	}
	else if (missing(st_varindex(touse))) {
		rc = 198
		errmsg = sprintf("estimation sample indicator variable " +
				"{bf:%s} does not exist",touse)
	}
	if (existonly | rc) {
		return(rc)
	}
	type = st_vartype(touse)
	if (type != "byte") {
		errmsg = sprintf("estimation sample variable {bf:%s} must " +
			"be type byte",touse)
		rc = 498
	}
	else if (sum(st_data(.,touse)) == 0) {
		errmsg = sprintf("estimation sample indicator variable " +
			"eliminates all observations")
		rc = 2000
	}
	return(rc)
}

real vector __sub_expr_isparam(string scalar expr, real scalar tsop)
{
	real scalar k, val, nooutput
	string scalar stex, sval, ts
	string vector tokens, tstok
	transmorphic te

	if (!strlen(expr)) {
		return(`SUBEXPR_FALSE')
	}
	te = tokeninit(" ","=")
	tokenset(te,expr)
	tokens = tokengetall(te)
	k = length(tokens)
	if (k!=1 & k!=3) {
		return(`SUBEXPR_FALSE')
	}
	if (!st_isname((tokens[1]))) {
		if (!tsop) {
			return(`SUBEXPR_FALSE')
		}
		/* allow ts operators on parameters (Bayes)		*/
		te = tokeninit("",".")
		tokenset(te,tokens[1])
		tstok = tokengetall(te)
		if (length(tstok) != 3) {
			return(`SUBEXPR_FALSE')
		}
		ts = strupper(substr(tstok[1],1,1))
		if (ts!="L" & ts!="D" & ts!="F") {
			return(`SUBEXPR_FALSE')
		}
		k = strlen(tstok[1])-1
		if (k) {
			sval = substr(tstok[1],2,k)
			if (missing(strtoreal(sval))) {
				return(`SUBEXPR_FALSE')
			}
		}
		return(st_isname(tstok[3]))
	}
	if (k == 1) {
		return(`SUBEXPR_TRUE')
	}
	if (tokens[2] != "=") {
		return(`SUBEXPR_FALSE')
	}
	if (tokens[3] == ".") {
		/* initializing to missing				*/
		return(`SUBEXPR_TRUE')
	}
	if (st_isname(tokens[3])) {
		val = st_numscalar(tokens[3])
		if (rows(val)==0 & cols(val)==0) {
			/* missing() does not work			*/
			return(`SUBEXPR_FALSE')
		}
		return(`SUBEXPR_TRUE')
	}
	if (!missing(strtoreal(tokens[3]))) {
		return(`SUBEXPR_TRUE')
	}
	sval = st_tempname()
	nooutput = `SUBEXPR_TRUE'
	stex = sprintf("scalar %s = %s",sval,tokens[3])
	if (_stata(stex,nooutput)) {
		return(`SUBEXPR_FALSE')
	}
	val = st_numscalar(sval)
	if (rows(val)==0 & cols(val)==0) {
		/* missing() does not work				*/
		return(`SUBEXPR_FALSE')
	}
	stex = sprintf("scalar drop %s",sval)
	(void)_stata(stex,nooutput)

	return(`SUBEXPR_TRUE')
}

real scalar __sub_expr_as_numeric(string scalar snumber)
{
	real scalar nooutput, number
	string scalar tmpname, cmd

	tmpname = st_tempname()

	cmd = sprintf("scalar %s = %s",tmpname,snumber)
	nooutput = `SUBEXPR_TRUE'
	number = .
	if (!_stata(cmd,nooutput)) {
		number = st_numscalar(tmpname)
	}
	return(number)
}

string scalar __sub_expr_fixup_covariate(string scalar covariate)
{
	real scalar k, i
	string scalar op
	string vector toks, vars
	transmorphic te

	if (!ustrlen(covariate)) {
		return(covariate)
	}
	te = tokeninit("",("#","##"),"")

	tokenset(te,covariate)
	toks = tokengetall(te)
	k = length(toks)
	if (k == 1) {
		return(covariate)
	}
	vars = J(1,0,"")
	for (i=1; i<=k; i++) {
		if (toks[i]=="#" | toks[i]=="##") {
			op = toks[i]
		}
		else {
			vars = (vars,toks[i])
		}
	}
	vars = sort(vars',1)'
	return(invtokens(vars,op))
}

real scalar __sub_expr_prune_TS_op(struct nlparse_node scalar node, 
		struct nlparse_node scalar pnode, real scalar ind)
{
	real scalar i, prune
	struct nlparse_node scalar nodei

	if (node.type == `TSOP') {
		prune = `SUBEXPR_TRUE'
		node = node.arg[1]
		if (pnode.type != `NULL') {
			pnode.arg[ind] = node
		}
	}
	else {
		prune = `SUBEXPR_FALSE'
	}
	i = 1
	while (i<=node.narg) {
 		/* make copy to get around Mata memory bug:
		 * nlparse_tree struct contains a nlparse_tree
		 * struct array, pruning it will crash Stata		*/
		nodei = pt_clone_tree(node.arg[i])
		if (__sub_expr_prune_TS_op(nodei,node,i)) {
			/* copy again					*/
			node.arg[i] = pt_clone_tree(nodei)
		}
		i++
	}
	return(prune)
}

void __sub_expr_drop_TS_op(string scalar name)
{
	real scalar depth
	string scalar errmsg
	struct nlparse_node scalar tree, null

	pragma unset errmsg
	
	if (_nlparse(sprintf("tmp: %s",name),tree,errmsg)) {
		/* should not happen					*/
		errprintf("%s\n",errmsg)
		return
	}
	tree = tree.arg[2].arg[1]	// by pass LC varlist
	null.type = `NULL'
	(void)__sub_expr_prune_TS_op(tree,null,0)

	depth = 0
	name = __sub_expr_traverse_LC_tree(tree,depth)
}

end
exit
