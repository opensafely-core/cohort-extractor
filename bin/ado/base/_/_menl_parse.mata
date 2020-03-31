*! version 1.1.6  04sep2019

findfile __sub_expr_global.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

local TRUE  1
local FALSE 0

mata:

mata set matastrict on

/* assumption: syntax already validate by menl.ado			*/

void _menl_create_instance(string scalar exprname)
{
	class __menl_expr scalar expr
	transmorphic scalar ptr

	ptr = crexternal(exprname)
	if (ptr == NULL) {
		/* should not happen					*/
		errprintf("{p}could not create external parsing object; " + 
			"an object with name %s already exists{p_end}\n",
			exprname)
		exit(110)
	}
	*ptr = expr
}

void _menl_remove_instance(class __menl_expr scalar obj, string scalar name)
{
	obj.clear()

	rmexternal(name)
}

pointer (class __menl_expr) scalar _menl_get_instance(string scalar name)
{
	pointer (class __menl_expr) scalar pExpr

	pExpr = findexternal(name)
	if (pExpr == NULL) {
		errprintf("{p}external parsing object named %s not found" +
			"{p_end}\n",name)
		exit(111)
	}
	return(pExpr)
}

void _menl_post_error(class __menl_expr scalar obj, real scalar rc)
{
	st_local("rc",strofreal(rc))
	st_local("errmsg",obj.errmsg())
	st_local("message",obj.message())
}

void _menl_set_touse(class __menl_expr scalar obj, string scalar touse)
{
	real scalar rc

	if (rc=obj._set_touse(touse)) {
		_menl_post_error(obj,rc)
	}
}

void _menl_parse_expression(class __menl_expr scalar obj, string scalar expr)
{
	real scalar rc

	if (rc=obj._parse_expression(expr)) {
		_menl_post_error(obj,rc)
	}
}

void _menl_parse_equation(class __menl_expr scalar obj, string scalar eq,
		|real scalar noconst, real scalar xb)
{
	real scalar rc, idef

	idef = ustrpos(eq,"define(")
	if (rc=obj.parse_equation(eq,noconst,xb)) {
		if (idef & strlen(obj.message())==0) {
			obj.set_message("Perhaps you have omitted the comma " +
				"that separates the nonlinear equation from " +
				"the options.")
		}
		_menl_post_error(obj,rc)
	}
}

void _menl_parse_tsinit(class __menl_expr scalar obj, string scalar tsinit)
{
	real scalar rc

	if (rc=obj.parse_expr_init(tsinit)) {
		_menl_post_error(obj,rc)
	}
}

void _menl_estimation_sample(class __menl_expr scalar obj, string scalar expr)
{
	string scalar touse

	touse = obj.touse(expr)

	st_global("r(touse)",touse)
}

void _menl_resolve_hierarchy(class __menl_expr scalar obj, 
			|string scalar tvar, string scalar gvar)
{
	real scalar rc, kh

	if (rc=obj.resolve_lvhierarchy(tvar,gvar)) {
		_menl_post_error(obj,rc)
		return
	}
	kh = obj.hier_count()
	if (kh > 1) {
		st_local("errmsg",sprintf("crossed effects are not allowed; " +
			"your random effect specifications define %g " +
			"hierarchies",kh))
		st_local("rc","198")
	}
	st_numscalar("r(khier)",kh)
}

void _menl_resolve_expressions(class __menl_expr scalar obj, 
			|string scalar tvar, string scalar gvar)
{
	real scalar rc, i, kh, kw
	string vector warn

	if (rc=obj._resolve_expressions(tvar,gvar)) {
		_menl_post_error(obj,rc)
		return
	}
	kh = obj.hier_count()
	if (kh > 1) {
		st_local("errmsg",sprintf("crossed effects are not allowed; " +
			"your random effect specifications define %g " +
			"hierarchies",kh))
		st_local("rc","198")
	}
	st_numscalar("r(khier)",kh)
	_menl_TS_query(obj)

	warn = obj.warnings()
	kw = length(warn)
	st_numscalar("r(kwarn)",kw)
	for (i=1; i<=kw; i++) {
		st_global(sprintf("r(warn%g)",i),warn[i])
	}
	obj.clear_warnings()
}

