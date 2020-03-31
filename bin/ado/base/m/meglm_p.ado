*! version 1.3.4  18mar2019
program meglm_p, eclass
	version 13
	local vv : di "version " string(_caller()) ", missing:"
	
	if "`e(cmd)'" != "meglm" & "`e(cmd2)'" != "meglm" {
		di "{err}last estimates not found"
		exit 198
	}
	if "`e(family)'"=="" {
		di "{err}e(family) not found"
		exit 198
	}
	if "`e(link)'"=="" {
		di "{err}e(link) not found"
		exit 198
	}
	
	local cens = inlist("`e(cmd2)'","metobit","meintreg")
	if `cens' {
		local cens_pred PR1(string) YStar(passthru) e(passthru)
	}
		
	syntax  anything(id="stub* or newvarlist") 	///
		[if] [in] [,				///
		REFfects				///
		remeans					/// undocumented
		remodes					/// undocumented
		reses(string)	 			///
		mu					///
		pr					///
		eta					///
		FITted					/// undocumented
		RESiduals				///
		PEArson					///
		DEViance				///
		ANScombe				///
		xb					///
		stdp					///
		SCores					///
		CONDitional1(string)			///
		CONDitional				///
		UNCONDitional				/// undocumented
		MARGinal				///
		FIXEDonly				/// undocumented
		EBMEANs					///
		EBMODEs					///
		means					/// undocumented
		modes					/// undocumented
		mean					/// disallowed
		mode					/// disallowed
		`cens_pred'				///
		margvar(string)				/// undocumented
		DENsity					///
		DISTribution				///
		*					///
	]
	
	local mm `mean'`mode'
	if "`mm'"!="" {
		di "{err}option {bf:`mm'} not allowed"
		exit 198
	}
	if "`eta'" != "" {
		local fitted eta
	}
	
	if `"`pr'"' != "" & `"`pr1'"' != "" {
		di "{err}only one of {bf:pr} or {bf:pr()} is allowed"
		exit 198
	}
	if `"`pr'"' == "" & `"`pr1'"' != "" local pr pr(`pr1')
	
	local STAT `remeans' `remodes' `mu' `pr' `fitted' `residuals'	///
		`pearson' `deviance' `anscombe' `xb' `stdp' `reffects'	///
		`scores' `ystar' `e' `density' `distribution'
	opts_exclusive `"`STAT'"'
	
	if `"`STAT'"'=="" {
		if `cens' {
			local fitted eta
			di "{txt}(option {bf:eta} assumed)"
		}
		else if inlist("`e(cmd2)'","meologit","meoprobit") {
			local pr pr
			di "{txt}(option {bf:pr} assumed)"
		}
		else {
			local mu mu
			di "{txt}(option {bf:mu} assumed)"
		}
	}
	
	if "`scores'" != "" {
		`vv' gsem_p `0'
		exit
	}

	if "`fitted'" == "fitted" {
		local fitted eta
	}
	
	local STAT ///
