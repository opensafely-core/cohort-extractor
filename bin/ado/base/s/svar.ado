*! version 1.7.4  07mar2019
program define svar, eclass byable(recall) sort
	local version = string(_caller())
	if `version' >= 11 {
		local vv "version `version':"
		local negh negh
	}
	version 8.1

	if replay() {
		if "`e(cmd)'" != "svar" {
			error 301
		}

		if _by() {
			error 190 
		}

		syntax [ , Level(cilevel) Full NOCNSReport *]
		
		_get_diopts options, `options'
		Dheadernew, `nocnsreport'
		if "`e(small)'" != "" {
			local dfr = e(df_r)
			ETable2, level(`level') dfr(`dfr') `options'
		}
		else {
			ETable2, level(`level') `options'
		}	
		exit
	} 

	local cmdline : copy local 0

	 syntax varlist(ts) [if] [in] , 		/*
	 	*/ [ACONstraints(numlist)		/* svar
		*/ AEq(string)				/* svar
		*/ ACns(string)				/* svar 
	 	*/ BCONstraints(numlist)		/* svar
		*/ BEq(string)				/* svar
		*/ BCns(string)				/* svar
		*/ LRCONstraints(numlist)		/* svar
		*/ LREq(string)				/* svar
		*/ LRCns(string)			/* svar
		*/ noIDENcheck				/* svar
		*/ Full					/* undocumented
		*/ var 					/* svar
		*/ from(string) 			/* svar
		*/ NOCNSReport				/* svar
	 	*/ LAgs(numlist integer >0 sort ) 	/* var
		*/ EXog(varlist ts)			/* var
		*/ VARConstraints(string)		/* var
		*/ noCONStant DFK			/* var 
		*/ LUTstats noBIGf			/* var
		*/ SMall				/* var
		*/ Level(cilevel) 			/* var
		*/ noISLOG				/* var
		*/ noISure				/* var
		*/ ISITerate(numlist max =1 integer >0 )/* var
		*/ ISTOLerance(numlist max =1 >0 <1 )	/* var
		*/ CONSTraints(numlist) 		/* undocumented
		*/ * ]					/* mlopts */
							
/* constraints() option appears for error checking only.  constraints()
 * are not allowed but it must be explicitly parsed or mlopts will
 * parse it.
 */


	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	if `"`s(collinear)'"' != "" {
		di as err "option collinear not allowed"
		exit 198
	}


	if "`islog'" != "" {
		local islog nolog
	}	

	if "`isiterate'" != "" {
		local isiterate "iterate(`isiterate')"
	}	

	if "`istolerance'" != "" {
		local istolerance "tolerance(`istolerance')"
	}	
	



	if "`isure'" != "" & "`varconstraints'" == "" {
		di as err "{cmd:noisure} cannot be specified without "	/*
			*/ "{cmd:varconstraints}"
		exit 198
	}	

	if "`islog'" != "" & "`varconstraints'" == "" {
		di as err "{cmd:noislog} cannot be specified without "	/*
			*/ "{cmd:constraints}"
		exit 198
	}	
	if "`istolerance'" != "" & "`varconstraints'" == "" {
		di as err "{cmd:istolerance()} cannot be specified without "/*
			*/ "{cmd:varconstraints}"
		exit 198
	}	

	if "`isiterate'" != "" & "`varconstraints'" == "" {
		di as err "{cmd:isiterate()} cannot be specified without "/*
			*/ "{cmd:varconstraints}"
		exit 198
	}	


	if "`isure'" != "" {
		if "`isiterate'" != "" {
			di as err "{cmd:isiterate} cannot be specified "/*
				*/ "with {cmd:noisure}"
			exit 198	
		}	

		if "`istolerance'" != "" {
			di as err "{cmd:istolerance} cannot be specified "/*
				*/ "with {cmd:noisure}"
			exit 198	
		}	

		if "`islog'" != "" {
			di as err "{cmd:noislog} cannot be specified "/*
				*/ "with {cmd:noisure}"
			exit 198	
		}	
	}


	
	if "`constraints'" != "" {
		di as err "constraints() not allowed"
		exit 198
	}	

	if "`aconstraints'`bconstraints'`acns'`bcns'`aeq'`beq'" == "" /*
		*/ & "`lreq'`lrconstraints'`lrcns'" == "" { 
		di as err "no constraints specified"
		exit 198
	}

	if "`aconstraints'`bconstraints'`acns'`bcns'`aeq'`beq'" != "" /*
		*/ & "`lreq'`lrconstraints'`lrcns'" != "" { 
		di as err "short-run and long-run constraints may not "/*
			*/ "both be specified"
		exit 198
	}

	
	marksample touse

	qui tsset, noquery

	local tvar `r(timevar)'
	local pvar `r(panelvar)'

	if "`tvar'" == "" {
di as err "{help tsset##|_new: tsset} your data before using "	/*
*/ "{help svar##|_new:svar}"
		exit 498
	}

	qui sort `pvar' `tvar'

	if "`exog'" != "" {
		markout `touse' `exog'
	}	


	/* drop collinear variables */

	_rmcoll `varlist' if `touse', `constant'
	local varlist `r(varlist)'

	if "`lags'" == "" {
		local lags 1 2
	}	

	
	if "`constant'" == "" {
		local ncons 1
	}
	else {
		local ncons 0
	}
	

	if "`varconstraints'" != "" {
		local cnslist_var `varconstraints'
		local varconstraints "constraints(`varconstraints')"
	}	

	markout `touse' L(`lags').(`varlist')

	local nlags : word count `lags'
	local mlag  : word `nlags' of `lags'

	qui count if `touse'
	local N = r(N)

	if `mlag' > r(N)-1 {
		di as err "you cannot fit a model with `nlags' and `N'"/*
			*/ " observations"
	}		


	if "`exog'" != "" {
		_rmcoll `exog' if `touse', `constant'
		local exog `r(varlist)'

		tsunab flist : L(0 `lags').(`varlist') `exog'

		_rmcoll `flist' if `touse', `constant'
		local flist2 `r(varlist)'

		local same : list flist == flist2
		if `same' != 1 {
			di as err "{p 0 4}the exogenous variables may "	/*
				*/ "not be collinear with the "		/*
				*/ "dependent variables, or their "	/*
				*/ "lags{p_end}"
			exit 198
		}	
	}

	if "`exog'" != "" {
		local exogm "exog(`exog')"
	}	
	
	local nexog : word count `exog'


/* parse acns() and bcns() into acnsmat and bcnsmat, if specified */

	local neqs: word count `varlist'
	
	if `version' < 16 {
		local aname a
		local bname b
		local cname c
	}
	else {
		local aname A
		local bname B
		local cname C
	}
	if  "`lreq'`lrconstraints'`lrcns'" == "" { 


		if "`aconstraints'`acns'`aeq'" == "" {
			tempname aeqi
			mat `aeqi' = I(`neqs')
			local aeq  `aeqi'
		}

		if "`bconstraints'`bcns'`beq'" == "" {
			tempname beqi
			mat `beqi' = I(`neqs')
			local beq  `beqi'
		}
		if "`acns'" != "" {
			tempname acnsmat
			`vv' ///
			_svar_mkmatcns, mat(`acns') name(`aname') /*
				*/ neqs(`neqs') tname(`acnsmat') type(acns())
			local imp_cnsa `r(svar_cnslist)'	
		}
		if "`bcns'" != "" {
			tempname bcnsmat
			`vv' ///
			_svar_mkmatcns, mat(`bcns') name(`bname') /*
				*/ neqs(`neqs') tname(`bcnsmat') type(bcns())
			local imp_cnsb  `r(svar_cnslist)'	
		}
	
		if "`aeq'" != "" {
			tempname aeqmat
			`vv' ///
			_svar_mkmatcns, mat(`aeq') name(`aname') neqs(`neqs') /*
				*/ tname(`aeqmat') eq type(aeq())
			local imp_cnsa `imp_cnsa' `r(svar_cnslist)'	
		}
	
		if "`beq'" != "" {
			tempname beqmat
			`vv' ///
			_svar_mkmatcns, mat(`beq') name(`bname') neqs(`neqs') /*
				*/ tname(`beqmat') eq type(beq())
			local imp_cnsb `imp_cnsb' `r(svar_cnslist)'	
		}
	}
	else {
		if "`lrcns'" != "" {
			tempname lrcnsmat
			`vv' ///
			_svar_mkmatcns, mat(`lrcns') name(`cname') /*
				*/ neqs(`neqs') tname(`lrcnsmat') type(lrcns())
			local imp_cnski `imp_cnski' `r(svar_cnslist)'	
		}

		if "`lreq'" != "" {
			tempname lreqmat
			`vv' ///
			_svar_mkmatcns, mat(`lreq') name(`cname') /*
				*/ neqs(`neqs') tname(`lreqmat') eq type(lreq())
			local imp_cnski `imp_cnski' `r(svar_cnslist)'	
		}
	}

	if "`var'" == "" {
		local dispvar nodisplay  
	}	
	else {
		local dispvar  
	}
	

	capture noi var `varlist'  if `touse', lags(`lags') 	/*
		*/ `exogm' `dfk' `constant' `lutstats' 		/*
		*/ `bigf' level(`level') `small'		/*
		*/ `varconstraints' `islog' `isure'		/*
		*/ `isiterate' `istolerance' `dispvar'		/*
		*/ `nocnsreport'
	
	if _rc > 0 {
		di as err "{cmd:var} returned error " _rc 
		di as err "check the specification of the "	/*
			*/ "underlying VAR"

		if "`imp_cnsa'`imp_cnsb'`imp_cnski'" != "" {
			constraint drop `imp_cnsa' `imp_cnsb' `imp_cnski'
		}
		exit _rc
	}	