void _menl_resolve_covariances(class __menl_expr scalar obj)
{
	real scalar rc

	if (rc=obj._resolve_covariances()) {
		_menl_post_error(obj,rc)
	}
}

void _menl_add_re_covariance(class __menl_expr scalar obj, 
		string vector lvnames, string scalar covtype,
		|string scalar fpmatrix)
{
	real scalar rc, vtype, ctype
	real matrix fixpat
	string scalar errmsg
	class __recovmatrix scalar cov

	ctype = .
	if (covtype == "independent") {
		vtype = cov.HETEROSKEDASTIC
		ctype = cov.INDEPENDENT
	}
	else if (covtype == "exchangeable") {
		vtype = cov.HOMOSKEDASTIC
		ctype = cov.EXCHANGEABLE
	}
	else if (covtype == "identity") {
		vtype = cov.HOMOSKEDASTIC
		ctype = cov.INDEPENDENT
	}
	else if (covtype == "unstructured") {
		vtype = cov.HETEROSKEDASTIC
		ctype = cov.UNSTRUCTURED
	}
	else if (covtype == "fixed") {
		vtype = cov.FIXED
		fixpat = st_matrix(fpmatrix)
	}
	else if (covtype == "pattern") {
		vtype = cov.PATTERN
		fixpat = st_matrix(fpmatrix)
	}
	else {
		st_local("errmsg",sprintf("invalid covariance type {bf:%s}\n",
			covtype))
		st_local("rc","198")
		return
	}
	lvnames = tokens(lvnames)
	if (rc=obj._add_re_covariance(lvnames,vtype,ctype,fixpat)) {
		errmsg = obj.errmsg()
		errmsg = subinstr(errmsg,"correlation","covariance")
		obj.set_errmsg(sprintf("option {bf:covariance()}: %s",errmsg))
		_menl_post_error(obj,rc)
	}
}

