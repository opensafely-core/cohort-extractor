*! version 1.10.0  21jun2018
program define xtreg_fe_13, eclass sort prop(xtbs)
	_vce_parserun xtreg, panel mark(I CLuster) : `0'
	if "`s(exit)'" != "" {
		exit
	}
	version 6, missing
	local options "Level(cilevel)"
	if !replay() {
		syntax varlist(fv ts) [if] [aw fw pw] [,	///
			`options'				///
			FAST I(varname) FE			///
			Robust Cluster(varname)			///
			NONEST 				/// undocumented
			DFADJ 				/// undocumented 
			VCE(passthru) *]

		_get_diopts diopts, `options'
		local cfmt `"`s(cformat)'"'
		local fvops = "`s(fvops)'" == "true" | _caller() >= 11

		_vce_parse, argopt(CLuster) opt(CONVENTIONAL Robust) old ///
			: , `vce' `robust' cluster(`cluster')
		local robust `r(robust)'
		local cluster `r(cluster)'
		local vce = cond("`r(vce)'" != "", "`r(vce)'", "conventional")

		if `fvops' {
			fvunab varlist : `varlist'
		}
		else {
			tsunab varlist : `varlist'
		}
		tokenize `varlist'

		xt_iis `i'
		local ivar "`s(ivar)'"

		if "`weight'" == "pweight" {
			local weight aweight
			local robust robust
			local pwtflag 1
		}
		
		if "`robust'" != "" & "`cluster'" == "" {
			local cluster "`ivar'"
			local robust   robust
			local vce      cluster
			tempvar csafe
			generate double `csafe' = `ivar'
		}

		tempvar x w touse tmp XB U Ti
		tempname sst sse r2
		local dv `1'

		if "`fast'"!="" {
			local fast "*"
		}
		
		quietly {
			mark `touse' [`weight'`exp'] `if'
			markout `touse' `varlist' `ivar'
			if "`cluster'" != "" {		// allow strings
				markout `touse' `cluster', strok
				tempvar csafe
				capture generate double `csafe' = `cluster' 
				local rc = _rc
				if `rc' {
					quietly ///
					egen `csafe' = group(`cluster')
				}
			}
			
			count if `touse'
			if r(N)<=1 { error 2001 }
			capture tsset, noquery
			if _rc == 0 {
				local ivar `r(panelvar)'
				local tvar `r(timevar)'
			}
			sort `ivar' `tvar' `touse'
			if `fvops' {
				fvexpand `varlist' if `touse'
				local ovlist `"`r(varlist)'"'
				fvrevar `ovlist'
				local varlist `r(varlist)'
			}
			else {
				local ovlist : copy local varlist
				tsrevar `varlist'
				local varlist `r(varlist)'
			}

			preserve
			keep if `touse'

/*			
			if "`weight'" == "pweight" {
				local weight aweight
				local robust robust
				local pwtflag 1
			}
