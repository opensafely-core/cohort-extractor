*! version 1.1.2  25may2011
program define _qsur , eclass
	version 8.0
	syntax varlist(ts) [if] [in], 		/*
		*/ [ lags(numlist min=1 ascending >=1 integer) 	/*
		*/ exog(varlist ts) 		/*
		*/ SMall 			/*
		*/ noCONstant 			/*
		*/ dfk 				/*
		*/ ZLags			/*
		*/ noMODEL 			/* undocumented
						   suppresses model test
	 	*/ exfront(varlist ts)		/* undoc 
		*/ dfmodel(integer 0)		/* undoc
		*/ ]

/* Notes:

	exfront is an undocumented option that contains exogenous variables
	to appear before the lags of the endogenous variables  (this is used 
	by -vec- which now calls this routine

	dfmodel() specifies the degrees of freedom for the model and is used to 
	compute an alternative degree of freedom correction in computing the
	VCE matrix. This option is used by -vec- when it call this routine.
	The reason is that the constraints used to identify the cointegrating
	vectors must be subtracted from the number of free parameters in the
	model
*/
						 

	if `dfmodel' > 0 & "`dfk'" != "" {
		di as err "dfmodel() may not be specified with dfk"
	}

	if `dfmodel' > 0 {
		local dfk dfk
	}

	if "`zlags'" != "" & "`lags'" != ""{
		di as err "zlags and lags() may not both be specified"
		exit 198
	}

	if "`zlags'" == "" & "`lags'" == ""{
		di as err "zlags and lags() may not both be empty"
		exit 198
	}
		

	marksample touse

	if "`lags'" != "" {
		markout `touse' `varlist' l(`lags').(`varlist') `exog'	///
			`exfront'
	}
	else {
		markout `touse' `varlist' `exog' `exfront'
	}

	tempname b bigb XpX sig_u T V detsig_ml detsig
	tempvar res
	
	local nlags    : word count `lags'
	local neqs : word count `varlist'

	if "`lags'" != "" {
		local maxlag   : word `nlags' of `lags' 
		local neqs : word count `varlist'
	}
	else {
		local maxlag  0
	}

	if `maxlag' > 0 {
		foreach var2 of local varlist {
			local indeps "`indeps' l(`lags').`var2' " 	
		}			
		local endvs = `nlags' * `neqs'
		local endvs " + `endvs' "
	}	
		
	local nexvars  : word count `exog'  `exfront'
	local exvs " `nexvars' "

	if "`constant'" == "" {
		local addc " + 1"
	}

	local mparms = `exvs' `endvs' `addc' 
		
	if "`dfk'" != "" {
		local mparms2 " - (`mparms') "
	}

	local dfm  "."