void _menl_set_resid_covariance(class __menl_expr scalar obj, 
		string scalar vartype, string vector vbyvar,
		string vector vivar, string scalar varopt,
		string scalar cortype, string vector cbyvar,
		string vector ctvar, string scalar coropt)
{
	real scalar rc, ctype, vtype, vorder, k, ivar
	real vector corder
	string vector ops, depvar
	string vector pvar, tvar
	class __ecovmatrix scalar cov

	/* menl supported variance structures				*/
	if (vartype == "identity") {
		vtype = cov.HOMOSKEDASTIC
	}
	else if (vartype == "power") {
		vtype = cov.CONSTPOWER
		ops = tokens(varopt)
		ivar = .
		if (k=length(ops)) {
			if (k == 2) {
				if (ops[2] == "noconstant") {
					vtype = cov.POWER
				}
			}
			ivar = 0
			if (ops[1] != `MENL_VAR_RESID_FITTED') {
				ivar = _st_varindex(ops[1])
			}
		}
		if (missing(ivar)) {
			st_local("errmsg","invalid residual variance " +
				"specification; power covariate required")
			st_local("rc","498")		
			return
		}
		pvar = ops[1]
	}
	else if (vartype == "linear") {
		vtype = cov.LINEAR
		ivar = _st_varindex(varopt)
		if (missing(ivar)) {
			st_local("errmsg","invalid residual variance " +
				"specification; linear covariate required")
			st_local("rc","498")		
			return
		}
		pvar = varopt
	}
	else if (vartype == "exponential") {
		vtype = cov.EXPONENTIAL
		ivar = .
		if (ustrlen(varopt)) {
			ivar = 0
			if (varopt != `MENL_VAR_RESID_FITTED') {
				ivar = _st_varindex(varopt)
			}
		}
		if (missing(ivar)) {
			st_local("errmsg","invalid residual variance " +
				"specification; exponential covariate required")
			st_local("rc","498")		
			return
		}
		pvar = varopt
	}
	else if (vartype=="independent" | vartype=="distinct") {
		/* unequal variances					*/
		vtype = cov.HETEROSKEDASTIC
		/* postestimation if length(vivar) == 2, vivar[2] is
		 *  the matrix name containing the levels associated
		 *  with the 1 based index variable vivar[1]		*/
		ivar = _st_varindex(vivar[1])
		if (missing(ivar)) {
			st_local("errmsg","invalid independent residual " +
				"covariance specification; index variable " +
				"required")
			st_local("rc","498")		
			return
		}
		vorder = strtoreal(varopt)
		if (missing(vorder)) {
			st_local("errmsg","invalid independent residual " +
				"covariance specification; maximum number of " +
				"variances required")
			st_local("rc","498")		
			return
		}
		pvar = vivar
	}
	else {
		errprintf("residual variance %s not implemented\n",vartype)
		exit(498)
	}
	/* menl supported correlation structures			*/
	if (cortype == "identity") {
		ctype = cov.INDEPENDENT
	}
	else if (cortype == "ar") {
		ctype = cov.AUTOREGRESS
	}
	else if (cortype == "ma") {
		ctype = cov.MOVINGAVERAGE
	}
	else if (cortype == "ctar1") {
		ctype = cov.CONTINUOUSAR1
	}
	else if (cortype == "exchangeable") {
		ctype = cov.EXCHANGEABLE
	}
	else if (cortype == "unstructured") {
		ctype = cov.UNSTRUCTURED
	}
	else if (cortype == "banded") {
		ctype = cov.BANDED
	}
	else if (cortype == "toeplitz") {
		ctype = cov.TOEPLITZ
	}
	else {
		st_local("errmsg",sprintf("residual correlation {bf:%s} " +
			"not implemented",cortype))
		st_local("rc","198")
		return
	}
	if (ctype==cov.AUTOREGRESS | ctype==cov.MOVINGAVERAGE |
		ctype==cov.CONTINUOUSAR1 | ctype==cov.UNSTRUCTURED |
		ctype==cov.BANDED | ctype==cov.TOEPLITZ) {
		ivar = _st_varindex(ctvar[1])
		if (missing(ivar)) {
			st_local("errmsg",sprintf("invalid %s residual " +
				"correlation specification; time variable " +
				"required",cortype))
			st_local("rc","498")		
			return
		}
		if (ctype == cov.CONTINUOUSAR1) {
			corder = 1
		}
		else {
			corder = strtoreal(tokens(coropt))
		}
		if (missing(corder)) {
			if (ctype == cov.UNSTRUCTURED) {
				st_local("errmsg","invalid unstructured " +
					"residual correlation specification; " +
					"maximum covariance dimension required")
			}
			else {
				st_local("errmsg",sprintf("invalid %s " +
				"residual correlation specification; %s " +
				"order required",cortype,cortype))
			}
			st_local("rc","498")		
			return
		}
		tvar = ctvar
	}
	depvar = obj.eq_names()[1]
	if (rc=obj._set_res_covariance(depvar,vtype,ctype,vbyvar,cbyvar,pvar,
			tvar,vorder,corder)) {
		_menl_post_error(obj,rc)
	}
}

void _menl_debug_display(class __menl_expr scalar obj, real scalar level)
{
	if (missing(level) | level<=0) {
		return
	}
	printf("\n{hline 78}")
	obj.display_equations()
	obj.dump_components()
	if (level > 1) {
		printf("\n{hline 78}")
		obj.display_expressions()
	}
}