/* make tempnames and tempvars */

	tempname starts sigma b_var v_var bf_var vf_var  G_var e_var 	/*	
		*/ b_svar v_svar ll_svar sbic_var hqic_var aic_var 	/*
		*/ fpe_var detsig_var detsig_ml_var ll_var		/*
		*/ a_est b_est Cns Cns_var ll_dfk_var klr_est

/* save off info from VAR */

	estimates store `e_var'
	
	mat `b_var'  = e(b)
	mat `v_var'  = e(V)
	mat `bf_var' = e(bf)
	mat `G_var'  = e(G)
	mat `Cns_var'  = e(Cns)


	mat `sigma'  = e(Sigma)

	local endog_var `varlist'
	local exog_var `e(exog)'
	local eqnames_var `e(eqnames)'
	local depvar_var   `varlist'
	local nocons_var `e(nocons)'
	local tsfmt "`e(tsfmt)'"
	local timevar "`e(timevar)'"

	
	local neqs  	  = e(neqs)
	local df_eq_var   = e(df_eq)
	local k_var 	  = e(k)
	local tparms_var  = e(tparms)
	
	scalar `sbic_var' = e(sbic)
	scalar `hqic_var' = e(hqic)
	scalar `aic_var'  = e(aic)
	scalar `fpe_var'  = e(fpe)

	local mlag_var    = e(mlag) 
	local tmax_var    = e(tmax)
	local tmin_var    = e(tmin)
	local N_gaps_var  = e(N_gaps)
	local T_var       = e(T)

	local lags_var    `e(lags)'
	scalar `detsig_var'    = e(detsig)
	scalar `detsig_ml_var' = e(detsig_ml)
	scalar `ll_var'        = e(ll)
	

	if "`dfk'" != "" {
		scalar `ll_dfk_var'        = e(ll_dfk)
	}	
	
	if "`small'" != "" {
		local df_r_var 			= e(df_r)
		forvalues i = 1/`neqs' {
			tempname rmse_`i'_var r2_`i'_var  ll_`i'_var /*
				*/ F_`i'_var
			local obs_`i'_var	= e(obs_`i')
			local k_`i'_var 	= e(k_`i')
			scalar `rmse_`i'_var'  	= e(rmse_`i')
			scalar `r2_`i'_var'    	= e(r2_`i')
			scalar `ll_`i'_var'	= e(ll_`i')
			local df_m`i'_var	= e(df_m`i')
			local df_r`i'_var	= e(df_r`i')
			scalar `F_`i'_var'	= e(F_`i')
		}
	}	
	else {
		forvalues i = 1/`neqs' {
			tempname rmse_`i'_var r2_`i'_var ll_`i'_var /*
				*/ chi2_`i'_var
			local obs_`i'_var	= e(obs_`i')
			local k_`i'_var 	= e(k_`i')
			scalar `rmse_`i'_var'  	= e(rmse_`i')
			scalar `r2_`i'_var'    	= e(r2_`i')
			scalar `ll_`i'_var'	= e(ll_`i')
			local df_m`i'_var	= e(df_m`i')
			scalar `chi2_`i'_var'	= e(chi2_`i')
		}
	}

	global T_sigma  `sigma'
	global T_neqs `neqs'
	global T_T = `N'

	if  "`lreq'`lrconstraints'`lrcns'" == "" { 
		`vv' ///
		_mkpmats, neqs(`neqs')
		local aparms "`r(aparms)'"
		local bparms "`r(bparms)'"

		local cns_a `aconstraints' `imp_cnsa'
		local cns_b `bconstraints' `imp_cnsb'

		foreach cnsitem of local cns_a {
			constraint get `cnsitem'
			if "`cns_a_list'" == "" {
				local cns_a_list "`r(contents)'"
			}
			else {
				local cns_a_list "`cns_a_list':`r(contents)'"
			}	
		}

		foreach cnsitem of local cns_b {
			constraint get `cnsitem'
			if "`cns_b_list'" == "" {
				local cns_b_list "`r(contents)'"
			}
			else {
				local cns_b_list "`cns_b_list':`r(contents)'"
			}	
		}

		local fullcns `aconstraints' `bconstraints' 
		local fullcns `fullcns' `imp_cnsa' `imp_cnsb'

		if "`imp_cnsa'`imp_cnsb" != "" {
			local impcns "impcns(`imp_cnsa' `imp_cnsb') "
		}	

		if "`from'" == "" {
			mat `starts' = J(1,2*`neqs'*`neqs',1)
			local base = 2*`neqs'*`neqs'
			forvalues i = 1/`base' {
				mat `starts'[1,`i'] = 1+`i'/100
			}
			local init  "init(`starts', copy)"
		}
		else {
			local init  "init(`from')"
			
			`vv' ///
			capture ml model d2 _svard2 `aparms' `bparms' 	/*
				*/ if `touse', /*
				*/ const(`fullcns') max `mlopts' search(off) /*
				*/ nopreserve `init' iter(0) nolog /*
				*/ `negh'
				
			if _rc > 0 {
				di as err "initial values not feasible"
				
				if "`imp_cnsa'`imp_cnsb'" != "" {
					constraint drop `imp_cnsa' `imp_cnsb'
				}
				exit _rc
			}
			mat `starts' = e(b)	
		}
		
		if "`idencheck'" == "" {
			`vv' ///
			_svariden , b(`starts') cnsa(`cns_a')  	/*
				*/ cnsb(`cns_b') neqs(`neqs') 	/*
				*/ sigma(`sigma') bigt(`N') `impcns'
		}		


		di as txt "Estimating short-run parameters"
		`vv' ///
		capture noi ml model d2 _svard2  `aparms' `bparms'	/*
			*/ if `touse', /*
			*/ const(`fullcns') max `mlopts' search(off) /*
			*/ nopreserve `init' `negh'
		
			if _rc > 0 {
				if "`imp_cnsa'`imp_cnsb'" != "" {
					constraint drop `imp_cnsa' `imp_cnsb'
				}
				exit _rc
			}

		mat `b_svar' = e(b)
	}
	else {
		tempname abar abari
		_getAbar , nlags(`nlags') neqs(`neqs') abar(`abar') /*
			*/ nexog(`nexog') ncons(`ncons')

		global T_Abar `abar'
		capture mat `abari' = inv(`abar')
		if _rc > 0 {
			di as err "Matrix (I-A_1-A_2...-A_p) not invertible"
			exit 498
		}	
		global T_Abari `abari'

		`vv' ///
		_mkpmats, neqs(`neqs') lr
		local kiparms "`r(kiparms)'"

		local cns_ki `lrconstraints' `imp_cnski'
		local fullcns `lrconstraints' `imp_cnski'


		foreach cnsitem of local cns_ki {
			constraint get `cnsitem'
			if "`cns_ki_list'" == "" {
				local cns_ki_list "`r(contents)'"
			}
			else {
				local cns_ki_list "`cns_ki_list':`r(contents)'"
			}	
		}

		if "`from'" == "" {
			mat `starts' = J(1,`neqs'*`neqs',1)
			local base = `neqs'*`neqs'
			forvalues i = 1/`base' {
				mat `starts'[1,`i'] = 1+`i'/100
			}
			local init  "init(`starts', copy)"
		}
		else {
			local init  "init(`from')"
			`vv' ///
			capture ml model d2 _svarlrd2  `kiparms' if `touse', /*
				*/ const(`fullcns') max `mlopts' search(off) /*
				*/ nopreserve `init' iter(0) nolog /*
				*/ `negh'
			if _rc > 0 {
				di as err "initial values not feasible"
				
				if "`imp_cnski'" != "" {
					constraint drop `imp_cnski' 
				}	
				exit _rc
			}	
				
			mat `starts' = e(b)	
		
		}

		if "`idencheck'" == "" {
			`vv' ///
			_svaridenlr, b(`starts') cnsk(`cns_ki') 	/*	
				 */ neqs(`neqs') sigma(`sigma')		/*
				 */  bigt(`N') impcns(`imp_cnski')	/*
				 */ abar(`abar') abari(`abari')
		}	 

		
		di as txt "Estimating long-run parameters"
		`vv' ///
		capture noi ml model d2 _svarlrd2  `kiparms' if `touse', /*
			*/ const(`fullcns') max `mlopts' search(off) /*
			*/ nopreserve `init' `negh'

		if _rc > 0 {
			if "`imp_cnski'" != "" {
				constraint drop `imp_cnski' 
			}	
			exit _rc
		}	
		

	}

				/* drop global macros used in 
				 * ML evaluator */
	capture macro drop T_T T_neqs T_sigma
	
	mat `b_svar' = e(b)
	mat `v_svar' = e(V)
	scalar `ll_svar' = e(ll)
	local rc_ml   = e(rc)
	local ic_ml   = e(ic)
	local rank       = e(rank)

	mat `Cns' = get(Cns)

/* calculate number of independent restrictions */

/* 	since e(rank) = rank of e(V)
	      e(rank) = number of estimated parms 
	           - number of independent restrictions imposed
*/		   

	local N_cns = e(k)-e(rank)

	ereturn post  `b_svar' `v_svar' `Cns', esample(`touse') obs(`N') 

	ereturn hidden scalar version = cond(`version'<16,1,2)

	ereturn matrix b_var = `b_var'
	ereturn matrix V_var = `v_var'

	if  "`lreq'`lrconstraints'`lrcns'" == "" { 
		local overid_df = `N_cns' - 2*(`neqs')^2+.5*((`neqs')^2+`neqs') 
		eret scalar oid_df = `overid_df'
	}
	else {
		local overid_df = `N_cns' - (`neqs')^2+.5*((`neqs')^2+`neqs') 
		eret scalar oid_df = `overid_df'
	}
	if `overid_df' > 0 {
		if "`dfk'" != "" {
			eret scalar chi2_oid = 2*(`ll_dfk_var'- `ll_svar')
		}
		else {
			eret scalar chi2_oid = 2*(`ll_var'- `ll_svar')
		}
	}

	if `overid_df' < 0 {
		di as err "the number of overidentifying restrictions " /*
			*/ " is negative"
		di as err "the fitted model might not be identified"	
	}	

	
	if  "`lreq'`lrconstraints'`lrcns'" == "" { 
		mat `a_est' = J(`neqs', `neqs', 0)
		mat `b_est' = J(`neqs', `neqs', 0)
		forvalues j = 1/`neqs' {
			forvalues i = 1/`neqs' {
				if `version' < 16 {
					mat `a_est'[`i',`j'] = ///
						_b[a_`i'_`j':_cons]
					mat `b_est'[`i',`j'] = ///
						_b[b_`i'_`j':_cons]
				}
				else {
					mat `a_est'[`i',`j'] = _b[/A:`i'_`j']
					mat `b_est'[`i',`j'] = _b[/B:`i'_`j']
				}
			}
		}
		mat colnames `a_est' = `eqnames_var'
		mat rownames `a_est' = `eqnames_var'
		mat colnames `b_est' = `eqnames_var'
		mat rownames `b_est' = `eqnames_var'
	}
	else {
		mat `a_est' = I(`neqs')
		mat `klr_est' = J(`neqs', `neqs', 0)
		forvalues j = 1/`neqs' {
			forvalues i = 1/`neqs' {
				if `version' < 16 {
					mat `klr_est'[`i',`j'] = ///
						_b[c_`i'_`j':_cons]
				}
				else {
					mat `klr_est'[`i',`j'] = _b[/C:`i'_`j']
				}
			}
		}
		mat `b_est' = `abar'*`klr_est'

		mat colnames `klr_est' = `eqnames_var'
		mat rownames `klr_est' = `eqnames_var'
		mat colnames `b_est' = `eqnames_var'
		mat rownames `b_est' = `eqnames_var'
		mat colnames `abar' = `eqnames_var'
		mat rownames `abar' = `eqnames_var'
	}
	

	if "`imp_cnsa'`imp_cnsb'" != "" {
		constraint drop `imp_cnsa' `imp_cnsb'
	}	

	if "`imp_cnski'" != "" {
		constraint drop `imp_cnski' 
	}	

	
	if  "`lreq'`lrconstraints'`lrcns'" != "" { 
		tempname atemp
		mat `atemp' = I(rowsof(`abar'))

		eret mat A  = `atemp'
		eret mat A1 = `abar'
		eret mat B = `b_est'
		eret mat C  = `klr_est'
		eret local lrmodel  lrmodel

		local k_eq  = (`neqs'^2)
		if `version' < 16 {
			local k_aux = (`neqs'^2)
		}

		if "`lreq'" != "" {
			eret mat lreq `lreq' , copy
		}
		if "`lrcns'" != "" {
			eret mat lrcns `lrcns'
		}	

		eret local cns_lr "`cns_ki_list'"
	}
	else {
		local k_eq  = 2*(`neqs'^2)
		if `version' < 16 {
			local k_aux = 2*(`neqs'^2)
		}

		if "`aeq'" != "" {
			eret mat aeq `aeq', copy
		}
		if "`beq'" != "" {
			eret mat beq `beq', copy
		}
		if "`acns'" != "" {
			eret mat acns `acns', copy
		}
		if "`bcns'" != "" {
			eret mat bcns `bcns', copy
		}

		eret local cns_a "`cns_a_list'"
		eret local cns_b "`cns_b_list'"
	}

	if  "`lreq'`lrconstraints'`lrcns'" == "" { 
		eret mat A `a_est', copy
		eret mat B `b_est', copy
	}

	eret mat bf_var	= `bf_var' 
	eret mat G_var  = `G_var'
	eret mat Sigma  = `sigma' 
	
	if "`cnslist_var'" != "" {
		eret mat Cns_var = `Cns_var'
	}


	eret scalar rc_ml = `rc_ml'
	eret scalar ic_ml = `ic_ml'
	eret scalar N_cns = `N_cns'
	eret hidden scalar neqs  = `neqs'		// now undocumented
	eret scalar k_dv  = `neqs'		// follow convention
	eret hidden scalar neqs_var  = `neqs'		// undocumented
	eret scalar k_dv_var  = `neqs'		// follow convention

	eret scalar k_eq_var  = `neqs'
	eret scalar k_eq  = `k_eq'
	if `version' < 16 {
		eret scalar k_aux = `k_aux'
		eret hidden scalar version = 1
	}
	else {
		eret hidden scalar version = 2
	}

	eret scalar df_eq_var = `df_eq_var'
	eret scalar k_var = `k_var'
	eret scalar tparms_var = `tparms_var'
	
	eret scalar sbic_var 	= `sbic_var'
	eret scalar hqic_var 	= `hqic_var'
	eret scalar aic_var 	= `aic_var'
	eret scalar fpe_var 	= `fpe_var'

	eret scalar mlag_var   	= `mlag_var' 
	eret scalar tmax    	= `tmax_var'
	eret scalar tmin    	= `tmin_var'
	eret scalar N_gaps_var  = `N_gaps_var'
	eret hidden scalar T_var       = `T_var'

	eret scalar detsig_var     = `detsig_var'
	eret scalar detsig_ml_var  = `detsig_ml_var'
	eret scalar ll_var         = `ll_var'
	eret scalar ll		   = `ll_svar'
	
	if "`small'" != "" {
		eret scalar df_r_var 		= `df_r_var'
		eret scalar df_r                = `T_var'-`rank'
		local dfr                	= `T_var'-`rank'
		forvalues i = 1/`neqs' {
			eret scalar obs_`i'_var	= `obs_`i'_var'
			eret scalar k_`i'_var 	= `k_`i'_var'
			eret scalar rmse_`i'_var= `rmse_`i'_var'
			eret scalar r2_`i'_var  = `r2_`i'_var'
			eret scalar ll_`i'_var	= `ll_`i'_var'
			eret scalar df_m`i'_var	= `df_m`i'_var'
			eret scalar df_r`i'_var	= `df_r`i'_var'
			eret scalar F_`i'_var	= `F_`i'_var'
		}
	}	
	else {
		forvalues i = 1/`neqs' {
			eret scalar obs_`i'_var	= `obs_`i'_var'
			eret scalar k_`i'_var 	= `k_`i'_var'
			eret scalar rmse_`i'_var= `rmse_`i'_var'
			eret scalar r2_`i'_var  = `r2_`i'_var'
			eret scalar ll_`i'_var	= `ll_`i'_var'
			eret scalar df_m`i'_var	= `df_m`i'_var'
			eret scalar chi2_`i'_var= `chi2_`i'_var'
		}
	}
	eret local title "Structural vector autoregression"
	eret local small `small'
	eret local lutstats_var `lutstats'
	eret local tsfmt "`tsfmt'"
	eret local timevar "`timevar'"

	eret local endog_var `endog_var' 
	eret local exog_var `exog_var'
	eret local eqnames_var `eqnames_var'
	eret local depvar_var   `depvar_var'
	eret local lags_var `lags_var'
	eret local nocons_var `nocons_var'
	eret hidden local vcetype EIM

	if "`varconstraints'" != "" {
		eret local constraints_var constraints_var
	}	
	
	if "`dfk'" != "" {
		eret local dfk_var dfk
	}	
	
	eret local predict svar_p
	eret local cmdline `"svar `cmdline'"'
	eret local cmd svar
	_post_vce_rank
	
	Dheadernew, `nocnsreport'

	if "`e(small)'" != "" {
		ETable2 , level(`level') dfr(`dfr') `diopts'
	}
	else {
		ETable2 , level(`level')  `diopts'
	}
end


program define _mkpmats , rclass
	local version = string(_caller())
	syntax , neqs(numlist max=1 >0) [ lr ]

	if "`lr'" == "" {
		forvalues i = 1/`neqs' {
			forvalues j = 1/`neqs' {
				if `version' < 16 {
					local aparm "(a_`j'_`i':)"
					local bparm "(b_`j'_`i':)"
				}
				else {
					local aparm /A:`j'_`i'
					local bparm /B:`j'_`i'
				}
				local aparms `aparms' `aparm'
				local bparms `bparms' `bparm'
			}
		}

		return local aparms "`aparms'"
		return local bparms "`bparms'"
	}
	else {
		forvalues i = 1/`neqs' {
			forvalues j = 1/`neqs' {
				if `version' < 16 {
					local kiparm "(c_`j'_`i':)"
				}
				else {
					local kiparm /C:`j'_`i'
				}
				local kiparms " `kiparms' `kiparm'"
			}
		}

		return local kiparms "`kiparms'"
	}