`mu'`pr'`fitted'`residuals'`pearson'`deviance'`anscombe'`xb'`stdp'`density'`distribution'
	if !missing(`"`STAT'"') {
		if !missing("`reses'") {
			di `"{err}option {bf:reses()} not allowed with "' ///
				`"option {bf:`STAT'}"'
			exit 198
		}
	}

	if "`unconditional'" != "" {
		opts_exclusive "unconditional `xb'"
		opts_exclusive "unconditional `stdp'"
		opts_exclusive "unconditional `fixedonly'"
		opts_exclusive "unconditional `reffects'"
		opts_exclusive "unconditional `remeans'"
		opts_exclusive "unconditional `remodes'"
		opts_exclusive "unconditional `ebmeans'"
		opts_exclusive "unconditional `means'"
		opts_exclusive "unconditional `ebmodes'"
		opts_exclusive "unconditional `modes'"
		local marginal marginal
	}
	if "`conditional1'" == "" {
		if "`conditional'" != "" {
			opts_exclusive "conditional `xb'"
			opts_exclusive "conditional `stdp'"
			opts_exclusive "conditional `reffects'"
			opts_exclusive "conditional `remeans'"
			opts_exclusive "conditional `remodes'"
			opts_exclusive "conditional `unconditional'"
			opts_exclusive "conditional `marginal'"
			opts_exclusive "conditional `fixedonly'"
			opts_exclusive "conditional `ebmodes'"
			opts_exclusive "conditional `modes'"
			local means means
		}
	}
	else {
		ParseCond1, `conditional1'
		local condopt "conditional(`conditional1')"
		opts_exclusive "`condopt' `stdp'"
		opts_exclusive "`condopt' `xb'"
		opts_exclusive "`condopt' `reffects'"
		opts_exclusive "`condopt' `remeans'"
		opts_exclusive "`condopt' `remodes'"
		opts_exclusive "`condopt' `unconditional'"
		opts_exclusive "`condopt' `marginal'"
		if "`conditional1'" != "fixedonly" {
			opts_exclusive "`condopt' `fixedonly'"
		}
		else	local fixedonly fixedonly
		if "`conditional1'" != "ebmeans" {
			opts_exclusive "`condopt' `ebmeans'"
			opts_exclusive "`condopt' `means'"
			opts_exclusive "`condopt' `conditional'"
		}
		else	local means means
		if "`conditional1'" != "ebmodes" {
			opts_exclusive "`condopt' `ebmodes'"
			opts_exclusive "`condopt' `modes'"
		}
		else	local modes modes
	}

	if "`reffects'`remeans'`remodes'" != "" {
		local reffects latent
	}
	if "`ebmeans'" != "" {
		if "`reffects'" == "" {
			di as err ///
"option {bf:ebmeans} requires the {bf:reffects} option"
			exit 198
		}
		local means means
	}
	if "`ebmodes'" != "" {
		if "`reffects'" == "" {
			di as err ///
"option {bf:ebmodes} requires the {bf:reffects} option"
			exit 198
		}
		local modes modes
	}

	local mm `marginal' `means' `modes'
	opts_exclusive "`xb' `mm'"
	opts_exclusive "`stdp' `mm'"
	opts_exclusive "`fixedonly' `mm'"
	if "`reffects'"=="latent" & !e(k_r) {
		di "{err}random-effects equation(s) empty; predictions of " ///
			"random effects not available"
		exit 198
	}
	if "`remeans'" != "" {
		if "`mm'" != "" {
			di "{err}option {bf:`mm'} not allowed with {bf:remeans}"
			exit 198
		}
		local mm means
	}
	if "`remodes'" != "" {
		if "`mm'" != "" {
			di "{err}option {bf:`mm'} not allowed with {bf:remodes}"
			exit 198
		}
		local mm modes
	}
	if "`reses'" != "" local reses se(`reses')
	if "`reses'" != "" & "`reffects'"=="" {
		di "{err}option {bf:reses()} requires the {bf:reffects} " ///
			" option"
		exit 198
	}

	if "`mm'" == "" & e(k_hinfo) == 0 {
		local fixedonly fixedonly
	}

	local STAT `pearson' `deviance' `anscombe' `stdp'
	opts_exclusive "`marginal' `STAT'"
	local STAT `deviance' `anscombe'
	local fixed `fixedonly'`xb'`stdp'

	local type "`residuals'`pearson'`deviance'`anscombe'"
	
	local fn `e(family)'
	
	if `cens' & "`type'"!="" {
		di "{err}statistic {bf:`type'} not available with censored outcomes"
		exit 198
	}
	if inlist("`fn'","ordinal") & "`type'"!="" {
		di "{err}statistic {bf:`type'} not available with `fn' outcomes"
		exit 198
	}
	if !inlist("`fn'","gaussian") & "`type'"=="residuals" {
		di "{err}statistic {bf:`type'} not available with `fn' family"
		exit 198
	}
	if "`fn'"=="nbinomial" & "`e(dispersion)'"=="constant" {
		if "`type'"=="deviance" | "`type'"=="anscombe" {
			di "{err}statistic {bf:`type'} not available for " ///
				"`fn' family with constant dispersion"
		exit 198
		}
	}
	if !inlist("`fn'","bernoulli","ordinal") & `"`pr'"'=="pr" {
		di "{err}statistic {bf:pr} not available with `fn' family"
		exit 198
	}
	
	if "`mm'"=="" {
		if _caller() >= 14 & "`c(marginscmd)'" == "on" {
			local mm marginal
		}
		else {
			local mm means
		}
	}
	if "`fixed'" != "" local mm

	if "`reffects'" != "" {
		di as txt "(calculating posterior `mm' of random effects)"
	}
	else if "`fixed'" == "" & "`mm'" != "marginal" {
	    if e(k_hinfo) != 0 {
		di as txt "(predictions based on fixed effects and "	///
			"posterior `mm' of random effects)"
		}
	}
	
	if `cens' & !missing(`"`pr'`e'`ystar'"') {
		marksample touse, novarlist
		
		_stubstar2names `anything', nvars(1) outcome single
		local varn `s(varlist)'
		local vtyp `s(typlist)'
		
		tempvar L U
		qui gen double `L' = .
		qui gen double `U' = .
		
		_get_lb_ub, `pr' `e' `ystar' lvar(`L') uvar(`U') ///
			touse(`touse') `marginal' `fixedonly'
		local ttl `s(ttl)'
		
		tempvar p yhat
		qui gsem_p double `yhat' `if' `in' , eta `options' `mm' `fixedonly'
		
		// calculate the variance needed for predictions
		tempvar s
		local depvar `e(depvar)'
		local depvar : word 1 of `depvar'
		qui gen double `s' = _b[/var(e.`depvar')] if `touse'
		if missing("`fixedonly'") {
			tempvar cons
			qui gen byte `cons' = 1
			mata: _get_cens_variance(`e(k_hinfo)',"`s'","`touse'")
		}
		if !missing("`margvar'") {
			qui gen double `margvar' = `s'
			label var `margvar' "Marginal variance of the linear predictor"
		}
		qui replace `s' = sqrt(`s') if `touse'
		
		if `"`pr'"' != "" {
			_cens_pr `p' `yhat' `s' `touse' `L' `U'
			qui gen `vtyp' `varn' = `p' if `touse'
			label var `varn' "`ttl'"
			exit
		}
		if "`e'" != "" {
			_cens_e `p' `yhat' `s' `touse' `L' `U'
			qui gen `vtyp' `varn' = `p' if `touse'
			label var `varn' "`ttl'"
			exit
		}
		if "`ystar'" != "" {
			_cens_ystar `p' `yhat' `s' `touse' `L' `U'
			qui gen `vtyp' `varn' = `p' if `touse'
			label var `varn' "`ttl'"
			exit
		}
	}
	
	local gsem = "`type'"==""
	if `gsem' {
		local preds `reffects' `reses' `fitted' `fixedonly' 	///
			`xb' `stdp' `mm' `pr' `mu' `density' `distribution'
		local cmd `anything' `if' `in' , `preds' `options'
		`vv' gsem_p `cmd'
		exit
	}
	
	// residuals, pearson, deviance, anscombe -- need mu for calculations
	
	local y `e(depvar)'
	_stubstar2names `anything', nvars(1) outcome single
	local varn `s(varlist)'
	local vtyp `s(typlist)'
	
	marksample touse, novarlist
	
	tempvar mu
	`vv' gsem_p double `mu' if `touse' , mu `fixedonly' `mm' `options'
	
	if "`type'"=="residuals" {
		qui gen `vtyp' `varn' = `y' -`mu' if `touse'
		label var `varn' "Residuals`lab'"
		exit
	}
	
	if "`type'"=="pearson" {
		tempvar p
		qui _pearson_`fn' `y' `mu' `p' `touse'
		qui gen `vtyp' `varn' = `p' if `touse'
		label var `varn' "Pearson residuals`lab'"
		exit
	}
	
	if "`type'"=="deviance" {
		tempvar d
		qui _deviance_`fn' `y' `mu' `d' `touse'
		qui gen `vtyp' `varn' = `d'
		label var `varn' "deviance residuals`lab'"
		exit
	}
	
	if "`type'"=="anscombe" {
		tempvar a
		qui _anscombe_`e(family)' `y' `mu' `a' `touse'
		qui gen `vtyp' `varn' = `a'
		label var `varn' "Anscombe residuals`lab'"
		exit
	}
	
