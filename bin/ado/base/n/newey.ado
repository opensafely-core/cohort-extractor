*! version 1.6.0  12jan2015
program define newey, eclass sort byable(recall)
	version 8, missing
	
	if replay() & _by() {
		error 190
	}
	
	if _caller() < 8 {
		newey_7 `0'
		exit
	}

	if !replay() {
		local vv : display "version " string(_caller()) ", missing:"
		local cmdline : copy local 0
		syntax varlist(fv ts) [if] [in] [aw/], LAG(integer) [ /*
			*/ noCONstant FORCE /*
			*/ Level(cilevel) *] 
		_get_diopts diopts, `options'
		marksample touse	/* tvar to be subsequently marked out*/
		local fvops = "`s(fvops)'" == "true" | _caller() >= 11

		if `lag'<0 { 
			di in red `"lag(`lag') invalid"'
			exit 198
		}

		quietly {
			cap xt_tis
			if _rc {
				di as err "time variable not set, " /*
				*/ "use -tsset varname ...-"
				exit 111
			}
			local tvar `"`s(timevar)'"'
			markout `touse' `tvar'

			fvunab varlist : `varlist'
			tokenize `varlist'
			local depv `"`1'"'
			mac shift
			local indv `"`*'"'

			if `"`constant'"'==`""' {
				tempvar CONS
				gen byte `CONS' = 1
				local carg `""'
				local names `names' "_cons"
			}
			else {
				local CONS `""'
				local carg `"nocons"'
				if `"`indv'"'==`""' {
					di in red /*
			*/ `"may not specify noconstant without regressors"'
					exit 198
				}
			}
			local indc `"`indv' `CONS'"'

			tempvar wvar
			if `"`exp'"'==`""' {
				gen byte `wvar'=1
				local weight `"fweight"'
				local wtexp `"[`weight'=`wvar']"'
			}
			else {
				gen double `wvar' = `exp'
				local wtexp `"[`weight'=`wvar']"'
			}

			Checkt `tvar' `touse'
			if r(tflag)==2 {
				noi di in red /*
*/ `"`tvar' is regularly spaced, but does not have intervals of 1"'
				exit 198
			}
			if r(tflag)==1 & `lag' > 0 & `"`force'"' == "" {
				noi di in red /*
*/ `"`tvar' is not regularly spaced"'
				exit 198
			}

			if `"`weight'"' == "aweight" {
				summ `wvar' if `touse'
				replace `wvar' = `wvar'/r(mean) if `touse'
			}

			if `fvops' {
				local rmcoll "version 11: _rmcoll"
			}
			else	local rmcoll _rmcoll
			noi `rmcoll' `indv' if `touse' `wtexp', `carg'
			if `fvops' {
				fvexpand `r(varlist)'
				local indv `"`r(varlist)'"'
			}
			else	local indv `"`r(varlist)'"'
			`vv' ///
                        _regress `depv' `indv' if `touse' `wtexp', `carg'
			if e(N)==0 | e(N)>=. { 
				di in red `"no observations"'
				exit 2000
			}
			local nobs=e(N)
			local mdf=e(df_m)
			local tdf=e(df_r)
			*local rmse=e(rmse)
			global S_4 `"`indv'"'
			
			local xv `"`indv'"'
			if "`constant'" == "" {
				local xv `"`xv' _cons"'
			}
			local indc `"`indv' `CONS'"'
			local nx : word count `xv'

			tempname beta /* scale */
			mat `beta' = e(b)
			
			tempvar e 
			predict double `e' if `touse', resid

			*	scalar `scale' = sqrt(`rmse')

			tempvar vt1 vt2
			gen double `vt1' = .
			gen double `vt2' = .
			tempname xtx tt tx tx2 tt2 xtix tp2 tx3 xtiy tt3

			if `"`weight'"'=="aweight" {
				local ow `"`wvar'"'
			}
			else 	local ow 1

			local j 0
			while `j' <= `lag' {
				capture mat drop `tt' 
				capture mat drop `tt2'
				capture mat drop `tt3'

				local i 1
				while `i' <= `nx' {
					local x : word `i' of `xv'
					if `"`x'"' == `"_cons"' {
						local x `"`CONS'"'
					}
					else {
	_ms_parse_parts `x'
	if r(type) == "interaction" {
		local K = r(k_names)
		local spec
		local sharp
		forval k = 1/`K' {
			local spec `spec'`sharp'`r(op`k')'l`j'.`r(name`k')'
			local sharp "#"
		}
		local x : copy local spec
	}
	else {
		local x l`j'.`x'
	}
					}
					replace `vt1' = `x'*`e'* /*
					*/ l`j'.`e'*l`j'.`wvar'* /*
					*/ `ow' if `touse'
					mat vecaccum `tx' = `vt1' `indc' /*
					*/ if `touse', nocons
					mat `tt' = nullmat(`tt') \ `tx'

					local i = `i'+1
				}
				mat `tt' = (`tt'+`tt'')*(1-`j'/(1+`lag'))
				if `j' > 0 {
					mat `xtx' = `xtx' + `tt'
				}
				else {
					mat `xtx' = `tt' * 0.5
				}
				local j = `j'+1
			}
			tempname xtxi v
			mat accum `xtxi' = `indv' if `touse' /*
				*/ `wtexp', `carg'
			mat `xtxi' = syminv(`xtxi')
			mat `v' = (`xtxi'*`xtx'*`xtxi')*(`nobs'/`tdf')
			mat `v' = (`v' + `v'')/2

			mat post `beta' `v', dof(`tdf') obs(`nobs') /*
				*/ depname(`depv') esample(`touse') /*
				*/ buildfvinfo
			if `"`indv'"'==`""' {
				eret scalar df_m = 0
				eret scalar df_r = `tdf'
				eret scalar F = .
			}
			else {
				qui test `indv', min
				eret scalar df_m = r(df)
				eret scalar df_r = r(df_r)
				eret scalar F = r(F)
			}


			/* Double saves */
			global S_E_mdf = e(df_m)
			global S_E_tdf = e(df_r)
			global S_E_f = e(F)


			eret local depvar `"`depv'"'
			eret scalar N =  `nobs'
			eret scalar lag =  `lag'
			eret local vcetype `"Newey-West"'
			eret local predict newey_p
			eret local estat_cmd "newey_estat"
			if "`weight'"=="aweight" {  // only ones allowed
				eret local wtype "`weight'"
				eret local wexp `"= `exp'"'
			}
			version 10: ereturn local cmdline `"newey `cmdline'"'
			eret local cmd     `"newey"'
			eret local title /*
				*/ "Regression with Newey-West standard errors"
			/* Double saves */
			global S_E_depv `"`e(depvar)'"'
			global S_E_nobs `"`e(N)'"'
			global S_E_lag  `"`e(lag)'"'
			global S_E_vce  `"`e(vcetype)'"'
			global S_E_cmd  `"`e(newey)'"'
			_post_vce_rank
		}
	}
	else {
		if `"`e(cmd)'"' != `"newey"' {
			error 301
		}
		syntax [, Level(cilevel) *]
		_get_diopts diopts, `options'
	}
	#delimit ;
	di _n in gr
		`"Regression with Newey-West standard errors"'
		_col(49) `"Number of obs"'
		_col(67) "= " in yel %10.0fc e(N) _n
		in gr `"maximum lag: "' in ye e(lag)   
		_col(49) 
		in gr 
		`"F("' in gr %3.0f e(df_m) in gr `","' in gr %10.0f e(df_r)
		in gr `")"' _col(67) `"= "' in ye %10.2f e(F) _n
	        /* in gr `"coefficients: "' /*
		*/ in ye `"`e(vcetype)' least squares"' */
		_col(49) in gr `"Prob > F"' _col(67) "= "
		in ye %10.4f fprob(e(df_m),e(df_r),e(F)) _n ;
		
	#delimit cr
	_coef_table, level(`level') `diopts'
