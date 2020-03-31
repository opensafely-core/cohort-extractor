*! version 1.0.9  21oct2019
program define dvech_p, properties(notxb)
	version 11

	syntax anything [if] [in] , 		///
		[				///
		xb 				///
		Residuals 			///
		EQuation(string) 		///
		Variance			///
		DYNamic(string)			///
		]

	if "`e(cmd)'" != "dvech" {
		exit 301
	}	

	tempvar touse
	if "`if'`in'" != "" {
		mark `touse' `if' `in'
	}
	else {
		qui gen byte `touse'  = 1
	}
	local indeps `e(indeps)'
	local indeps : subinstr local indeps ";" " ", all
	local indeps : subinstr local indeps "_cons" " ", all word
	local vlist `e(depvars)' `indeps'

	if `"`dynamic'"' == "" {
		markout `touse' `indeps'
	}	

	_ts tvar pvar if `touse', sort onepanel

	if `"`dynamic'"' != "" {
		local dperiod = `dynamic'
		if _rc {
			di `"{err}option {bf:dynamic(`dynamic')} invalid"'
			exit 498
		}

		local okay 1
		foreach var in `e(depvars)' {
			_ms_parse_parts `var'
			if "`r(op)'" != "" | "`r(ts_op)'" != "" {
				di "{p}{err}dynamic predictions are "	///
					"not allowed when a "		///
					"dependent variable has "	///
					"time-series operators{p_end}"
				exit 498		
			}
			
		}

		qui sum `tvar' if `touse' , meanonly
		local tmin = r(min)
		local tmax = r(max)

		if `dperiod' < `tmin' | `tmax'<`dperiod' {
			di `"{err}option {bf:dynamic(`dynamic')} specifies "'	///
				"an invalid time period"
			exit 498
		}
	}


	local n_els : word count `anything'

	if `n_els' >2 {
		di as err `"`anything' invalid"'
		exit 198
	}
	else if `n_els' == 1 {
		local nvlist `"`anything'"'
		local type float
	}
	else {
		gettoken type nvlist:anything

		local typelist byte int long float double

		local istype : list type in typelist

		if !`istype' {
			di as err `"`anything' invalid"'
			exit 198
		}
	}	

	if "`xb'`residuals'`variance'" == "" {
		local stat xb
		di as txt "(option {bf:xb} assumed)"
	}
	else {
		local slist xb residuals variance
		local stat "`xb' `residuals' `variance'" 
		
		local stat : list stat & slist
		
		local n_stat : word count `stat'
		if `n_stat' != 1 {
			di as err "{bf:`stat'} invalid: More than one " ///
				"statistic specified"
			exit 498
		}
	}
	
	local len : ustrlen local nvlist
	if `len' >32 {
		di as err `"`anything' invalid"'
		exit 198
	}
	local isstub = (bsubstr("`nvlist'",`len',1)=="*")

	if `isstub' {
		local nvlist = bsubstr("`nvlist'", 1, `len'-1)
		if `"`equation'"' != "" {
			di as err `"option {bf:equation()} may not "' ///
				"be specified with the {it:stub}{bf:*} syntax"
			exit 198
		}
	}
	else {
		if `"`equation'"' != "" {
			gettoken first second:equation, parse(",")

			_getnovar `first'
			local eq1nor `r(norvar)'
			local eq1num  `r(number)'
			local eq1dep  `r(depvar)'

			if "`second'" == "" {
				local cnt : word count `first'
				if `cnt' > 1 {
di as err "option {bf:equation(`equation')} invalid"
exit 498
				}
			}
			else {
				if "`stat'" == "xb"  {
di as err "option {bf:equation(`equation')} not allowed with option {bf:`stat'}"
exit 498
				}

						// put comma into first
				gettoken first second:second, parse(",")
				_getnovar `second'
				local eq2nor `r(norvar)'
				local eq2num  `r(number)'
				local eq2dep  `r(depvar)'

			}
		}
		else {
			local equation "#1"
			local eq1nor variable
			local eq1num  1
			local eq1dep : word 1 of `e(depvars)' 
		}

		if "`stat'" == "variance" & "`eq2num'"=="" {
			local eq2nor variable
			local eq2num  `eq1num'
			local eq2dep : word `eq1num' of `e(depvars)' 
		}
	}

	if `"`dynamic'"' != "" {
		if "`stat'" == "residuals" {
			di "{err}option {bf:residuals} may not be specified "	///
				"with option {bf:dynamic()}"
			exit 498
		}

		
		if "`stat'" == "xb" {
			tempname b b0
			tempvar touse2 touse_dyn touse_ndyn
			qui gen byte `touse2' = `touse' 
			qui replace `touse2'  = 1 if `tvar' >= `dperiod'
			qui gen byte `touse_dyn' = 	///
				cond(`tvar' >= `dperiod', 1, 0)
			qui gen byte `touse_ndyn' = 	///
				cond(`tvar' < `dperiod', 1, 0)

			matrix `b'  = e(b)
			matrix `b0' = e(b)

			local col_eq    : coleq `b'
			local col_names : colnames `b'

			local depvars `e(depvars)'
			local dv_eqs  `e(dv_eqs)'

			local i 1
			foreach var of local depvars {
				tempname dep`i'
				qui gen double `dep`i'' = `var' 	///
					if `touse_ndyn'
				local newlist `newlist' `dep`i''
				local ++i
			}

			local meqs : word count `newlist'
			foreach wrd of local col_names {
				_ms_parse_parts `wrd'
				local op   `r(op)'
				local nname `r(name)'

				forvalues i=1/`meqs' {
local old : word `i' of `depvars'
local new : word `i' of `newlist'
local nname : subinstr local nname "`old'" "`new'", all word
				}
				if "`op'" != "" {
					local op "`op'."
				}	

				local clist `clist' `op'`nname'
			}
			local col_names `clist'			

			local parms : word count `col_eq'
			forvalues i=1/`parms' {
				local eqi : word `i' of `col_eq'
				local ni  : word `i' of `clist'
				local newnames `newnames' `eqi':`ni'
			}
			matrix colnames `b' = `newnames'

			forvalues t=`dynamic'/`tmax' {
				local i 1
				foreach var of local depvars {
					local haseq : list var in dv_eqs
					if `haseq' {
						qui mat score 		///
							`dep`i''=`b'	///
							if `tvar'==`t'	///
							& `touse',	///
							equation(`var')	///
							replace
						qui replace `dep`i'' =.	///
							if `tvar'==`t'	///
							& !`touse'
					}
					else {
						qui replace `dep`i'' = 	///
							cond(`touse',	///
								0, .)	///
							if `tvar'==`t'	
					}
					local ++i
				}
			}

			local i 1
			foreach var of local depvars {
				local haseq : list var in dv_eqs
				if `haseq' {
					qui mat score `dep`i'' = `b0'	///
				            if `touse_ndyn' & `touse',	///
					    equation(`var') replace
				}
				else {
					qui replace `dep`i''=0 		///
					    if `touse_ndyn' & `touse'
				}
				qui replace `dep`i'' = .		/// 
				   	    if `touse_ndyn' & !`touse'
				local ++i
			}


			local dlab "dynamic(`dynamic')"
			if `isstub' {
				local i 1
				local q 
				foreach var of local depvars {
					local var : subinstr local var "." "_" 
					confirm name `nvlist'_`var'
					local dvi : word `i' of `newlist'
					`q' gen `type' `nvlist'_`var' = `dvi'
					local lab "xb prediction, `var', `dlab'"
					label variable `nvlist'_`var' `"`lab'"'
					local ++i
					local q  quietly
				}	
			}
			else {
				local dvi : word `eq1num' of `newlist'
				local var : word `eq1num' of `depvars'
				gen `type' `nvlist' = `dvi'
				local lab "xb prediction, `var', `dlab'"
				label variable `nvlist' `"`lab'"'
			}
			exit
		}
		else {			// variance case 
			tempvar touse_dyn
			if `isstub' {
				tempname cpull
				local k2 = .5*e(k_dv)*(e(k_dv) + 1)
				mata: st_matrix("`cpull'", 1..`k2')

				GetVariance , nvlist(`nvlist')		///
					touse(`touse') cpull(`cpull') 	///
					all dperiod(`dperiod') 		///
					dynamic(`dynamic')
			}
			else {
				// eq2num is column j eq1num is row i in H_t
				if `eq2num' > `eq1num' {
					local tmp     `eq1num'
					local eq1num  `eq2num'
					local eq2num  `tmp'
				}
				local eq1dep : word `eq1num' of `e(depvars)' 
				local eq2dep : word `eq2num' of `e(depvars)' 
				local col = (`eq2num'-1)*e(k_dv) 	///
					- .5*(`eq2num'-2)*(`eq2num'-1)  ///
					+ `eq1num' - (`eq2num'-1)
				tempname cpull
				matrix `cpull' = (`col')
				GetVariance , nvlist(`nvlist') 		///
					touse(`touse') cpull(`cpull')	///
					dperiod(`dperiod') 		///
					dynamic(`dynamic')		///
					eqname(`eq1dep', `eq2dep')
			}

			exit
		}
	}

					// not dynamic from here down

	if `isstub' {
		if "`stat'"=="xb" {
			local dv_eqs   `e(dv_eqs)'
			local depvars  `e(depvars)'
			foreach depi of local depvars {
				local depi_n : subinstr local depi "." "_" 
				confirm name `nvlist'_`depi_n'
				local haseq : list depi in dv_eqs
				if `haseq' {
					_predict `type' `nvlist'_`depi_n' ///
						if `touse', xb equation(`depi')
				}
				else {
					gen `type' `nvlist'_`depi_n' = 0  ///
						if `touse'
				}
			}
			exit
		}
		else if "`stat'"=="residuals" {
			local dv_eqs   `e(dv_eqs)'
			local depvars  `e(depvars)'

			local q
			tempvar xb
			foreach depi of local depvars {
				local depi_n : subinstr local depi "." "_" 
				confirm name `nvlist'_`depi_n'

				local lab "residuals, `depi'"
				local haseq : list depi in dv_eqs
				if `haseq' {
					capture drop `xb'
					qui _predict double `xb'	 ///
						if `touse', xb equation(`depi')
					`q' gen `type' `nvlist'_`depi_n' = ///
						`depi' - `xb' if `touse'
				}		
				else {
					`q' gen `type' `nvlist'_`depi_n' = ///
						`depi' if `touse'
				}
				label variable `nvlist'_`depi_n' `"`lab'"'
				local q quietly
			}
			exit
		}
		else if "`stat'"=="variance" {
			tempname cpull
			local k2 = .5*e(k_dv)*(e(k_dv) + 1)
			mata: st_matrix("`cpull'", 1..`k2')

			GetVariance , nvlist(`nvlist')	///
				touse(`touse') cpull(`cpull') all
			exit 
		}
		else {
			di as err "option {bf:`stat'} invalid"
			exit 198
		}
	}
	else {
		if "`stat'"=="xb" {
			local dv_eqs   `e(dv_eqs)'
			local depvars  `e(depvars)'
			local haseq : list first in dv_eqs
			if `haseq' {
				_predict `type' `nvlist' if `touse', xb	///
					equation(`first')
			}
			else {
				local inmodel : list first in depvars
				if `inmodel' {
					gen `type' `nvlist' = 0 if `touse'
				}
				else {
					di "{err}equation `first' not found"
					exit 303
				}
			}
			exit
		}
		else if "`stat'"=="residuals" {
			local dv_eqs   `e(dv_eqs)'
			local depvars  `e(depvars)'
			local haseq : list eq1dep in dv_eqs
			local lab "residuals, `eq1dep'"
			if `haseq' {
				tempvar xb
				local depi `eq1dep'
				qui _predict double `xb' if `touse', xb	///
					equation(`first')
				gen `type' `nvlist' = `depi' - `xb'	///
					if `touse'
			}
			else {
				local inmodel : list eq1dep in depvars
				if `inmodel' {
					gen `type' `nvlist' =		///
						`eq1dep' if `touse'
				}
				else {
					di "{err}equation `first' not found"
					exit 303
				}
			}
			label variable `nvlist' `"`lab'"'
			exit
		}
		else if "`stat'"=="variance" {
			// eq2num is column j eq1num is row i in H_t

			if `eq2num' > `eq1num' {
				local tmp     `eq1num'
				local eq1num  `eq2num'
				local eq2num  `tmp'
			}
			local eq1dep : word `eq1num' of `e(depvars)' 
			local eq2dep : word `eq2num' of `e(depvars)' 
			local col = (`eq2num'-1)*e(k_dv) 		///
				- .5*(`eq2num'-2)*(`eq2num'-1) + 	///
				`eq1num' - (`eq2num'-1)
			tempname cpull
			matrix `cpull' = (`col')
			GetVariance , nvlist(`nvlist') 			///
				touse(`touse') cpull(`cpull')		///
				eqname(`eq1dep', `eq2dep')
			exit 
		}
		else {
			di as err "option {bf:`stat'} invalid"
			exit 198
		}

	}

