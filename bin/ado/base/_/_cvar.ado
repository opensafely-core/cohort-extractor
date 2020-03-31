*! version 1.2.0  13mar2018
program define _cvar, eclass
	version 8.0

	syntax varlist(ts) [if] [in],				/*
		*/ CONSTraints(numlist) 			/*
		*/ [Lags(numlist min=1 >=1 ascending integer) 	/*
		*/ ZLags					/* 
		*/ exog(string) 				/*
		*/ small 					/*
		*/ dfk 						/*
		*/ noISure					/*
		*/ ITerate(numlist max =1 integer >0 )		/*
		*/ TOLerance(numlist max=1 >0 <1)		/*
		*/ NOLOg LOg					/*
		*/ noCONStant 					/*
		*/ dfmodel(integer 0)				/* undoc
		*/ exfront(varlist ts)				/* undoc
		*/ from(passthru)				/* undoc
		*/ ]
/* Notes
	dfmodel is an undocumented option that is used when -vec- calls _cvar.
	dfmodel is the degrees of freedom in the model.

	exfront() is an undocumented option that -vec- uses when it calls 
	_cvar.  exfront() specifies a set of exogenous variables that will be
	displayed before the lags on the endogenous variables.

*/
		
	if "`zlags'" != "" & "`lags'" != ""{
		di as err "zlags and lags() may not both be specified"
		exit 198
	}

	if "`zlags'" == "" & "`lags'" == ""{
		di as err "zlags and lags() may not both be empty"
		exit 198
	}

	tempname b v smp sig_u detsig Cns

	marksample touse

	if "`lags'" != "" {
		markout `touse' `varlist' l(`lags').(`varlist') `exog'	///
			`exfront'
	}
	else {
		markout `touse' `varlist' `exog' `exfront'
	}

	if "`isure'" == "" {
		local isure isure
	}
	else {
		if "`iterate'" != "" {
			di as err "{cmd:iterate} cannot be specified "	/*
				*/ "with {cmd:noisure}"
			exit 198	
		}	
		if "`tolerance'" != "" {
			di as err "{cmd:tolerance} cannot be specified "/*
				*/ "with {cmd:noisure}"
			exit 198	
		}	
		if "`nolog'" != "" {
			di as err "{cmd:nolog} cannot be specified "/*
				*/ "with {cmd:noisure}"
			exit 198	
		}	
		local isure
	}

	if "`tolerance'" != "" {
		local tolerance "tolerance(`tolerance')"
	}	

	if "`iterate'" != "" {
		local iterate "iterate(`iterate')"
	}	

	if "`constant'" == "" {
		local mcon 1
	}
	else {
		local mcon 0
	}
	if "`dfk'" != "" {
		local dfk dfk2
	}	

	if "`exog'" != "" {
		_exogPARSE `exog'
		local exoglist `r(varlist)'
		local exogm "exog(`exoglist')"
	}	
	
	_ckcns `varlist', lags(`lags') constraints(`constraints') /*
		*/ `exogm' `zlags' exfront(`exfront')

	if "`zlags'" == "" {
		foreach var of local varlist {
local sureg_cmd " `sureg_cmd' (`var' `exfront' L(`lags').(`varlist') `exoglist', `constant') "
		}
	}
	else {
		foreach var of local varlist {
local sureg_cmd " `sureg_cmd' (`var' `exfront' `exoglist', `constant') "
		}
	}

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" == "" {
		di as txt "Estimating VAR coefficients"
	}	
	sureg `sureg_cmd' if `touse'==1, 		/*
		*/ constraints(`constraints') `small' 		/*
		*/ `dfk' `isure' notable noheader `tolerance'	/*
		*/ `iterate' `mllog' `from'

	if "`constant'" == "" {
		local df_cons 1
	}
	else {
		local df_cons 0
	}
	mat `b' = e(b)
	mat `v' = e(V)
	mat `Cns' = get(Cns)
	mat `sig_u' = e(Sigma)
	gen byte `smp' = e(sample)

	local eqs : word count `varlist'

	local df_eq 0
	if "`small'" == "" {
		forvalues i = 1/`eqs' {
			local df_m`i' = e(df_m`i')
			local rss_`i' = e(rss_`i')
			local rmse_`i' = e(rmse_`i')
			local r2_`i' = e(r2_`i')
			local chi2`i' = e(chi2_`i')

			local df_eq = `df_eq' + e(df_m`i')+`df_cons' 
		}
	}
	else {
		forvalues i = 1/`eqs' {
			local df_m`i' = e(df_m`i')
			local df_r`i'  = e(df_r)
			local rss_`i' = e(rss_`i')
			local rmse_`i' = e(rmse_`i')
			local r2_`i' = e(r2_`i')
			local F`i' = e(F_`i')
			
			local df_eq = `df_eq' + e(df_m`i')+`df_cons' 
		}
		local df_r = e(df_r)
	}

	local df_eq = `df_eq'/`eqs'


	local N = e(N)
	local ll =e(ll)
	local k  = e(k)
	local depvar `e(depvar)'
	local eqnames `e(eqnames)'
	
	if "`dfk'" != "" {
		tempname df_adj 
		scalar `df_adj' = `df_eq'
	}
	
	eret post `b' `v' `Cns' , esample(`smp')
	eret mat Sigma  `sig_u'

	
	scalar `detsig' = det(e(Sigma))
	eret scalar detsig    = `detsig'

	if "`dfk'" != "" {
		eret scalar ll_dfk = -0.5 *`N'* (`eqs'*ln(2*_pi) +  /*
			*/  ln(`detsig') + `eqs')
	
		eret scalar detsig_ml = ((`df_adj'/`N')^(`eqs'))*`detsig'
	}
	else {
		eret scalar detsig_ml   = `detsig'
	}

	if "`small'" == "" {
		forvalues i = 1/`eqs' {
			eret scalar df_m`i'	= `df_m`i''
			eret scalar k_`i'	= `df_m`i'' + `mcon'
			eret scalar rss_`i' 	= `rss_`i''
			eret scalar rmse_`i'	= `rmse_`i''
			eret scalar r2_`i'	= `r2_`i'' 
			eret scalar chi2_`i' 	= `chi2`i'' 
			
			eret scalar df_eq = `df_eq'
		}
	}
	else {
		forvalues i = 1/`eqs' {
			eret scalar df_m`i'	= `df_m`i''
			eret scalar df_r`i'	= `df_r`i''
			eret scalar k_`i'	= `df_m`i'' + `mcon'
			eret scalar rss_`i'	= `rss_`i''
			eret scalar rmse_`i'	= `rmse_`i''
			eret scalar r2_`i'	= `r2_`i''
			eret scalar F_`i'	= `F`i'' 
			
			eret scalar df_eq 	= `df_eq'
		}
		eret scalar df_r = `df_r'
	}

	eret scalar N 		= `N' 
	eret scalar df_eq 	= `df_eq'
	eret scalar k  		= `k'
	eret scalar tparms 	= `k'
	eret scalar ll 		= `ll'
	eret scalar neqs 	= `eqs'

	eret local depvar  `depvar'
	eret local endog   `depvar'
	eret local eqnames `eqnames'

	eret local cnslist_var `constraints' 

end

program define _ckcns
	syntax varlist(ts), 			/*
		*/ constraints(numlist) 	/*
		*/ [exog(string) 		/*
		*/ lags(numlist min=1 >=1 )	/*
		*/ ZLags			/*
		*/ noCONStant			/*
		*/ exfront(varlist ts)		/*
		*/ ]
	
	if "`zlags'" != "" & "`lags'" != ""{
		di as err "zlags and lags() may not both be specified"
		exit 198
	}

	if "`zlags'" == "" & "`lags'" == ""{
		di as err "zlags and lags() may not both be empty"
		exit 198
	}
	tempname b bfull cresults v ressamp
	
	capture _estimates hold `cresults', restore nullok copy		/*
		*/ varname(`ressamp')


	nobreak {
		local vlist `varlist'

		foreach var of local vlist {
			local eq : subinstr local var "." "_"

			if "`zlags'" == "" {
				local 0 "L(`lags').(`vlist') "
				syntax varlist(ts)
			}

			local varlist `exfront' `varlist' `exog'

			if "`constant'" == "" {
				local varlist `varlist' _cons
			}	

			local bcols : word count `varlist'
			mat `b' = J(1,`bcols', 0)
			mat colnames `b' = `varlist'
			mat coleq `b' = `eq'
			mat `bfull' = ( nullmat(`bfull'), `b')
		}

		mat `v' = `bfull''*`bfull'
		eret post `bfull' `v'

		capture noi matrix makeCns `constraints'
		local rc = _rc
		if _rc > 0 {
			di as err "at least one constraint in "	/*
				*/ "constraints(`constraints') invalid"
		}		
	}
	capture _estimates unhold `cresults'
	if `rc' > 0 {
		exit `rc'
	}	
	
	
end

program define _exogPARSE, rclass
	syntax varlist(ts)
	ret local varlist `varlist'
end
