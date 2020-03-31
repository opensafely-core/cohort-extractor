*! version 1.0.5  22feb2016

program _sspace_p, rclass sortpreserve
	version 11

	syntax anything(name=vlist id="varlist") [if] [in],  [, xb STates ///
		Residuals RSTAndard EQuation(string) rmse(string) 	  ///
		SMETHod(string) DYNamic(passthru) ]

	local which `xb' `states' `residuals' `rstandard'
	if "`which'" == "" {
		if `"`filter'`smooth'`dynamic'"' == "" {
			di as txt "(option xb assumed; fitted values)"
		}
		local which xb
	}
	if `:word count "`which'"' != 1 {
		di as err "{p}only one of {bf:xb states}, {bf:residuals}, " ///
		 "or {bf:rstandard} allowed{p_end}"
		exit 184
	}

	if "`which'" == "states" {
		local neq0 = `e(k_state)'
		local eqlist `e(state_deps)'
	}
	else {
		local neq0 = `e(k_obser)'
		local eqlist `e(obser_deps)'
	}
	if `"`equation'"' != "" {
		CheckEQ `equation', eq(`eqlist')
		local vindex `s(vindex)'
		local neq = `s(n)'

		_stubstar2names `vlist', nvars(`neq') 
	}
	else {
		cap _stubstar2names `vlist', nvars(`neq0')
		if c(rc) {
			_stubstar2names `vlist', nvars(1)
			/* default to first equation			*/
			local neq = 1
			local vindex = 1
		}
		else {
			local neq = `neq0'
			numlist "1/`neq'"
			local vindex `r(numlist)'
		}
	}
	local varlist `"`s(varlist)'"'
	local typlist `"`s(typlist)'"'

	ParseSmethod, `smethod'	
	local how `s(method)'

	if "`which'"=="rstandard" && "`how'"!="onestep" {
		di as err "{p}options {bf:smethod(`how')} and " ///
		 "{bf:rstandard} may not be combined{p_end}"
		exit 184
	}
	if "`which'"=="rstandard" && "`rmse'"!="" {
		di as err "{p}options {bf:rmse()} and {bf:rstandard} " ///
		 "may not be combined{p_end}"
		exit 184
	}
	if "`how'"=="filter" & "`which'"!="states" {
		di as err "{p}options {bf:`which'} and " ///
		 "{bf:smethod(filter)} may not be combined{p_end}"
		exit 184
	}

	if "`rmse'" != "" {
		cap noi _stubstar2names `rmse', nvars(`neq') 
		local rc = _rc
		if `rc'==102 | `rc'==103 {
			local nr : word count `rmse'
			di as err "{p}specification {bf:rmse(`rmse')} "    ///
			 "requires `neq' " 				   ///
			 `"`=plural(`neq',"name","names")', or use the "' ///
			 "{bf:{it:stub*}} notation{p_end}"
			exit `rc'
		}
		else if (`rc') exit `rc'

		local rmselist `"`s(varlist)'"'
		local rtyplist `"`s(typlist)'"'

		local alllist `"`varlist' `rmselist'"'
		local kall : word count `alllist'
		local alllist : list uniq alllist
		if `:word count `alllist'' != `kall' {
			di as err "{p}duplicate names exist in the " ///
			 "{bf:varlist} and the {bf:rmse()} option{p_end}"

			exit 198
		}
	}
	marksample touse, novarlist
	_ts tvar panvar if `touse', sort onepanel

	/* independent vars with TS operators				*/
	local indeps `e(covariates)'
	if ("`indeps'"=="_NONE") local indeps

	local cons _cons
	local indeps : list indeps - cons
	/* names of dependent vars (without TS operators)		*/
	local depvar `e(depvar)'
	local tsdeps = 0

	if "`dynamic'" != "" {
		if "`which'"!="xb" & "`which'"!="states" {
			di as err "{p}options {bf:`which'} and " ///
			 "{bf:dynamic()} may not be combined{p_end}"
			exit 184
		}
		if "`how'" != "onestep" {
			di as err "{p}options {bf:smethod(`how')} and " ///
			 "{bf:dynamic()} may not be combined{p_end}"
			exit 184
		}
		foreach var of local indeps {
			_ms_parse_parts `var'

			if "`r(type)'" == "variable" {
				local iy : list posof "`r(name)'" in depvar
				if `iy' & "`r(ts_op)'"!="" {
					local `++tsdeps'
					local marktsvar `marktsvar' `var'
					continue
				}
			}
			local markindvars `markindvars' `var'
		}
		if ("`markindvars'"!="") markout `touse' `markindvars'
	}
	else markout `touse' `indeps'

	qui count if `touse'
	if (r(N)==0) error 2000
	
	if "`dynamic'" != "" {
		Check_dynamic `tvar', touse(`touse') `dynamic' ///
			marktsvar(`marktsvar')
		local tdynamic = r(value)
		local idynamic = r(index)
	}
	else {
		markout `touse' `e(obser_deps)'
		local tdynamic = .
		local idynamic = .
	}

	_check_ts_gaps `tvar', touse(`touse')

	local indeps `e(covariates)'
	if ("`indeps'"=="_NONE") local indeps

	forvalues i=1/`neq0' {
		tempvar var
		
		qui gen double `var' = .
		local tvlist `tvlist' `var'

		if "`rmse'" != "" {
			tempvar rvar
		
			qui gen double `rvar' = .
			local rvlist `rvlist' `rvar'
		}
	}
	local ntsop = 0
	if `idynamic' < . {
		/* second independent variable list where we substitute	*/
		/*  predicted vars for lagged and differenced dependent	*/
		/*  vars						*/

		/* state equations do not include lagged dependent 	*/
		/*  vars, but they must exist since we do not 		*/
		/*  differentiate between the covariates that	 	*/
		/*  belong to the state and observation	equations 	*/

		foreach var of local indeps {
			if "`var'" == "_cons" {
				tempvar cons
				qui gen int `cons' = 1
				local ivlist `ivlist' `cons'

				continue
			}
			if `tsdeps' {
				FixupTSvar `var', depvar(`depvar') ///
					tvlist(`tvlist') dvTS(`e(obser_deps)')

				if "`s(tsvar)'" != "" {
					local ivlist `ivlist' `s(tsvar)'
					local `++ntsop'
					continue
				}
			}
			local ivlist `ivlist' `var'
		}
	}

	local wopt ("`which'","`how'")
	local opt (`idynamic',`tdynamic')

	mata: _sspace_predict_entry(`wopt', "`tvlist'", "`touse'", ///
		"`ivlist'", `opt', "`rvlist'")

	local k = 0
	local ty : word 1 of `typlist'
	local rty : word 1 of `rtyplist'
	tempvar mis

	foreach i of local vindex {
		local vi : word `++k' of `varlist'
		local tvi : word `i' of `tvlist'
		local eq : word `i' of `eqlist'
		qui gen `ty' `vi' =  `tvi' if `touse'

		if ("`which'"=="xb") local pred "xb prediction"
		else local pred `which'

		if ("`dynamic'"=="") local more "`eq', `how'"
		else {
			qui gen byte `mis' = 0
			qui replace `mis' = (`vi'>=.) if `tvar'>=`tdynamic' ///
				& `touse'
			qui count if `mis'
			if `r(N)' > 0 {
				di as err "{p}dynamic forecast generated " ///
				 "`=r(N)' missings for variable `vi'" _c
				if `ntsop'>0 {
					 di as err "; make sure there are " ///
					 "enough observations for the "     ///
					 "time-series operators"
				}
				di as err "{p_end}"

				exit 459
			}
			qui drop `mis'
			local more "`eq', `dynamic'"
		}
		label variable `vi' `"`pred', `more'"'
		local vlist1 `vlist1' `vi'

		if "`rmse'" != "" {
			local vi : word `k' of `rmselist'
			local tvi : word `i' of `rvlist'
			local eq : word `i' of `eqlist'
			qui gen `rty' `vi' =  `tvi'
			label variable `vi' `"`which' RMSE, `more'"'

			local rvlist1 `rvlist1' `vi'
		}
	}
	return local vlist `"`vlist1'"'
	return local rvlist `"`rvlist1'"'
end

program FixupTSvar, sclass
	syntax varname(ts fv), depvar(varlist) tvlist(varlist) dvTS(string)

	sreturn clear
	_ms_parse_parts `varlist'

	if ("`r(type)'"!="variable") exit

	local iy : list posof "`r(name)'" in depvar

	if (!`iy') exit

	local tsop `r(ts_op)'

	/* check of TS op on corresponding depvar			*/
	local tsdep : word `iy' of `dvTS'
	_ms_parse_parts `tsdep'
	local opd `r(ts_op)'
	local tsok = ("`opd'"=="")
	if "`tsop'" != "" {
		local tdep : word `iy' of `tvlist'

		if !`tsok' {
			local tsok = strpos("`tsop'","`opd'")

			if (`tsok') local tsop = subinstr("`tsop'","`opd'","",1)
		}

		if ("`tsop'"!="") sreturn local tsvar `tsop'.`tdep'
	}
	if !`tsok' {
		di as err "{p}dynamic forecasting is not allowed; "     ///
		 "{bf:`varlist'} on the right-hand-side of one of the " ///
		 "observation equations requires the {bf:`opd'} "       ///
		 "time-series operator to match dependent variable "    ///
		 "{bf:`tsdep'}{p_end}"
		exit 322
	}
end

program CheckEQ, sclass
	syntax anything(name=elist id="equation"), eq(string)

	local neq : word count "`eq'"

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
	sreturn local n `:word count `ind''
	sreturn local vindex `ind'
end

program Check_dynamic, rclass
	syntax varname, touse(varname) dynamic(string) [ marktsvar(string) ]

	local tvar `varlist'
	/* depvars with TS operators					*/
	local depvars `e(obser_deps)'

	summarize `tvar' if `touse', meanonly
	if `dynamic'<r(min) | `dynamic'>r(max)+1 {
		local fmt : format `tvar'
		di as err "{p}{bf:dynamic(`dynamic')} is invalid; " ///
		 "dynamic() must be in [" `fmt' r(min) ", " `fmt'   ///
		 r(max)+1 "]{p_end}"
		exit 459
	}
	tempvar dy
	/* with delta > 1 dynamic may not be equal to any of the 	*/
	/*  elements in tvar						*/
	cap gen byte `dy' = (`tvar'<`dynamic') 
	if _rc {
		di as err "{bf:dynamic(`dynamic')} is invalid"
		exit 198
	}
	qui count if `dy'
	local index = r(N) + 1
	local value = `tvar'[`index']

	foreach var of varlist `depvars' {
		qui replace `touse' = (`touse'&(`var'<.)) if `dy' 
	}
	if "`marktsvar'" != "" {
		/* markout for indepvars like LD.depvar			*/
		foreach var of local marktsvar {
			qui replace `touse' = (`touse'&(`var'<.)) if `dy'
		}
	}
	qui count if `touse' & `tvar'>=`dynamic'
	if r(N) == 0 {
		di as err "{p}there are no valid observations beyond "  ///
		 `"{bf:dynamic(`dynamic')}; check for missing values "' ///
		 "in your variables{p_end}"
		exit 459
	}
	/* index of dynamic after dropping all missings			*/
	qui count if `touse' & `dy'
	local index = r(N)+1

	if (`index'<=0) local index = 1

	return local index = `index'
	return local value = `value'
end

program ParseSmethod, sclass
	syntax, [ ONEstep FIlter SMooth * ]

	local method `onestep' `filter' `smooth'
	local n : word count `method'
	if "`options'"!="" | `n'>1 {
		local method `method' `options'
		local method : list retokenize method
		di as err "{p}smethod(`method') is not allowed; use "   ///
		 "{bf:onestep}, {bf:filter}, or {bf:smooth} in option " ///
		 "{bf:smethod()}{p_end}"
		exit 198
	}
	sreturn clear
	if (`n'==0) local method onestep

	sreturn local method `method'
end

exit
