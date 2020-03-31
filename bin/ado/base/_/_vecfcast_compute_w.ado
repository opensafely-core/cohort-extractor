*! version 1.1.8  22feb2016
program define _vecfcast_compute_w, rclass
	version 8.2

	syntax  name(name=prefix id="prefix") 		///
		[ , 	STep(numlist max=1 integer >0)	///	
			Dynamic(string)			///
			DIfferences			///
			replace				///
			noSE				///
			ESTimates(string)		///
			Level(cilevel)			///
			esamp1(varname)			/// e-sample from
							/// estimates held off
		]	
		

	local tsdelta `=`: char _dta[_TSdelta]''
		
	if "`step'" == "" {
		local step 1
	}
	local step `=`step'*`tsdelta''

	if "`dynamic'" == "" {
		local dynamic `=`e(tmax)' + `tsdelta''
	}

	capture local fbegin `dynamic'
	if _rc > 0 {
		di as err "dynamic(`dynamic') invalid"
		exit 198
	}	
	
	local fbegin `=`fbegin''
	capture confirm integer number `fbegin'
	if _rc >0 {
		di as err "dynamic(`dynamic') invalid"
		exit 198
	}

	tempname sigy omega esamp

	qui gen byte `esamp' = e(sample)
	qui count if `esamp' == 1
	local rN = r(N)
	local eN = e(N)
	if `rN' < `eN' {
		di as err "{p 0 4 4}{cmd:e(sample)} indicates only "	///
			"`rN' observations in the sample, while e(N) "	///
			" is `eN'{p_end}"
		exit 498
	}

	local endog   "`e(endog)'"
	local mlag = e(n_lags) 
	local pm1 = e(n_lags) -1
	local eqs  = e(k_eq)
	
	local est_min `e(tmin)'
	local est_max `e(tmax)'

	if `fbegin' < `est_min' {
		di as err "{cmd:dynamic()} cannot specify a time "	///
			"prior to the beginning of the estimation sample"
		exit 198
	}	

	
	if `fbegin' != `est_max' + 1 {
		di as txt "{p 0 4 4 }since `dynamic' is not the period " ///
			"immediately following the estimation "		///
			"sample, {cmd:nose} is implicitly specified{p_end}"
		local se nose
	}	
	
	mat `omega' = ((e(N)/(e(N)-e(df_m)))*e(omega))
	

	local endog_n  : subinstr local endog "." "_" , all
	local endog_f
	local Dendog_f
	local cnt 1
	foreach var of local endog_n {

		if "`replace'" == "replace" {
			capture drop `prefix'`var'
			capture drop `prefix'D_`var'
			foreach typ in _SE _LB _UB {
				capture drop `prefix'`var'`typ'
			}
		}


	
		local var0 : word `cnt' of `endog'
		qui tsrevar `var0' , list
		local var0_noop `r(varlist)'
		capture confirm new variable `var0_noop'
		if _rc != 110 {
			di as err "`var0' not found"
			exit 111
		}
		local ++cnt	
		global S_vecfcast_cr " $S_vecfcast_cr `prefix'`var' " 
		qui gen double `prefix'`var' = `var0'
		char define `prefix'`var'[observed] "`var0'"
		if "`differences'" != "" {
char define `prefix'`var'[difference] "`prefix'D_`var'"
		}
		label variable `prefix'`var' `"`prefix'`var', dyn(`dynamic')"'
		local created `created' `prefix'`var'
		if "`se'" == "" {
global S_vecfcast_cr "$S_vecfcast_cr `prefix'`var'_SE " 
qui gen double `prefix'`var'_SE = .
label var `prefix'`var'_SE `"SE for `prefix'`var'"'
local created `created' `prefix'`var'_SE

global S_vecfcast_cr "$S_vecfcast_cr `prefix'`var'_LB " 
qui gen double `prefix'`var'_LB = .
label var `prefix'`var'_LB `"`=strsubdp("`level'")'% LB for `prefix'`var'"'
local created `created' `prefix'`var'_LB

global S_vecfcast_cr "$S_vecfcast_cr `prefix'`var'_UB " 
qui gen double `prefix'`var'_UB = .
label var `prefix'`var'_UB `"`=strsubdp("`level'")'% UB for `prefix'`var'"'
local created `created' `prefix'`var'_UB
		}	

		global S_vecfcast_cr  "$S_vecfcast_cr `prefix'D_`var' " 
		qui gen double `prefix'D_`var' = D.`var0'
		label var `prefix'D_`var' `"D.`var0' forecast, dyn(`dynamic')"'
		local created `created' `prefix'D_`var'

		local endog_f "`endog_f' `prefix'`var' "
		local Dendog_f "`Dendog_f' `prefix'D_`var' "
	}
	

	local trend "`e(trend)'"
	local rank = e(k_ce)

	forvalues i = 1/`rank' {
		capture drop _ce`i'
		qui gen double _ce`i' = .
	}
		
	local seas_ind `e(sindicators)'
		
	local eq_names 
	local  v_names
	foreach eqn of local Dendog_f {
		forvalues i = 1/`rank' {
			local eq_names  `eq_names' `eqn'
			local  v_names "`v_names' L._ce`i' "
		}

		foreach vn of local Dendog_f {
			forvalues i=1/`pm1' {
				local eq_names  `eq_names' `eqn'
				local  v_names "`v_names' L`i'.`vn' "

			}
		}

		if "`trend'" == "trend" {
			local eq_names  `eq_names' `eqn'
			local  v_names "`v_names' _trend "

		}

		if "`seas_ind'" != "" {
			foreach s of local seas_ind {
				local eq_names `eq_names' `eqn'
				local  v_names "`v_names' `s' "
			}
		}

		if "`trend'" != "none" & "`trend'" != "rconstant" {
			local eq_names  `eq_names' `eqn'
			local  v_names "`v_names' _cons "

		}
	}
	
	tempname b beta
	mat `b'     = e(b)
	mat `beta'  = e(beta)
	
	mat colnames `b' = `v_names'
	mat coleq `b'    = `eq_names'


	forvalues i = 1/`rank' {
		foreach vn of local endog_f {
			local b_eq "`b_eq' _ce`i' "
			local b_vn "`b_vn' `vn' "
		}	

		if "`trend'" == "trend" | "`trend'" == "rtrend" {
			local b_eq "`b_eq' _ce`i' "
			local b_vn "`b_vn' _trend "
		}

		if "`trend'" != "none"  {
			local b_eq "`b_eq' _ce`i' "
			local b_vn "`b_vn' _cons "
		}
	}

	mat colnames `beta' = `b_vn'
	mat coleq `beta'    = `b_eq'


	qui tsset, noquery
	local tvar `r(timevar)'
	local pvar `r(panelvar)'

