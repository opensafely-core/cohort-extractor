*! version 1.0.1  05sep2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __component.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __component.matah
quietly include `"`r(fn)'"'

findfile __sub_expr.matah
quietly include `"`r(fn)'"'

// local TRACE trace = 1
// local ESTATA = 0

mata:

mata set matastrict on

/* implementation: __bayes_expr_group					*/
void __bayes_expr_group::new()
{
	unlink()
	m_options = J(1,0,"")
}

void __bayes_expr_group::destroy()
{
//	errprintf("destroying __sub_expr_group %s ",name()); &this
//	displayas("txt")
	/* call private version here					*/
	_clear()
	unlink()
}

void __bayes_expr_group::unlink()
{
	real scalar i, k

	m_vlist = J(1,0,"")
	m_ib = J(1,0,0)
	m_ibcons = 0
	k = length(m_lvlist)
	/* explicitly decrement reference counts			*/
	for (i=1; i<=k; i++) {
		m_lvlist[i]->param = NULL
		m_lvlist[i] = NULL
	}
	m_lvlist = J(1,0,"")
	m_X = J(0,0,0)

	super.unlink()
}

pointer (struct __LV_summary) scalar __bayes_expr_group::construct_LV_summary(
			pointer (class __component_lv) scalar pC)
{
	real scalar nooutput
	string scalar cmd, eq
	real colvector ix, tu, tu0
	pointer (struct __LV_summary) scalar pLV
	pointer (class __sub_expr_elem) scalar pE
	class __tempnames scalar tn	// for static scalar tempname types

	pLV = &__LV_summary(1)
	pLV->lvname = pC->name()
	pLV->path = pC->path()
	pLV->expr = sprintf("%s[%s]",pLV->lvname,pLV->path)
	pLV->param = NULL
	pLV->covariate = J(0,1,0)
	pLV->vexpr = pC->covariate()
	pLV->ib = m_data->LV_index_vector(pLV->lvname)
	tu = st_data(.,touse())
	m_n = sum(tu)
	if (m_n < m_data->sample_size()) {
		/* different estimation samples				*/
		tu0 = st_data(.,m_data->touse())
		ix = select((tu0:&tu),tu0)
		pLV->ib = select(pLV->ib,ix)
	}
	pLV->param = NULL
	pLV->iparam = .
	if (ustrlen(pLV->vexpr)) {
		if (missing(_st_varindex(pLV->vexpr))) {
			pLV->vname = m_data->new_tempname(tn.VARIABLE)
			nooutput = `SUBEXPR_TRUE'
			cmd = sprintf("gen double %s = %s if %s",pLV->vname,
				pLV->vexpr,touse())
			if (_stata(cmd,nooutput)) {
				m_data->set_errmsg(sprintf("failed to " +
					"evaluate %s {bf:%s} covariate " +
					"expression {bf:%s}",
					m_data->LATENT_VARIABLE,pLV->lvname,
					pLV->vexpr))
				pLV = NULL
				return(pLV)
			}
		}
		else {
			pLV->vname = pLV->vexpr
		}
		pLV->covariate = st_data(.,pLV->vname,touse())
		pLV->expr = sprintf("%s*%s",pLV->vexpr,pLV->expr)
	}
	if ((pE=eqobj()) != NULL) {
		/* scaling parameter					*/
		eq = pE->name()
		pLV->param = pC->param(eq)
		if (pLV->param != NULL) {
			pLV->iparam = (pLV->param)->param_index()
			pLV->expr = sprintf("%s*%s",(pLV->param)->name(),
				pLV->expr)
		}
	}
	return(pLV)
}

void _menl_display_LV_summary(pointer (struct __LV_summary) scalar pLV)
{
	real scalar k

	printf("\nLV: %s\n",pLV->lvname)
	printf("path: %s\n",pLV->path)
	printf("cov expr: %s\n",pLV->vexpr)
	printf("cov name: %s\n",pLV->vname)
	if (k=rows(pLV->covariate)) {
		k = min((k,10))
		pLV->covariate[|1\k|]'
	}
	if (pLV->param != NULL) {
		printf("scaling parameter: {%s}\n",(pLV->param)->name())
		printf("parameter index: {%g}\n",pLV->iparam)
	}
	printf("expr: %s\n",pLV->expr)
}

real scalar __bayes_expr_group::compose_LC_eval()
{
	real scalar i, type, kv, klv, kfv, icoef, facind
	real scalar nooutput
	string scalar vari, touse
	pointer (class __sub_expr_elem) scalar pE
	pointer (class __component_base) scalar pC
	pointer (class __component_param) vector pFV
	pointer (struct __LV_summary) scalar pLV

/*
if (`ESTATA' == 1) {
	return(super.compose_LC_eval())
}
*/
	m_ib = J(1,0,0)
	m_vlist = J(1,0,"")
	m_X = J(0,0,0)
	m_n = 0
	m_ibcons = 0
	kv = klv = 0
	m_lvlist = J(1,0,NULL)
	facind = `SUBEXPR_FALSE'	// indicator for factors
	if (sum(TS_order()) > 0) {
		/* check that data is tsset, or st_data() will fail	*/
		nooutput = `SUBEXPR_TRUE'
		if (_stata("tsset",nooutput) == 111) {
			m_data->set_errmsg(sprintf("linear combination " +
				"{bf:%s} contains time-series operators and " +
				"a time variable is not set; use option " +
				"{bf:tsvar(}{it:varname}{bf:)} or " +
				"{helpb tsset} {it:varname}",name()))
			return(111)
		}
	}
	pE = first()
	while (pE != NULL) {
		pC = pE->component()
		type = pC->type() 
		if (type == `SUBEXPR_LV') {
			pLV = construct_LV_summary(pC)
			if (pLV == NULL) {
				return(498)
			}
			m_lvlist = (m_lvlist,pLV)
			pLV = NULL

			klv++
		}
		else {
			kfv = 1
			if (type == `SUBEXPR_FV') {
				pFV = pC->data(`SUBEXPR_HINT_FV')
				kfv = length(pFV)
			}
			else if (type == `SUBEXPR_FV_PARAM') {
				facind = `SUBEXPR_TRUE'
			}
			for (i=1; i<=kfv; i++) {
				if (type == `SUBEXPR_FV') {
					pC = pFV[i]
					pFV[i] = NULL
				}
				vari = pC->name()
				icoef = pC->data(`SUBEXPR_HINT_COEF_INDEX')
				if (vari == "_cons") {
					m_ibcons = icoef
				}
				else {
					kv++
					m_ib = (m_ib,icoef)
					m_vlist = (m_vlist,vari)
				}
			}
			pFV = J(1,0,NULL)
		}
		pE = pE->next()
	}
	pC = NULL
	touse = touse()
	m_n = sum(st_data(.,touse))
	if (kv) {
		if (facind) {
			/* prevent a base category from being imposed 
			 * when the user simply wants indicator 
			 * variables					*/
			m_X = J(m_n,kv,.)
			for (i=1; i<=kv; i++) {
				m_X[.,i] = st_data(.,m_vlist[i],touse)
			}
		}
		else {
			m_X = st_data(.,m_vlist,touse)
		}
		if (cols(m_X) != length(m_vlist)) {
			m_data->set_errmsg(sprintf("could not " +
				"establish a data view of variables " +
				"{bf:%s}; name vector is of length " +
				"%g but the data view has %g columns",
				invtokens(m_vlist,", "),length(m_vlist),
				cols(m_X)))
			return(498)
		}
	}
	else {
		m_X = J(0,0,0)
	}
	m_eready = `SUBEXPR_TRUE'

	return(0)
}

real scalar __bayes_expr_group::evaluate_LC(real colvector xb)
{
	string scalar expr

	expr = ""	// ignored

	return(_evaluate_LC(expr,xb))
}

real scalar __bayes_expr_group::_evaluate_LC(string scalar expr, 
			|real colvector xb)
{
	real scalar i, gtype, kv, klv, nooutput, rc, trace, m
	real scalar store
	string scalar tvar, vlist, plus, lv
	string scalar cmd, panelvar, tsvar, ifL, ifF, byy
	real colvector b, zb
	real rowvector b0
	real vector ord
	string vector lvs

	store = (args()==1)
	gtype = group_type()
	if (gtype!=`SUBEXPR_GROUP_LC' & gtype!=`SUBEXPR_EQ_LC') {
		/* programmer error					*/
		m_data->set_errmsg(sprintf("%s object {bf:%s} cannot be " +
			"evaluated as a linear combination",sgroup_type(),
			name()))
		return(498)
	}
	if (m_state->estate == `SUBEXPR_EVAL_CLEAN') {
		/* already evaluated					*/
		expr = subexpr()
		return(0)
	}
	tvar = tempname()
	if (coefref()) {
		/* referencing param of LC, _00000x[1,icoef]		*/
		expr = tvar
		return(0)
	}
	if (!m_eready) {
		/* compose evaluate information				*/
		if (rc=compose_LC_eval()) {
			return(rc)
		}
	}
	trace = (m_data->trace()==`SUBEXPR_ON')
	kv = length(m_ib)
	b0 = m_data->parameters()
	if (kv | m_hascons) {
		/* make xb a data member and only compute once/eval	*/
		if (kv) {
			b = b0[m_ib]'
			if (cols(m_X) != rows(b)) {
				m_data->set_errmsg(sprintf("cannot evaluate " +
					"linear combination {bf:%s}; data " + 
					"matrix has %g columns, but the " +
					"coefficient vector is of length %g",
					name(),cols(m_X),rows(b)))
				return(503)
			}
			xb = m_X*b
			if (m_hascons) {
				xb = xb :+ b0[m_ibcons]
			}
		}
		else if (m_hascons) {
			xb = J(m_n,1,b0[m_ibcons])
		}
		else {
			/* should not happen				*/
			m_data->set_errmsg(sprintf("%s %s is empty\n",
				sgroup_type(),name()))
			return(498)
		}
	}
	kv = kv + m_hascons
	lvs = J(1,0,"")
	if (klv=length(m_lvlist)) {
		if (!kv) {
			xb = J(m_n,1,0)
		}
		for (i=1; i<=klv; i++) {
			lv = m_lvlist[i]->lvname
			b = m_data->LV_parameters(lv)'
			zb = b[m_lvlist[i]->ib]
			if (rows(zb) == 1) {
				/* if b is 1x1 b[idx] becomes a row 
				 * vector				*/
				zb = zb'
			}
			if (rows(m_lvlist[i]->covariate)) {
				zb = zb:*(m_lvlist[i]->covariate)
			}
			if (!missing(m_lvlist[i]->iparam)) {
				zb = b0[m_lvlist[i]->iparam]:*zb
			}
			xb = xb:+zb
		}
	}
	if (missing(_st_varindex(tvar))) {
		if (missing(_st_addvar("double",tvar))) {
			m_data->set_errmsg(sprintf("%s %s could not be " +
				"evaluated",sgroup_type(),name()))
			return(498)
		}
	}
	if (store) {
		st_store(.,tvar,touse(),xb)
		m_state->estate = `SUBEXPR_EVAL_CLEAN'
		m_state->subexpr = expr = tvar
	}

	if (trace) {
		/* trace is only decoration, not a real expression	*/
		ord = TS_order()
		panelvar = m_data->stata_panelvar()
		tsvar = m_data->stata_tsvar()
		if ((max(ord)>0) & ustrlen(panelvar)) {
			byy = sprintf("by %s (%s): ",panelvar,tsvar)
		}
		vlist = invtokens(m_vlist)
		if (length(m_ib)) {
			printf("\n{txt}{p 0 8 2}evaluation %s: {res}%s%s = " +
				"(%s)*b[(%s)]",name(),byy,tvar,vlist,
				invtokens(strofreal(m_ib),","))
			plus = "+"
		}
		else {
			printf("\n{txt}{p 0 8 2}evaluation %s: {res}%s%s = ",
				name(),byy,tvar)
			plus = ""
		}
		if (m_hascons) {
			printf("{res}%sb[%g]",plus,m_ibcons)
			plus = "+"
		}
		if (klv) {
			for (i=1; i<=klv; i++) {
				lvs = (lvs,m_lvlist[i]->expr)
			}
			printf("{res}%s%s",plus,invtokens(lvs,"+"))
		}
		if (ord[`TS_LORDER']) {
			ifL = sprintf("& _n>%g",ord[`TS_LORDER'])
		}
		if (ord[`TS_FORDER']) {
			ifF = sprintf("& _n<_N-%g",ord[`TS_FORDER'])
		}
		
		printf(" {res}if %s%s%s{p_end}\n",touse(),ifL,ifF)
	}
	if (trace) {
		cmd = "list"
		if (ustrlen(panelvar)) {
			cmd = sprintf("%s %s",cmd,panelvar)
		}
		if (ustrlen(tsvar)) {
			cmd = sprintf("%s %s",cmd,tsvar)
		}
		m_n = sum(st_data(.,touse()))
		m = min((m_n,20))
		cmd = sprintf("%s %s %s in 1/%g",cmd,tvar,touse(),m)
		if (ustrlen(panelvar)) {
			cmd = sprintf("%s, sepby(%s)",cmd,panelvar)
		}
		nooutput = `SUBEXPR_FALSE'
		(void)_stata(cmd,nooutput)
	}
	return(0)
}

transmorphic __bayes_expr_group::data(real scalar hint)
{
	return(super.data(hint));
}

real scalar __bayes_expr_group::update(transmorphic data,
		real scalar hint)
{
	return(super.update(data,hint));
}

real scalar __bayes_expr_group::isequal(
		pointer (class __sub_expr_elem) scalar pE)
{
	return(super.isequal(pE));
}

void __bayes_expr_group::display(real scalar lev)
{
	super.display(lev);
}

string scalar __bayes_expr_group::traverse_expr(real scalar which,
			|real scalar top)
{
	return(super.traverse_expr(which,top));
}

string scalar __bayes_expr_group::expression()
{
	return(super.expression())
}

real scalar __bayes_expr_group::_evaluate(string scalar expr, 
		|transmorphic extra)
{
	return(super._evaluate(expr,extra));
}

pointer (class __sub_expr_elem) scalar __bayes_expr_group::clone(
		|pointer (class __sub_expr_elem) scalar pE)
{
	return(super.clone(pE))
}

string scalar __bayes_expr_group::subexpr()
{
	return(super.subexpr())
}

string scalar __bayes_expr_group::tempname()
{
	return(super.tempname())
}

string scalar __bayes_expr_group::touse(|real scalar markout)
{
	return(super.touse(markout))
}

real scalar __bayes_expr_group::lhstype()
{
	return(super.lhstype())
}

real scalar __bayes_expr_group::estate()
{
	return(m_state->estate)
}

real scalar __bayes_expr_group::set_component(
		pointer (class __component_base) scalar pC)
{
	return(super.set_component(pC))
}

real scalar __bayes_expr_group::group_type()
{
	return(super.group_type())
}

void __bayes_expr_group::clear()
{
	super.clear()
}

real scalar __bayes_expr_group::post_resolve()
{
	return(super.post_resolve())
}

end
exit