void _menl_hierarchy_sort_order(class __menl_expr scalar obj, real scalar ih,
		string scalar ordervar)
{
	real scalar rc, ivar, kh
	real colvector order

	pragma unset order

 	/* select hierarchy; can only have 1 for lbates			*/
	kh = obj.hier_count()
	if (kh > 1) {
		st_local("errmsg",sprintf("crossed effects are not allowed; " +
			"your random effect specifications define %g " +
			"hierarchies",kh))
		st_local("rc","198")
		return
	}
	if (ih<0 | ih>kh) {
		st_local("errmsg",sprintf("invalid hierarchy index %g; " +
			"must be in [0,%g]",ih,kh))
		st_local("rc","498")
	}
	if (missing(ivar=_st_varindex(ordervar))) {
		ivar = st_addvar("long",ordervar)
	}
	/* includes correlation time variable in sort order		*/
	if (rc=obj._hierarchy_sort_order(ih,order)) {
		_menl_post_error(obj,rc)
	}
	else {
		st_store(.,ivar,obj.touse(),order)
	}
}

void _menl_hierarchy_gen_panel_info(class __menl_expr scalar obj,
		string scalar panelvar,	|real scalar noegen)
{
	real scalar rc, ivar
	string scalar depvar
	string vector path
	real colvector panels

	pragma unset panels
	pragma unset path

	noegen = (missing(noegen)?`FALSE':(noegen!=`FALSE'))
	depvar = obj.eq_names()[1]
	/* data has been sorted in Stata using the order variable
	 *  returned by _menl_hierarchy_sort_order()			*/
	if (rc=obj._gen_hierarchy_panel_info(depvar,path,noegen)) {
		_menl_post_error(obj,rc)
		return
	}
	if (rc=obj._hierarchy_panel_vector(panels)) {
		_menl_post_error(obj,rc)
		return
	}
	if (missing(ivar=_st_varindex(panelvar))) {
		ivar = st_addvar("long",panelvar)
	}
	// st_store(.,ivar,obj.touse(depvar),panels)
	st_store(.,ivar,obj.touse(depvar),panels)
	st_global("r(path)",path[1])
	if (length(path) == 2) {
		st_global("r(group)",path[2])
	}
	st_global("r(touse)",obj.touse(depvar))
}

void _menl_get_parameters(class __menl_expr scalar obj, string scalar sb)
{
	class __stmatrix scalar m

	m = obj.stparameters()
	if (!m.cols()) {
		st_matrix(sb,J(1,0,0))
	}
	else {
		m.st_matrix(sb)
	}
}

void _menl_TS_query(class __menl_expr scalar obj)
{
	real scalar recur, i, k
	real vector order, io
	string scalar depvar
	string vector renames, varnames, exnames
	string matrix stripe

	pragma unset renames
	pragma unset varnames
	pragma unset exnames

	depvar = obj.depvars()[1]
	recur = obj.TS_recursive(depvar,renames)

	st_numscalar("r(TS_recursive)",recur)
	st_global("r(TS_recurexpr)",invtokens(renames))

	order = obj.TS_order_expr(varnames,exnames)
	if (length(exnames) & (k=length(renames))) {
		for (i=1; i<=k; i++) {
			io=strmatch(renames[i],exnames)
			if (any(io)) {
				io = selectindex(1:-io)
				exnames = exnames[io]
				if (!length(exnames)) {
					break
				}
			}
		}
	}
	stripe = (("","l.order")\("","f.order")\("","l.expr"))

	st_matrix("r(TS_order)",order)
	st_matrixcolstripe("r(TS_order)",stripe)
	if (length(varnames)) {
		st_global("r(TS_varlist)",invtokens(varnames))
	}
	if (length(exnames)) {
		st_global("r(TS_exprlist)",invtokens(exnames))
	}
}

void _menl_get_varlists(class __menl_expr scalar obj, real scalar mark_depvar)
{
	real scalar idvars, nameonly
	string vector vlist

	vlist = obj.depvars()
	st_global("r(depvar)",invtokens(vlist))

	/* tsmissing option specified?					*/
	obj.set_markout_depvar(mark_depvar)

	/* strip off TS ops						*/
	nameonly = `TRUE'

	vlist = obj.varlist("",nameonly)
	st_global("r(varlist)",invtokens(vlist))

	idvars = 1
	vlist = obj.latentvars(idvars)
	st_numscalar("r(kRV)",length(vlist))
	st_global("r(idvars)",invtokens(vlist))

	_menl_TS_query(obj)
}

void _menl_set_parameters(class __menl_expr scalar obj, string scalar sb)
{
	real scalar rc
	real rowvector b
	class __stmatrix scalar stb

	if (rc=stb.st_getmatrix(sb)) {
		st_local("rc",strofreal(rc))
		st_local("errmsg",stb.errmsg())
	}
	else {
		b = stb.m()
		if (rc=obj._set_parameters(b)) {
			_menl_post_error(obj,rc)
		}
	}
}

void _menl_init_parameters(class __menl_expr scalar obj, string scalar init)
{
	real scalar rc

	if (rc=obj._set_parameters(init)) {
		_menl_post_error(obj,rc)
	}
}

void _menl_mkvec_from_vec(string scalar sb, string scalar sb0, 
		|string scalar opt)
{
	real scalar rc, copy, skip
	string scalar errmsg
	real rowvector b, b0
	string matrix stripe, stripe0

	pragma unset errmsg

	rc = 0
	copy = (opt=="copy") 
	skip = (opt=="skip")

	b = st_matrix(sb)
	stripe = st_matrixcolstripe(sb)
	b0 = st_matrix(sb0)
	if (rows(b0) > 1) {
		errmsg = sprintf("expected a rowvector, but got a %g x %g " +
			"matrix",rows(b0),cols(b0))
		rc = 503
	}
	else if (copy) {
		if (cols(b) != cols(b0)) {
			errmsg = sprintf("expected a row vector of length " +
				"%g, but got %g",cols(b),cols(b0))
			rc = 503
		}
		else {
			rc = _initial_vector_copy(b0,b,errmsg)
		}
	}
	else {
		stripe0 = st_matrixcolstripe(sb0)
		rc = _initial_vector_byname(b0,stripe0,b,stripe,skip,errmsg)
	}
	st_local("rc",strofreal(rc))
	if (rc) {
		st_local("errmsg",errmsg)
	}
	else {
		st_matrix(sb,b)
		st_matrixcolstripe(sb,stripe)
	}
}

void _menl_mkvec_from_spec(string scalar sb, string scalar spec, 
			string scalar opt)
{
	real scalar rc, skip
	real rowvector b
	string scalar errmsg
	string matrix stripe

	pragma unset errmsg

	skip = (opt=="skip")
	b = st_matrix(sb)
	stripe = st_matrixcolstripe(sb)
	rc = _parse_initial_vector(spec,b,stripe,skip,errmsg)
	st_local("rc",strofreal(rc))
	if (rc) {
		st_local("errmsg",sprintf("invalid {bf:initial()} " +
			"specification; %s",errmsg))
	}
	else {
		st_matrix(sb,b)
		st_matrixcolstripe(sb,stripe)
	}
}

void _menl_mkvec_from_numlist(string scalar sb, string scalar numlist)
{
	real scalar rc
	real rowvector b
	string scalar errmsg
	string vector toks
	string matrix stripe

	pragma unset errmsg

	rc = 0
	b = st_matrix(sb)
	stripe = st_matrixcolstripe(sb)
	toks = tokens(numlist)
	if (cols(b) != length(toks)) {
		errmsg = sprintf("expected a number list of length %g, " +
			"but got %g",cols(b),length(toks))
		rc = 503
	}
	else {
		rc = _initial_numlist_copy(numlist,b,errmsg) 
	}
	st_local("rc",strofreal(rc))
	if (rc) {
		st_local("errmsg",sprintf("invalid {bf:initial()} " +
			"specification; %s",errmsg))
	}
	else {
		st_matrix(sb,b)
		st_matrixcolstripe(sb,stripe)
	}
}

void _menl_test_evaluate(class __menl_expr scalar obj, |real scalar trace)
{
	real scalar rc
	real colvector yhat
	string vector depvar

	pragma unset yhat

	trace = (missing(trace)?`FALSE':(trace!=`FALSE'))
	depvar = obj.eq_names()
	if (!length(depvar)) {
		obj.set_errmsg("failed to evaluate equation; no dependent " +
			"variable")
		_menl_post_error(obj,198)
		return
	}
	if (trace) {
		obj.set_trace_on()
	}
	rc = obj._eval_equation(yhat,depvar[1])
	if (trace) {
		obj.set_trace_off()
	}
	if (rc) {
		_menl_post_error(obj,rc)
	}
}

