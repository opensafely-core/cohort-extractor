*! version 1.0.1  27oct2015

/*
	u_mi_sets_okay

	Verifies that tsset, ..., all do not use imputed or 
	passive variables
*/

program u_mi_sets_okay
	version 11

	novarabbrev {
	/* ------------------------------------------------------------ */
					/* tsset, xtset			*/
		local cmd = cond("`_dta[iis]'"=="", "tsset", "xtset")
		u_mi_check_setvars runtime `cmd' `_dta[tis]' `_dta[iis]'
	/* ------------------------------------------------------------ */
					/* stset			*/
		if ("`_dta[_dta]'"=="st") {
			u_mi_check_setvars runtime stset 		///
				_t0 _t _d _st				///
				`_dta[st_id]' 				///
				`_dta[st_wv]'
			capture confirm var _origin
			if (_rc==0) {
				u_mi_check_setvars runtime stset _origin
			}
			capture confirm var _scale
			if (_rc==0) {
				u_mi_check_setvars runtime stset _scale
			}
		}
	/* ------------------------------------------------------------ */
					/* svyset			*/
		capture svyset
		if !c(rc) & "`r(settings)'" != ", clear" {
			local vlist	`r(wvar)'			///
					`r(brrweight)'			///
					`r(jkrweight)'			///
					`r(poststrata)'			///
					`r(postweight)'
			local k = r(stages)
			forval i = 1/`k' {
				local vlist	`vlist'			///
						`r(su`i')'		///
						`r(strata`i')'		///
						`r(fpc`i')'
			}

			u_mi_check_setvars runtime svyset `vlist'
		}
	/* ------------------------------------------------------------ */
	}
end
