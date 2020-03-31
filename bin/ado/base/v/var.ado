*! version 1.10.1  17dec2018
program define var, eclass sortpreserve byable(recall)
	version 8.0
	if replay() {
		if "`e(cmd)'" != "var" {
			error 301
		}
		if _by() { 
			error 190 
		}
		syntax [ , Level(cilevel) NOCNSReport *]
		
		_get_diopts options, `options'
		Dheadernew, `nocnsreport'
		eret display, level(`level') `options'
		exit
	} 
	local cmdline : copy local 0
	syntax varlist(ts) [if][in] , 				/*
	 	*/ [LAgs(numlist min=1 sort integer >=1)	/*
		*/ EXog(varlist ts) 				/*
		*/ CONSTraints(numlist sort)			/*
		*/ noConstant  					/*
		*/ DFK 						/*
		*/ LUTstats 					/*
		*/ noBIGf Level(cilevel) 			/*
		*/ SMall 					/*
		*/ noISure					/*
		*/ ITerate(numlist max =1 integer >0 )		/*
		*/ TOLerance(numlist max =1 >0 <1 )		/*
		*/ NOCNSReport					/*
		*/ NOLOg LOg					/*
		*/ noDISPlay				/* undocumented
		*/ ZLags				/* undocumented
		*/ noMODEL *]				/* undocumented */

	_get_diopts diopts, `options'
/* zlags and nomodel are undocumented 
 * they are used by var postestimation routines and are not designed for 
 * general use
 *
 * zlags estimates a model with zero lags
 * nomodel asks that the model F/chi2 tests not be performed
 */


/* call to tsunab requires that operator have fewer characters than 
 * internal limit RawRecipeLen
 */

	if "$S_FLAVOR" == "Small" {
		local RawRecipeLen 80
	}
	else {
		local RawRecipeLen 240
	}

	marksample touse

	if "`tolerance'" != "" {
		local tolerance "tolerance(`tolerance')"
	}	

	if "`iterate'" != "" {
		local iterate "iterate(`iterate')"
	}	

	if "`isure'" != "" & "`constraints'" == "" {
		di as err "{bf:noisure} cannot be specified without "	/*
			*/ "{cmd:constraints()}"
		exit 198
	}	

	if "`nolog'`log'" != "" & "`constraints'" == "" {
		di as err "{bf:log} and {bf:nolog} cannot be specified " /*
			*/ "without {bf:constraints()}"
		exit 198
	}	
	if "`tolerance'" != "" & "`constraints'" == "" {
		di as err "{bf:tolerance()} cannot be specified without "/*
			*/ "{bf:constraints()}"
		exit 198
	}	

	if "`iterate'" != "" & "`constraints'" == "" {
		di as err "{bf:iterate()} cannot be specified without "/*
			*/ "{bf:constraints()}"
		exit 198
	}	
	if "`exog'" != "" {
		markout `touse' `exog'
	}

	if "`zlags'" != "" & "`lags'" != "" {
		di as err "zlags and lags() cannot both be specified"
	}	

	qui tsset, noquery
	local timevar "`r(timevar)'"	
	local panelvar "`r(panelvar)'"
	local tsfmt   "`r(tsfmt)'"
	tempname tsdelta
	scalar `tsdelta' = `: char _dta[_TSdelta]'
	
	if "`zlags'" == "" {
		if "`lags'" == "" {
			local lags "1 2"
		}
		local recipe "L(0 `lags')"
		local rcplen : length local recipe
		if `rcplen' >= `RawRecipeLen' {
			di as err "too many lags, cannot fit VAR"
			exit 498
		}

		tsunab flist : L(0 `lags').(`varlist')
		markout `touse' `flist'
	}	
	else {
		markout `touse' `varlist'
	}

	_rmcoll `varlist' if `touse', `constant'
	local varlist "`r(varlist)'"

	tempname b bf V Cns sig_ml fpe aic hqic sbic ll detsig_ml 	///
		detsig G exlagsm		

	local eqs : word count `varlist'
	local nlags  : word count `lags'
	if "`lags'" != "" {
		local mlag : word `nlags' of `lags'
	}	
	else {
		local mlag 0
	}	
	
	qui count if `touse' ==1

	if r(N)<= 2 {
		di as err "cannot fit a model with `mlag' lags on the " /*
			*/ "current sample"
		exit 498
	}	
		

	if "`zlags'" != "" {
		local nlags 0
		local zeros ""
		local maxlag 0
	}
	else {
		local maxlag : word `nlags' of `lags'
		local zeros "zeros"
		tempvar zerov
		gen `zerov' = 0
		forvalues i=1(1)`eqs' {
			local zvarlist "`zvarlist' `zerov' "
		}
	}	

	if "`exog'" != "" {
		_rmcoll `exog' if `touse' , `constant'
		local exog "`r(varlist)'"

		if "`zlags'" == "" {
			local recipe "L(0 `lags')"
			local rcplen : length local recipe
			if `rcplen' >= `RawRecipeLen' {
				di as err "too many lags, cannot fit VAR"
				exit 498
			}

			tsunab flist : L(0 `lags').(`varlist') `exog'
		}
		else {
			tsunab flist : `varlist' `exog'
		}

		_rmcoll `flist' if `touse', `constant'
		local flist2 `r(varlist)'

		local same : list flist == flist2
		if `same' != 1 {
			di as err "{p 0 4}the exogenous variables may "	/*
				*/ "not be collinear with the "		/*
				*/ "dependent variables, or their "	/*
				*/ "lags{p_end}"
			exit 198
		}	

		_sep_varsylags `exog', `constant'

		local exlags    "`r(lags)'"
		local exogvars  "`r(basevars)'"
		mat  `exlagsm' = r(lagsm)
		
		tsunab exog  : `r(newlist)'
		
		local exogl " exog(`exog') "
	}	

	if "`constraints'" == "" {
		_qsur `varlist' if `touse' , lags(`lags') `exogl' `dfk'	/*
			*/ `small' `constant' `model' `zlags'
	}
	else {
		_cvar `varlist' if `touse', lags(`lags')	/*
			*/ const(`constraints') `exogl' 	/*
			*/ `constant' `dfk' `small'  `zlags'	/*
			*/ `isure' `iterate' `tolerance' `log' `nolog'
		mat `Cns' = get(Cns)
	}	

	mat `b' = e(b)
	mat `V' = e(V)

/* make bf */
	local nexog : word count `exog'
	
	if "`constant'" == "" {
		local mycons "_cons"
	 	local tsize = `eqs'*`eqs'*`maxlag' + `eqs'+`eqs'*`nexog'	
	}
	else {
		local mycons ""
	 	local tsize = `eqs'*`eqs'*`maxlag'+`eqs'*`nexog' 
	}


	if "`zeros'" != "" & "`bigf'" == "" {
		local cnt 1
		foreach v1 of local varlist {
			local v1eq : subinstr local v1 "." "_", all
			foreach v2 of local varlist {
				local j 1
				forvalues i = 1(1)`maxlag' {
					local clag : word `j' of `lags'
					if `i' == `clag' {
						mat `bf' =( nullmat(`bf') , /*
							*/ `b'[1,`cnt']  )	
						local cnt = `cnt' + 1	
						local j = `j' + 1	
					}
					else {
						mat `bf' =( nullmat(`bf') , 0)
					}
					local bfname "`bfname' `v1eq':L`i'.`v2' "
				}
			}	
			foreach v3 of local exog {
				mat `bf' =( nullmat(`bf') , `b'[1,`cnt'] )
				local cnt = `cnt' + 1	
				
				local bfname "`bfname' `v1eq':`v3' " 

			}
			if "`mycons'" != "" {
				mat `bf' =( nullmat(`bf') , `b'[1,`cnt'] )
				local cnt = `cnt' + 1	
				
				local bfname "`bfname' `v1eq':_cons " 
			}
		}
		mat colnames `bf' = `bfname'
	}	
	else {
		mat `bf'=e(b)
	}	

	local K=`eqs'
	local M = `maxlag'
	local T = e(N)
	local eqparm = e(df_eq)		/* This gives the number of parameters
					   in equation with most parameters 
					   NB: this number includes the
					   constant, if present
					*/  
					   
	local arparms=`nlags'*e(neqs)^2


	scalar `detsig_ml' = e(detsig_ml)
	scalar `detsig' = e(detsig)

/* Note: all model fit statistics use detsig which = detsig_ml when
 * dfk is not specified and differs from detsig_ml when dfk is specified,
 * i.e. all model fit statistics change with dfk
 */
	scalar `fpe' = ( (`T'+`eqparm')/(`T'-`eqparm') )^(`K') /*
			*/ * `detsig_ml'

	if "`lutstats'" == "" {
		scalar `ll'= e(ll)
		local tparms=e(tparms)
		
		scalar `aic'=-2*(`ll'/`T') + (2*`tparms')/`T' 
		scalar `hqic'=-2*(`ll'/`T') + (2*ln( ln(`T'))/`T')*`tparms'
		scalar `sbic'=-2*(`ll'/`T') + (ln(`T')/`T')*`tparms'
	}
	else {
		scalar `aic'=ln(`detsig_ml') + (2*`arparms')/`T'
		scalar `hqic'=ln(`detsig_ml') + (2*ln( ln(`T'))/`T')*`arparms'
		scalar `sbic'=ln(`detsig_ml') + (ln(`T')/`T')*`arparms'
	}

	

	if "`constant'" == "" {
		tempname cons 
		gen `cons' = 1
	}	

	if "`zeros'" == "" | "`bigf'" != "" {
		foreach i of local lags {
			local gvars "`gvars' L`i'.(`varlist') "
		}
	}
	else {
		local claglist "`lags'"
		gettoken clag claglist : claglist
		forvalues i=1(1)`maxlag' {
			if `clag' == `i' {
				local gvars "`gvars' L`i'.(`varlist') "
				gettoken clag claglist : claglist
			}
			else {
				local gvars "`gvars' L`i'.(`zvarlist') "
			}
		}	
	}	
	if "`cons'`gvars'" != "" {
		qui matrix accum `G' = `cons' `gvars' if e(sample), nocons 
		local noG 
	}
	else {
		local noG noG
		mat `G' = 0
	}
	
	local T = r(N)

	matrix `G'= (1/`T')*`G'
	local trnames : colnames `G'
	if "`cons'" != "" {
		local trnames : subinstr local trnames "`cons'" "_cons", all
	}	
	if "`zerov'" != "" {
		local trnames : subinstr local trnames "`zerov'" "zero", all
	}	
		
	mat colnames `G' = `trnames'
	mat rownames `G' = `trnames'


// save off standard k_dv and k_eq
	eret scalar k_eq = e(neqs)
	eret scalar k_dv = e(neqs)
	
/* calculate and save off # gaps in e(sample) */	
	tempvar timetmp
	qui gen double `timetmp' = `timevar' if e(sample)
	nobreak {
		qui tsset `timetmp', delta(`=`tsdelta'') noquery
		capture tsreport 
		local rc = _rc
		eret scalar N_gaps = r(N_gaps)
		qui tsset `panelvar' `timevar', 		///
			format(`tsfmt') delta(`=`tsdelta'') noquery
	}	
	if `rc' > 0 {
		error `rc'
	}

	qui sum `timevar' if e(sample)	
	eret scalar tmin = r(min)
	eret scalar tmax = r(max)
	eret scalar mlag = `maxlag'

	eret scalar fpe = `fpe'
	eret scalar aic = `aic'
	eret scalar hqic = `hqic'
	eret scalar sbic = `sbic'
	eret hidden scalar T = `T'
	

	if "`constraints'" != "" {
		eret matrix Cns = `Cns'
	}

	if "`noG'" == "" {
		eret matrix G `G'
	}	
	if "`bigf'" == "" {
		eret matrix bf `bf'
	}
	else {
		eret local bigf "nobigf"
	}	
	if "`constant'" != "" {
		eret local nocons "nocons"
	}	
	
	if "`constraints'" != "" {
		eret local constraints constraints
	}	
	eret local title    "Vector autoregression"
	eret local dfk      "`dfk'"
	eret local lutstats "`lutstats'"
	eret local tsfmt    "`tsfmt'"
	eret local timevar  "`timevar'"
	eret local endog    "`varlist'"
	eret local exog     "`exog'"
	eret local lags     "`lags'"
	eret local small    "`small'"
	eret repost, buildfvinfo
	eret local marginsok xb default
	eret local marginsnotok stdp Residuals
	local eqnames `"`e(eqnames)'"'
	foreach eq of local eqnames {
		local mdflt `mdflt' predict(xb equation(`eq'))
	}
	eret local marginsdefault `"`mdflt'"'
	eret local predict  "var_p"

	if "`exog'" != "" {
		eret local exogvars `exogvars'
		eret local exlags   `exlags'
		eret matrix exlagsm `exlagsm'
	}

	eret local cmdline `"var `cmdline'"'
	eret local cmd      "var"
	_post_vce_rank

	if "`display'" == "" {
		Dheadernew, `nocnsreport'
		eret display, level(`level') `diopts'
	}	
end	

program define Dheadernew
	syntax [, NOCNSReport]
	local neqs = e(neqs)
	local vlist "`e(endog)'"

	di
	di as txt "Vector autoregression"
	di

	if "`e(lutstats)'" != "" {
		local luts "(lutstats)"
	}	

	_mvtsheadr
	di as txt "{col 49}Number of obs{col 67}= " as res %10.0fc e(N)
	di as txt "Log likelihood =  " as res %9.8g e(ll)		///
		as txt "{col 38}`luts'"					///
		"{col 49}AIC{col 67}=  " as res %9.8g e(aic)	
	di as txt "FPE{col 16}=  " as res %9.8g e(fpe)			///
		as txt "{col 49}HQIC{col 67}=  " as res %9.8g e(hqic)	
	di as txt "Det(Sigma_ml){col 16}=  " as res %9.8g e(detsig_ml)	///
		as txt "{col 49}SBIC{col 67}=  " as res %9.8g e(sbic)	
		
	di	
	_vardisprmse , est(var) `e(small)'
	di
	if "`nocnsreport'" == "" {
		matrix dispCns, r
		if r(k) > 0 {
			matrix dispCns
		}	
	}
	
end