//  does not work with one panel from a panel dataset

	if "`pvar'" != "" {
		di as err "{cmd:fcast compute} does not work with "	///
			"panel data"
		exit 498	
	}

	qui tsfill

	qui sum `tvar'

	local tmax `r(max)'
	local tmin `r(min)'

	local lastp_t `=`fbegin' + `step' - `tsdelta''

	local add = cond(`lastp_t' > `tmax', `lastp_t' - `tmax', 0)

	if `add' > 0 {
		tsappend , add(`add')
	}	

	qui replace `esamp' = 0 if `esamp' >= .
	if "`esamp1'" != "" {
		qui replace `esamp1' = 0 if `esamp1' >= .
	}	
	if "`estimates'" != "" {
		qui replace _est_`estimates' = 0 	/*
			*/ if _est_`estimates' >= .
	}

	_vecmktrend if `esamp'

	local j `=`fbegin' - `tsdelta''
	forvalues i=1/`rank' {
		qui mat score _ce`i' = `beta' if `tvar'==`j', 	///
			equation(_ce`i') replace
	}

	local stepm1 `=(`step' - `tsdelta') / `tsdelta''
	forvalues j = 0/`stepm1' {
		tempname phi`j'
		local philist `philist' `phi`j''
	}
	
	vec_mkphi `philist' 

	mat `sigy' = J(`eqs', `eqs', 0 )

	tempname zvalue 

	scalar `zvalue' = invnorm( 1 - .5*(1-.01*`level'))

	local stepi 0
	forvalues j = `fbegin'(`tsdelta')`lastp_t' {

		if "`se'" == "" {
			qui mat `sigy' = `phi`stepi''*`omega'*`phi`stepi''' ///
				+ `sigy'
			local ++stepi
		}	

		foreach eqn of local Dendog_f {
			qui mat score `eqn' = `b' if `tvar'==`j',	///
				equation(`eqn') replace
		}

		local cnt_eq 1
		foreach level of local endog_n {
			qui replace `prefix'`level' = 			///
				`prefix'D_`level' 			///
				+ L.`prefix'`level' if `tvar'==`j'

			if "`se'" == "" {
				qui replace `prefix'`level'_SE = 	///
					sqrt(`sigy'[`cnt_eq',`cnt_eq'])	///
					if `tvar' == `j'
				qui replace `prefix'`level'_UB = 	///
					`prefix'`level' 		///
					+ `zvalue'*`prefix'`level'_SE
				qui replace `prefix'`level'_LB = 	///
					`prefix'`level'		 	///
					- `zvalue'*`prefix'`level'_SE
			}		

			local ++cnt_eq	
		}


		forvalues i=1/`rank' {
			qui mat score _ce`i' = `beta' if `tvar'==`j', 	///
				equation(_ce`i') replace
		}

	}

	
	foreach levelv of local endog_n {
		qui replace `prefix'`levelv' = . 			///
			if `tvar' < `fbegin'-1 | `tvar' > `lastp_t' 

		qui replace `prefix'D_`levelv' = . 			///
			if `tvar' < `fbegin'-1 | `tvar' > `lastp_t' 
	}

	ret local created "`created'"
end