end	

program define _getnovar, rclass

	syntax anything

	local k_dv    = e(k_dv)
	local depvars   `e(depvars)'

	gettoken ns num:anything, parse("#")
	if "`ns'" == "#" {
					// number syntax not allowed because
					// some equations do not have mean
					// terms which causes them not to be
					// displayed in output
		di as err "{bf:equation(#}{it:i}{bf:)} syntax not allowed"
		exit 498

		return local norvar "number"
		capture confirm integer number `num'
		if _rc {
			di as err `"{bf:`anything'} invalid "'	///
				"in option {bf:equation()}"
			exit 498
		}
		if `num'<1 | `num' > `k_dv' {
			di as err "equation number {bf:#`num'} invalid"
			exit 498
		}
		return local number `num'
		local depvar : word `num' of `depvars'
		return local depvar `depvar'
	}
	else {
		local isdep : list anything in depvars 
		if !`isdep' {
			di as err `"{bf:`anything'} invalid "'	///
				"in option {bf:equation()}"
			exit 498
		}

		return local norvar "variable"
		return local depvar `anything'
		local num : list posof "`anything'" in depvars
		if `num'==0 {
di as err "{bf:`anything'} is not a valid equation name"
exit 498
		}
		return local number `num'
	}

end


program define _parse_eq, rclass

	syntax 

	if `"`anything'"' == "" {
		return local n_eq  1
		return local eqs   "#1"
	}
	else{
		local tmp : subinstr local anything `"""' "" , all 	///
			count(local n_prob)
		if n_prob {
			di as error `"`anything' invalid"'
			exit 198
		}

		local depvars   `e(depvars)'
		local n_dv	`e(k_dv)'
		local n_eq  : word count `anything'

		foreach el of anything {
			local tmp : subinstr local el "#" "" , all 	///
				count(local n_sign)
			if `sign'>1 {
				di as error `"`anything' invalid"'
				exit 198
			}
			else if `sign'==1 {
				local len : length local el
				if `len' > 33 {
					di as error `"`anything' invalid"'
					exit 198
				}
				local n_el = bsubstr("`el'", 2, .)
				capture confirm integer number `n_el"
				if _rc {
					di as error `"`anything' invalid"'
					exit 198
				}
				if `n_el' < 1 | `n_el' > `n_eq' {
					di as err "`el' invalid"	
					di as err "equation number out of range"
					exit 498	
				}
			}
			else {
				local isdname : local list el in depvars
				if !`isdname' {
					di as err "`el' is not a valid " ///
						"dependent variable"
					exit 498	
				}
			}
		}
		return local n_eq  `n_eq'
		return local eqs   `anything'
	}

