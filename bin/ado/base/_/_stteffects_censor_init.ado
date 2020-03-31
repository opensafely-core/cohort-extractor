*! version 1.0.0  14mar2015

program define _stteffects_censor_init, rclass
	version 14.0
	syntax newvarname, censordist(string) touse(varname)           ///
		[ censorvars(string) censorshape(string) wvar(varname) ///
		wtype(string) fuser verbose * ]

	/* fuser macro indicates user specified from()			*/
	if "`verbose'" != "" {
		local noi noi
	}
	else {
		local qui qui
		local nolog nolog
	}
	_stteffects_split_vlist, vlist(`censorvars')
	local censorvars `"`s(vlist)'"'
	local constant `s(constant)'
	if `"`censorshape'"' != "" {
		_stteffects_split_vlist, vlist(`censorshape')
		local censorshape `"`s(vlist)'"'
		local shapeconst `s(constant)'
	}	
	/* assumption stset with failure event 				*/
	local d : char _dta[st_d]
	local do : char _dta[st_bd]
	local wtype : char _dta[st_wt]
	if "`wtype'" != "" {
		local wvar : char _dta[st_wv]
		local wopt wvar(`wvar') wtype(`wtype')
		local wt [`wtype'=`wvar']
		if "`wtype'" == "pweight" {
			local iwt [iw=`wvar']
		}
		else {
			local iwt `wt'
		}
	}
	local t : char _dta[st_t]
	/* check for variation in censoring time			*/
	qui summarize `t' `iwt' if `touse' & !`d'
	if r(Var) < 1e-8 {
		di as err "insufficient variance in censoring time"
		exit 459
	}
	/* -preserve- to prevent triggering the data modification flag	*/
	preserve
	tempvar c co
	qui gen byte `c' = cond(`d',0,1) if `touse'
	qui gen byte `co' = cond(`do',0,1) if `touse'
	qui replace `d' = `c' if `touse'
	qui replace `do' = `co' if `touse'
		
	if "`verbose'" != "" {
		di as txt _n "Fitting the censoring model"
	}
	if "`censordist'" == "gamma" {
		if "`censorshape'" != "" {
			local ancopt ancillary(`censorshape')
			if "`shapeconst'" != "" {
				local ancopt `"`ancopt' noancconst"'
			}
		}
		cap `noi' _stteffects_gamma, touse(`touse')           ///
			vars(`censorvars') `wopt' `ancopt' `constant' ///
			`verbose' `options'
	}
	else {
		if "`censordist'"!="exponential" & `"`censorshape'"'!="" {
			local ancopt `"ancillary(`censorshape'"'
			if "`shapeconst'" != "" {
				local ancopt `"`ancopt',noconstant"'
			}
			local ancopt `"`ancopt')"'
		}
		cap `noi' streg `censorvars' if `touse', `constant' time ///
			distribution(`censordist') `ancopt' `nolog' `options' 
	}
	local rc = c(rc)
	/* -predict, survival- does not use stset failure indicator	*/
	restore
	if `rc' {
		if `rc' > 1 {
			di as err "{p}censoring-model estimation has " ///
			 "failed; computations cannot proceed{p_end}"
		}
		exit `rc'
	}
	local converged = e(converged)
	if !`converged' & "`fuser'"=="" {
		di as txt "{p 0 6 2}note: censoring-model estimation, " ///
		 "convergence not achieved{p_end}"
	}
	qui predict double `varlist' if `touse', surv

	tempname b
	mat `b' = e(b)
	local names : colfullnames `b'
	while `"`names'"' != "" {
		gettoken exp names : names, bind
		gettoken eq exp : exp, parse(":")
		gettoken colon exp :exp, parse(":")
		if "`eq'" == "_t" {
			local stripe `"`stripe' CME:`exp'"'
		}
		else {
			local stripe `"`stripe' CME_lnshape:`exp'"'
		}
	}
	local vlist : list retokenize vlist
	local slist : list retokenize slist

	mat colnames `b' = `stripe'

	return mat b = `b'
	return scalar converged = `converged'
end

exit
