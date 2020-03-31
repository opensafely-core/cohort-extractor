*! version 1.1.6  26aug2019

mata: 

mata set matastrict on

void _bayesmh_parse_sub_expr(
	real scalar isequation, real scalar ismultieq, 
	string scalar expr, string scalar touse, string scalar nocons, 
	string scalar eqexpr_local, string scalar eqnolatent_local, 
	string scalar eqlatent_local, string scalar eqlatname_local, 
	string scalar pathlist_local, string scalar varlist_local, 
	string scalar feparams_local, string scalar feinit_local, 
	string scalar matparams_local, 
	string scalar totalre, string scalar retcode)
{
	real scalar rc, i, nlv, ntotalre, nooutput
	string rowvector lv, yvars, xvars, feparams, feinit, matparams
	string rowvector varlist, toks
	real colvector b, y
	string scalar path, eqnolatent, eqlatent, eqlatname, pathlist
	string scalar tsvar, panelvar
	string matrix stripe
	string scalar exprobj, exprname
	pointer(class __bayes_expr) scalar S
	real matrix mpanel, bmat
	real scalar srelease

	S = NULL
	exprobj = ""
	exprobj = st_global("MCMC_mexprobj")
	if (exprobj != "") {
		S = findexternal(exprobj)
		if (S == NULL) {
			rc = _stata(sprintf("mata: %s = __bayes_expr(1)",
				exprobj))
			S = findexternal(exprobj)
		}
	}
	srelease = 0
	if (S == NULL) {
		srelease = 1
		S = &__bayes_expr(1)
	}

	if (ismultieq) {
		S->set_multi_eq_on()
	}
	
	S->reset_parse()

	if (isequation & nocons == "noconstant") {
		expr = sprintf("%s, noconstant", expr)
	}

	yvars = ""
	tsvar = ""
	panelvar = ""
	nooutput = 1
	if (!(rc=_stata("tsset",nooutput))) {
		tsvar = st_global("r(timevar)")
		panelvar = st_global("r(panelvar)")
		if (ustrlen(tsvar)) {
			S->set_stata_tsvar(tsvar)
		}
		if (ustrlen(panelvar)) {
			S->set_stata_panelvar(panelvar)
		}
	}
	if (isequation) {
		rc = S->_parse_equation(expr, exprname, touse)
		yvars = invtokens(exprname)
	}
	else {
		rc = S->_parse_expression(expr, exprname, touse)
	}
	if (rc == 0) {
		rc = S->_resolve_expressions()
	}
	if (rc) {
		errprintf("{p}%s{p_end}\n",S->errmsg())
		st_numscalar(retcode, rc)
		if (srelease) {
			S->clear()
		}
		return
	}

	varlist = S->varlist(exprname)
	varlist = invtokens(varlist)

	eqnolatent = yvars
	eqlatent = ""
	eqlatname = ""
	pathlist = ""

	feparams  = J(1, 0, "")
	matparams = J(1, 0, "")

	stripe = S->expr_stripe(exprname)
	if (cols(stripe) == 2) {
		bmat = S->parameters()
		xvars = stripe[,2]'
		feparams = J(1, rows(stripe), "")
		feinit   = J(1, rows(stripe), "")
		for (i = 1; i <= rows(stripe); i++) {
			toks = tokens(stripe[i,1], "/")
			if (length(toks) == 0) {
				toks = ""
			}
			if (length(toks) > 1 & toks[1] == "/") {
				toks = invtokens(toks[2..length(toks)])
			}
			if (toks[1] != "" & toks[1] != "." & toks[1] != "/") {
				feparams[i] = toks[1] + ":" + stripe[i,2]
			}
			else {
				feparams[i] = stripe[i,2]
			}
			feinit[i] = sprintf(`""%s %g""', feparams[i], bmat[i])
		}
	}
	feparams = invtokens(feparams)
	feinit   = invtokens(feinit)
	xvars    = invtokens(xvars)

	if (xvars != "") {
		if (eqnolatent  != "") {
			eqnolatent = eqnolatent + " "
		}
		eqnolatent = eqnolatent + xvars
	}

	stripe = S->mat_stripe(exprname)
	if (rows(stripe) > 0 & cols(stripe) == 2) {
		matparams = J(1, rows(stripe), "")
		for (i = 1; i <= rows(stripe); i++) {
			toks = tokens(stripe[i,1], "/")
			if (length(toks) == 0) {
				toks = ""
			}
			if (length(toks) > 1 && toks[1] == "/") {
				toks = invtokens(toks[2..length(toks)])
			}
			if (toks[1] != "" & toks[1] != "." & toks[1] != "/") {
				matparams[i] = toks[1] + ":" + stripe[i,2]
			}
			else {
				matparams[i] = stripe[i,2]
			}
		}
	}
	matparams = invtokens(matparams)

	lv = S->expr_latentvars(exprname)
	nlv = length(lv)
	ntotalre = 0
	for(i = 1; i <= nlv; i++) {
		path = S->LV_path(lv[i])
		eqlatent  = sprintf("%s %s[%s]", eqlatent,  lv[i], path)
		eqlatname = sprintf("%s %s", eqlatname, lv[i])
		pathlist  = sprintf("%s %s", pathlist,  path)
		mpanel = S->path_index_matrix(path)
		mpanel = uniqrows(mpanel)
		st_local(sprintf("%s_%s", totalre, lv[i]), 
			strofreal(rows(mpanel)))
		ntotalre = ntotalre + rows(mpanel)
	}

	if (matparams != "" & nlv > 0) {
		errprintf("Matrix parameter {bf:%s} and random effects {bf:%s} cannot be combined\n",
			matparams[1], eqlatent)
		st_numscalar(retcode, 198)
		if (srelease) {
			S->clear()
		}
		return
	}

	if (srelease) {
		S->clear()
	}
	if (eqexpr_local != "") {
		st_local(eqexpr_local, expr)
	}
	if (eqlatname_local != "") {
		st_local(eqlatname_local, eqlatname)
	}
	if (eqlatent_local != "") {
		st_local(eqlatent_local, eqlatent)
	}
	if (eqnolatent_local != "") {
		st_local(eqnolatent_local, eqnolatent)
	}
	if (varlist_local != "") {
		st_local(varlist_local, varlist)
	}
	if (pathlist_local != "") {
		st_local(pathlist_local, pathlist)
	}
	if (feparams_local != "") {
		st_local(feparams_local, feparams)
	}
	if (feinit_local != "") {
		st_local(feinit_local, feinit)
	}
	if (matparams_local != "") {
		st_local(matparams_local, matparams)
	}
	if (totalre != "") {
		st_local(totalre, strofreal(ntotalre))
	}
	if (retcode != "") {
		st_numscalar(retcode, 0)
	}
}

end
