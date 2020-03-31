*! version 1.3.5  09feb2015
program define newey_7, eclass sort
	version 6.0, missing

	if !replay() {
		syntax varlist [if] [in] [aw/], LAG(integer) [ /*
			*/ T(string) noCONstant FORCE /*
			*/ Level(cilevel) ] 
		marksample touse	/* tvar to be subsequently marked out */

		if `lag'<0 { 
			di in red `"lag(`lag') invalid"'
			exit 198
		}

		quietly {
			if `lag' > 0 {
				xt_tis `t'
				local tvar `"`s(timevar)'"'
				markout `touse' `tvar'
			}
			else {
				tempvar tvar
				gen `c(obs_t)' `tvar' = _n
			}
			tokenize `varlist'
			local depv `"`1'"'
			mac shift
			local indv `"`*'"'
			if `"`constan'"'==`""' {
				tempvar CONS
				gen byte `CONS' = 1
				local carg `""'
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
					*/ `"`tvar' has duplicate values"'
					exit 198
			}
			if r(tflag)==1 & `lag' > 0 & `"`force'"' == "" {
				noi di in red /*
*/ `"`tvar' is not regularly spaced -- use the force option to override"'
				exit 198
			}

			if `"`weight'"' == "aweight" {
				summ `wvar' if `touse'
				replace `wvar' = `wvar'/r(mean) if `touse'
			}

			reg `depv' `indv' if `touse' `wtexp', `carg'
			if e(N)==0 | e(N)>=. { 
				di in red `"no observations"'
				exit 2000
			}
			local nobs=e(N)
			local mdf=e(df_m)
			local tdf=e(df_r)
			*local rmse=e(rmse)
			global S_4 `"`indv'"' 
			noi fixnames
			local xv `"$S_1"'
			local indc `"$S_2 `CONS'"'
			local nx $S_3
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
					replace `vt1' = `x'[_n-`j']*`e'* /*
					*/ `e'[_n-`j']*`wvar'[_n-`j']* /*
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
				*/ depname(`depv') esample(`touse')

			if `"`indv'"'==`""' {
				est scalar df_m = 0
				est scalar df_r = `tdf'
				est scalar F = .
			}
			else {
				qui test `indv', min
				est scalar df_m = r(df)
				est scalar df_r = r(df_r)
				est scalar F = r(F)
			}


			/* Double saves */
			global S_E_mdf = e(df_m)
			global S_E_tdf = e(df_r)
			global S_E_f = e(F)


			est local depvar `"`depv'"'
			est scalar N =  `nobs'
			est scalar lag =  `lag'
			est local vcetype `"Newey-West"'
			est local predict newey_p
			if "`weight'"=="aweight" {  // only ones allowed
				est local wtype "`weight'"
				est local wexp `"`exp'"'
			}
			est local cmd     `"newey"'

			/* Double saves */
			global S_E_depv `"`e(depvar)'"'
			global S_E_nobs `"`e(N)'"'
			global S_E_lag  `"`e(lag)'"'
			global S_E_vce  `"`e(vcetype)'"'
			global S_E_cmd  `"`e(newey)'"'
		}
	}
	else {
		if `"`e(cmd)'"' != `"newey"' { error 301 }
		syntax [, Level(cilevel)]
	}
	#delimit ;
	di _n in gr
		`"Regression with Newey-West standard errors"'
		_col(53)
		`"Number of obs  ="' in yel %10.0f e(N) _n
		in gr `"maximum lag: "' in ye e(lag)   
		_col(53) 
		in gr 
		`"F("' in gr %3.0f e(df_m) in gr `","' in gr %6.0f e(df_r) 	
		in gr `")"' _col(68) `"="' in ye %10.2f e(F) _n
	        /* in gr `"coefficients: "' /*
		*/ in ye `"`e(vcetype)' least squares"' */
		_col(53) in gr `"Prob > F       =    "' 
		in ye %6.4f fprob(e(df_m),e(df_r),e(F)) _n ;
		
	#delimit cr
	mat mlout, level(`level')
end


program define fixnames
	tempname b v
	mat `b' = e(b)
	mat `v' = e(V)

	local xnam : colnames(`b')
	local nx : word count `xnam'

	tokenize `"`xnam'"'
	local i 1
	while `i' <= `nx' {
		if `b'[1,`i'] == 0 & `v'[`i',`i'] == 0 {
			local vnam : word `i' of `xnam'
			noi di in gr _n `"`vnam' "' in blue /*
			*/ `"dropped due to collinearity"'
			local ``i'' `" "'
			global S_5 = 1
		}
		local i = `i'+1
	}
	local xnam `"`*'"'
	local nx : word count `xnam'
	tokenize `"`xnam'"'
	if `"``nx''"' == `"_cons"' {
		local `nx' `""'
	}
	global S_1 `"`xnam'"'
	global S_2 `"`*'"'
	global S_3 = `nx'
end
	
program define Checkt, rclass
	args tvar touse 

	replace `touse'=. if `touse'==0
	ret scalar tflag = 0 
	sort `touse' `tvar'
	tempvar tt
	gen `tt' = `tvar'-`tvar'[_n-1] if `touse'<.	
	summ `tt', meanonly
	if r(min) != r(max) {
		ret scalar tflag = 1
	}
	if r(min) == 0 {
		ret scalar tflag = 2
	}
	replace `touse'=0 if `touse'>=.
	sort `touse' `tvar'
end
exit

/* 
   update:
   version 1.3.0 	add -sort- to keep the sort order	(whg) 
*/