void _menl_post(class __menl_expr scalar obj)
{
	obj.return_post()
}

void _menl_rpost_rescov_vars(class __menl_expr scalar obj)
{
	string scalar civar, tvar, cbyvar, vivar, vbyvar
	pointer (class __ecovmatrix) scalar var

	var = obj.res_covariance()

	cbyvar = var->byvarname(var->CORR)
	vbyvar = var->byvarname(var->STDDEV)

	civar = var->indvarname(var->CORR)
	vivar = var->indvarname(var->STDDEV)

	tvar = var->tvar_name()

	st_global("r(cbyvar)",cbyvar)	
	st_global("r(vbyvar)",vbyvar)	

	st_global("r(civar)",civar)
	st_global("r(vivar)",vivar)

	st_global("r(tvar)",tvar)

	st_global("r(touse)",obj.touse())
}

void _menl_full2null_model(class __menl_expr scalar fobj,
			class __menl_expr scalar nobj, string vector touse)
{
	real scalar rc, hasnull, dispnull
	real scalar vtype, ctype
	pointer (class __ecovmatrix) scalar ecov

	pragma unset hasnull

	if (rc=fobj.null_model(nobj,hasnull,touse)) {
		_menl_post_error(fobj,rc)
		return
	}
	dispnull = `FALSE'
	if (hasnull) {
		dispnull = (length(fobj.latentvars()))
		ecov = fobj.res_covariance()
		vtype = ecov->vtype()
		ctype = ecov->ctype()
		if (ctype == ecov->INDEPENDENT) {
			if (vtype == ecov->LINEAR) {
				/* df_reduced == df_full
				 *  not nested model			*/
				hasnull = dispnull = `FALSE'
			}
		}
	}
	st_numscalar("r(dispnull)",dispnull)
	st_numscalar("r(hasnull)",hasnull)
}

