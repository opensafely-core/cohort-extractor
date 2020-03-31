*! version 1.1.0  19aug2019

program _threshold_p, rclass 
	version 14.0
	syntax anything(name=vlist id="varlist") [if] [in] [, xb Residuals  ///
			stdp DYNamic(passthru) rmse(string) ]


/**Check errors**/
	local whichopts `xb' `residuals' `stdp'
	if ("`whichopts'"==""|"`whichopts'"=="xb") {
		if ("`whichopts'"=="") {
			di in gr "(option {bf:xb} assumed; predicted values)"
			local xb xb 
			local whichopts `whichopts' `xb'
		}
	}
	if (wordcount("`whichopts'") != 1) {
		di as err "{p 0 8 2}only one of {bf:xb}, {bf:stdp}, or"
		di as err "{bf:residuals} allowed{p_end}"
		exit 184
	}

	if ("`dynamic'"!="" & "`whichopts'"!="xb") {
		di as err "{p 0 8 2} option {bf:`whichopts'} and {bf:dynamic()}"
		di as err "may not be combined{p_end}"
		exit 184
	}

	local depvar `e(depvar)'
	local threshvar `e(threshvar)'
	local nthresholds = e(nthresholds)

/**Check variable labels**/
	local eqlist `e(eqnames)'
	if ("`xb'"!="" & "`equation'"!="") {
		CheckEQ `equation', eq(`eqlist')
		local whreg
		foreach eq of local equation {
			if ("`eq'"!="`depvar'") {
				local wh = usubstr("`eq'",7,1)
				local whreg `whreg' `wh'
			}
		}
		local neq = wordcount("`equation'")
		_stubstar2names `vlist', nvars(`neq')
	}
	else {
		cap _stubstar2names `vlist', nvars(`nstates')
		if c(rc) {
			_stubstar2names `vlist', nvars(1)
		}
	}
	local varnem `s(varlist)'
	local numvars = wordcount("`varnem'")
	local typ `s(typlist)'


/**Set labels**/
	local nreg 1
	foreach var of local varnem {
		local xblab: word `nreg' of `equation'
		qui gen `typ' `var' = .
		if ("`whichopts'"=="xb" & "`dynamic'"=="") {
			label var `var' `"`whichopts' prediction"'
			if (`numvars'>1) {
				label var `var' `"`whichopts' prediction, `xblab'"'
			}
		}	
		else if ("`whichopts'"=="xb" & "`dynamic'"!="") {
			label var `var' `"`whichopts' prediction, `dynamic'"'	
			if (`numvars'>1) {
				label var `var' `"`whichopts' prediction, `xblab', `dynamic'"'
			}
		}
		else if ("`whichopts'"=="xb") {
			label var `var' `"`whichopts' prediction"'
			if (`numvars'>1) {
				label var `var' `"`whichopts' prediction, `xblab'"'
			}
		}
		else if ("`whichopts'"=="stdp") {
			label var `var' "S.E. of the prediction"
		}
		else if ("`whichopts'"=="residuals") {
			label var `var' `"`whichopts'"'
			if (`numvars'>1) {
				label var `var' `"`whichopts', `xblab'"'
			}
		}
		local nreg = `nreg'+1
	}


/**RMSE option related**/
	if ("`rmse'"!="") {
		cap noi _stubstar2names `rmse', nvars(`numvars')
		local rc = _rc
		if (`rc'==102 | `rc'==103) {
			local nr : word count `rmse'
			di as err "{p 0 8 2}specification {bf:rmse(`rmse')}" ///
				" requires `numvars' "			     ///
				`"`= plural(`numvars',"name","names")', "'   ///
				"or use the {bf:{it:stub*}} notation{p_end}"
			exit `rc'
		}
		else if (`rc') exit `rc'

		local rmselist 	`"`s(varlist)'"'
		local rtyplist	`"`s(typlist)'"'
		local alllist `"`varnem' `rmselist'"'
		local kall: word count `alllist'
		local alllist : list uniq alllist
		if (`:word count `alllist'' != `kall') {
			di as err "{p}duplicate names exist in the "	     ///
				"{bf:varlist} and the {bf:rmse()} option{p_end}"
			exit 189
		}
		foreach var of local rmselist {
			local nreg 1
			qui gen `rtyplist' `var' = .
			if ("`whichopts'"=="xb") {
				label var `var' `"`whichopts' RMSE"'
				if (`numvars'>1) {
					label var `var' `"`whichopts' RMSE, Region`nreg'"'
				}
			}	
			else if ("`whichopts'"=="residuals") {
				label var `var' `"`whichopts'"'
				if (`numvars'>1) {
					label var `var' `"`whichopts', Region`nreg'"'
				}
			}
			local nreg = `nreg'+1
		}
	}


	marksample touse
	_ts tvar panvar if `touse', sort onepanel
	local tsdeps = 0
	local nsvars `e(indepvars)'
	local swvars `e(regionvars)'

	if ("`dynamic'"!="") {
		local touse_thvar
		_ms_parse_parts `threshvar'
		if "`r(type)'" == "variable" {
			local iy : list posof "`r(name)'" in depvar
			if `iy' & "`r(ts_op)'"!="" {
				local predvar `r(ts_op)'.`varnem'
				local touse_thvar `predvar'
			}
			else local touse_thvar `threshvar'
		}
		local touse_nsvars
		local touse_swvars
		foreach var of local nsvars {
			_ms_parse_parts `var'
			if "`r(type)'" == "variable" {
				local iy : list posof "`r(name)'" in depvar
				if `iy' & "`r(ts_op)'"!="" {
					local marktsvar `marktsvar' `var'
					local predvar `r(ts_op)'.`varnem'
					local touse_nsvars `touse_nsvars' `predvar'
				}
				else local touse_nsvars `touse_nsvars' `var'
			}
			local markindvars `markindvars' `var'
		}
		foreach var of local swvars {
			_ms_parse_parts `var'
			if "`r(type)'" == "variable" {
				local iy : list posof "`r(name)'" in depvar
				if `iy' & "`r(ts_op)'"!="" {
					local marktsvar `marktsvar' `var'
					local predvar `r(ts_op)'.`varnem'
					local touse_swvars `touse_swvars' `predvar'
				}
				else local touse_swvars `touse_swvars' `var'
			}
			local markindvars `markindvars' `var'
		}
		if ("`markindvars'"!="") markout `touse' `markindvars'
		Check_dynamic `tvar', touse(`touse') `dynamic' ///
				markindvars(`markindvars') myvars(`varnem')
		local tdynamic = r(value)
		local idynamic = r(index)
		local dyn_colnames `touse_nsvars' `touse_swvars'
		forvalues i = 1/`nthresholds' {
			local dyn_colnames `dyn_colnames' `touse_swvars'
		}
	}
	else {
		markout `touse' `e(depvar)'
		local tdynamic = .
		local idynamic = .
	}
	qui count if `touse'
	if (r(N)==0) error 2000
	local usevars	.
	local tousevars	.
	markout `touse' `depvar' `nsvars' `swvars'
        _check_ts_gaps `tvar', touse(`touse')

	if ("`in'"!="") {
		local touse_in `touse'
		local tsin `in'
		local 0 `depvar' `nsvars' `swvars'
		syntax varlist(ts)
		marksample touse
	}
	local cons = "`e(cons1)'"
	local nscons = "`e(nscons1)'"
	local dots
	local nodots
	mata: threshold_predict("`depvar'", "`nsvars'", "`swvars'",	    ///
		"`threshvar'", "", "`touse'", "`cons'", "`nscons'", ., .,   ///
		., ., ., ., `nthresholds', ., ., "`whichopts'", 	    ///
		"`usevars'", "`tousevars'", "`varnem'", "`dyn_colnames'",   ///
		"`touse_nsvars'", "`touse_swvars'", "`touse_thvar'",	    ///
		"`rmselist'", `tdynamic', `idynamic')


	if ("`tsin'"!="") {
		replace `varnem' = . if (`touse_in'==0)
	}
	tempname mval obs
	qui des
	scalar `obs' = r(N)
	qui count if `touse'
	scalar `mval' = r(N)
/*
	if (`obs'-`mval'==1) {
		di as txt "(" `obs'-`mval' " missing value generated)"
	}
	else di as txt "(" `obs'-`mval' " missing values generated)"
*/
end


program CheckEQ
	syntax anything(name=elist id="equation"), eq(string)
	       
	local neq = wordcount("`eq'")
	foreach ei of local elist {
		local i : list posof "`ei'" in eq
		if `i' == 0 {
			di as err "{p}equation {bf:`ei'} is not in the model; "
			if `:word count `eq'' == 1 {
				di as err "only available equation name "  ///
					 "is {bf:`eq'}{p_end}"
			 }
			else {
				di as err "available equation names are "  ///
					 "{bf:`eq'}{p_end}"
			 }
			exit 322
		}
		local ind `ind' `i'
	}

end


program Check_dynamic, rclass
	syntax varname, touse(varname) dynamic(string) [ markindvars(string) ///
							myvars(string) ]

	local tvar `varlist'
	/* depvars with TS operators                                    */
	local depvar `e(depvar)'

	summarize `tvar' if `touse', meanonly
	if `dynamic'<r(min) | `dynamic'>r(max)+1 {
		local fmt : format `tvar'
		di as err "{p}{bf:dynamic(`dynamic')} is invalid; " ///
			 "dynamic() must be in [" `fmt' r(min) ", " `fmt'   ///
			  r(max)+1 "]{p_end}"
		drop `myvars'
		exit 459
	}

        tempvar dy
	/* with delta > 1 dynamic may not be equal to any of the        */
	/*  elements in tvar                                            */
	cap gen byte `dy' = (`tvar'<`dynamic')

	if _rc {
		di as err "{bf:dynamic(`dynamic')} is invalid"
		exit 198
	}
        qui count if `dy'
	local index = r(N) + 1	
	//Indexing the beginning of dynamic predictions in the sample
	local value = `index'

	qui replace `touse' = (`touse'&(`depvar'<.)) if `dy'

	/**Do not allow out-of-sample dynamic predictions if there are
	   exogenous variables**/
        if "`markindvars'" != "" {
		foreach var of local markindvars {
			_ms_parse_parts `var'
			if ("`r(name)'"!="`depvar'") {
				qui count if `touse' & `tvar'>=`dynamic'
				if r(N) == 0 {
di as err "{p}there are no valid observations beyond "  ///
`"{bf:dynamic(`dynamic')}; check for missing values in your variables{p_end}"' 
drop `myvars'
exit 459
				}
			}
		}
	}

        /* index of dynamic after dropping all missings */
        qui count if `touse' & `dy'
	//Indexing the beginning of dynamic predictions in the touse sample
	local index = r(N)+1			
	if (`index'<=0) local index = 1
	return local index = `index'
	return local value = `value'
end


local SS	string scalar
local RS	real scalar
local RMAT	real matrix
local CL	class _threshold_p scalar

mata:

void threshold_predict(`SS' depvar, nsvars, swvars, threshvar, genvars, touse, 
			cons,
			nscons, criteria, vcetype, repartition, nodots, dots,
			`RS' frac, nthreshold, maxthreshold, 
			`RMAT' threshmat,
			`SS' whichopts, usevars, tousevars, varnem, equation, 
				touse_ns, touse_sw, touse_thvar, rmselist,
			`RS' tdynamic, idynamic)

{
	`CL' TrPredobj

	TrPredobj._setuptreg(depvar, nsvars, swvars, threshvar, genvars, touse, 
			cons, nscons, criteria, vcetype, repartition, nodots, 
			dots, frac, nthreshold, maxthreshold, threshmat)
	TrPredobj.predict_setup(whichopts, usevars, tousevars, varnem, equation,
			touse_ns, touse_sw, touse_thvar, rmselist, tdynamic, 
			idynamic)
}

end

