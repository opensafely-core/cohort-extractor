*! version 1.0.8  12may2017
program define varirf_table, rclass
	version 8.0
	syntax [anything(id="irf object list" name=irf_olist)]	/*
	*/ [,						/*
	*/ IRf(string)					/*
	*/ Impulse(string)				/*
	*/ Response(string)				/*
	*/ noCI						/*
	*/ STDerror					/*
	*/ noSTRuctural					/*
	*/ STep(numlist max=1 integer >0 <=500)		/* 
	*/ TItle(string)				/*
	*/ INdividual					/*
	*/ Level(passthru)				/*
	*/ Set(string)					/*
	*/ ]

	if "`level'" != "" & "`ci'" != "" {
		di as err "{cmd:level()} and {cmd:noci} cannot "	/*
			*/ "both be specified"
		exit 198
	}

	local zero `0'
	local 0 ", `level'"
	local backopt `options'
	syntax [, level(cilevel)]
	local 0 `zero'
	local options `backopt'

	/* default irf object list */
	if "`e(cmd)'"=="arima" | "`e(cmd)'"=="arfima" {
		if "`irf_olist'" == "" {
			local irf_olist irf cirf oirf coirf sirf
		}
		else {
			local tmp irf cirf oirf coirf sirf
			local out : list irf_olist - tmp
			if "`out'"!="" {
				di as err "{cmd:`out'} not available after " /*
					*/ "`e(cmd)'"
				exit 198
			}
		}
	}
	if ("`e(cmd)'"=="dsge" ) {
		if "`irf_olist'" == "" {
			local irf_olist irf 
		}
		else {
			local tmp irf 
			local out : list irf_olist - tmp
			if "`out'"!="" {
				di as err "{cmd:`out'} not available after " /*
					*/ "`e(cmd)'"
				exit 198
			}
		}
	}
	if "`irf_olist'" == "" {
		if  "`structural'" == "" {
			local irf_olist irf oirf sirf fevd sfevd
		}	
		else {
			local irf_olist irf oirf fevd
		}
	}
	
	if "`individual'" != "" & `"`title'"' != "" {
		di as err "{cmd:title()} cannot be specified with "	/*
			*/ "{cmd:individual}"
		exit 198
	}	

	/* set a new varirf data file */
	if `"`set'"' != "" {
		varirf set `set'
	}	

	if "`step'" != "" {
		local stepm "step(`step')"
	}	

	if "`level'" != "`c(level)'" {
		local levelm "level(`level')"
	}
	
	/* Options to pass directly to -varirf ctable- */
	local globalopts " `ci' `stderror' `stepm' `levelm' "

	preserve
	_virf_use

	/* default for irf() option is all irfnames */
	if "`irf'" == "" {
		local irf : char _dta[irfnames]
	}

	if `"`title'"' == "" {
		local irft : list retokenize irf
		local title "Results from `irft'"
	}	

	/* build arguments to pass to -varirf ctable- */
	foreach irfn of local irf {
		
		if "`individual'" != "" {
			local lines 
			local titlei `"title("Results from `irfn'")"'
		}
		

		// default for impulse() option after dsge: all state
		//         variables with shocks attached to them
		local irfmodel : char _dta[`irfn'_model]
		if ("`irfmodel'"=="dsge" & "`impulse'" == "") {
			local shocks : char _dta[`irfn'_shocks]
			local myimpulse `shocks'
		}
		/* default for impulse() option all of them */
		else if "`impulse'" == "" {
			local myimpulse : char _dta[`irfn'_order]
		}
		else {
			local myimpulse `impulse'
		}	

		/* default for response() option all of them */
		if "`response'" == "" {
			local myresponse : char _dta[`irfn'_order]
		}
		else {
			local myresponse `response'
		}

		foreach imp of local myimpulse {
			foreach resp of local myresponse {
				local args `irfn' `imp' `resp' `irf_olist'
				local lines " `lines' (`args', `opts') "
			}
		}
		if "`individual'" != "" {
			varirf ctable `lines' , `globalopts' `titlei'
			
			/* save of r() stuff in locals for each irfn */
			
			local ncols_`irfn' = r(ncols)
			local k_umax_`irfn' = r(k_umax)
			local k_`irfn' = r(k)

			forvalues i2 = 1/`k_umax_`irfn'' {
				local key`i2'_`irfn'  "`r(key`i2')'"
			}
			local tnotes_`irfn' "`r(tnotes)'"
		}	
	}

	restore
	if "`individual'" == "" {
		varirf ctable `lines' , `globalopts' title("`title'")
		ret add
	}	
	else {
		foreach irfn of local irf {
			ret scalar `irfn'_ncols  = `ncols_`irfn''
			ret scalar `irfn'_k_umax = `k_umax_`irfn''
			ret scalar `irfn'_k      = `k_`irfn''

			forvalues i2 = 1/`k_umax_`irfn'' {
				ret local `irfn'_key`i2'  "`key`i2'_`irfn''"
			}
			ret local `irfn'_tnotes "`tnotes_`irfn''"
		}
	}

end

exit