void _menl_null_model_setup(class __menl_expr scalar fobj,
			class __menl_expr scalar nobj, string vector touse)
{
	real scalar rc, i, k, eps
	real scalar select
	real vector io
	real rowvector b
	real colvector yhat, sel
	string scalar depvar
	string matrix strf, strn
	class __stmatrix scalar bf, bn

	pragma unset yhat

	depvar = nobj.depvars()[1]
	bf = fobj.stparameters()
	bn = nobj.stparameters()
	strf = bf.colstripe()
	strn = bn.colstripe()
	k = rows(strn)
	for (i=1; i<=k; i++) {
		io = strmatch(strf,strn[i,.])
		io = io[.,1]:&io[.,2]
		if (!any(io)) {
			/* should not happen				*/
			continue
		}
		io = selectindex(io')[1]
		(void)bn.set_el(1,i,bf.el(1,io[1]))
	}
	select = `FALSE'
	if (!fobj.markout_depvar()) {
		if (rc=_stata(sprintf("gen byte %s = %s",touse[2],touse[1]))) {
			printf(sprintf("failed to evaluate the {bf:%s} " +
				"NULL model",depvar))
			return(rc)	
		}
		if (rc=_stata(sprintf("markout %s %s",touse[2],depvar))) {
			printf(sprintf("failed to evaluate the {bf:%s} " +
				"NULL model",depvar))
			return(rc)	
		}
		select = `TRUE'
		sel = st_data(.,touse[2],touse[1])
		sel = J(sum(st_data(.,touse[1])),1,1):&sel
	}
	b = bn.m()
	rc = k = 0
	eps = 2
	for (i=0; i<=5; i++) {
		eps = eps/2
		b = b*eps
		if (rc=nobj._set_parameters(b)) {
			_menl_post_error(nobj,rc)
			break
		}
		if (rc=nobj._eval_equation(yhat,depvar)) {
			_menl_post_error(nobj,rc)
			break
		}
		if (select) {
			yhat = select(yhat,sel)
		}
		if (!(k=missing(yhat))) {
			break
		}
	}
	st_numscalar("r(missing)",k)
	if (k & !rc) {
		printf("{txt}note: initial values not feasible\n")
	}
}

