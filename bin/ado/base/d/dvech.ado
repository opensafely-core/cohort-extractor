*! version 1.0.12  20jan2015

program define dvech, eclass byable(onecall)

	version 11
	if _by() {
                local BY `"by `_byvars'`_byrc0':"'
        }

	if replay() {
		if ("`e(cmd)'"!="dvech") error 301
		
		Replay `0'
		exit
	}
	cap noi `BY' Estimate `0'
	local rc = c(rc)
	
	foreach m of local mnames {
		cap mata: mata drop `m'
	}
	if `rc' exit `rc'
	
	ereturn local cmdline `"`BY'dvech `0'"'
end

program Estimate, eclass byable(recall)

	syntax anything [if] [in],				///
		[						///
		vce(string)					///
		ARch(numlist integer >0 sort)			///
		GArch(numlist integer >0 sort)			///
		CONSTraints(numlist integer >=1 <= 1999)	///
		from(name)					///
		ITERate(numlist max=1 integer >=0)		///
		SVITERate(numlist max=1 integer >=0)		///
		TECHnique(string)				///
		SVTECHnique(string)				///
						/// max options
		nolog 						///
		TRace 						///
		GRADient 					///
		HESSian 					///
		showstep 					///
		SHOWNRtolerance					///
		SHOWTOLerance					///
		TOLerance(passthru)				///
		LTOLerance(passthru)				///
		NRTOLerance(passthru)				///
		GTOLerance(passthru)				///
		DIFFicult					///
				/// method() is undocumented 	///
		method(string)					///
				/// allow for display options	///	
		*						///
		]

	marksample touse		

	local maxopts "`log' `trace' `gradient' `hessian' `showstep' "
	local maxopts "`maxopts' `shownrtolerance' `showtolerance' "
	local maxopts "`maxopts' `tolerance' `ltolerance' "
	local maxopts "`maxopts' `nrtolerance' `gtolerance' "
	local maxopts "`maxopts' `difficult' "

	_get_diopts diopts , `options'

	if "`log'" == "nolog" {
		local svnolog svnolog
	}	

	if "`garch'" != "" & "`arch'"=="" {
		di "{err}{p 0 4}{cmd:garch()} may only be specified " ///
			"with {cmd:arch()}{p_end}"
		di "{err}{p 0 4}GARCH terms are not identified "	///
			"without ARCH terms in the model.{p_end}"
		exit 498	
	}
	local 0_orig `"`0'"'
	_parse expand eqninfo left : anything 

	local k_0 = `eqninfo_n'

	forvalues i = 1/`k_0' {
		
		local 0 `"`eqninfo_`i''"'
		syntax anything(equalok) [, noCONStant]

		local constant`i' `constant'

		local tmp : subinstr local anything "=" "=", all 	///
			count(local n_eqsign)

		if `n_eqsign' != 1 {
			di as err `"{cmd:(`eqninfo_`i'')} invalid"'
			exit 198
		}

		gettoken deps`i' indeps`i': anything , parse("=")
		tsunab deps`i' : `deps`i''

		local indeps`i' : subinstr local indeps`i' "=" "", 
		if "`indeps`i''" != "" {
			fvexpand `indeps`i''
			local indeps`i' "`r(varlist)'"
		}
			
	}

	forvalues i=1/`k_0' {
		local molist `molist' `deps`i'' `indeps`i''
		local COVARS `COVARS' `indeps`i''
	}
	markout `touse' `molist'
	qui count if `touse'
	local N = r(N)

	if `:list sizeof COVARS' == 0 {
		local COVARS _NONE
	}
	
	tempvar cons
	tempname xlvec ylvec xlvecb
	local mnames1 `xlvec' `ylvec' `xlvecb'
	c_local mnames `mnames1'
	qui gen double `cons' = 1
	mata: `xlvec' = J(1,0,"")
	mata: `xlvecb' = J(1,0,"")
	mata: `ylvec' = J(1,0,"")
	
	local n_ind = 0
	local cnt = 0
	forvalues i=1/`k_0' {
		_rmcoll `indeps`i'', expand
		local indeps`i' `r(varlist)'
		foreach dvar of local deps`i' {
			local ++cnt
			local ind`cnt' :copy local indeps`i'
			local dep`cnt' `dvar'
			local cons`cnt' `constant`i''
			foreach ivar of local ind`cnt' {
				local delta_names `delta_names' `dvar':`ivar'
			}
			if "`cons`cnt''" == "" {
				local delta_names `delta_names' `dvar':_cons
				local indi `ind`cnt'' _cons
				local ind`cnt' `ind`cnt'' `cons'
			}
			else {
				local indi `ind`cnt'' 
			}
			local n_ind`i' : word count `ind`cnt''
			local n_ind = `n_ind' + `n_ind`i''
					// dv_eqs (dep vars with equations)
			if "`ind`cnt''" != "" {
				local dv_eqs `dv_eqs' `dvar'
			}
			mata: `xlvec'  = `xlvec',  "`ind`cnt'' "
			mata: `xlvecb' = `xlvecb', "`indi' "
			mata: `ylvec' = `ylvec', "`dvar'"
		}
	}
	local k = `cnt'
	local d0names `delta_names'

	GetImpliedConstraints `d0names'
	local omit_cns `r(cnslist)'

	if "`omit_cns'" != "" {
		local constraints `constraints' `omit_cns'
	}

	mata: st_local("depvars", invtokens(`ylvec'))
	qui version 10 : _rmcoll `depvars'
	local klist `r(varlist)'
	local dlist : list depvars - klist
	if "`dlist'" != "" {
		if `:word count `dlist'' >1 {
			local is are
		} 
		else {
			local is is
		}
		di "{p}{err}{cmd:`dlist'} `is' perfectly collinear "	///
			"with other dependent variables {p_end}"
		di "{err}perfectly collinear dependent "	///
			"variables may not be specified"
		exit 498	
	}
	

	tempname fvlist 
	mata: st_local("`fvlist'", invtokens(`xlvec' + `ylvec'))
	local `fvlist' : list uniq `fvlist'

	_max_to_opt , `maxopts'

//	_max_to_opt returns the following macros which are then passed
//	to DoWork() which in turn passes them to optimize()
//	opts_tl opts_ptol opts_vtol opts_nrtol opts_shm 

	tempname tmin tmax
	_ts tvar pvar if `touse', sort onepanel

	qui sum `tvar' if `touse' , meanonly
	scalar `tmax' = r(max)
	scalar `tmin' = r(min)
	local fmt : format `tvar'
        local tmins = trim(string(r(min), "`fmt'"))
        local tmaxs = trim(string(r(max), "`fmt'"))

	local ts_delta : char _dta[_TSdelta]
	if "`ts_delta'" == "" {
		local ts_delta 1
	}	
	qui count if `tvar' - `tvar'[_n-1] != `ts_delta' & `touse'==1 	///
		& `tvar'>`tmin'
	local gaps1 = r(N)

	qui count if `touse'!=`touse'[_n-1] & `touse'==1 & `tvar'>`tmin'
	local gaps2 = r(N)

	if "`method'" != "" {
		local method_allowed gapsmata nogaps gapsfast
		local methodp : list method & method_allowed
		local method_n : word count `methodp'
		if `method_n'>1 {
			di "{err}method(`methodp') invalid"
			exit 498
		}	
	}	

	if "`methodp'" == "nogaps" {
		if `gaps1' | `gaps2' {
			di "{err}gaps in the data are not allowed"
			exit 498
		}
	}

	if "`vce'" != "" {
		local vce_allowed oim robust
		if "`vce'" != "" {
			local len = length(`"`vce'"')
			if `len'==0 {
				local vce oim
			}
			else {
				if `"`vce'"'==bsubstr("robust",1,max(1,`len')) {
				 	local vce robust
				}
			}
		}

		local va : list vce in vce_allowed
		if `va'==0 {
			di "{err}{cmd:vce(`vce')} not allowed"
			exit 498
		}	
	}
	else {
		local vce oim
	}

	if "`iterate'" == "" {
		local iterate 16000
	}

	if "`sviterate'" == "" {
		local sviterate 25
	}
	
	if "`technique'" != "" {
		check_technique `technique'
	}
	else {
		local technique "bhhh 5 nr 16000"
	}	

	if "`svtechnique'" != "" {
		check_technique `svtechnique'
	}
	else {
		local svtechnique "bhhh 8 nr 16000"
	}	


	preserve

	qui tsfill

	tempvar myn
	qui gen `myn' = _n
	qui sum `myn' if `touse'==1
	local first_ob = r(min)
	local last_ob  = r(max)

	tempvar touse_pull 
//	tempvar tmp 
//	qui gen byte `tmp' = `touse'==1
//	_dvech_falast `touse'
//	_dvech_falast `tmp'
//	local first_ob = r(first)
//	local last_ob  = r(lasts)

	if `first_ob'>=. | `first_ob'==`last_ob' {
		di as err "no observations"
		exit 2000
	}
	local N_pull = `last_ob'-`first_ob' + 1
	qui gen byte `touse_pull' = cond(_n>=`first_ob' & _n<=`last_ob', 1, 0)
	qui replace `touse' = 0 if `touse'>=.

	tempname b v xinfo

	if "`constraints'" != "" & `n_ind'>0 {
		matrix `b' = J(1, `n_ind', .1)
		matrix `v' = J(`n_ind', `n_ind', .1)
		matrix colnames `b' = `delta_names'
		matrix colnames `v' = `delta_names'
		matrix rownames `v' = `delta_names'

		ereturn post `b' `v'

		makecns `constraints', nocnsnotes
		local mconstraints `r(clist)'

		if "`mconstraints'" != "" {
			tempname T_cns_m a_cns_m C_cns_m
			matcproc `T_cns_m' `a_cns_m' `C_cns_m'
		}
	}
	
						// add names for S
	forvalues j=1/`k' {
		forvalues i=`j'/`k' {
			local vnames `vnames' Sigma0:`i'_`j'
		}	
	}
	local delta_names `delta_names' `vnames'

	foreach alag of local arch {
		forvalues j=1/`k' {
			forvalues i=`j'/`k' {
				local anames `anames' L`alag'.ARCH:`i'_`j'
			}	
		}
	}
	local delta_names `delta_names' `anames'

	foreach glag of local garch {
		forvalues j=1/`k' {
			forvalues i=`j'/`k' {
				local gnames `gnames' L`glag'.GARCH:`i'_`j'
			}	
		}
	}
	local delta_names `delta_names' `gnames'

	local cvnames `vnames' `anames' `gnames'

	if "`constraints'" != "" {
		local nvterms : word count `cvnames'
		matrix `b' = J(1, `nvterms', .1)
		matrix `v' = J(`nvterms', `nvterms', .1)
		matrix colnames `b' = `cvnames'
		matrix colnames `v' = `cvnames'
		matrix rownames `v' = `cvnames'

		ereturn post `b' `v'

		makecns `constraints', nocnsnotes
		local vconstraints `r(clist)'

		if "`vconstraints'" != "" {
			tempname T_cns_v a_cns_v C_cns_v
			matcproc `T_cns_v' `a_cns_v' `C_cns_v'

		}
	}

	if "`constraints'" != "" {
		local nfterms : word count `delta_names'
		matrix `b' = J(1, `nfterms', .1)
		matrix `v' = J(`nfterms', `nfterms', .1)
		matrix colnames `b' = `delta_names'
		matrix colnames `v' = `delta_names'
		matrix rownames `v' = `delta_names'

		ereturn post `b' `v'

		makecns `constraints'
		local constraints `r(clist)'

		if "`constraints'" != "" {
			tempname T_cns_f a_cns_f C_cns_f
			matcproc `T_cns_f' `a_cns_f' `C_cns_f'
		}
	}

	local nfterms : word count `delta_names'
	if "`from'" != "" {
		confirm matrix `from'
		tempname b0
		mat `b0' = `from'
		if (rowsof(`b0')!= 1) {
			di "{err}{cmd:from(`from')} does not "		///
				"specify a row vector"
			exit 498
		}	

		if (colsof(`b0')!= `nfterms') {
			di "{p}{err}{cmd:from(`from')} does not "	///
				"specify a row vector conformable "	///
				"with the model parameters{p_end}"
			exit 503
		}
	}	

	if `nfterms' >= `N_pull' {
		di "{err}Insufficient observations"
		exit 498
	}

	tempname arch_lvec garch_lvec b v ll gradient hessian sig0	///
		S A B

						// arch_lvec is 1 x np, 
						// np = number of arch lags
						// 0<=np

	local mnames2 `arch_lvec' `garch_lvec'
	c_local mnames `mnames1' `mnames2'
	
	mata: `arch_lvec'  = strtoreal(tokens("`arch'"))
	mata: `garch_lvec' = strtoreal(tokens("`garch'"))

	mata: _DVECH_DoWork( `ylvec', `xlvec',				/// 
		"`T_cns_m'", "`a_cns_m'", 				///	
		"`C_cns_v'", "`C_cns_f'", 				///
		`arch_lvec', `garch_lvec', "`b'", "`v'", 		///
		"`touse'", "`touse_pull'", "`b0'", "`ll'", 		///
		"`gradient'", "`hessian'", `iterate', `sviterate',	///
		"`technique'", "`svtechnique'", "`sig0'", "`S'", 	///
		"`A'", "`B'", "`vce'", "`opts_tl'", "`opts_ptol'",	///
		"`opts_vtol'", "`opts_nrtol'", "`opts_shm'", 		///
		"`svnolog'","`methodp'")

	tempname ilog pinfo V_modelbased
	local converged = r(converged)
	local ic        = r(ic)
	matrix `ilog'   = r(ilog)
	matrix `pinfo'  = r(pinfo)

	matrix colnames `b' = `delta_names'
	matrix colnames `v' = `delta_names'
	matrix rownames `v' = `delta_names'

	matrix rownames `hessian' = `delta_names'
	matrix colnames `hessian' = `delta_names'

	matrix colnames `gradient' = `delta_names'

	if "`vce'" == "robust" {
		matrix `V_modelbased' = r(V_modelbased)
		matrix colnames `V_modelbased' = `delta_names'
		matrix rownames `V_modelbased' = `delta_names'
	}	

	restore
	
	local k_p   = colsof(`b')
	mata: st_local("rank", strofreal(rank(st_matrix("`v'"))))

	ereturn post `b' `v' `C_cns_f', esample(`touse') ///
		findomitted buildfvinfo

	if "`omit_cns'" != "" {
		constraint drop `omit_cns'
	}

	ereturn scalar rank = `rank'
	ereturn scalar k    = `k_p'
					// k_eq is used by _coef_table
					// k_eq is number of equations to
					// display

	local k_dveqs : word count `dv_eqs'
	local n_arch  : word count `arch'
	local n_garch : word count `garch'
	local k_extra =  1 + `n_arch' + `n_garch'
	local k_eq 		= `k_dveqs' + `k_extra' 
	ereturn scalar k_extra	= `k_extra'
	ereturn scalar k_eq	= `k_eq'

	local flist `d0names'

	while "`flist'" != "" {
		gettoken next flist: flist	
		gettoken eq vname:next, parse(":")
		
		gettoken colon vname:vname, parse(":")
		if "`eq'" == "" {
			local include 0
		} 
		else {
			local include : list eq in dv_eqs
		}	
		if `include' {
			if "`vname'" != "_cons" {
				local tlist `tlist' [`eq']`vname'
			}
		}
	}
	if "`tlist'" != "" {
		qui test `tlist'	
	}
	ereturn scalar p     = r(p)
	ereturn scalar df_m  = r(df)
	ereturn scalar chi2  = r(chi2)
	ereturn local chi2type Wald

					// store tvar information
	ereturn local tvar  = "`tvar'"
	ereturn scalar tmax = `tmax'
	ereturn scalar tmin = `tmin'
	ereturn local tmins   `tmins'
	ereturn local tmaxs   `tmaxs'

	ereturn local marginsok	    "xb Variance"
	ereturn local marginsnotok  "Residuals"
	ereturn local covariates    "`COVARS'"

	ereturn scalar N         = `N'
	ereturn scalar ll        = `ll'
	ereturn scalar k_dv	 = `k'
	ereturn scalar converged = `converged'
	ereturn scalar ic        = `ic'

	ereturn matrix hessian  = `hessian'
	ereturn matrix gradient = `gradient'
	ereturn matrix Sigma    = `sig0'
	ereturn matrix ilog     = `ilog'
	ereturn matrix pinfo    = `pinfo'

// pinfo matrix has one row for  each parameter block
// Possible parameter blocks are  mean parameters, 
// V parameters,  Ai (arch parameters at lag i),
// and  Bi (garch parameters at lag i).
// The number of rows of pinfo is the number of parameter 
//  blocks in the model.
// Each row in pinfo has form
// (type, lag#, firstrow, lastrow)
// 	where 
//	type is 1,2,3, or 4
//		1 ="mean"
//		2 = "V", 
//		3 = "arch"
//		4 = "garch"
// 	lag is the lag of the term in the model 
//	(or . for mean and "V")
//	firstrow is the first of delta in which parms appear
//	lastrow is the last of delta in which parms appear
// pinfo is used by postestimation routines to rebuild matrices from e(b)
	

	local n_q : word count `garch'
	local n_a : word count `arch'

	ereturn matrix S     = `S'
	if `n_a' > 0 {
		ereturn matrix A     = `A'
	}

	if `n_q' > 0 {
		ereturn matrix B     = `B'
	}

	mata: st_local("indeps", invtokens(`xlvecb', ";"))
	ereturn local depvars `depvars'
	ereturn local indeps  `indeps'

	mata: st_local("evlist", invtokens(`xlvecb'))
	local evlist : list uniq evlist
//	ereturn local varlist `evlist'

	ereturn local predict "dvech_p"
	ereturn local estat_cmd "_dvech_estat"

	ereturn local dv_eqs  "`dv_eqs'"

	ereturn local title "Diagonal vech multivariate GARCH model"
	ereturn hidden local crittype "log likelihood"
	ereturn local arch  "`arch'"
	ereturn local garch "`garch'"
	ereturn local technique "`technique'"
	ereturn local svtechnique "`svtechnique'"

	ereturn local vce `vce'
	if "`vce'" == "robust" {
		ereturn local vcetype "Robust"
		ereturn matrix V_modelbased `V_modelbased'
	}	

	mata: mata drop `xlvec' `xlvecb' `ylvec' `arch_lvec' `garch_lvec'

	ereturn local cmd        "dvech"

	Replay , `diopts'

end

program define Replay

	syntax, *

	_get_diopts diopts , `options'

	_coef_table_header
	if !e(converged) {
		di as txt "convergence not achieved"
	}
	di 
	_coef_table, `diopts'
end

program define GetImpliedConstraints, rclass

	syntax [anything]

	if "`anything'" == "" {
		exit
	}

	tempname b 
	local k : word count `anything'
	mat `b' = J(1, `k', 0)
	mat colnames `b' = `anything'
	_ms_omit_info `b'

	if `r(k_omit)' > 0 {
		tempname omit_mat
		matrix `omit_mat' = r(omit)
		local eqnames : coleq `b'
		local pnames  : colnames `b'
		forvalues i=1/`k' {
			local omit `omit_mat'[1,`i']
			if `omit'==1 {
				local eqi  : word `i' of `eqnames'
				local nmei : word `i' of `pnames'
				constraint free
				local cns `r(free)'
				constraint define `cns' [`eqi']`nmei' = 0
				local cnslist `cnslist' `cns'
			}
		}
	}

	return local cnslist `cnslist'

end

program define check_technique

	syntax anything
	local orig "`anything'"

	local type technique
	local techniques "bhhh nr bfgs dfp"
	while ("`anything'" != "") {
		if "`type'" == "technique" {
			gettoken next anything:anything
			local okay : list next in techniques
			if !`okay' {
di as err "{p}{cmd:technique(`orig')} invalid{p_end}"
exit 498
			}
			else {
				local type tornumber
			}	
		}
		else if "`type'" == "tornumber" {
			gettoken next anything:anything
			local istechnique : list next in techniques
			if `istechnique' {
				local type tornumber
			}
			else {
				capture confirm integer number `next'
				if _rc {
di as err "{p}{cmd:technique(`orig')} invalid{p_end}"
exit 498
				}
				if `next'<=0 {
di as err "{p}{cmd:technique(`orig')} invalid{p_end}"
exit 498
				}
				local type technique
			}
		}
	}

end