end


program define _PARSEab

	syntax , mat(string) name(string) neqs(integer) tname(string)
	
	local toks : word count `mat'
	if `toks' == 1 {
		capture confirm matrix `mat'
		if _rc > 0 {
			di as err "`name'(`mat') does not define a matrix"
			exit 198
		}	
		mat `tname' = `mat'
		exit
	}
	capture matrix input `tname' = `mat'
	if _rc > 0 {
		di as err "`name'(`mat') does not define a matrix"
		exit 198
	}	

end	

program define _svar_mkmatcns, rclass
		local vv : display "version " _caller() ":"
		syntax , mat(string) name(string) neqs(integer) 	/*
			*/ tname(string) type(string) [ eq ]
		_PARSEab, mat(`mat') name(`name') neqs(`neqs') tname(`tname')
		
		capture assert rowsof(`tname') == `neqs'
		if _rc > 0 {
			di as err "`type' matrix does not have the "/*
				*/ "correct row dimension"
			exit 198
		}		
		capture assert colsof(`tname') == `neqs'
		if _rc > 0 {
			di as err "`type' matrix does not have the "/*
				*/ " correct column dimension"
			exit 198
		}
		if "`eq'" == "" {
			`vv' ///
			_svar_cnsmac, mat(`tname') name(`name') neqs(`neqs')
		}
		else {
			`vv' ///
			_svar_eqmac, mat(`tname') name(`name') 	/*
				*/ neqs(`neqs') 
		}
		local cnsmac "`r(cnsmac)'"
		if "`cnsmac'" == "" {
			di as err "no constraints implied by matrix `a'"
			exit 498
		}	
		
		while "`cnsmac'" != "" {
			gettoken tok cnsmac:cnsmac, parse(":")
			if "`tok'" != ":" {
				_svar_newcns `tok'
				local svar_cnslist `svar_cnslist' `r(new)'

			}
		}
		ret local svar_cnslist `svar_cnslist'
end 		


program define Dheadernew
	syntax [, NOCNSReport]
	local neqs = e(neqs)
	local vlist "`e(endog_var)'"

	di
	di as txt "Structural vector autoregression"
	di

	if "`nocnsreport'" == "" {
		matrix dispCns, r
		if r(k) > 0 {
			matrix dispCns
			di
		}		
	}

	_mvtsheadr
	di as txt "{col 49}Number of obs{col 67}= " as res %10.0fc e(N)

	if e(oid_df) < 1 {
		di as txt "Exactly identified model"		///
			"{col 49}Log likelihood{col 67}=  " 	///
			as res %9.8g e(ll)	
	}
	else {
		di as txt "Overidentified model"		///
			"{col 49}Log likelihood{col 67}=  " 	///
			as res %9.8g e(ll)	
	}
	di
end

program define _getAbar 
	syntax , nlags(integer) neqs(integer) abar(string) nexog(integer) /*
		*/ ncons(integer)

	tempname b 

	mat `b' = e(b)
	mat `abar' = I(`neqs')

	local col 0
	forvalues i = 1/`neqs' {
		forvalues j = 1/`neqs' {
			forvalues lg = 1/`nlags' {
				local ++col
				mat `abar'[`i',`j'] = `abar'[`i',`j'] 	/*
					*/ - `b'[1,`col']
			}
		}
		local col = `col' + `nexog' + `ncons'
	}
