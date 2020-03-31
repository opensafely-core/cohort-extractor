*! version 1.1.3  15apr2015
program define mgarch_ccc_p, properties(notxb)
	version 11

	syntax anything [if] [in] , 		///
		[				///
		xb 				///
		Residuals 			///
		EQuation(passthru) 		///
		Variance			///
		Correlation			///
		DYNamic(string)			///
		]

	if "`e(cmd)'" != "mgarch" | "`e(model)'" != "ccc" {
		exit 301
	}
	
	opts_exclusive "`xb' `residuals' `variance' `correlation'"
	local stat "`xb'`residuals'`variance'`correlation'"
	
	local meaneqs `e(dv_eqs)'
	local depvars `e(depvar)'
	local ndepvars : word count `depvars'
	local covars `e(covariates)'
	if "`covars'" == "_NONE" {
		local covars
	}
	
	_mgarch_util CheckHetvars, depvars(`depvars') hetvars(`e(hetvars)')
			
	marksample touse
	_ts tvar pvar if `touse', sort onepanel
	
	qui tsset, noquery
	local delta `r(tdelta)'
	
	// parse dynamic option
	
	if "`stat'" == "" {
		local stat xb
		di "{txt}(option {bf:xb} assumed)"
	}
	
	if `"`dynamic'"' == "" {
		markout `touse' `e(depvar)' `covars'
	}
	else {
		capture local dperiod = `dynamic'
		if _rc {
			di `"{err}{cmd:dynamic(`dynamic')} invalid"'
			exit 498
		}
		
		foreach var in `e(depvar)' {
			_ms_parse_parts `var'
			if "`r(ts_op)'" != "" {
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
			di `"{err}{cmd:dynamic(`dynamic')} specifies "'	///
				"an invalid time period"
			exit 498
		}
	}
	
	// get names of new variables etc.
	
	_mgarch_p_names `anything', suffix(`depvars') stat(`stat') `equation'
	
	local newvarlist `s(newvarlist)'
	local typlist	 `s(typlist)'
	local lablist	 `s(lablist)'
	local isstub	 `s(stub)'
	local ix1	 `s(ix1)'
	local ix2	 `s(ix2)'
	local depvars	 `s(depvars)'
	
	if "`ix1'"=="" local ix1 0
	if "`ix2'"=="" local ix2 0
	
	if `"`dynamic'"' != "" {
		_mgarch_util DynamicWarning, stat(`stat') 	///
			ix1(`ix1') ix2(`ix2') stub(`isstub')
		local ignoredyn `r(ignoredyn)'
		if (`ignoredyn') local dynamic
		local hasop `r(hasop)'
	}
	
	if `"`dynamic'"' == "" {
		
		if "`stat'"=="xb" {
				
			local i 1
			foreach v in `newvarlist' {
				local type  : word `i' of `typlist'
				local lab   : word `i' of `lablist'
				local eq    : word `i' of `depvars'
				local haseq : list eq in meaneqs
				if (`haseq') {
					qui _predict `type' `v' ///
						if `touse', xb equation(`eq')
				}
				else qui gen `type' `v' = 0 if `touse'
				label var `v' `"Linear prediction `lab'"'
				local ++i
			}
			exit
		}
		else if "`stat'"=="residuals" {
			
			local i 1
			tempvar xb
			foreach v in `newvarlist' {
				local type  : word `i' of `typlist'
				local lab   : word `i' of `lablist'
				local eq    : word `i' of `depvars'
				local haseq : list eq in meaneqs
				if (`haseq') {
					capture drop `xb'
					qui _predict double `xb' ///
						if `touse', xb equation(`eq')
					qui gen `type' `v' = ///
						`eq'-`xb' if `touse'
				}
				else qui gen `type' `v' = `eq' if `touse'
				label variable `v' `"Residuals `lab'"'
				local ++i
			}
			exit
		}
		else if "`stat'"=="variance" | "`stat'"=="correlation" {
			
			tempvar xb duse
			
			qui gen byte `duse' = 0
			
			forvalues i = 1/`ndepvars' {
				
				local eq    : word `i' of `depvars'
				local haseq : list eq in meaneqs
				
				tempvar res`i'
				
				if (`haseq') {
					capture drop `xb'
					qui _predict double `xb' ///
						if `touse', xb equation(`eq')
					qui gen double `res`i'' = ///
						`eq'-`xb' if `touse'
				}
				else qui gen double `res`i'' = `eq' if `touse'
				
				local reslist `reslist' `res`i''
			}
			
			local i 1
			foreach v in `newvarlist' {
				local type  : word `i' of `typlist'
				local lab   : word `i' of `lablist'
				local st = proper("`stat'")
				qui gen `type' `v' = .
				label variable `v' `"`st' prediction `lab'"'
				local ++i
			}
			
			mata: MGARCH_predict_CCC("`e(hetvars)'", 	  ///
				"`e(arch)'","`e(garch)'","`newvarlist'",   ///
				"`reslist'","`touse'","`duse'",`ix1',`ix2')
			exit
		}
		else {
			di as err "{cmd:`stat'} invalid"
			exit 198
		}
	}
	else { 						// dynamic prediction
		
		if "`stat'" == "residuals" {
			di "{err}{cmd:residuals} may not be specified "	///
				"with {cmd:dynamic}"
			exit 498
		}
		else if "`stat'" == "xb" {
			
			local alldepvars `e(depvar)'
			
			local i 1
			foreach var of local alldepvars {
				tempname dep`i'
				local newlist `newlist' `dep`i''
				local ++i
			}
			
			// get nondynamic prediction by calling itself
			
			mgarch_ccc_p double (`newlist') if `touse', xb
			qui replace `touse' = `touse' * (`tvar' > `dperiod')
			foreach v of local newlist {
				qui replace `v' = . if `touse'
			}
						
			// swap matrix stripe
			
			tempname b
			matrix `b' = e(b)
			local coleq    : coleq `b'
			local colnames : colnames `b'
			
			local meqs : word count `newlist'
			
			foreach wrd of local colnames {
				_ms_parse_parts `wrd'
				local op `r(ts_op)'
				local nname `r(name)'
				
				if "`op'" != "" local op "`op'."
				
				forvalues i=1/`meqs' {
					if "`op'" != "" {
local old : word `i' of `alldepvars'
local new : word `i' of `newlist'
local nname : subinstr local nname "`old'" "`new'", all word
					}
				}
				
				local clist `clist' `op'`nname'
			}
			local col_names `clist'

			local parms : word count `coleq'
			forvalues i=1/`parms' {
				local eqi : word `i' of `coleq'
				local ni  : word `i' of `clist'
				local newnames `newnames' `eqi':`ni'
			}
			matrix colnames `b' = `newnames'
			
			// calculate dynamic predictions
			
			forvalues t=`dperiod'/`tmax' {
				local i 1
				foreach var of local alldepvars {
					local to : word `i' of `newlist'
					local haseq : list var in meaneqs
					if `haseq' {
						qui mat score `to'=`b'      ///
						if `tvar'==`t' & `touse',   ///
						equation(`var')	replace
					}
					else {
						qui replace `to'=0          ///
						if `tvar'==`t' & `touse'
					}
					local ++i
				}
			}
		
			// substitute newvarlist into newlist
			
			if (`isstub'==0) local newlist : word `ix1' of `newlist'

			local dpart ", dynamic(`dynamic')"
			
			local i 1
			foreach v in `newvarlist' {
				local from : word `i' of `newlist'
				local lbl : variable label `from'
				label var `from' `"`lbl'`dpart'"'
								
				local type : word `i' of `typlist'
				qui recast `type' `from', force
				
				rename `from' `v'
				
				local ++i
			}
			
			exit
		}
		else if "`stat'"=="variance" | "`stat'"=="correlation" {
			
			tempvar xb duse
			
			qui gen byte `duse' = `touse' * (`tvar' > `dperiod')
			
			forvalues i = 1/`ndepvars' {
				
				local eq    : word `i' of `depvars'
				local haseq : list eq in meaneqs
				
				tempvar res`i'
				
				if (`haseq') {
					capture drop `xb'
					qui _predict double `xb' ///
						if `touse', xb equation(`eq')
					qui gen double `res`i'' = ///
						`eq'-`xb' if `touse'
				}
				else qui gen double `res`i'' = `eq' if `touse'
				
				local reslist `reslist' `res`i''
			}
			
			local dpart ", dynamic(`dynamic')"
			
			local i 1
			foreach v in `newvarlist' {
				local type  : word `i' of `typlist'
				local lab   : word `i' of `lablist'
				local st = proper("`stat'")
				qui gen `type' `v' = .
				label var `v' `"`st' prediction `lab'`dpart'"'
				local ++i
			}
			
			mata: MGARCH_predict_CCC("`e(hetvars)'", 	  ///
				"`e(arch)'","`e(garch)'","`newvarlist'",   ///
				"`reslist'","`touse'","`duse'",`ix1',`ix2')
			
			exit
		}
		else {
			di as err "{cmd:`stat'} invalid"
			exit 198
		}
	}
end
