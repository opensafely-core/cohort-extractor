*! version 1.0.0  26jan2015

program define _stteffects_gmm_wra, rclass
	version 14.0
	syntax varlist(numeric fv) [if] [fw iw pw/], at(name)              ///
		survdist(string) tvar(varname) stat(string) levels(string) ///
		control(integer) tlevel(integer) [ censordist(string)      ///
		wra(name) verbose derivatives(varlist) dwra(varlist) ]
	local expo = ("`survdist'"=="exponential")
	local pomeans = ("`stat'"=="pomeans")
	local bcensor = ("`censordist'"!="")
	local bderiv = ("`derivatives'"!="")
	local bverbose = ("`verbose'"!="")
	local klev : list sizeof levels
	local kpar = colsof(`at')
	local eqs : coleq `at'
	local eqs : list uniq eqs
	local keq : list sizeof eqs

	/* assumption: stset						*/
	/* survival time variable					*/
	local to : char _dta[st_t]
	/* failure event variable					*/
	local do : char _dta[st_d]

	if "`weight'"!="" & "`verbose'"!="" {
		/* gmm handles weights, use for debugging		*/
		tempvar wvar

		qui gen double `wvar'=`exp'
		if "`weight'" == "pweight" {
			local wts [iw=`wvar']
		}
		else {
			local wts [`weight'=`wvar']
		}
	}

	if `bverbose' {
		di _n "scores varlist |`varlist'|"
		/* count # POMEANS and OME equations			*/
		local ko = `klev'*(2 + !`expo')
	}
	if `bcensor' {
		local cexpo = ("`censordist'"=="exponential")
		/* return weight vector? used in validation		*/
		if "`wra'" == "" {
			tempvar wra
		}
		if `bderiv' {
			if "`dwra'" != "" {
				/* return for testing			*/
				gettoken dwc dwa : dwra
			}
			else {
				/* variable for d_censor/d_xb		*/
				tempvar dwc
				if !`cexpo' {
					/* variable for d_censor/d_zg	*/
					tempvar dwa
				}
			}
		}
		_stteffects_gmm_censor `varlist' `if', dist(`censordist') ///
			b(`at') to(`to') do(`do') deriv(`derivatives')    ///
			surv(`wra') dsurv(`dwc' `dwa')
		if `bverbose' {
			local slist `r(varlist)'
			di _n "censor outcome moments"
			summarize `slist' `if' `wts'
			di _n "censor weights"
			summarize `wra' `if' 
		}
		qui replace `wra' = cond(`do',1/`wra',0) `if'
		if `bderiv' {
			tempvar wra2
			qui gen double `wra2' = cond(`do',-`wra'^2,0) `if'
			qui replace `dwc' = cond(`do',`dwc'*`wra2',0) `if'
			if !`cexpo' {
				qui replace `dwa' = cond(`do',`dwa'*`wra2', ///
					0) `if'
			}
			qui drop `wra2'
		}
	}
	_stteffects_gmm_surv `varlist' `if', b(`at') dist(`survdist') ///
		stat(`stat') tvar(`tvar') levels(`levels')            ///
		control(`control') tlevel(`tlevel') to(`to') do(`do') ///
		deriv(`derivatives')

	if `bcensor' {
		_stteffects_gmm_dcensor `varlist' `if', do(`do')            ///
			levels(`levels') eqs(`eqs') wgt(`wra') expo(`expo') ///
			cexpo(`cexpo') deriv(`derivatives') dwgt(`dwc' `dwa')
		if `bderiv' {
			_stteffects_gmm_scale_dome `derivatives' `if', ///
				wgt(`wra') eqs(`eqs') levels(`levels') ///
				expo(`expo')
		}
	}
	local slist `r(varlist)'
	if `bverbose' {
		di _n "survival outcome moments"
		summarize `slist' `if' `wts'
	}
end

exit