void _menl_display_model(class __menl_expr scalar obj)
{
	real scalar i, k
	string vector expr

	printf("\n")
	expr = obj.expr_names()
	k = length(expr)
	for (i=1; i<=k; i++) {
		_menl_display_expression(obj,expr[i])
	}
	if (k) {
		printf("\n")
	}
	_menl_display_equation(obj)
}

void _menl_display_equation(class __menl_expr scalar obj)
{
	real scalar i, lsz, sz, k, ind, ab, sp
	string scalar eq, eqname, eq1, pg, pg1, line

	ab = 12
	ind = 1
	sp = 2
	k = ind + ab + sp

	eqname = obj.eq_names()[1]	// only 1
	eqname = abbrev(eqname,ab)
	k = 2 // ind + ab + sp
	lsz = st_numscalar("c(linesize)") - ind
	eq = obj.equation(eqname,obj.EXPRESSION_CONDENSED)

	i = 2 // ab-ustrlen(eqname)+ind
	pg1 = sprintf("{p %g %g 2}",i,k)
	sz = ustrlen(eq)
	while (sz) {
		pg = pg1
		if (sz > lsz) {
			eq1 = ustrleft(eq,lsz)
			sz = sz - ustrlen(eq1)
			eq = ustrright(eq,sz)
			pg1 = sprintf("{p %g %g 2}",k,k)
		}
		else {
			eq1 = eq
			sz = 0
		}
		if (ustrlen(eqname)) {
			line = sprintf("%s{res}%s = %s{p_end}",pg,eqname,eq1)
		}
		else {
			line = sprintf("%s{res}%s{p_end}",pg,eq1)
		}
		printf("%s\n",line)
		eqname = ""
	}
}

void _menl_display_expression(class __menl_expr scalar obj,
			string scalar exname)
{
	real scalar i, lsz, sz, k, ind, ab, sp
	string scalar pref, ex, ex1, pg, pg1
	string scalar line

	ab = 12
	ind = 2
	sp = 2
	k = ind + ab + sp
	lsz = st_numscalar("c(linesize)") - k - 2
	ex = obj.expression(exname,obj.EXPRESSION_CONDENSED)
	sz = ustrlen(ex)
	ex = ustrleft(ex,--sz)
	i = ustrpos(ex,":")
	sz = sz-i
	ex = ustrright(ex,sz)
	pref = abbrev(exname,ab)
	i = ab-ustrlen(pref)+ind
	
	pg1 = sprintf("{p %g %g 2}",i,k)
	while (sz) {
		pg = pg1
		if (sz > lsz) {
			ex1 = ustrleft(ex,lsz)
			sz = sz - ustrlen(ex1)
			ex = ustrright(ex,sz)
			pg1 = sprintf("{p %g %g 2}",k,k)
		}
		else {
			ex1 = ex
			sz = 0
		}
		if (ustrlen(pref)) {
			line = sprintf("%s{txt}%s: {res}%s{p_end}",pg,pref,ex1)
		}
		else {
			line = sprintf("%s{res}%s{p_end}",pg,ex1)
		}
		printf("%s\n",line)
		pref = ""
	}
}

end
exit
