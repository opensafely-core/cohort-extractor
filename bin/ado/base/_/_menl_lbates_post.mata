*! version 1.1.3  09jan2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_cov.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

local MENL_REL_ZERO = 1E-4
local TS_EXPR_LORDER 3	// defined in __sub_expr_object.matah

mata:

mata set matastrict on

void _menl_lbates_blups(class __menl_expr scalar expr, real scalar maxiter,
		real scalar tol, real scalar nrtol, string scalar log,				real scalar compse, real scalar reml, string vector scns,
		|string scalar touse2)
{
	real scalar i, j, conv, rc, noFE, klv, scalef
	real scalar iter, maxit, sse0, sse, srd
	real rowvector b
	string scalar sopts
	string vector lvs
	string matrix paths
	class __menl_pnls scalar pnls
	pointer (class __lvhierarchy) scalar hier
	pointer (struct _lvhinfo) scalar hinfo
	struct _menl_constraints scalar cns
	struct _menl_mopts scalar popts

	hier = expr.hierarchy()
	hinfo = hier->current_hinfo()
	if (hinfo == NULL) {
		/* no random effects					*/
		return
	}
	sopts = sprintf("iterate %g tolerance %g %s %s",maxiter,tol,
		(reml?"reml":"mle"),log)
	if (missing(nrtol)) {
		sopts = sopts + " nonrtolerance"
	}
	else {
		sopts = sprintf("%s nrtolerance %g",sopts,nrtol)
	}
	_menl_parse_mopts(sopts, popts, `MOPTS_DEFAULT_PNLS')

	if (ustrlen(touse2)) {
		pnls.set_subexpr(expr,touse2)
	}
	else {
		pnls.set_subexpr(expr)
	}
	if (strlen(scns)) {
		_menl_constraint_matrix(scns,cns)
	}
	paths = hier->paths()

	for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
		lvs = tokens(paths[i,`MENL_HIER_LV_NAMES'])
		klv = length(lvs)
		for (j=1; j<=klv; j++) {
			b = expr.RE_parameters(lvs[j])
			b = J(1,cols(b),0)
			(void)expr._set_RE_parameters(b,lvs[j])
		}
	}
	hier = NULL	// decrement reference count
	hinfo = NULL 	// decrement reference count
	expr.scale_covariances(`MENL_SCALE_DIVIDE',`MENL_FALSE')

	noFE = `MENL_TRUE'
	if (rc=pnls.initialize(cns,popts,noFE)) {
		errprintf("{p}%s{p_end}\n",pnls.errmsg())
		pnls.clear()
		exit(rc)
	}
	maxit = 10
	scalef = (pnls.rscale()==`MENL_RESID_SCALE_FITTED')
	if (scalef) {
		maxit = popts.maxiter
	}
	else {
		maxit = 1
	}
	sse0 = maxdouble()
	for (iter=1; iter<=maxit; iter++) {
		/* only optimize on the RE holding FE fixed		*/
		if (rc=pnls.run()) {
			if (rc == `MENL_RC_MISSING') {
				printf("{txt}{p 0 6 2}note: %s{p_end}\n",
					pnls.errmsg())
			}
			else {
				errprintf("{p}%s{p_end}\n",pnls.errmsg())
				pnls.clear()
				exit(rc)
			}
		}
		conv = pnls.converged(`MENL_CONVERGED_MOPT')
		if (scalef) {
			/* scale by fitted values
			 * 	outer loop for updating yhat		*/
			sse = pnls.fun_value()
			if (iter > 1) {
				srd = abs(sse-sse0)/(sse0+`MENL_REL_ZERO')
				if (srd < popts.ltol) {
					break
				}
				conv = `MENL_FALSE'
			}
			if (popts.itracelevel > `MENL_TRACE_NONE') {
				printf("\n{txt}Outer iteration %f: {col 15} " +
					"SSE = {res}%12.0g\n\n",iter,sse)
			}
			sse0 = sse

			if (iter < maxit) {
				if (rc=pnls.reinitialize(iter)) {
					errprintf("{p}%s{p_end}\n",
						pnls.errmsg())
					pnls.clear()
					exit(rc)
				}
			}
		}
	}
	if (!conv) {
		printf("{p 0 6 2}{txt}warning: convergence not achieved when " +
			"computing random effects{p_end}")
	}
	if (compse) {
		popts.maxiter = 0
		/* now get the standard errors				*/
		if (rc=pnls.initialize(cns,popts)) {
			errprintf("{p}%s{p_end}\n",pnls.errmsg())
			pnls.clear()
			exit(rc)
		}
		if (rc=pnls.run(compse)) {
			errprintf("{p}%s{p_end}\n",pnls.errmsg())
			pnls.clear()
			exit(rc)
		}
	}
	pnls.clear()
	/* used the scaled covariances to compute RE, need to put 
	 * them in the correct scale		 			*/
	expr.scale_covariances(`MENL_SCALE_MULTIPLY',`MENL_FALSE')
}

void _menl_blup_post(class __menl_expr scalar expr, string scalar spath,
		string vector vnames, string vector senames, 
		real scalar cumulative)
{
	real scalar klev, i, j, ivar, knms, ksnms, kv, klvs
	real scalar idm, ih
	real colvector id, re, b, se, io
	string scalar touse
	string vector lvs
	string matrix paths
	pointer (real vector) vector seRE
	pointer (class __lvhierarchy) scalar hier
	pointer (struct _lvhinfo) scalar hinfo
	class __lvpath scalar path, pathi

	pragma unset pathi
	pragma unset path

	/* assumption: vnames proper length				*/
	vnames = tokens(vnames[1])
	senames = tokens(senames[1])
	knms = length(vnames)

	/* assumption: data has hierarchical sort			*/
	hier = expr.hierarchy()
	ih = hier->hier_count()		// ih = 0 or 1
	if (!ih) {
		return
	}
	paths = hier->paths()
	(void)hier->set_current_hierarchy_index(ih)
	hinfo = hier->current_hinfo()
	i = hinfo->hrange[1]
	j = hinfo->hrange[2]
	paths = paths[|i,1\j,cols(paths)|]
	klev = rows(paths)
	(void)path.init("tmpname",spath)
	kv = 0
	if (ksnms=length(senames)) {
		seRE = expr.RE_stderr()
	}
	/* full estimation sample; may be larger because of TS ops	*/
	touse = expr.touse()
	for (i=1; i<=klev; i++) {
		pathi.clear()
		(void)pathi.init(sprintf("tmpname%g",i),
				paths[i,`MENL_HIER_PATH'])
		if (!cumulative) {
			if (!pathi.isequal(path)) {
				continue
			}
		}
		id = expr.path_index_vector(pathi.path())
		idm = max(id)
		lvs = tokens(paths[i,`MENL_HIER_LV_NAMES'])
		klvs = length(lvs)
		for (j=1; j<=klvs; j++) {
			if (knms < ++kv) {
				/* programmer error			*/
				errprintf("{p}error storing random effect " +
					"estimates; %g variables are too " +
					"few{p_end}\n",knms)
				hier = NULL
				hinfo = NULL
				seRE = NULL
				exit(498)
			}
			ivar = _st_varindex(vnames[kv])
			if (missing(ivar)) {	// should be
				(void)st_addvar("double",vnames[kv])
			}
			b = expr.RE_parameters(lvs[j])'
			if (idm > rows(b)) {
				/* programmer error			*/
				errprintf("{p}expected a random effect " +
					"vector of length %g but got %g;" +
					"cannot proceed{p_end}\n",idm,rows(b))
				hier = NULL
				hinfo = NULL
				seRE = NULL
				exit(506)
			}
			/* check for bad out-of-sample indices		*/
			io = id:>length(b)
			if (any(io)) {
				errprintf("invalid random effect vector " +
					"index\n")
				exit(503)
			}
			re = b[id]
			st_store(.,vnames[kv],touse,re)
			if (ksnms) {
				if (ksnms < kv) {
					/* programmer error		*/
					errprintf("{p}error storing random " +
						"effect estimates; %g " +
						"variables are too few" +
						"{p_end}\n",length(senames))
					hier = NULL
					hinfo = NULL
					seRE = NULL
					exit(498)
				}
				ivar = _st_varindex(senames[kv])
				if (missing(ivar)) {	// should be
					(void)st_addvar("double",senames[kv])
				}
				/* computed in the same order as lvs	*/
				b = (*seRE[i])[.,j]
				se = b[id]
				st_store(.,senames[kv],touse,se)
			}
		}
		if (pathi.isequal(path)) {
			break		// done
		}
	}
	seRE = NULL
	hier = NULL
	hinfo = NULL
}

void _menl_post_eval_expr(class __menl_expr scalar expr, string vector exnames,
		string vector vnames, string scalar spath)
{
	real scalar rc, i, j, kex, ivar, n, klev, ipath, klv, all
	real colvector ex
	real vector jv, b, TS_order
	string scalar pathi
	string vector exname, lvs, vtouse
	string matrix paths
	pointer (class __lvhierarchy) scalar hier
	pointer (struct _lvhinfo) scalar hinfo
	class __lvpath scalar path

	pragma unset ex

	exname = expr.expr_names()
	kex = length(exname)
	vnames = tokens(vnames)		// space delimited string
	exnames = tokens(exnames)
	if (kex != length(vnames)) {
		errprintf("expected %g variable names but got %g\n",kex,
			length(vnames))
		exit(498)
	}
	if (kex != length(exnames)) {
		errprintf("expected %g expression names but got %g\n",kex,
			length(exnames))
		exit(498)
	}
	hier = expr.hierarchy()
	hinfo = hier->current_hinfo()
	paths = hier->paths()
	hier = NULL
	if (hinfo == NULL) {
		/* either no random effects or -fixedonly- option 	*/
		if (ustrlen(spath)) {
			/* should not happen				*/
			errprintf("no random effects in the model\n")
			exit(322)		// no hierarchy
		}
	}
	else {
		i = hinfo->hrange[1]
		j = hinfo->hrange[2]
		hinfo = NULL
	
		paths = paths[|i,1\j,cols(paths)|]
	}
	klev = rows(paths)
	ipath = klev+1
	if (ustrlen(spath)) {
		/* set lower level REs to zero beyond specified path	*/
		(void)path.init("tmpname",spath)
		spath = path.path()
		for (i=1; i<=klev; i++) {
			pathi = paths[i,`MENL_HIER_PATH']
			if (pathi == spath) {
				ipath = i+1
				break
			}
		}
	}
	for (i=ipath; i<=klev; i++) {
		lvs = tokens(paths[i,`MENL_HIER_LV_NAMES'])
		klv = length(lvs)
		for (j=1; j<=klv; j++) {
			b = expr.RE_parameters(lvs[j])
			b = J(1,cols(b),0)
			(void)expr._set_RE_parameters(b,lvs[j])
		}
	}
	vtouse = J(1,kex,"")
	n = sum(st_data(.,expr.touse()))
	for (i=1; i<=kex; i++) {
		jv = strmatch(exnames,exname[i])
		if (!any(jv)) {
			continue
		}
		j = select(1..kex,jv)[1]
		TS_order = expr.TS_order(exnames[j])
		all = (TS_order[`TS_EXPR_LORDER']>0) // TS initial expr
		if (rc=expr._eval_expression(ex,exnames[j],all)) {
			errprintf("{p}failed to evaluate expression {bf:%s}"  +
				"{p_end}\n",exnames[j])
			exit(rc)
		}
		ivar = _st_varindex(vnames[j])
		if (missing(ivar)) { 	// should be
			(void)st_addvar("double",vnames[j])
		}
		if (length(ex) == 1) {
			ex = J(n,1,ex)
		}
		if (all) {
			vtouse[j] = expr.touse()
			/* full estimation sample; include TS init	*/
		}
		else {
			vtouse[j] = expr.touse(exnames[j])
		}
		st_store(.,vnames[j],vtouse[j],ex)
	}
	st_global("s(touse)",invtokens(vtouse))
}

void _menl_predict_stat(class __menl_expr scalar expr, string scalar svar,
		string scalar stat, string scalar spath,
		real scalar fixedonly)
{
	real scalar rc, i, j, i1, i2, klev, ipath, klv, scale
	real scalar vtype, kp, all
	string scalar depvar, touse
	real colvector yhat, result, r
	real rowvector b
	real matrix pinfo, psi
	string scalar pathi
	string vector lvs
	string matrix paths
	pointer (class __lvhierarchy) scalar hier
	pointer (struct _lvhinfo) scalar hinfo
	class __lvpath scalar path
	pointer (class __ecovmatrix) scalar var
	
	pragma unset yhat
	pragma unset result

	hier = expr.hierarchy()
	hinfo = hier->current_hinfo()
	if (!hier->current_hierarchy_index()) {	
		/* no random effects					*/
		fixedonly = `MENL_TRUE'
		klev = 0
		ipath = klev + 1
	}
	else {
		paths = hier->paths()
		i = hinfo->hrange[1]
		j = hinfo->hrange[2]
		hinfo = NULL
		paths = paths[|i,1\j,cols(paths)|]
		klev = rows(paths)
		ipath = klev + 1
		if (strlen(spath)) {
			/* set lower level REs to zero beyond specified
			 *  path					*/
			(void)path.init("tmpname",spath)
			spath = path.path()
			for (i=1; i<=klev; i++) {
				pathi = paths[i,`MENL_HIER_PATH']
				if (pathi == spath) {
					ipath = i+1
					break
				}
			}
		}
		else if (fixedonly) {
			/* set all REs to zero				*/
			ipath = 1
		}
	}
	for (i=ipath; i<=klev; i++) {
		lvs = tokens(paths[i,`MENL_HIER_LV_NAMES'])
		klv = length(lvs)
		for (j=1; j<=klv; j++) {
			b = expr.RE_parameters(lvs[j])
			b = J(1,cols(b),0)
			(void)expr._set_RE_parameters(b,lvs[j])
		}
	}
	depvar = expr.depvars()[1]

	all = (stat != "rstandard") 	// full estimation sample
	if (rc=expr._eval_equation(yhat,depvar,all)) {
		errprintf("{p}%s{p_end}\n",expr.errmsg())
		hier = NULL
		exit(rc)
	}
	if (missing(_st_varindex(svar))) {
		(void)st_addvar("double",svar)
	}
	if (all) {
		touse = expr.touse()	// maximum estimation sample
	}
	else {
		touse = expr.touse(depvar)
	}
	st_view(result,.,svar,touse)
	if (stat == "yhat") {
		result[.] = yhat
	}
	else {
		r = st_data(.,depvar,touse)-yhat
		if (stat == "rstandard") {
			var = expr.res_covariance()	// residual covariance
			vtype = var->vtype()
			if (vtype==var->POWER | vtype==var->CONSTPOWER |
				vtype==var->EXPONENTIAL) {
				var->set_fitted(yhat)
			}
			rc = hier->gen_current_panel_info(touse)
			if (rc) {
				errprintf("{p}%s{p_end}\n",hier->errmsg())
				hier = NULL
				var = NULL
				exit(rc)
			}
			pinfo = hier->current_panel_info()
			kp = rows(pinfo)

			scale = `SUBEXPR_TRUE'
			for (j=1; j<=kp; j++) {
				if (rc=var->compute_V(pinfo[j,.],scale)) {
					errprintf("{p}%s{p_end}\n",
						var->errmsg())
					hier = NULL
					var = NULL
					exit(rc)
				}
				psi = var->scale_matrix()
				if (missing(psi)) {
					errprintf("{p}residual covariance is " +
						"not positive definite{p_end}")
					hier = NULL
					var = NULL
					exit(506)
				}
				i1 = pinfo[j,1]
				i2 = pinfo[j,2]

				if (cols(psi) == 1) {
					r[|i1\i2|] = psi:*r[|i1\i2|]
				}
				else {
					r[|i1\i2|] = psi*r[|i1\i2|]
				}
			}
		}
		result[.] = r
	}
	var = NULL
	hier = NULL
}

void menl_parse_path(string scalar spath)
{
	real scalar k, i, rc
	string vector vlist
	class __lvpath scalar path

	if (rc=path.init("__tmpname",spath)) {
		st_global("s(errmsg)",sprintf("invalid path {bf:%s}: %s",
			spath,path.errmsg()))
		st_global("s(rc)",strofreal(rc))
		return
	}
	spath = path.path()
	st_global("s(path)",spath)

	vlist = tokens(path.varlist())
	k = length(vlist)
	st_global("s(kvar)",strofreal(k))

	for (i=1; i<=k; i++) {
		st_global(sprintf("s(var%g)",i),vlist[i])
	}

	vlist = path.hierarchy()
	k = length(vlist)
	st_global("s(klevel)",strofreal(k))

	for (i=1; i<=k; i++) {
		if (length(tokens(vlist[i])) > 1) {
			vlist[i] = subinstr(vlist[i]," ","#")
		}
		st_global(sprintf("s(level%g)",i),vlist[i])
	}
	st_global("s(rc)","0")
}

void _menl_estat_wcorrelation(class __menl_expr scalar expr,
		string scalar spath, string vector mnames, string scalar sobs,
		string scalar ssample, real scalar obsorder, string vector Cm)
{
	real scalar i, j, k, ih, kp, kh, khg, kt, all, rc
	real scalar i1, i2, j1, j2, scale, vtype
	real colvector w, obs, sample, order, f
	real rowvector p, path, sd
	real matrix X, tinfo, pinfo, R, V, D, PV, ip, Ri, Vi, T, a
	string scalar depvar, touse
	string rowvector pvnames
	string matrix stripe
	pointer (real matrix) vector vZ, vR
	pointer (struct _lvhinfo) scalar hinfo
	pointer (class __pathcovmatrix) vector covs
	pointer (class __lvhierarchy) scalar hier
	pointer (class __ecovmatrix) scalar var

	pragma unset w
	pragma unset X
	pragma unset vZ
	pragma unset R
	pragma unset Ri
	pragma unset p
	pragma unset PV
	pragma unset obs
	pragma unset sample
	pragma unset touse
	pragma unset f

	all = `SUBEXPR_TRUE'
	kp = 0
	depvar = expr.depvars()[1]
	touse = expr.touse(depvar)
	if (strlen(spath)) {
		path = st_matrix(spath)
		kp = cols(path)
		pvnames = st_matrixcolstripe(spath)[.,2]'
		st_view(PV,.,pvnames,touse)
		all = `SUBEXPR_FALSE'
	}
	mnames = tokens(mnames)
	if (length(mnames) != 3) {
		/* programmer error					*/
		errprintf("expected 3 matrix names, but got %g\n",
			length(mnames))
		exit(498)
	}
	hier = expr.hierarchy()
	kh = 0
	pinfo = hier->current_panel_info()		// residual panels
	if (ih=hier->current_hierarchy_index()) {
		hinfo = hier->current_hinfo()
		tinfo = *(hinfo->hinfo[1])		// top panels
		kh = khg = hinfo->kpath			// hierarchy depth
		khg = kh + hier->has_groupvar()		// depth + resid group
	}
	else {
		khg = hier->has_groupvar()		// group variable
		if (!khg) {
			/* cannot happen				*/
			errprintf("{p}no residual panels; a correlation " +
				"matrix cannot be computed{p_end}\n")
			exit(322)
		}
		tinfo = pinfo			 	// group panels
	}
	hier = NULL
	if (!all & kp > khg) {
		errprintf("at least one invalid level variable specified: " +
			"{bf:%s}\n",invtokens(pvnames,","))
		hinfo = NULL
		exit(198)
	}
	kt = rows(tinfo)
	w = st_data(.,depvar,touse)

	if (length(Cm)==2 & strlen(Cm[1]) & strlen(Cm[2])) {
		/* FV constraints for derivative efficiency		*/
		T = st_matrix(Cm[1])
		a = st_matrix(Cm[2])
		rc = _menl_linearize(expr,w,X,vZ,T,a)
	}
	else {
		rc = _menl_linearize(expr,w,X,vZ)
	}
	if (rc) {
		if (rc == `MENL_RC_MISSING') {
			errprintf("{txt}{p 0 6 2}note: %s{p_end}\n",
				expr.errmsg())
			rc = 0
		}
		else {
			errprintf("{p}%s{p_end}\n",expr.errmsg())
			k = length(vZ)
			for (i=1; i<=k; i++) {
				vZ[i] = NULL
			}
			vZ = J(1,0,NULL)
			hinfo = NULL
			exit(rc)
		}
	}
	vR = J(1,kh,NULL)
	if (ih) {
		covs = expr.path_covariances()
		j = 0
		for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
			vR[++j] = &J(1,1,(covs[i]->sqrt_matrix()))
		}
	}
	covs = NULL
	if (all) {
		i1 = 1
		i2 = sum(st_data(.,touse))
		ip = (i1,i2)
		kp = 1
		V = J(i2,i2,0)
		R = J(i2,i2,0)
	}
	else {
		ip = J(kp,2,.)
	}
	var = expr.res_covariance()
	vtype = var->vtype()
	if (vtype==var->POWER | vtype==var->CONSTPOWER | 
		vtype==var->EXPONENTIAL) {
		if (var->pvar_name() == `MENL_VAR_RESID_FITTED') {
			if (rc=_menl_eval_F(expr,depvar,f)) {
				var = NULL
                        	return(rc)
	                }
        	        var->set_fitted(f)
		}
	}
	scale = `MENL_TRUE'
	for (i=1; i<=kt; i++) {
		i1 = tinfo[i,1]
		i2 = tinfo[i,2]
		if (!all) {
			if (!any(path[1,1]:==PV[|i1,1\i2,1|])) {
				continue
			}
			ip[1,1] = i1
			ip[1,2] = i2
		}
		if (ih) {
			/* hinfo is the hierarchy panels
			 * pinfo is the residual panels			*/
			(void)_menl_panel_factor_cov(i,hinfo->hinfo,pinfo,
				vZ,*var,vR,Ri,p)
			p = invorder(p)
			Ri = Ri[.,p]
			Vi = Ri'Ri
		}
		else {
			if (rc=var->compute_V((i1,i2),scale)) {
				errprintf("{p}%s{p_end}\n",var->errmsg())
				var = NULL
				hinfo = NULL
				exit(rc)
			}
			Vi = var->V()
		}	
		if (cols(Vi) == 1) {
			Ri = I(rows(Vi))
			Vi = diag(Vi)
		}
		else {
			D = 1:/sqrt(diagonal(Vi))
			Ri = D:*Vi:*D'
			Ri = (Ri+Ri'):/2	// make perfectly symmetric
			Vi = (Vi+Vi'):/2
		}
		if (!all) {
			V = Vi
			R = Ri
			break
		}
		if (ih) {
			R[|i1,i1\i2,i2|] = Ri
		}
		V[|i1,i1\i2,i2|] = Vi
	}
	var = NULL
	k = length(vZ)
	for (i=1; i<=k; i++) {
		vZ[i] = NULL
	}
	vZ = J(1,0,NULL)
	for (i=1; i<=kh; i++) {
		vR[i] = NULL
	}
	vR = J(1,0,NULL)

	for (i=2; i<=kp; i++) {
		if (i > hinfo->kpath) {
			tinfo = hinfo->pinfo	// residual panels
		}
		else {
			tinfo = *(hinfo->hinfo[i])
		}
		j1 = i1
		j2 = i2
		for (j=1; j<=rows(tinfo); j++) {
			i1 = tinfo[j,1]
			i2 = tinfo[j,2]
			if (i1<j1 | i1>j2) {
				continue
			}
			if (i2<j1 | i2>j2) {
				continue
			}
			if (!any(path[1,i]:==PV[|i1,i\i2,i|])) {
				continue
			}
			ip[i,1] = i1
			ip[i,2] = i2
			break
		}
	}
	hinfo = NULL
	if (missing(ip)) {
		errprintf("{p}invalid level specification: {bf:%s}{p_end}\n",
			invtokens(pvnames:+"=":+strofreal(path),","))
		exit(198)
	}
	st_view(obs,.,sobs,touse)
	st_view(sample,.,ssample,touse)
	i1 = ip[kp,1]
	i2 = ip[kp,2]
	if (obsorder) {
		order = order(obs[|i1\i2|],1)
	}
	stripe = (J(i2-i1+1,1,""),strofreal(obs[|i1\i2|]))
	if (obsorder) {
		stripe = stripe[order,]
	}
	sample[|i1\i2|] = J(i2-i1+1,1,1)
	i1 = i1-ip[1,1]+1
	i2 = i2-ip[1,1]+1

	V = V[|i1,i1\i2,i2|]
	if (obsorder) {
		V = V[order,order']
	}
	st_matrix(mnames[3],V)
	st_matrixrowstripe(mnames[3],stripe)
	st_matrixcolstripe(mnames[3],stripe)

	R = R[|i1,i1\i2,i2|]
	if (obsorder) {
		R = R[order,order']
	}
	st_matrix(mnames[1],R)
	st_matrixrowstripe(mnames[1],stripe)
	st_matrixcolstripe(mnames[1],stripe)

	sd = sqrt(diagonal(V))'
	if (obsorder) {
		sd = sd[order']
	}
	st_matrix(mnames[2],sd)
	st_matrixcolstripe(mnames[2],stripe)
	st_matrixrowstripe(mnames[2],("","sd"))
}

end
exit
