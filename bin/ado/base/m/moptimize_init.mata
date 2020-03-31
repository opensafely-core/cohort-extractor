*! version 1.6.1  15feb2018
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'
findfile moptimize_include.mata
quietly include `"`r(fn)'"'

mata:

transmorphic scalar moptimize_init()
{
	`MoptStruct' M

	// NOTE: the opt__settings structure will point to the mopt__struct
	// structure and vice versa
	M.S		= optimize_init()
	moptimize_init_evaluatortype(M, `MOPT_evaltype_default')
	M.linked	= 0

	// items for the optimizer settings
	M.mopt_version		= `MOPT_version_default'
	M.caller_version	= `MOPT_caller_version_default'

	// equations
	mopt__set_ndepvars(M,`MOPT_ndepvars_default')
	M.obs		= `MOPT_obs_default'

	// equations
	mopt__set_eqsize(M,`MOPT_neq_default')
	M.kaux		= `MOPT_kaux_default'
	M.diparm	= `MOPT_diparm_default'

	// items for user defined arguments
	M.nuinfo		= `MOPT_nuinfo_default'
	M.uinfolist	= `MOPT_uinfolist_default'

	M.wname		= `MOPT_wname_default'
	M.wtype		= `OPT_wtype_none'
	M.weights	= NULL

	M.svy		= `MOPT_svy_default'

	// searching for initial values
	M.search		= `MOPT_search_default'
	M.search_quietly	= `OPT_onoff_off'
	M.search_feasible	= `MOPT_feasible_default'
	M.search_repeat		= `MOPT_repeat_default'
	M.search_rescale	= `MOPT_rescale_default'
	M.search_random	= `MOPT_restart_default'

	M.uvcetype	= `MOPT_vcetype_default'
	M.vce		= `MOPT_vcetype_default'

	// internal data management for equations
	M.eqdims	= `MOPT_eqdims_default'
	M.scale		= `MOPT_scale_default'
	M.h		= `MOPT_h_default'

	// user supplied names of Stata objects
	M.view		= c("matafavor") == "space"
	M.need_views	= `MOPT_need_views_default'
	M.st_user	= `MOPT_st_user_default'
	M.st_userprolog	= `MOPT_st_userprolog_default'
	M.st_trace	= `MOPT_st_trace_default'
	M.st_touse	= `MOPT_st_touse_default'
	M.st_sample	= `MOPT_st_touse_default'
	M.st_wvar	= `MOPT_st_wvar_default'
	M.k_autoCns	= `MOPT_k_autoCns_default'
	M.st_drop_macros= `MOPT_st_drop_macros_default'
	M.st_regetviews	= `MOPT_st_regetviews_default'
	M.st_tsops	= `MOPT_st_tsops_default'
	M.check		= `MOPT_check_default'
	M.st_rc		= `MOPT_st_rc_default'
	M.norc		= `MOPT_norc_default'

	// names of temporary Stata objects
	M.st_p		= `MOPT_st_p_default'
	M.st_v		= `MOPT_st_v_default'
	M.st_g		= `MOPT_st_g_default'
	M.st_H		= `MOPT_st_H_default'
	M.st_scores	= `MOPT_st_scores_default'
	M.st_xb		= `MOPT_st_xb_default'
	M.st_cmd_args	= `MOPT_st_cmd_args_default'
	M.st_tmp_w	= `MOPT_st_tmp_w_default'

	// pointers to views
	M.xb		= `MOPT_xb_default'
	M.hold_xb	= `OPT_onoff_off'

	// miscellaneous
	M.title		= `MOPT_title_default'
	M.valid		= `OPT_onoff_off'
	M.rescore	= `OPT_onoff_off'
	M.p_updated	= `OPT_onoff_off'
	M.interactive	= `OPT_onoff_off'
	
	// recallable ML evaluator
	M.usrname	= st_local("moptobj")
	M.dropmetoo	= st_local("dropmetoo")
	M.vmacros	= J(0,2,"")
	M.mmacros	= J(0,2,"")
	M.smacros	= J(0,2,"")
		
	return(M)
}

function moptimize_init_macros(`MoptStruct' M)
{

	real	scalar 	i, j, m, rc, i_v, i_m, i_s, notvar
	string	scalar	glnames
	string	vector	names

	if (M.usrname != "") {
		stata(sprintf(`"local check : all globals "S_ML_*""'))
		glnames = tokens(st_local("check"))
		
		// check for other globals in $GLIST
		glnames = glnames, tokens(st_global("GLIST"))
		m = cols(glnames)		
		
		// split globals into variables, matrices, and locals/scalars
		
		M.vmacros = M.mmacros = M.smacros = J(m,2,"")
		i_v = i_m = i_s = 0
		
		for (i=1; i<=m; i++) {
			notvar = 0
			names = tokens(st_global(glnames[1,i]))
			for (j=1; j<=cols(names); j++) {
				rc = _stata(sprintf("confirm numeric variable %s",names[j]),1)
				if (rc & j==1) notvar = 1
				if (rc==0 & notvar==0) { // variable
					if (j==1) i_v++
					stata( sprintf("capture clonevar %s%s = %s",M.usrname,names[j],names[j]) )
					M.vmacros[i_v,1] = glnames[1,i]
					M.vmacros[i_v,2] = M.vmacros[i_v,2] + " " + sprintf("%s%s",M.usrname,names[j])
				}
				else { 
					rc = _stata(sprintf("confirm matrix %s",names[j]),1)
					if (rc==0) { // matrix
						if (j==1) i_m++
						M.mmacros[i_m,1] = glnames[1,i]
						M.mmacros[i_m,2] = sprintf("%s",names[j])
					}
					else { // local or scalar (can be string or number)
						if (j==1) i_s++
						M.smacros[i_s,1] = glnames[1,i]
						M.smacros[i_s,2] = st_global(glnames[1,i])
						continue
					}
				}
			}
		}

		if (i_v) {
			M.vmacros = M.vmacros[|1,1 \ i_v,2|]
		}
		else 	M.vmacros = J(0,2,"")
		if (i_m) {
			M.mmacros = M.mmacros[|1,1 \ i_m,2|]
		}
		else 	M.mmacros = J(0,2,"")
		if (i_s) {
			M.smacros = M.smacros[|1,1 \ i_s,2|]
		}
		else 	M.smacros = J(0,2,"")		
	}
}

function moptimize_init_kaux(`MoptStruct' M, |real scalar k)
{
	if (args() == 1) {
		return(M.kaux)
	}
	if (k != floor(k) | k > M.neq | k < 0) {
		errprintf("invalid kaux argument;\n")
		if (k != floor(k)) {
			errprintf("kaux must be an integer\n")
		}
		else if (k < 0) {
			errprintf("negative values not allowed\n")
		}
		else {
			errprintf(
		"kaux cannot be larger than the number of equations\n")
		}
		exit(3498)
	}
	M.kaux	= (missing(k) ? 0 : k)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_diparm(`MoptStruct' M, |string vector diparm)
{
	if (args() == 1) {
		return(M.diparm)
	}
	M.diparm = diparm
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_title(`MoptStruct' M, |string scalar title)
{
	if (args() == 1) {
		return(M.title)
	}
	M.title = title
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_userinfo(`MoptStruct' M, real scalar i, |arg)
{
	if (i<1 | i>`MOPT_nuinfo_max' | i!=trunc(i)) {
		errprintf("invalid userinfo index\n")
		exit(3498)
	}
	if (args() == 2) {
		if (i > M.nuinfo) {
			errprintf("userinfo index too large\n")
			exit(3498)
		}
		if (M.uinfolist[i] == NULL) {
			return(J(0,0,.))
		}
		return(*M.uinfolist[i])
	}
	M.uinfolist[i] = &arg
	if (M.nuinfo < i) moptimize_init_nuserinfo(M, i)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_by(`MoptStruct' M, |by)
{
	if (args() == 1) {
		if (M.by != NULL) {
			return(M.by)
		}
		return(&J(0,1,.))
	}
	M.by	= NULL
	M.st_by	= ""
	if (isreal(by)) {
		mopt__check_need_views(M, "by")
		M.by = &by
	}
	else if (isstring(by)) {
		M.st_by = mopt__check_varnames(by, 0, 1, "by")
		if (strlen(M.st_by)) {
			M.by = &st_data(., M.st_by, M.st_touse)
		}
	}
	else {
		errprintf("invalid by argument\n")
		exit(3498)
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_constraints(`MoptStruct' M, |real matrix constraints)
{
	if (args() == 1) {
		return(optimize_init_constraints(M.S))
	}
	optimize_init_constraints(M.S,constraints)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_maxiter(`MoptStruct' M, |real scalar maxiter)
{
	if (args()==1) {
		return(optimize_init_conv_maxiter(M.S))
	}
	M.norc = (missing(maxiter) ? `OPT_onoff_off' : `OPT_onoff_on')
	optimize_init_conv_maxiter(M.S,maxiter)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_ndami(`MoptStruct' M, |scalar ndami)
{
	if (args()==1) {
		return(optimize_init_conv_ndami(M.S))
	}
	optimize_init_conv_ndami(M.S,ndami)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_gtol(`MoptStruct' M, |real scalar tol)
{
	if (args()==1) {
		return(optimize_init_conv_gtol(M.S))
	}
	optimize_init_conv_gtol(M.S, tol)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_nrtol(`MoptStruct' M, |real scalar tol)
{
	if (args()==1) {
		return(optimize_init_conv_nrtol(M.S))
	}
	optimize_init_conv_nrtol(M.S, tol)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_qtol(`MoptStruct' M, |real scalar tol)
{
	if (args()==1) {
		return(optimize_init_conv_qtol(M.S))
	}
	optimize_init_conv_qtol(M.S, tol)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_ignorenrtol(`MoptStruct' M, |scalar onoff)
{
	if (args()==1) {
		return(optimize_init_conv_ignorenrtol(M.S))
	}
	optimize_init_conv_ignorenrtol(M.S, onoff)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_ptol(`MoptStruct' M, |real scalar tol)
{
	if (args()==1) {
		return(optimize_init_conv_ptol(M.S))
	}
	optimize_init_conv_ptol(M.S, tol)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_vtol(`MoptStruct' M, |real scalar tol)
{
	if (args()==1) {
		return(optimize_init_conv_vtol(M.S))
	}
	optimize_init_conv_vtol(M.S, tol)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_notconcave(
	`MoptStruct'	M,
	|real	scalar	notconcave)
{
	if (args()==1) {
		return(optimize_init_conv_notconcave(M.S))
	}
	optimize_init_conv_notconcave(M.S, notconcave)
}

function moptimize_init_obs(`MoptStruct' M, |real scalar obs)
{
	if (args() == 1) {
		return(M.obs)
	}
	M.obs = obs
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_search_bounds(
	`MoptStruct'	M,
	real	scalar	eq,
	|real	vector	minmax)
{
	mopt__check_eqnum(eq, .)
	if (args() == 2) {
		if (eq > M.neq) {
			return(J(2,1,.))
		}
		return(M.eqbounds[,eq])
	}
	if (eq > M.neq) {
		mopt__set_eqsize(M,eq,1)
	}
	if (length(minmax) != 2) {
		errprintf("invalid search bounds argument\n")
		exit(503)
	}
	if (missing(minmax)) {
		M.eqbounds[1,eq] = .
		M.eqbounds[2,eq] = .
	}
	else {
		if (minmax[1] < minmax[2]) {
			M.eqbounds[1,eq] = minmax[1]
			M.eqbounds[2,eq] = minmax[2]
		}
		else {
			M.eqbounds[1,eq] = minmax[2]
			M.eqbounds[2,eq] = minmax[1]
		}
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_colnames(
	`MoptStruct' M,
	real	scalar		eq,
	|string	rowvector	eqcolnames
)
{
	mopt__check_eqnum(eq, .)
	if (args() == 2) {
		string	rowvector	colnames
		real	scalar		hascons

		if (eq > M.neq) {
			return(J(1,0,""))
		}
		hascons = M.eqcons[eq] != 0
		if (M.eqcolnames[eq] == NULL) {
			if (strlen(M.st_eqlist[eq])) {
				colnames = tokens(M.st_eqlist[eq])
				if (hascons) {
					colnames = colnames, "_cons"
				}
				return(colnames)
			}
			else if (M.eqlist[eq] == NULL) {
				if (hascons) {
					return("_cons")
				}
				else	return(J(1,0,""))
			}
			else if (isview(*M.eqlist[eq])) {
				real	vector	viewvars
				viewvars = st_viewvars(*M.eqlist[eq])
				if (missing(viewvars) == 0) {
					colnames = st_varname(
						st_viewvars(*M.eqlist[eq]))
					if (hascons) {
						colnames = colnames, "_cons"
					}
					return(colnames)
				}
			}
			real	scalar	j, dim

			dim = cols(*M.eqlist[eq])
			colnames = J(1, dim + hascons, "")
			for (j=1; j<=dim; j++) {
				colnames[j] = "x" + strofreal(j)
			}
			if (hascons) {
				colnames[dim+1] = "_cons"
			}
			return(colnames)
		}
		else {
			if (hascons) {
				colnames = *M.eqcolnames[eq], "_cons"
			}
			else	colnames = *M.eqcolnames[eq]
			return(colnames)
		}
	}
	if (eq > M.neq) {
		mopt__set_eqsize(M,eq,1)
	}
	if (cols(eqcolnames) == 0) {
		M.eqcolnames[eq] = NULL
	}
	else {
		if (M.eqlist[eq] == NULL) {
			errprintf("too %s columns in string vector\n", "many")
			exit(3200)
		}
		if (cols(*M.eqlist[eq]) != cols(eqcolnames)) {
			errprintf("too %s columns in string vector\n",
				cols(M.eqlist[eq]) > cols(eqcolnames) ?
				"few" : "many")
			exit(3200)
		}
		M.eqcolnames[eq] = &eqcolnames
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_coefs(
	`MoptStruct'		M,
	real	scalar		eq,
	|real	rowvector	eqcoefs
)
{
	if (missing(eq)) {
		if (args() == 2) {
			return(moptimize_init_coefs(M))
		}
		moptimize_init_coefs(M, eqcoefs)
		M.valid	= `OPT_onoff_off'
		return
	}

	mopt__check_eqnum(eq, .)
	if (args()==2) {
		if (eq <= M.neq) {
			if (M.eqcoefs[eq] != NULL) {
				return(*M.eqcoefs[eq])
			}
		}
		return(J(1,mopt__eqdim(M, eq),0))
	}
	if (eq > M.neq) {
		mopt__set_eqsize(M, eq, 1)
	}

	real	scalar		dim
	real	rowvector	mycoefs

	// NOTE: dim couldn't be zero since we would have called
	// 'mopt__set_eqsize()' above if 'eq' larger than the current number
	// of equations.

	dim	= mopt__eqdim(M, eq)
	if (cols(eqcoefs) != dim) {
		if (cols(eqcoefs) > dim) {
			errprintf("too many initial values for equation %f\n",
				eq)
		}
		else {
			errprintf("too few initial values for equation %f\n",
				eq)
		}
		exit(3498)
	}
	mycoefs	= eqcoefs
	M.eqcoefs[eq]	= &mycoefs
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_n(`MoptStruct' M, |real scalar n)
{
	if (args()==1) {
		return(M.neq)
	}
	mopt__set_eqsize(M, n, 1)
	robust_init_eq_n(M.S.R, n)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_cons(
	`MoptStruct'	M,
	real	scalar	eq,
	|	scalar	cons	// indicator for presence of constant
)
{
	real	scalar	hascons
	if (args() == 2) {
		mopt__check_eqnum(eq, M.neq)
		return(opt__onoff_numtostr(M.eqcons[eq]))
	}
	mopt__check_eqnum(eq, .)
	hascons	= opt__onoff(cons, "cons")
	if (eq > M.neq) {
		mopt__set_eqsize(M, eq, 1)
	}
	else if (M.eqcons[eq] != hascons) {
		M.eqcoefs[eq]	= NULL
	}
	M.eqcons[eq] = hascons
	robust_init_eq_cons(M.S.R, eq, cons)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_ndepvars(`MoptStruct' M, |real scalar n)
{
	if (args()==1) {
		return(M.ndepvars)
	}
	mopt__set_ndepvars(M, n, 1)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_depvar(
	`MoptStruct'	M,
	real	scalar	idx,
	|		y
)
{
	mopt__check_depvaridx(idx, .)
	if (args() == 2) {
		if (idx <= M.ndepvars) {
			if (M.depvars[idx] != NULL) {
				return(*M.depvars[idx])
			}
		}
		return(J(0,0,.))
	}
	if (idx > M.ndepvars) {
		mopt__set_ndepvars(M, idx, 1)
	}
	M.depvars[idx]		= NULL
	M.st_depvars[idx]	= ""
	if (isreal(y)) {
		mopt__check_need_views(M, "depvar")
		M.depvars[idx] = &y
	}
	else if (isstring(y)) {
		M.st_depvars[idx] =
			mopt__check_varnames(y, 0, ., "depvar", M.st_tsops)
		if (strlen(M.st_depvars[idx])) {
			M.depvars[idx] = &mopt__st_getdata(M,
				M.st_depvars[idx])
		}
	}
	else {
		errprintf("invalid depvar argument\n")
		exit(3498)
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_indepvars(
	`MoptStruct' M,
	real	scalar	eq,
	|		X,	// predictor matrix for equation 'eq'
		scalar	cons,	// indicator for presence of constant
	real	scalar	from_ml
)
{
	real	scalar	i, getdata

	mopt__check_eqnum(eq, .)
	if (args() == 2) {
		if (eq <= M.neq) {
			if (M.eqlist[eq] != NULL) {
				return(*M.eqlist[eq])
			}
		}
		return(J(0,0,.))
	}
	if (eq > M.neq) {
		mopt__set_eqsize(M, eq, 1)
	}
	M.eqlist[eq]	= NULL
	M.eqcoefs[eq]	= NULL
	M.st_eqlist[eq]	= ""
	if (isreal(X)) {
		mopt__check_need_views(M, "indepvars")
		if (cols(X)) {
			M.eqlist[eq] = &X
		}
		robust_init_eq_indepvars(M.S.R, eq, X)
	}
	else if (isstring(X)) {
		if (from_ml == 1) {
			M.st_eqlist[eq] = X
		}
		else {
			M.st_eqlist[eq] =
			mopt__check_varnames(X, 0,., "indepvars", M.st_tsops)
		}
		robust_init_eq_indepvars(M.S.R, eq, M.st_eqlist[eq])
		getdata = strlen(M.st_eqlist[eq])
		if (getdata) {
			for (i=1; i<=M.neq; i++) {
				if (i != eq) {
					if (M.st_eqlist[eq] == M.st_eqlist[i]) {
						M.eqlist[eq] = M.eqlist[i]
						getdata = 0
						break
					}
				}
			}
		}
		if (getdata) {
			M.eqlist[eq] = &mopt__st_getdata(M, M.st_eqlist[eq])
		}
	}
	else {
		errprintf("invalid indepvars argument\n")
		exit(3498)
	}
	if (args() >= 4) {
		moptimize_init_eq_cons(M, eq, cons)
		robust_init_eq_cons(M.S.R, eq, cons)
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_name(
	`MoptStruct' M,
	real	scalar	eq,
	|string	scalar	eqname
)
{
	mopt__check_eqnum(eq, .)
	if (args() == 2) {
		if (eq > M.neq) {
			return("eq"+strofreal(eq))
		}
		if (M.eqnames[eq] == "") {
			return("eq"+strofreal(eq))
		}
		return(M.eqnames[eq])
	}
	if (eq > M.neq) {
		mopt__set_eqsize(M, eq, 1)
	}
	if (!st_isname(eqname)) {
		errprintf("%s invalid equation name\n", eqname)
		exit(198)
	}
	M.eqnames[eq] = eqname
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_names(
	`MoptStruct'	M,
	|string	scalar	eqnames
)
{
	if (args() == 1) {
		return(invtokens(M.eqnames))
	}
	string rowvector names
	names = tokens(eqnames)
	if (cols(names) != M.neq) {
		errprintf("too %s equation names",
			cols(M.eqnames) < M.neq ? "few" : "many")
		exit(3200)
	}
	swap(M.eqnames, names)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_offset(
	`MoptStruct'	M,
	real	scalar	eq,
	|		offset
)
{
	mopt__check_eqnum(eq, .)
	if (args() == 2) {
		if (eq <= M.neq) {
			if (! M.eqexposure[eq]) {
				if (M.eqoffset[eq] != NULL) {
					return(*M.eqoffset[eq])
				}
			}
		}
		return(J(0,1,.))
	}
	if (eq > M.neq) {
		mopt__set_eqsize(M, eq, 1)
	}
	M.eqoffset[eq]		= NULL
	M.st_eqoffset[eq]	= ""
	M.st_eqoffset_revar[eq]	= ""
	M.eqexposure[eq]	= 0
	if (isreal(offset)) {
		mopt__check_need_views(M, "offset")
		if (missing(offset)) {
			errprintf("missing values not allowed in offset\n")
			exit(3498)
		}
		M.eqoffset[eq] = &offset
	}
	else if (isstring(offset)) {

		M.st_eqoffset[eq] = mopt__check_varnames(offset,0,1,"offset",1)
		if (strlen(M.st_eqoffset[eq])) {
			M.st_eqoffset_revar[eq] = mopt__tsrevar(M.st_eqoffset[eq])
			// for a recallable ml evaluator, check if the offset var is a tempvar
			// and if so, make offset variable permanent and store in the dataset
			if (M.usrname != "") {
				if ( usubstr(M.st_eqoffset_revar[eq],1,2)=="__" ) {
					stata(sprintf("capture clonevar %s%s = %s",M.usrname,
						M.st_eqoffset_revar[eq],M.st_eqoffset_revar[eq]))
					M.st_eqoffset_revar[eq] = M.usrname + M.st_eqoffset_revar[eq]
				}
			}
			M.eqoffset[eq] = &mopt__st_getdata(M, M.st_eqoffset_revar[eq])
		}
	}
	else {
		errprintf("invalid offset argument\n")
		exit(3498)
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_exposure(
	`MoptStruct'	M,
	real	scalar	eq,
	|		exposure
)
{
	mopt__check_eqnum(eq, .)
	if (args() == 2) {
		if (eq <= M.neq) {
			if (M.eqexposure[eq]) {
				if (M.eqoffset[eq] != NULL) {
					return(*M.eqoffset[eq])
				}
			}
		}
		return(J(0,1,.))
	}
	if (eq > M.neq) {
		mopt__set_eqsize(M, eq, 1)
	}
	M.eqoffset[eq]		= NULL
	M.st_eqoffset[eq]	= ""
	M.st_eqoffset_revar[eq]	= ""
	M.eqexposure[eq]	= 1
	if (isreal(exposure)) {
		mopt__check_need_views(M, "exposure")
		if (missing(exposure)) {
			errprintf("missing values not allowed in exposure\n")
			exit(3498)
		}
		M.eqoffset[eq] = &exposure
	}
	else if (isstring(exposure)) {
		M.st_eqoffset[eq] = mopt__check_varnames(exposure, 0,1,
			"exposure", 1)
		if (strlen(M.st_eqoffset[eq])) {
			M.st_eqoffset_revar[eq] = mopt__tsrevar(M.st_eqoffset[eq])
			M.eqoffset[eq] = &mopt__st_getdata(M,
				M.st_eqoffset_revar[eq])
		}
	}
	else {
		errprintf("invalid exposure argument\n")
		exit(3498)
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_eq_freeparm(
	`MoptStruct'	M,
	real	scalar	eq,
	|	scalar	onoff)
{
	mopt__check_eqnum(eq, .)
	if (args() == 2) {
		if (eq <= M.neq) {
			return(M.eqfreeparm[eq])
		}
	}
	if (eq > M.neq) {
		mopt__set_eqsize(M, eq, 1)
	}
	M.eqfreeparm[eq] = opt__onoff(onoff, "freeparm")
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_evaluator(`MoptStruct' M, |scalar f)
{
	if (args() == 1) {
		return(optimize_init_evaluator(M.S))
	}
	if (! strlen(M.st_userprolog)) {
		M.need_views	= 0
	}
	if (ispointer(f)) {
		optimize_init_evaluator(M.S, f)
	}
	else if (isstring(f)) {
		string	scalar	user

		user = strtrim(f)
		if (strlen(user)) {
			mopt__st_check_program(user)
			M.st_user = user
			mopt__update_st_user(M)
			M.need_views	= 1
		}
		else {
			M.st_user = ""
			optimize_init_evaluator(M.S, NULL)
		}
	}
	else {
		errprintf("invalid evaluator argument\n")
		exit(3498)
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_evaluatortype(`MoptStruct' M, |scalar type)
{
	if (args() == 1) {
		return(optimize_init_evaluatortype(M.S))
	}
	else if (isstring(type)) {
		opt__init_evaltype(M.S,type,1)
	}
	else {
		errprintf("invalid evaluator type\n")
		exit(3498)
	}
	if (strlen(M.st_user)) {
		mopt__update_st_user(M)
	}
	M.valid	= `OPT_onoff_off'
}

/*STATIC*/ void mopt__update_st_user(`MoptStruct' M)
{
	string	scalar	name 
	pointer	scalar	pf

	name	= sprintf("mopt__st_user_%s()", M.S.evaltype_f)
	pf	= findexternal(name)
	if (pf == NULL) {
		errprintf("%s not found\n", name)
		exit(3498)
	}
	optimize_init_evaluator(M.S, pf)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_iterprolog(`MoptStruct' M, |scalar f)
{
	if (args() == 1) {
		return(optimize_init_iterprolog(M.S))
	}
	if (! strlen(M.st_user)) {
		M.need_views	= 0
	}
	if (ispointer(f)) {
		optimize_init_iterprolog(M.S, f)
	}
	else if (isstring(f)) {
		M.need_views	= 1
		M.st_userprolog = strtrim(f)
		mopt__update_st_userprolog(M)
	}
	else {
		errprintf("invalid iterprolog argument\n")
		exit(3498)
	}
	M.valid	= `OPT_onoff_off'
}

void mopt__update_st_userprolog(`MoptStruct' M)
{
	pointer	scalar	pf

	if (strlen(M.st_userprolog)) {
		pf	= &mopt__st_prolog()
	}
	else {
		pf	= NULL
	}
	optimize_init_iterprolog(M.S, pf)
}

function moptimize_init_derivprolog(`MoptStruct' M, |scalar f)
{
	if (args() == 1) {
		return(optimize_init_derivprolog(M.S))
	}
	if (! strlen(M.st_user)) {
		M.need_views	= 0
	}
	if (!ispointer(f)) {
		errprintf("invalid derivprolog argument\n")
		exit(3498)
	}
	optimize_init_derivprolog(M.S, f)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_ado(`MoptStruct' M, string trace)
{
	if (trace == "on") {
		M.st_trace = "mopt_trace"
	}
	else if (trace == "off") {
		M.st_trace = `MOPT_st_trace_default'
	}
	else {
		errprintf("invalid trace argument\n")
		exit(3498)
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_vcetype(`MoptStruct' M, |scalar uvcetype)
{
	if (args() == 1) {
		return(mopt__vcetype_str(M))
	}
	if (isstring(uvcetype)) {
		M.uvcetype = mopt__vcetype_str(M, uvcetype)
	}
	else if (isreal(uvcetype)) {
		M.uvcetype = mopt__vcetype_num(M, uvcetype)
	}
	else {
		errprintf("invalid vcetype argument")
		exit(3498)
	}
	M.valid	= `OPT_onoff_off'
}

real scalar mopt__vcetype_num(`MoptStruct' M, |real scalar uvcetype)
{
	if (args() == 1) {
		return(M.uvcetype)
	}
	if (M.svy == `OPT_onoff_on' & uvcetype != `MOPT_vcetype_svy') {
		errprintf("svy option is not allowed with vce type\n")
		exit(3498)
	}
	real	scalar	v
	pragma	unset	v
	opt__set_int(v, uvcetype, 0, `MOPT_vcetype_max')
	return(v)
}

string scalar mopt__vcetype_numtostr(real scalar vce)
{
	if (vce == 0) {
		return(`MOPT_vcetype0')
	}
	if (vce == 1) {
		return(`MOPT_vcetype1')
	}
	if (vce == 2) {
		return(`MOPT_vcetype2')
	}
	if (vce == 3) {
		return(`MOPT_vcetype3')
	}
	if (vce == 4) {
		return(`MOPT_vcetype4')
	}
	if (vce == 5) {
		return(`MOPT_vcetype5')
	}
	return(`MOPT_vcetype0')
}

scalar mopt__vcetype_str(`MoptStruct' M, |string scalar uvcetype)
{
	if (args() == 1) {
		return(mopt__vcetype_numtostr(M.uvcetype))
	}
	if (M.svy == `OPT_onoff_on' & uvcetype != "svy") {
		errprintf("svy option is not allowed with vce type\n")
		exit(3498)
	}
	real	scalar	len
	len = strlen(uvcetype)
	if (uvcetype == `MOPT_vcetype0') {
		return(0)
	}
	else if (uvcetype == `MOPT_vcetype1') {
		return(1)
	}
	else if (uvcetype == `MOPT_vcetype2') {
		return(2)
	}
	else if (uvcetype == bsubstr(`MOPT_vcetype3',1,max((1,len)))) {
		// Robust
		return(3)
	}
	else if (uvcetype == bsubstr(`MOPT_vcetype4',1,max((2,len)))) {
		// CLuster
		return(4)
	}
	else if (uvcetype == `MOPT_vcetype5') {
		return(5)
	}
	else {
		errprintf("invalid vcetype argument\n")
		exit(3498)
	}
}

function moptimize_init_search_feasible(`MoptStruct' M, |real scalar feasible)
{
	if (args() == 1) {
		return(M.search_feasible)
	}
	if (feasible != trunc(feasible) | feasible < 0) {
		errprintf("invalid count argument\n")
		exit(3498)
	}
	M.search_feasible = feasible
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_caller_version(`MoptStruct' M, | real scalar v)
{
	if (args() == 1) {
		return(M.caller_version)
	}
	M.caller_version = v
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_nuserinfo(`MoptStruct' M, |real scalar n)
{
	if (args()==1) {
		return(M.nuinfo)
	}
	if (n<0 | n>9 | n!=trunc(n)) {
		errprintf("invalid argument index\n")
		exit(3498)
	}
	M.nuinfo = n
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_coefs(`MoptStruct' M, |real rowvector b0)
{
	if (args() == 1) {
		return(mopt__build_b0(M))
	}
	real	scalar	neq, dim, i, c1, c2

	neq	= M.neq
	mopt__build_eqdims(M)
	dim	= M.eqdims[2,neq]
	if (cols(b0) != dim) {
		if (cols(b0) > dim) {
			errprintf("too many initial values\n")
		}
		else {
			errprintf("too few initial values\n")
		}
		exit(3498)
	}
	for (i=1; i<=neq; i++) {
		c1	= M.eqdims[1,i]
		c2	= M.eqdims[2,i]
		M.eqcoefs[i] = &b0[|c1\c2|] 

	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_reset_p0(`MoptStruct' M)
{
	real	scalar	valid
	optimize_reset_p0(M.S)
	valid	= M.valid
	moptimize_init_coefs(M, optimize_init_params(M.S))
	M.valid	= valid
}

function mopt__reset_valid(`MoptStruct' M)
{
	M.valid = `OPT_onoff_off'
	M.S.valid = `OPT_onoff_off'
}

function moptimize_reset_params(`MoptStruct' M, real rowvector params)
{
	optimize_reset_params(M.S, params)
}

function moptimize_init_touse(`MoptStruct' M, |scalar touse)
{
	if (args() == 1) {
		return(M.st_touse)
	}
	if (isstring(touse)) {
		M.st_touse = touse
	}
	else if (isreal(touse)) {
		M.st_touse = st_varname(touse)
	}
	else {
		errprintf("invalid sample argument\n")
		exit(3498)
	}
	robust_init_touse(M.S.R, touse)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_touse_full(`MoptStruct' M, |scalar touse)
{
	if (args() == 1) {
		return(M.st_sample)
	}
	if (isstring(touse)) {
		M.st_sample = touse
	}
	else if (isreal(touse)) {
		M.st_sample = st_varname(touse)
	}
	else {
		errprintf("invalid sample argument\n")
		exit(3498)
	}
	robust_init_touse(M.S.R, touse)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_search_repeat(`MoptStruct' M, |real scalar random)
{
	if (args() == 1) {
		return(M.search_repeat)
	}
	if (random != trunc(random) | random < 0) {
		errprintf("invalid count argument\n")
		exit(3498)
	}
	M.search_repeat = random
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_search_rescale(`MoptStruct' M, |scalar rescale)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(M.search_rescale))
	}
	M.search_rescale = opt__onoff(rescale, "search rescale")
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_search_random(`MoptStruct' M, |scalar random)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(M.search_random))
	}
	M.search_random = opt__onoff(random, "search random")
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_search(`MoptStruct' M, |scalar search)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(M.search))
	}
	if (!isreal(search)) {
		if (search == "quietly") {
			search = "on"
			M.search_quietly = `OPT_onoff_on'
		}
	}
	M.search = opt__onoff(search, "search")
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_singularHmethod(`MoptStruct' M, |string scalar method)
{
	if (args() == 1) {
		return(optimize_init_singularHmethod(M.S))
	}
	optimize_init_singularHmethod(M.S,method)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_step_forward(`MoptStruct' M, |scalar onoff)
{
	if (args() == 1) {
		return(optimize_init_step_forward(M.S))
	}
	optimize_init_step_forward(M.S,onoff)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_technique(`MoptStruct' M, |string scalar technique)
{
	if (args() == 1) {
		return(optimize_init_technique(M.S))
	}
	optimize_init_technique(M.S,technique)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_deriv_h(`MoptStruct' M, |real rowvector h)
{
	if (args() == 1) {
		return(M.h)
	}
	M.h = h
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_deriv_scale(`MoptStruct' M, |real rowvector scale)
{
	if (args() == 1) {
		return(M.scale)
	}
	M.scale = scale
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_deriv_search(`MoptStruct' M, |scalar method)
{
	if (args() == 1) {
		return(optimize_init_deriv_search(M.S))
	}
	optimize_init_deriv_search(M.S, method)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_tracelevel(`MoptStruct' M, |scalar trace)
{
	if (args() == 1) {
		return(optimize_init_tracelevel(M.S))
	}
	optimize_init_tracelevel(M.S,trace)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_value(`MoptStruct' M, |scalar value)
{
	if (args() == 1) {
		return(optimize_init_trace_value(M.S))
	}
	optimize_init_trace_value(M.S,value)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_tol(`MoptStruct' M, |scalar tol)
{
	if (args() == 1) {
		return(optimize_init_trace_tol(M.S))
	}
	optimize_init_trace_tol(M.S,tol)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_step(`MoptStruct' M, |scalar step)
{
	if (args() == 1) {
		return(optimize_init_trace_step(M.S))
	}
	optimize_init_trace_step(M.S,step)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_paramdiffs(`MoptStruct' M, |scalar pdiffs)
{
	if (args() == 1) {
		return(optimize_init_trace_paramdiffs(M.S))
	}
	optimize_init_trace_paramdiffs(M.S,pdiffs)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_coefdiffs(`MoptStruct' M, |scalar pdiffs)
{
	if (args() == 1) {
		return(optimize_init_trace_paramdiffs(M.S))
	}
	optimize_init_trace_paramdiffs(M.S,pdiffs)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_params(`MoptStruct' M, |scalar params)
{
	if (args() == 1) {
		return(optimize_init_trace_params(M.S))
	}
	optimize_init_trace_params(M.S,params)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_coefs(`MoptStruct' M, |scalar params)
{
	if (args() == 1) {
		return(moptimize_init_trace_params(M))
	}
	moptimize_init_trace_params(M,params)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_gradient(`MoptStruct' M, |scalar gradient)
{
	if (args() == 1) {
		return(optimize_init_trace_gradient(M.S))
	}
	optimize_init_trace_gradient(M.S,gradient)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_Hessian(`MoptStruct' M, |scalar hessian)
{
	if (args() == 1) {
		return(optimize_init_trace_Hessian(M.S))
	}
	optimize_init_trace_Hessian(M.S,hessian)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_trace_dots(`MoptStruct' M, |scalar dots)
{
	if (args() == 1) {
		return(optimize_init_trace_dots(M.S))
	}
	optimize_init_trace_dots(M.S,dots)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_iterid(`MoptStruct' M, |string scalar iter_id)
{
	if (args() == 1) {
		return(optimize_init_iterid(M.S))
	}
	optimize_init_iterid(M.S,iter_id)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_valueid(`MoptStruct' M, |string scalar value_id)
{
	if (args() == 1) {
		return(optimize_init_valueid(M.S))
	}
	optimize_init_valueid(M.S,value_id)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_verbose(`MoptStruct' M, |scalar verbose)
{
	if (args() == 1) {
		return(optimize_init_verbose(M.S))
	}
	optimize_init_verbose(M.S, verbose)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_weight(`MoptStruct' M, |weights, scalar wtype)
{
	if (args() == 1) {
		return(optimize_init_weight(M.S))
	}
	if (M.svy == `OPT_onoff_on') {
		errprintf("svy option is not allowed with weights\n")
		exit(3498)
	}
	M.st_wvar	= `MOPT_st_wvar_default'
	M.wname		= `MOPT_st_wvar_default'
	if (isreal(weights)) {
		M.wname	= nameexternal(&weights)
		optimize_init_weight(M.S, weights)
	}
	else if (isstring(weights)) {
		M.st_wvar = mopt__check_varnames(weights, 0,1, "weight")
		if (strlen(M.st_wvar)) {
			optimize_init_weight(M.S, 
				mopt__st_getdata(M, M.st_wvar))
		}
		else {
			optimize_init_weight(M.S, `OPT_weights_default')
			optimize_init_weighttype(M.S, "")
		}
	}
	else {
		errprintf("invalid weight argument\n")
		exit(3498)
	}
	if (args() == 3) {
		moptimize_init_weighttype(M, wtype)
	}
	else if (M.wtype == `OPT_wtype_none') {
		moptimize_init_weighttype(M, "fw")
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_weighttype(
	`MoptStruct'	M,
	|scalar		wtype
)
{
	if (args() == 1) {
		return(optimize_init_weighttype(M.S))
	}
	if (M.svy == `OPT_onoff_on') {
		errprintf("svy option is not allowed with weights\n")
		exit(3498)
	}
	optimize_init_weighttype(M.S, wtype)
	M.wtype = opt__wtype_num(M.S)
	if (M.wtype == `OPT_wtype_none') {
		optimize_init_weight(M.S, `OPT_weights_default')
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_which(`MoptStruct' M, |scalar minimize)
{
	if (args() == 1) {
		return(optimize_init_which(M.S))
	}
	optimize_init_which(M.S,minimize)
	M.valid	= `OPT_onoff_off'
}

function mopt__which_num(`MoptStruct' M, |real scalar minimize)
{
	if (args() == 1) {
		return(optimize_init_which_num(M.S))
	}
	optimize_init_which_num(M.S, minimize)
}

function mopt__which_str(`MoptStruct' M, |real scalar minimize)
{
	if (args() == 1) {
		return(optimize_init_which_str(M.S))
	}
	optimize_init_which_str(M.S, minimize)
}

function moptimize_init_negH(`MoptStruct' M, |real scalar negH)
{
	if (args() == 1) {
		return(optimize_init_negH(M.S))
	}
	optimize_init_negH(M.S,negH)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_conv_warning(`MoptStruct' M, |scalar warn)
{
	if (args() == 1) {
		return(optimize_init_conv_warning(M.S))
	}
	optimize_init_conv_warning(M.S,warn)
	M.valid	= `OPT_onoff_off'
}

function mopt__conv_warn_num(`MoptStruct' M, |real scalar warn)
{
	if (args() == 1) {
		return(optimize_init_conv_warn_num(M.S))
	}
	optimize_init_conv_warn_num(M.S, warn)
}

function mopt__conv_warn_str(`MoptStruct' M, |real scalar warn)
{
	if (args() == 1) {
		return(optimize_init_conv_warn_str(M.S))
	}
	optimize_init_conv_warn_str(M.S, warn)
}

function moptimize_init_evaluations(`MoptStruct' M, |scalar count)
{
	if (args() == 1) {
		return(optimize_init_evaluations(M.S))
	}
	optimize_init_evaluations(M.S, count)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_gnweightmatrix(`MoptStruct' M, |real matrix A)
{
	if (args() == 1) {
		return(optimize_init_gnweightmatrix(M.S))
	}
	optimize_init_gnweightmatrix(M.S, A)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_nmsimplexdeltas(`MoptStruct' M, |real matrix delta)
{
	if (args() == 1) {
		return(optimize_init_nmsimplexdeltas(M.S))
	}
	optimize_init_nmsimplexdeltas(M.S, delta)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy(`MoptStruct' M, |scalar svy)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(M.svy))
	}
	if (M.wtype != `OPT_wtype_none') {
		errprintf("svy option is not allowed with weights\n")
		exit(3498)
	}
	robust_init_skip_setup(M.S.R, "off")
	optimize_init_svy(M.S, svy)
	M.svy = (optimize_init_svy(M.S) == "on")
	M.valid	= `OPT_onoff_off'
}

void mopt__rebuild_data(`MoptStruct' M, real scalar force)
{
	real	scalar		i
	real	scalar		dim

	if (!force &	(!M.st_regetviews |
			(!M.need_views	& M.view != `OPT_onoff_on'))) {
		return
	}

	// 'mopt' (the Stata program) performed the following
	//
	//	. preserve
	//	. keep if $ML_samp
	//
	// that resulted in less observations in the dataset, so we
	// need to rebuild the views.

	dim = M.ndepvars
	for (i=1; i<=dim; i++) {
		if (strlen(M.st_depvars[i])) {
			M.depvars[i] = &mopt__st_getdata(M,
				M.st_depvars[i])
		}
	}
	dim = M.neq
	for (i=1; i<=dim; i++) {
		if (strlen(M.st_eqlist[i])) {
			M.eqlist[i] = &mopt__st_getdata(M,
				M.st_eqlist[i])
		}
		if (strlen(M.st_eqoffset[i])) {
			M.eqoffset[i] = &mopt__st_getdata(M,
				M.st_eqoffset_revar[i])
		}
	}
}

function moptimize_init_svy_setup(`MoptStruct' M)
{
	`Errcode'		ec
	real	scalar		nobs, i, force
	real	colvector	w, sub
	string	scalar		name, wvar, subuse
	string	rowvector	posts
	string	scalar		calmeth

	if (!strlen(M.st_touse)) {
		nobs	= st_nobs()
	}
	else {
		stata(sprintf("quietly count if %s", M.st_touse))
		nobs	= st_numscalar("r(N)")
	}

	robust_svy_setup(M.S.R)
	robust_init_skip_setup(M.S.R, "on")

	// NOTE: robust_svy_setup() could generate a temporary 'touse'
	// variable if one hasn't been set.

	force	= 0
	name	= robust_name_touse(M.S.R)
	if (strlen(name)) {
		stata(sprintf("quietly count if %s", name))
		if (nobs != st_numscalar("r(N)")) {
			force		= 1
			M.st_sample	= name
			nobs		= st_numscalar("r(N)")
		}
	}

	mopt__rebuild_data(M, force)

	posts	= robust_name_poststrata(M.S.R)
	calmeth	= robust_name_calmethod(M.S.R)
	if (robust_init_svyset(M.S.R) == "on") {
		subuse	= robust_init_subuse(M.S.R)
	}
	else {
		robust_init_subuse(M.S.R, "")
	}

	wvar	= robust_name_weight(M.S.R)

	if (strlen(posts)) {
		// generate poststrata adjusted weights here
		posts	= tokens(posts)
		name	= st_tempname()
		ec = _stata(sprintf(`"quietly _rob_genw %s %s "%s" %s %s"',
			name,
			M.st_sample,
			robust_name_weight(M.S.R),
			posts[1],
			posts[2]))
		if (ec) exit(ec)
		w	= st_data(., name, M.st_sample)
	}
	else if (strlen(calmeth)) {
		// calibration adjusted weights
		name	= st_tempname()
		ec = _stata(sprintf(`"quietly _rob_calw %s %s "%s""',
			name,
			M.st_sample,
			robust_name_weight(M.S.R)))
		if (ec) exit(ec)
		w	= st_data(., name, M.st_sample)
	}
	else {
		if (strlen(wvar)) {
			w	= robust_init_weight(M.S.R)
		}
	}

	// reset out of subpop weight values to zero
	if (strlen(subuse)) {
		if (! rows(w)) {
			w	= J(nobs,1,1)
		}
		sub	= st_data(., subuse, M.st_sample)
		for (i=1; i<=nobs; i++) {
			if (!sub[i]) {
				w[i] = 0
			}
		}
	}

	if (rows(w)) {
		if (strlen(M.st_genwvar)) {
			if (missing(_st_varindex(M.st_genwvar))) {
				ec = _stata(sprintf("qui gen double %s = .",
					M.st_genwvar))
				if (ec) exit(ec)
			}
			st_view(sub=., ., M.st_genwvar, M.st_sample)
			sub[,]	= w
		}
		if (M.st_touse != M.st_sample) {
			st_view(sub=., ., M.st_touse, M.st_sample)
			w = select(w, sub)
		}
		optimize_init_weight(M.S, w)
		if (M.S.wtype == `OPT_wtype_none') {
			optimize_init_weighttype(M.S, "pweight")
		}
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_nstages(`MoptStruct' M,|real scalar K)
{
	if (args() == 1) {
		return(optimize_init_svy_nstages(M.S))
	}
	optimize_init_svy_nstages(M.S, K)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_stage_units(`MoptStruct' M, real scalar  k, |units)
{
	if (args() == 2) {
		return(optimize_init_svy_stage_units(M.S, k))
	}
	optimize_init_svy_stage_units(M.S, k, units)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_stage_strata(`MoptStruct' M, real scalar  k, |strata)
{
	if (args() == 2) {
		return(optimize_init_svy_stage_strata(M.S, k))
	}
	optimize_init_svy_stage_strata(M.S, k, strata)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_stage_fpc(`MoptStruct' M, real scalar  k, |fpc)
{
	if (args() == 2) {
		return(optimize_init_svy_stage_fpc(M.S, k))
	}
	optimize_init_svy_stage_fpc(M.S, k, fpc)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_weights(`MoptStruct' M, |weights, scalar wtype)
{
	if (args() == 1) {
		return(optimize_init_svy_weights(M.S))
	}
	if (args() == 2) {
		optimize_init_svy_weights(M.S, weights)
	}
	else {
		optimize_init_svy_weights(M.S, weights, wtype)
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_poststrata(`MoptStruct' M, |P)
{
	if (args() == 1) {
		return(optimize_init_svy_poststrata(M.S))
	}
	optimize_init_svy_poststrata(M.S, P)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_subpop(`MoptStruct' M, |subpop)
{
	if (args() == 1) {
		return(optimize_init_svy_subpop(M.S))
	}
	optimize_init_svy_subpop(M.S, subpop)
	if (strlen(optimize_name_svy_subpop(M.S))) {
		moptimize_init_svy(M, "on")
	}
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_genwvar(`MoptStruct' M, |string scalar wvar)
{
	if (args() == 1) {
		return(M.st_genwvar)
	}
	M.st_genwvar	= wvar
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_subuse(`MoptStruct' M, |string scalar subuse)
{
	if (args() == 1) {
		return(robust_init_subuse(M.S.R))
	}
	robust_init_subuse(M.S.R, subuse)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_cluster(`MoptStruct' M, |cluster)
{
	if (args() == 1) {
		return(optimize_init_cluster(M.S))
	}
	if (M.vce == `MOPT_vcetype_none') {
		if (isstring(cluster)) {
			if (any(strlen(cluster))) {
				M.vce = `MOPT_vcetype_cluster'
			}
		}
		else if (isreal(cluster)) {
			if (length(cluster)) {
				M.vce = `MOPT_vcetype_cluster'
			}
		}
	}
	optimize_init_cluster(M.S, cluster)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_singleunit(
	`MoptStruct'	M,
	|string	scalar	singleunit
)
{
	if (args() == 1) {
		return(optimize_init_svy_singleunit(M.S))
	}
	optimize_init_svy_singleunit(M.S, singleunit)
	M.valid	= `OPT_onoff_off'
}

function moptimize_init_svy_V_srs(
	`MoptStruct'	M,
	|real	scalar	srs
)
{
	if (args() == 1) {
		return(optimize_init_svy_V_srs(M.S))
	}
	optimize_init_svy_V_srs(M.S, srs)
	M.valid	= `OPT_onoff_off'
}

function mopt__init_doopt(`MoptStruct' M, |onoff)
{
	if (args() == 1) {
		return(opt__init_doopt(M.S))
	}
	opt__init_doopt(M.S, onoff)
}

function mopt__init_pupdated(`MoptStruct' M, |onoff)
{
	if (args() == 1) {
		return(M.p_updated)
	}
	M.p_updated = opt__onoff(onoff, "pupdated")
}

function moptimize_init_useviews(`MoptStruct' M, |scalar onoff)
{
	if (args() == 1) {
		if (M.view) {
			return("on")
		}
		return("off")
	}
	M.view = opt__onoff(onoff, "useviews")
	M.valid	= `OPT_onoff_off'
}


end