end

program ParseCond1
	local	OPTS	EBMEANs		///
			EBMODEs		///
			FIXEDonly
	capture syntax [, `OPTS' ]
	if c(rc) {
		di as err "invalid {bf:conditional()} option;"
		syntax [, `OPTS' ]
		error 198 // [sic]
	}
	local cond `ebmeans' `ebmodes' `fixedonly'
	if `:list sizeof cond' > 1 {
		di as err "invalid {bf:conditional()} option;"
		opts_exclusive "`cond'"
	}
	c_local conditional1 `cond'
end

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++ pearson residuals

program _pearson_bernoulli
	args y mu p touse
	gen double `p' = (`y'-`mu') / sqrt( `mu'*(1-`mu') ) if `touse'
end

program _pearson_binomial
	args y mu p touse
	if "`e(binomial)'"=="" local r_ij = 1
	else local r_ij `e(binomial)'
	gen double `p' = (`y'-`mu') / sqrt( `mu'*(1-`mu'/`r_ij') ) if `touse'
end

program _pearson_gamma
	args y mu p touse
	gen double `p' = (`y'-`mu') / sqrt(`mu'^2) if `touse'
end

program _pearson_gaussian
	args y mu p touse
	gen double `p' = `y'-`mu' if `touse'
end

program _pearson_nbinomial
	args y mu p touse
	if "`e(dispersion)'"=="mean" {
		local k = exp(_b[/lnalpha])
		gen double `p' = (`y'-`mu') / sqrt(`mu'+`k'*`mu'^2) if `touse'
	}
	else {
		local k = exp(_b[/lndelta])
		gen double `p' = (`y'-`mu') / sqrt(`mu' + `k'*`mu') if `touse'
	}