*/			
			tempvar usrwgt
			if "`weight'" != "" {
				gen double `usrwgt' `exp'
				cap by `ivar':assert `usrwgt' ==	///
					`usrwgt'[_n-1] if _n > 1
				if _rc {
					noi di as error 		///
					 "weight must be constant within `ivar'"
					exit 199
				}
				local wexp `"=`usrwgt'"'
			}
			else {
				gen byte `usrwgt' = 1
			}
			keep `varlist' `ivar' `touse' `usrwgt' `csafe'

			// drop invariant variables
			gettoken dep indeps : varlist
			local k : word count `indeps'
			if `k' {
				tempvar junk
				gen double `junk' = .
				forvalues i = 1/`k' {
					local name : word `i' of `indeps'
					replace `junk' = `name'
					by `ivar': replace `junk' = (`name'-`name'[1])
					summ `junk', meanonly
					if r(sum) {
						local newx `newx' `name'
					}
				}
			}
			`fast' _regress `dep' `newx' [`weight'`wexp']
			`fast' local r2c = e(r2)

			if "`cluster'" != "" {
				if "`nonest'" == "" {
					if _caller() < 9.1 {
						_xtreg_chk_cl `csafe' `ivar'
					}
					else {
						_xtreg_chk_cl2 `csafe' `ivar'
					}
				}	
				local clopt "cluster(`csafe')"
				local robust robust
			}

			tokenize `varlist'		
			local tmpdep `1'
			summ `1' [`weight'`wexp']
			scalar `sst' = (r(N)-1)*r(Var)

					/* lhs 		*/
			by `ivar': gen double `x' = 	///
				sum(`1'*`usrwgt')/sum(`usrwgt')
			summ `1' [`weight'`wexp']
			by `ivar': replace `x' = (`1' - `x'[_N]) + r(mean)
			drop `1'
			rename `x' `1'
			mac shift

					/* rhs		*/
			while ("`1'"!="") {
				by `ivar': gen double `x' = 	///
					sum(`1'*`usrwgt')/sum(`usrwgt')
				summ `1' [`weight'`wexp']
				by `ivar': replace `x' = /*
					*/ (`1' - `x'[_N]) + r(mean)
				drop `1'
				rename `x' `1'
				count if `1'!=`1'[1]
				if r(N)==0 {
					replace `1' = 0
				}
				mac shift
			}
			count if `ivar'!=`ivar'[_n-1]
			local dfa = r(N)-1

			est clear
			_regress `varlist' [`weight'`wexp']
			local nobs = e(N)
			local dfb = e(df_m)
			scalar `sse' = e(rss)
			local dfr = e(df_r)
			local dfe = e(df_r) - `dfa'
			if `dfe'<=0 | `dfe'>=. { noi error 2001 } 

			if "`robust'" == "" & "`clopt'" == "" {
				local dofopt "dof(`dfe')"
			}

			* we could avoid this if only we knew dfe in advance
			_regress `varlist' [`weight'`wexp'], 	///
				`dofopt' `robust' `clopt'

			if "`cluster'" != "" {
				local N_clust = e(N_clust)
				local df_cl = e(df_r)
				local dfmc  = e(df_m)
			}

			if "`robust'" != "" | "`cluster'" != "" {
					/* backup e() results */
				local scalars : e(scalars)
				foreach i of local scalars {
					if "`i'" != "F" {
						tempname `i'	
						scalar ``i'' = e(`i')
					}
				}
				local macros : e(macros)
				foreach i of local macros {
					local e_`i' `e(`i')'
				}
				local cvar `cluster'

				tempname b V 
				mat `V' = e(V)
				mat `b' = e(b)
						  /* adjust e(V) for d.f. */
				if "`cluster'" == "" | _caller() < 9.1	///
					| "`dfadj'" != ""  {
					mat `V' = `V'*`dfr'/`dfe'
				}

				est post `b' `V'
				_post_vce_rank

					/* restore e() results */
				foreach i of local scalars {
					if "`i'" != "F" {
						est scalar `i' = ``i''
					}
				}
				foreach i of local macros {
					est local `i' `"`e_`i''"'
				}
				est local clustvar "`cvar'"

				gettoken yvar xvars : varlist
				test `xvars'
				est scalar F = r(F)
				if r(df) < `dfb' {
					est scalar F = .
					local dfb = r(df)
				}
			}
			
			tempname er2 eF ermse emss er2a ell ell0 b V
			scalar `er2' = e(r2)
			scalar `eF' = e(F)
			scalar `ermse' = e(rmse)
			scalar `emss' = e(mss)
			scalar `er2a' = e(r2_a)
			scalar `ell' = e(ll)
			scalar `ell0' = e(ll_0)
			
			mat `b' = e(b)
			mat `V' = e(V)
			local xvars : subinstr local ovlist "`dv'" ""
			version 11: mat colnames `b' = `xvars' _cons
			version 11: mat colnames `V' = `xvars' _cons
			version 11: mat rownames `V' = `xvars' _cons
			est post `b' `V' [`weight'`wexp'], ///
				findomitted obs(`nobs') depname(`dv')
			_post_vce_rank
	
			if "`robust'" != "" | "`cluster'" != ""{ 
				est local vcetype  "Robust"
				est local clustvar "`cvar'"
			}
			est local vce "`vce'"
			est local cmd
			est scalar rss = `sse'
			if "`cluster'" != "" & _caller() >= 9.1 	///
				& "`dfadj'" == "" {
				est scalar df_m = `dfmc'
			}
			else {
				est scalar df_m = `dfa' + `dfb' 
			}	

			local df_r = `nobs' -1 - e(df_m)
			if "`cluster'" == "" { 
				est scalar df_r = `df_r'
			}
			else {
				est scalar N_clust = `N_clust'
				est scalar df_r = min(`df_r', `df_cl')
			}

			est scalar r2 = `er2'
			est scalar rmse = `ermse'
			est scalar mss = `emss'
			est scalar r2_a = `er2a'
			est scalar ll = `ell'
			est scalar ll_0 = `ell0'
			
			scalar S_E_sse = e(rss)
			global S_E_mdf = e(df_m)
			global S_E_tdf = e(df_r)
			if "`fast'"!="" { 
				exit 
			}

			est scalar tss = `sst'
			est scalar N = `nobs'
			est scalar df_b = `dfb' 
			est scalar r2_w = `er2' 	
						
			est local ivar "`ivar'"
			est scalar df_a = `dfa'	/* # of coeffs absorbed */
			est scalar F = `eF'

			scalar S_E_sst = `sst'
			scalar S_E_nobs = `nobs'
			global S_E_dfb = `dfb'
			scalar S_E_r2w = e(r2_w)
			global S_E_ivar	"`ivar'"
			global S_E_dfa  `dfa' 	/* # of coefs absorbed */
			global S_E_f = e(F)
			
			scalar `r2'=1-`sse'/`sst'
			if "`robust'" == "" & "`cluster'" == "" { 
				est scalar F_f = ((`r2'-`r2c')/(e(df_a)))/ /*
					*/ ((1-`r2')/e(df_r))
			}		

			scalar S_E_f2 = e(F_f)

			sort `ivar'  /* sic, in case in varlist */
			by `ivar': gen `c(obs_t)' `Ti' = _N if _n==_N
			summ `Ti'
			scalar S_E_T = r(max)
			est scalar Tbar = r(mean)
			scalar S_E_Tbar = e(Tbar)
			est scalar Tcon = (r(min)==r(max))
			global S_E_Tcon = e(Tcon) 

			est scalar g_min = r(min)
			est scalar g_avg = r(mean)
			est scalar g_max = r(max)

			if "`weight'" != "" {
				if "`pwtflag'" == "1" {
					est local wtype "pweight"
				}
				else {
					est local wtype "`weight'"
				}
				est local wexp "`exp'"
			}

			count if `Ti'<. 
			est scalar N_g = r(N)
			scalar S_E_n = r(N)

			restore
			est local depvar `dv'
			tempname mysamp
			qui gen byte `mysamp' = `touse'
			matrix `b' = e(b)
			est repost b=`b', esample(`mysamp') buildfvinfo

			_predict double `XB' if `touse', xb
			sort `ivar' `touse'
			by `ivar' `touse': gen double `U' = /*
				*/ cond(`touse' & _n==_N, /*
				*/ sum(`tmpdep')/_n-sum(`XB')/_n,.) /*
				*/ if `touse'
			summ `U'
			est hidden scalar ui = sqrt(r(Var))
			est scalar sigma_u = sqrt(r(Var))
			scalar S_E_ui= e(sigma_u)
			by `ivar' `touse': replace `U' = `U'[_N]
			corr `XB' `U'
			est scalar corr = r(rho)
			scalar S_E_rho = e(corr)

			corr `tmpdep' `XB' if `touse'
			est scalar r2_o = r(rho)^2
			scalar S_E_r2o = e(r2_o)

			by `ivar' `touse': replace `XB' = /*
				*/ cond(_n==_N & `touse', /*
				*/ sum(`XB'/_N),.)
			by `ivar' `touse': replace `U' = /* 
				*/ cond(_n==_N & `touse', /*
				*/ sum(`tmpdep'/_N),.)
			/* handle one group		*/
			count if `U'<. & `XB'<.
			if r(N) == 0 {
				error 2000
			}
			else if r(N) == 1 {
				est scalar r2_b = .
			}
			else {
				corr `U' `XB'
				est scalar r2_b = r(rho)^2
			}
			scalar S_E_r2b = e(r2_b)

			est scalar sigma_e = sqrt(e(rss)/`dfe') 
			est scalar sigma = sqrt(e(sigma_u)^2 + e(sigma_e)^2)
			est scalar rho   = e(sigma_u)^2 / e(sigma)^2
			
			est local model fe
			est local predict xtrefe_p
			est local marginsnotok E U UE SCore STDP XBU
			est local cmd xtreg
		
			tokenize `varlist'
			mac shift
			global S_E_vl `*'
			global S_E_if `"`if'"'
			global S_E_depv "`dv'"
			global S_E_cmd2 "xtreg_fe"
			global S_E_cmd "xtreg"
		}
	gettoken lhs xnames : ovlist
	local coln : colnames e(b)
	local i 1

	foreach var of local coln {
	  local xname : word `i' of `xnames'
		_ms_parse_parts `var'
		if `r(omit)' {
			_ms_parse_parts `xname'
			if !`r(omit)' {
				noi di as txt "note: `xname' omitted" /*
				*/ " because of collinearity"
			}
		}
		local ++i
	  }
	}
	else {
		if ("`e(model)'" !="fe") { 
			error 301 
		}
		syntax [, `options' *]
		_get_diopts diopts, `options'
		local cfmt `"`s(cformat)'"'
	}

	if e(Tcon) {
		local Twrd "    T"
	}
	else	local Twrd "T-bar"

	local dft = e(N) - 1
//	local dfe = `dft' - e(df_m)
	local dfe = e(df_r)
	* local ssm = scalar(e(tss) - e(rss))
	* local msm = `ssm'/e(df_m)
	local ssm . 
	local msm .

	local mse = e(rss)/`dfe'			
	if !missing(e(chi2)) {
		local p = chi2tail(e(df_b),e(chi2))	
	}
	else	local p = fprob(e(df_b),`dfe',e(F))	

	#delimit ;
        di _n in gr "Fixed-effects (within) regression"
                _col(49) in gr "Number of obs" _col(68) "="
                _col(70) in ye %9.0f e(N) ;
        di in gr "Group variable: " in ye abbrev("`e(ivar)'",12) in gr
		_col(49) "Number of groups" _col(68) "="
                _col(70) in ye %9.0g e(N_g) _n ;
        di in gr "R-sq:  within  = " in ye %6.4f e(r2_w)
                _col(49) in gr "Obs per group: min" _col(68) "="
                _col(70) in ye %9.0g e(g_min) ;
        di in gr "       between = " in ye %6.4f e(r2_b)
                _col(64) in gr "avg" _col(68) "="
                _col(70) in ye %9.1f e(g_avg) ;
        di in gr "       overall = " in ye %6.4f e(r2_o)
                _col(64) in gr "max" _col(68) "="
                _col(70) in ye %9.0g e(g_max) _n ;

	if !missing(e(chi2)) | "`e(df_r)'" == "" { ;
		di in gr _col(49) "Wald chi2(" in ye e(df_b) 
			in gr ")" _col(68) "=" _col(70) in ye %9.2f e(chi2) ;
		di in gr "corr(u_i, Xb)" _col(16) "= " in ye %6.4f e(corr)
			in gr _col(49) "Prob > chi2" _col(68) "="
			_col(73) in ye %6.4f `p' _n ;
	} ;
	else { ;
		if e(F) < . { ;
			di in gr _col(49) "F(" in ye e(df_b) in gr "," 
			in ye `dfe' in gr ")" _col(68) "=" _col(70) 
			in ye %9.2f e(F) ;
		} ;
		else { ;
			di in smcl _col(49) 
			"{help j_robustsingular##|_new:F(`e(df_b)',`dfe')}" 
			_col(68) in gr "=" _col(70) in ye %9.2f e(F) ;
		} ;
		di in gr "corr(u_i, Xb)" _col(16) "= " in ye %6.4f e(corr)
			in gr _col(49) "Prob > F" _col(68) "="
			_col(73) in ye %6.4f `p' _n ;
	} ;
	#delimit cr

	_coef_table , level(`level') plus `diopts'
	
	if c(noisily)==0 {
		exit
	}
	
	local c1 = `"`s(width_col1)'"'
	local w = `"`s(width)'"'
	if "`c1'"=="" {
		local c1 13
	}
	else {
		local c1 = int(`c1')
	}
	if "`w'"=="" {
		local w 78
	}
	else {
		local w = int(`w')
	}
	
	local c = `c1' - 1
	local rest = `w' - `c1' - 1
	if `"`cfmt'"' != "" {
		local rho	: display `cfmt' e(rho)
		local sigma_u	: display `cfmt' e(sigma_u)
		local sigma_e	: display `cfmt' e(sigma_u)
	}
	else {
		local rho	: display %10.0g e(rho)
		local sigma_u	: display %10.0g e(sigma_u)
		local sigma_e	: display %10.0g e(sigma_e)
	}
       	di in smcl in gr %`c's "sigma_u" " {c |} " in ye %10s "`sigma_u'"
       	di in smcl in gr %`c's "sigma_e" " {c |} " in ye %10s "`sigma_e'"
       	di in smcl in gr %`c's "rho" " {c |} " in ye %10s "`rho'" /*
		*/ in gr "   (fraction of variance due to u_i)"
	di in smcl in gr "{hline `c1'}{c BT}{hline `rest'}"

	if "`robust'"=="" & "`cluster'"=="" & "`e(prefix)'"!="bootstrap" {
	 	local ff : di %8.2f e(F_f)
		local ff = trim("`ff'")
		#delimit ;
		di in gr "F test that all u_i=0: " 
			"F(" in ye e(df_a) in gr ", " in ye e(df_r) in gr ") = "
			in ye %8.2f "`ff'" _col(62) in gr "Prob > F = " 
			in ye %6.4f fprob(e(df_a),e(df_r),e(F_f)) ;
		#delimit cr
	}
end