end

program define Checkt, rclass sort
	args tvar touse 

	replace `touse'=. if `touse'==0
	summ `touse', meanonly
	if r(N) == 0 {
		exit 2000
	}
	ret scalar tflag = 0 
	sort `touse' `tvar'
	tempname tsdelta
	if "`: char _dta[_TSdelta]'" != "" {
		scalar `tsdelta' = `: char _dta[_TSdelta]'
	}
	else {
		scalar `tsdelta' = 1
	}
	tempvar tt
	gen double `tt' = (`tvar'-`tvar'[_n-1])/`tsdelta' if `touse'<.	
	summ `tt', meanonly
	if r(min) != r(max) {
		ret scalar tflag = 1
	}
	if r(mean) > 1 & r(min) == r(max) {
		ret scalar tflag = 2
	}
	replace `touse'=0 if `touse'>=.
end

/* 
   update:
   version 1.3.0 	add -sort- to keep the sort order	(whg)
   version 1.3.6	allow time-series operators;
			syntax changed: 1) must -tsset- instead of -t()-
					2) -force- removed
			add version control
   version 1.3.12	(BPP, 20050608) Added an _rmcoll to remove
   			collinear variables before calling regress.
   			The "fixnames" subprogram in prior versions 
   			no longer need and hence removed.
*/

