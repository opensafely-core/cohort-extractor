*! version 1.2.9  05nov2018
program define varlmar, rclass sort
	version 8.0

	syntax  [, MLag(numlist max=1 integer >0) 		/*
		*/ ESTimates(string)				/*
		*/ SEParator(numlist integer max=1 >=0)  ]

	if "`mlag'" == "" {
		local mlag 2
	}	

	if `mlag' <=0 {
		di as error "mlag() must be a strictly positive integer"
		exit 198
	}
		
	if `mlag' >= e(N)-1 {
		di as err "mlag() invalid: insufficient observations "	/*
			*/ "to fit a model with `mlag' lags"
		exit 498
	}

	if "`separator'" == "" {
		local separator 0
	}	

	tempvar t_tmp samp n_ob
	tempname sig2 orig sample lm df p
	tempname tvar1 row results detsig_ml pest

	_est hold `pest', copy restore nullok varname(`samp')

	if "`estimates'" == "" {
		tempname pest2
		capture est store `pest2'
		if _rc > 0 {
			di as err "cannot restore current estimates"
			exit 498
		}	
	}
	else {
		local pest2 `estimates'
	}	



	capture estimates restore `pest2'
	if _rc > 0 {
		di as err "cannot restore estimates(`pest2')"
		exit 198
	}	

	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
	di as err "{help varlmar##|_new:varlmar} only works with "	/*
	*/ "estimates from {help var##|_new:var} or {help svar##|_new:svar}"
		exit 198
	}

	_cknotsvaroi varlmar


	if "`e(cmd)'" == "svar" {
		local svar _var
	}

	if "`e(Cns`svar')'" != "" {
		_getvarcns
		local cnslist $T_VARcnslist
		local cns constraints(`cnslist')
		macro drop T_VARcnslist
		macro drop T_VARcnslist2
	}	

	local nocons "`e(nocons`svar')'"

	qui tsset, noquery
	local tvar "`r(timevar)'"
	local pvar "`r(panelvar)'"


	if "`pvar'" != "" {
		qui sum  `pvar' if e(sample)
		if r(min) < r(max) {
			di as err "{help varlmar:varlmar} will only work " /*
				*/"with one panel in the estimation sample"
			exit 198
		}	
	}	

	local N = e(N)
	scalar `detsig_ml' = e(detsig_ml`svar')
	
	local neqs = e(neqs)
	local dvars "`e(endog`svar')'"
	local exog "`e(exog`svar')'"
	local lags "`e(lags`svar')'"
	
	local nlags : word count `lags'
	local nexog : word count `exog'
	local mcons = cond("`e(nocons`svar')')" != "" , `neqs', 0 )
		
	qui gen byte `sample'=e(sample)
	gen `n_ob' = sum(`sample')

	local rvars ""
	forvalues j=1(1)`mlag' {
		forvalues i=1(1)`neqs' {
			capture drop `tvar1'
			capture drop `e`i'_`j''
			tempvar e`i'_`j'
			qui predict double `tvar1' if `sample', equation(#`i') res
			qui gen double `e`i'_`j''=l`j'.`tvar1'
/* replace all missing values 
 * in residuals with zero 
 * if in sample 	
 */	
			qui replace `e`i'_`j''=0 if `e`i'_`j'' >= . &	/*
				*/ `sample'
			local rvars "`rvars' `e`i'_`j'' "
		}
	}	

	markout `sample' `rvars' `dvars' 

	forvalues j=1(1)`mlag' {
		
		local rvars ""

		forvalues i=1(1)`neqs' {
			local rvars "`rvars' `e`i'_`j'' "
		}
		
		tsunab flist:  L(0 `lags').(`dvars') `exog' `rvars'
		qui _rmcoll `flist' if `sample'
		local flist2 `r(varlist)'	
		local same : list flist == flist2
		if (`same'==0) {
			di as err "{p 0 4}"
			di as err "the lags of residuals may not"
			di as err "be collinear with the dependent"
			di as err "variables, or their lags"
			di as err "{p_end}"
			exit 198

		}
		qui var `dvars' if `sample' ,exog(`exog' (`rvars')) /*
			*/ lags(`lags') `nocons' `cns'
			
		local mdf=`N'-e(df_eq)-.5
		mat `sig2'=e(Sigma)

		scalar `lm'= (`mdf')*(ln((`detsig_ml') /*
			*/ /(det(`sig2'))))
		scalar `df' =`neqs'*`neqs'
		scalar `p'  = chi2tail(`df', `lm')

		capture estimates restore `pest2'
		if _rc > 0 {
			di as err "cannot restore estimates"
			exit _rc
		}

		mat `row' = ( `j', `lm' , `df', `p' )
		mat `results' = ( nullmat(`results') \ `row')
		local js "`js' `j'"
	}
		
	_est unhold `pest'	
	if "`cnslist'" != "" {
		constraint drop `cnslist'
	}	
	
	matrix colnames `results' = j chi2 df p 
	matrix rownames `results' = `js'

	DTable , mname(`results') separator(`separator')
	
	ret matrix lm `results'	


end

program define DTable

	syntax  , mname(name) separator(numlist max=1 integer >=0)

	capture confirm matrix `mname'
	if _rc > 0 {
		di as err "results matrix not found"
		exit 498
	}

	local rows = rowsof(`mname')

	tempname table 

	.`table' = ._tab.new, col(4) separator(`separator')
	.`table'.width |6|12 6 13|
	.`table'.strcolor green . . . 
	.`table'.numcolor green yellow yellow yellow
	.`table'.numfmt %4.0f %8.4f %4.0f %6.5f
	.`table'.pad . 2 . 3

	di _n as text "{col 4}Lagrange-multiplier test"
	.`table'.sep, top
	.`table'.titles	"lag "		/// 1
			"chi2 " 	/// 2
			"df "		/// 3
			"Prob > chi2"
	.`table'.sep, mid

	forvalues i = 1/`rows' {
		.`table'.row	`mname'[`i',1]	///
				`mname'[`i',2]	///
				`mname'[`i',3]	///
				`mname'[`i',4]	
	}
	.`table'.sep, bot
	di as text "{col 4}H0: no autocorrelation at lag order"

end

exit