end

program _pearson_ordinal
	di "Pearson residuals not available with ordinal outcomes"
	exit 198
end

program _pearson_poisson
	args y mu p touse
	gen double `p' = (`y'-`mu') / sqrt(`mu') if `touse'
end

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++ deviance residuals

program _deviance_bernoulli
	args y mu d touse
	gen double `d' = -2*ln1m(`mu') if `y'==0 & `touse'
	replace `d' = -2*ln(`mu') if `y'==1 & `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_binomial
	args y mu d touse
	if "`e(binomial)'"=="" local r_ij = 1
	else local r_ij `e(binomial)'
	gen double `d' = 2*`r_ij'*ln( `r_ij'/(`r_ij'-`mu') ) if `y'==0 & `touse'
	replace `d' = 2*`y'*ln(`y'/`mu') + ///
		2*(`r_ij'-`y')*ln( (`r_ij'-`y')/(`r_ij'-`mu') ) ///
		if (`y'>0 & `y'<`r_ij') & `touse'
	replace `d' = 2*`r_ij'*ln(`r_ij'/`mu') if `y'==`r_ij' & `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_gamma
	args y mu d touse
	gen double `d' = -2*( ln(`y'/`mu') - (`y'-`mu')/`mu' ) if `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_gaussian
	args y mu d touse
	gen double `d' = (`y'-`mu')^2 if `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_nbinomial
	args y mu d touse
	local k = exp(_b[/lnalpha])
	gen double `d' = 2*ln1p(`k'*`mu')/`k' if `y'==0 & `touse'
	replace `d' = 2*`y'*ln(`y'/`mu') - ///
		(2/`k')*(1+`k'*`y')*ln( (1+`k'*`y')/(1+`k'*`mu') ) ///
		if `y'>0 & `y'<. & `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

program _deviance_ordinal
	di "{err}deviance residuals not available with ordinal outcomes"
	exit 198
end

program _deviance_poisson
	args y mu d touse
	gen double `d' = 2*`mu' if `y'==0 & `touse'
	replace `d' = 2*`y'*ln(`y'/`mu') - 2*(`y'-`mu') ///
		if `y'>0 & `y'<. & `touse'
	replace `d' = sign(`y'-`mu')*sqrt(`d') if `touse'
end

// +++++++++++++++++++++++++++++++++++++++++++++++++++++++ anscombe residuals

program _anscombe_bernoulli
	args y mu a touse
	gen double `a' = 1.5 * 						///
		( `y'^(2/3)*_hyp2f1(`y') - `mu'^(2/3)*_hyp2f1(`mu') ) /	///
		(`mu'*(1-`mu'))^(1/6) if `touse'
end

program _anscombe_binomial
	args y mu a touse
	if "`e(binomial)'"=="" local r_ij = 1
	else local r_ij `e(binomial)'
	gen double `a' = 1.5 * 						///
		( `y'^(2/3)*_hyp2f1(`y'/`r_ij') - 			///
		  `mu'^(2/3)*_hyp2f1(`mu'/`r_ij') 			///
		) / 							///
		( `mu'*(1-`mu'/`r_ij') )^(1/6) if `touse'
end

program _anscombe_gamma
	args y mu a touse
	gen double `a' = 3*( (`y'/`mu')^(1/3) - 1 ) if `touse'
