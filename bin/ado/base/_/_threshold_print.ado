*! version 1.0.0  23mar2017

program _threshold_print, eclass
	version 14.0
	syntax [anything] [if] [in] 				///
		[, 						///
			*					///
		]

/**Get display options**/
	_get_diopts diopts, `options'
	cap qui tsreport if e(sample), `detail' 
	if (_rc!=111) {
		local ts 1
		local start = r(start)
		local end = r(end)
		local tsfmt = r(tsfmt)
	}

	cap qui tsset
	if !_rc {
		local unit1 = r(unit1)
		if ("`unit1'"=="." | "`unit1'"=="g") {
			local tmins = `start'
			local tmaxs = `end'
		}
		else {
			local tmins: di `tsfmt' `start'
			local tmaxs: di `tsfmt' `end'
		}

		ereturn scalar tmin = `start'
		ereturn scalar tmax = `end'
		ereturn local tsfmt = "`tsfmt'"
		ereturn local tmins = "`tmins'"
		ereturn local tmaxs = "`tmaxs'"
	}
	
        di as txt _n "Threshold regression"
	if (!missing(e(optthresh))) {
		if ("`ts'"=="1") di 
		if ("`ts'"=="1") di "{txt:Full sample}:{col 16}{res: `tmins' - `tmaxs'}" ///
			as txt "{col 49} Number of obs {col 67}= " as res %10.0fc e(N) 
		else di as txt "{col 49} Number of obs {col 67}= " as res %10.0fc e(N) 
		local crit = strupper("`e(criteria)'")
		local ic = e(criteria)
		di as txt "Number of thresholds = " as res %2.0f e(nthresholds) _c
		di as txt "{col 49} Max thresholds {col 67}= " as res  	    ///
			 %10.0f e(optthresh)
		di "{txt:Threshold variable}: " as res "`e(threshvar)'"_c
		di as text "{col 49} `crit' {col 67}= " as res         ///
			%10.04f e(`ic')

	}
        else {
		if ("`ts'"=="1") di 
		di as txt "{col 49} Number of obs {col 67}= " as res %10.0fc e(N) 
		if ("`ts'"=="1") di "{txt:Full sample}:{col 16}{res: `tmins' - `tmaxs'}"  ///
			as txt "{col 49} AIC {col 67}= " as res %10.04f e(aic)
		di as txt "Number of thresholds = " as res %2.0f            ///
			e(nthresholds) as txt "{col 49} BIC {col 67}= " as  ///
			res %10.04f e(bic)
		di "{txt:Threshold variable}: " as res "`e(threshvar)'" as  ///
			txt "{col 49} HQIC {col 67}= " as res %10.04f e(hqic)
	}
	if (e(nthresholds)!=0) {
		di
		di as txt "{hline 33}"
		di as txt "Order{col 10} Threshold{col 27} SSR"
		di as txt "{hline 33}"
		//di as res ".{col 10} -inf{col 25} ."
		tempname thtable estholds
		mat `thtable' = e(thtable)
		mat `estholds' = e(thresholds)
		local nthresh = e(nthresholds)
		cap qui tsreport `e(threshvar)'
		if (`"`r(var1)'"'==`"`r(timevar)'"') local tflag 1
		forvalues i=1/`nthresh' {
			local order     = `thtable'[`i',1]
			local thval     = `thtable'[`i',2]
			local thSSR     = `thtable'[`i',3]
			if ("`tflag'"=="1") {
				local thval: di `tsfmt' `thval'
				di as res "`order'" as res _col(12) 	    ///
					"`thval'" _col(24) %10.04f `thSSR'
			}
			else di as res "`order'" as res _col(8)  %10.04f    ///
				`thval' _col(24) %10.04f `thSSR'
		}
			//di as res ".{col 10} +inf{col 25} ."
			di as txt "{hline 33}" _newline
/*
			mat `estholds' = `estholds'[1,2..1+`nthresh']
			forvalues i = 1/`nthresh' {
				local tname `tname' Threshold`i'
			}
			mat colname `estholds' = `tname'
*/
	}
        else di
	_coef_table, `diopts'

end