end


program define ETable2, eclass
	version 12
	syntax , level(cilevel) [ full  dfr(numlist max = 1 >0) *]

	tempname b v bt vt esample rowt eres
		
	_get_diopts options, `options'
	mat `b' = e(b)
	mat `v' = e(V)
	if "`e(Cns)'" == "matrix" {
		tempname C
		matrix `C' = e(Cns)
	}
	local version = cond(missing(e(version)),1,e(version))
	local k_eq  = e(k_eq)
	if `version' == 1 {
		local k_aux = e(k_aux)
	}
	local sep   = e(neqs)^2
		
	nobreak {
		capture _est hold `eres', varname(`esample') restore
		eret post `b' `v' `C'
		if "`dfr'" != "" {
			eret scalar df_r = `dfr'
		}	

		eret scalar k_eq  = `k_eq'
		if `version' == 1 {
			eret scalar k_aux = `k_aux'
		}

		eret local cmd "svar"

		_coef_table , level(`level') separator(`sep') `options'	///
			nocnsreport

		_est unhold `eres'
	}

	if e(oid_df) >= 1 {
		local chi : di %7.4g e(chi2_oid)
		local chi = trim("`chi'")
		local df : di %3.0f e(oid_df)
		local df = trim("`df'")
		
		di as txt "LR test of identifying restrictions: "	/// 
			"chi2(" as res "`df'"				/// 
			as txt ") = " as res "`chi'"			///
			as txt "{col 60}Prob > chi2{col 72}="  		///
			as res %6.3f chi2tail(e(oid_df),e(chi2_oid))
	}
end	