end

program _anscombe_gaussian
	args y mu a touse
	gen double `a' = (`y'-`mu') if `touse'
end

program _anscombe_nbinomial
	args y mu a touse
	local k = exp(_b[/lnalpha])
	gen double `a' = ( _hyp2f1(-`k'/`y') - _hyp2f1(-`k'/`mu') +	///
			   1.5*(`y'^(2/3)-`mu'^(2/3)) ) /		///
			 (`mu' + `k'*`mu'^2)^(1/6) if `touse'
end

program _anscombe_ordinal
	di "{err}Anscombe residuals not available with ordinal outcomes"
	exit 198
end

program _anscombe_poisson
	args y mu a touse
	gen double `a' = 1.5*(`y'^(2/3) - `mu'^(2/3)) / `mu'^(1/6) if `touse'
end

// ++++++++++++++++++++++++++++++ metobit, meintreg predictions

program define _cens_e
	local depvar `e(depvar)'
	local depvar : word 1 of `depvar'
	
	args e yhat s touse lb ub
	local L "((`lb'-`yhat')/`s')"
	local U "((`ub'-`yhat')/`s')"
	
	qui gen double `e' = `yhat' if `touse' & `lb'==. & `ub'==.
	qui replace `e' = ///
		`yhat' + `s'*normalden(`L')/normal(-`L') ///
		if `touse' & `lb'!=. & `ub'==.
	qui replace `e' = ///
		`yhat' - `s'*normalden(`U')/normal(`U') ///
		if `touse' & `lb'==. & `ub'!=.
	qui replace `e' = ///
		`yhat' - `s'*(normalden(`U')-normalden(`L')) / ///
		(normal(`U')-normal(`L')) ///
		if `touse' & `lb'!=. & `ub'!=.
end

program define _cens_pr
	local depvar `e(depvar)'
	local depvar : word 1 of `depvar'

	args p yhat s touse lb ub
	
	qui gen double `p' = 1 if `touse' & `lb'==. & `ub'==.
	qui replace `p' = ///
		normal(-(`lb'-`yhat')/`s') if `touse' & `lb'!=. & `ub'==.
	qui replace `p' = ///
		normal((`ub'-`yhat')/`s') if `touse' & `lb'==. & `ub'!=. 
	qui replace `p' = ///
		normal((`ub'-`yhat')/`s') - normal((`lb'-`yhat')/`s') ///
		if `touse' & `lb'!=. & `ub'!=. 
end

program define _cens_ystar
	local depvar `e(depvar)'
	local depvar : word 1 of `depvar'
	
	args y yhat s touse lb ub
	
	tempvar e p p2
	_cens_e `e' `yhat' `s' `touse' `lb' `ub'
	_cens_pr `p' `yhat' `s' `touse' `lb' `ub'
	_cens_pr `p2' `yhat' `s' `touse' . `lb'

	qui gen double `y' = `e' if `touse' & `lb'==. & `ub'==.
	qui replace `y' = ///
		`p'*`e' + (1-`p')*`lb' if `touse' & `lb'!=. & `ub'==.
	qui replace `y' = ///
		`p'*`e' + (1-`p')*`ub' if `touse' & `lb'==. & `ub'!=.
	qui replace `y' = ///
		`p'*`e' + `p2'*`lb' + (1-`p'-`p2')*`ub' ///
		if `touse' & `lb'!=. & `ub'!=. 
end

exit

Note:
Option -margvar()- is only consumed after metobit and meintreg.
This option generates a new variable that contains the marginal variance of
the linear predictor.  This is useful for certification purposes.
No checks are made whether the newvarname is valid or the variable exists.