end

program define GetVariance
	syntax , nvlist(string) touse(varname) cpull(string)		///
		[all dperiod(string) dynamic(string) eqname(string) ]

	local deps   `e(depvars)'
	local k_deps : word count `deps'

	if "`dynamic'" != "" {
		local dlab " dynamic(`dynamic')"
	}
	else {
		local dlab 
	}

	if "`all'" != "" {
		local q 
		forvalues i1 = 1/`k_deps' {
			local dv1  : word `i1' of `deps'
			local dv1n : subinstr local dv1 "." "_" 
			forvalues i2 = `i1'/`k_deps' {
local dv2 : word `i2' of `deps'
local dv2n : subinstr local dv2 "." "_" 
local lab "variance prediction (`dv2', `dv1')`dlab'"
`q' gen double `nvlist'_`dv2n'_`dv1n' = -1 if `touse'
label variable `nvlist'_`dv2n'_`dv1n' `"`lab'"'
local svlist `svlist' `nvlist'_`dv2n'_`dv1n'
local q quietly
			}
		}
	}
	else {
		local lab "variance prediction (`eqname')`dlab'"
		gen double `nvlist' = -1 if `touse'
		label variable `nvlist' `"`lab'"'
		local svlist `nvlist'
	}

	tempvar tdyn
	if "`dperiod'" == "" {
		local tdyn 1
	}
	else {
		_ts tvar pvar
		qui gen byte `tdyn' = 		///
			cond(`tvar'>=`dperiod', 0, 1)
	}
		

	local i 1
	tempvar xb
	local dv_eqs   `e(dv_eqs)'
	foreach var of local deps {
		tempvar res`i'
		local haseq : list var in dv_eqs
		if `haseq' {
			capture drop `xb'
			qui _predict double `xb' 	///
			if `touse', xb equation(`var')
			qui gen double `res`i'' 	///
			= `var' - `xb'  	///
			if `touse' & `tdyn'
		}
		else {
			qui gen double `res`i'' = 	///
				`var' if `touse' & `tdyn'
		}

		local rlist `rlist' `res`i''
		local ++i
	}
	

// predicting the variances with potential gaps in the data complicates 
// matters
// touse is 1 if [if] [in] and none of the residuals are missing
// ob_min is the first observation for which touse=1 after calling tsfill
// ob_max is the last  observation for which touse=1 after calling tsfill
// touse_pull is if _n>=ob_min & _n<=ob_max
// touse0	is 1 if the observation is in the dataset before tsfill and 
// 	touse_pull=1
// touse_dyn = 1 if the current observation is to be predicted dynamically
//             and 0 otherwise

	tempvar touse_pull touse0
	_dvech_falast `touse'
	local first_ob = r(first)
	local last_ob  = r(last)
	if `first_ob'>=. {
		di as err "no observations"
		exit 2000
	}
	qui gen byte `touse_pull' = 			///
		cond(_n>=`first_ob' & _n<=`last_ob', 1, 0)

	qui gen byte `touse0' = 1


	preserve
	qui tsfill

	qui replace `touse_pull' = 1 			///
		if missing(`touse_pull') 		///
		& _n>=`first_ob' & _n<=`last_ob'

	qui replace `touse0' = 0 if `touse0'>=.
	qui replace `touse'  = 0 if `touse'>=.

// The restore occurs inside _DVECH_cvar() so that the predictions are 
// not lost

	tempname res
	qui predict double `res'* if `touse', residuals
	foreach dv of local deps {
		local dv : subinstr local dv "." "_" 
		local reslist `reslist' `res'_`dv'
	}

	tempname Sigma
	qui matrix accum `Sigma' = `reslist' if `touse', noconstant
	mat `Sigma' = `Sigma'/r(N)	
			
	local n_p : word count `e(arch)'
	local n_q : word count `e(garch)'
	tempname A B S beta delta pinfo

	mata: `delta' = st_matrix("e(b)")'
	mata: `pinfo' = st_matrix("e(pinfo)")
	mata: `beta' = .

	tempname pinfo_min
	mata: st_numscalar("`pinfo_min'", min(`pinfo'[.,1]))
	if `pinfo_min' == 1 {
		local mcase "mean"
	}
	else {
		local mcase "nomean"
	}

	mata: _DVECH_GetMats("`mcase'", `k_deps',	///
		`n_p', `n_q', `delta', `pinfo', 	///
		`beta', `S'=., `A'=., `B'=.)	
							
	if `n_p' > 0 {
		mata: st_matrix("`A'", `A')
	}
	else {
		mata: st_matrix("`A'", .)
	}

	if `n_q' > 0 {
		mata: st_matrix("`B'", `B')
	}
	else {
		mata: st_matrix("`B'", .)
	}

	mata: st_matrix("`S'", `S')
	mata: `Sigma' = st_matrix("`Sigma'")

	local todrop `delta' `pinfo' `beta' `A' `B' `S'	
	local todrop `todrop' `Sigma'
			
	mata: _DVECH_cvar("`S'", "`A'", "`B'",	///
		"`Sigma'", "`rlist'", "`touse0'",	///
		"`touse'", "`touse_pull'", 		///
		"`svlist'", "`e(arch)'", 		///
		"`e(garch)'", "`cpull'")

	mata: mata drop `todrop'	
end				