/* eqparm will hold the number of parameters from the equation with
	the most parameters.  This way of defining eqparm protects against
	collinearity in model definition.
*/	
	local eqparm = 0
	local i 1
	foreach var of local varlist {
		
	 	 capture regress  `var' `exfront' `indeps' `exog' if `touse', /*
			*/ `constant'  

		if _rc == 2000 {
			di as err "no observations"
			exit 2000
		}
		if _rc > 0 {
			error _rc
		}	
		
		local obs`i'   = e(N)
		local parms`i' = e(N)-e(df_r)
		local rmse`i'  = e(rmse)
		local r2`i'    = e(r2)
		local ll`i'    = e(ll)
		local N`i'     = e(N)

		local df_m`i'  = e(df_m)

		if "`small'" != "" {
			local df_r`i'  = e(df_r)
		}

		if "`small'" != "" & `dfm' > e(df_m) {
			local dfr = e(df_r)
		}	
		
		local eqK=e(N)-e(df_r)
	
		qui _predict double `res'`i' if `touse', residuals

		local resvars "`resvars' `res'`i' "
			
		mat `b'=e(b)
		local var2 : subinstr local var "." "_" 

		local eqnames "`eqnames'`var2' " 
		matrix coleq `b' = `var2'	

		matrix `bigb' = (nullmat(`bigb') , `b' )

		local eqparm = `eqparm' + `eqK'
		local tparms = `tparms' + `eqK'

		local i = `i'+1

	}	

	local eqparm = `eqparm'/`neqs'


	local N=e(N)
/* now make e(Sigma) and e(V) */
	
	qui mat accum `XpX' = `exfront' `indeps' `exog' if `touse', `constant'

	qui mat `XpX' = syminv(`XpX') 
	qui mat accum `sig_u' = `resvars' if `touse', nocons
	local T = r(N)


	if `dfmodel' > 0 {
		if `T' <= `dfmodel' {
			di as err "there are too many parameters in the model"
			di as err "{p}the model uses up `dfmodel' "	///
				"degrees of freedom, but there are "	///
				"only `T' observations{p_end}"
			exit 498
		}
		local eqparm = `dfmodel'
	}

	local T_dfk = `T'-`eqparm'
	mat `sig_u'=  (1/`T')*`sig_u' 
	scalar `detsig_ml'=det(`sig_u')
	
	
	if "`dfk'" != "" {
		local T_dfk = `T'-`eqparm'
		mat `sig_u'=  (`T'/`T_dfk')*`sig_u' 
		scalar `detsig'=det(`sig_u')
	}	
	else {
		scalar `detsig'=`detsig_ml'
	}	


	mat `V' = `sig_u' # `XpX'


	local names : colfullnames `bigb'
	mat colnames `V' = `names'
	mat rownames `V' = `names'

	mat colnames `sig_u' = `varlist'
	mat rownames `sig_u' = `varlist'

	
	eret post `bigb' `V', esample(`touse')
	eret mat Sigma `sig_u' 
	
	eret hidden scalar neqs = `neqs' 
	eret scalar N = `N' 
	eret scalar df_eq = `eqparm'
 	eret scalar k =  `tparms'
/*	
 * eret scalar k = e(neqs)*e(df_eq)
*/
	eret hidden scalar tparms = `tparms'

	if "`small'" != "" {
		forvalues i=1(1)`neqs' {
			eret scalar obs_`i'   = `obs`i''
			eret scalar k_`i' = `parms`i'' 
			eret scalar rmse_`i'  = `rmse`i''
			eret scalar r2_`i'    = `r2`i''
			eret scalar ll_`i'    = `ll`i''
			eret scalar df_m`i'   = `df_m`i''
			eret scalar df_r`i'   = `df_r`i''
		}
		eret scalar df_r = `dfr'
	}	
	else {
		forvalues i=1(1)`neqs' {
			eret scalar obs_`i'   = `obs`i''
			eret scalar k_`i' = `parms`i'' 
			eret scalar rmse_`i'  = `rmse`i''
			eret scalar r2_`i'    = `r2`i''
			eret scalar ll_`i'    = `ll`i''
			eret scalar df_m`i'   = `df_m`i''
		}
	}

	if "`exfront'`indeps'`exog'" != "" {
		_mtvarsPARSE `exfront' `indeps' `exog'
		local mtvars `r(varlist)'

		local i 0
		foreach var1 of local varlist {
			local ++i 
			local mt 
			local var1 : subinstr local var1 "." "_"
			foreach var2 of local mtvars {
				local mt " `mt' [`var1']`var2' "
			}
			qui test `mt'
			if "`small'" != "" {
				eret scalar F_`i'      = r(F)
			}
			else {
				eret scalar chi2_`i'  = r(chi2)
			}
		}	
	}	

	if "`dfk'" != "" {
		eret scalar df_m = `mparms'
	}

	eret scalar ll = -0.5 *`N'* (e(neqs)*ln(2*_pi) +  /*
		*/  ln(`detsig_ml') + e(neqs))

	if "`dfk'" != "" {
		eret scalar ll_dfk = -0.5 *`N'* (e(neqs)*ln(2*_pi) +  /*
			*/  ln(`detsig') + e(neqs))
	}		
	eret scalar detsig_ml = `detsig_ml'	
	eret scalar detsig = `detsig'
	
	eret local nocons "`constant'"
	eret local depvar "`varlist'"
	eret local eqnames "`eqnames'"
	
end

program define _mtvarsPARSE, rclass
	syntax varlist(ts)
	ret local varlist `varlist'
end
