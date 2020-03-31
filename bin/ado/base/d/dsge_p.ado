*! version 1.1.1  18oct2018
program define dsge_p

	version 15
	_dsge_p `0'

end

program define _dsge_p

	syntax anything(name=vlist id="varlist") [if] [in],  ///
		[xb STates SMETHod(string)                   ///
		RMSE(string) DYNamic(string) noDEMEAN] 

	if ("`e(cmd)'" != "dsge" &  ///
	("`e(cmd)'" != "dsgenl" & "`e(solvetype)'" != "firstorder")) error 301
	
	marksample touse, novarlist
	_ts tvar
	local observed = e(observed)
        qui count if `touse'
        if (r(N)==0) error 2000
	_check_ts_gaps `tvar', touse(`touse')

	local statistic `xb' `states'
	if ("`statistic'"=="") {
		local statistic xb
	}
        if `:word count `statistic'' != 1 {
                di as err "{p}only one of {bf:xb states} allowed{p_end}"
                exit 184
        }
	
	if (`"`xb'`states'`filter'`smooth'`dynamic'"' == "") {
		di as txt "(option {bf:xb} assumed; fitted values)"
	}

	ParseSmethod, `smethod'
	local method `s(method)'
	
	
	// which statistic
	local wflag = 0
	if (     "`statistic'"=="xb"   & "`method'"=="onestep") local wflag = 1
	else if ("`statistic'"=="xb"   & "`method'"=="filter") {
		disp as err "options {bf:xb} and {bf:smethod(filter)} " ///
		"may not be combined"
		exit 184
	}
	else if ("`statistic'"=="states" & "`method'"=="onestep") local wflag = 3
	else if ("`statistic'"=="states" & "`method'"=="filter")  local wflag = 4


	// new varnames 
	local eq0: word count `vlist'
	cap _stubstar2names `vlist', nvars(`eq0')
	if c(rc) {
		newVars `vlist'
		local neq = r(neq)
		_stubstar2names `vlist', nvars(`neq')
	}
	if (s(stub)=="1") {  
		if("`statistic'" == "states") {
			 _stubstar2names `vlist', nvars(`e(k_state)')
		}
		else if ("`statistic'"=="xb") {
			 _stubstar2names `vlist', nvars(`e(k_observed)')
		}
	}
	local predlist = s(varlist)
	local ptyplist = s(typlist)
	local predno   = `:word count `predlist''

	// error trapping # of newvars
	if      ("`statistic'"=="xb")     local compno = `e(k_observed)'
	else if ("`statistic'"=="states") local compno = `e(k_state)'
	else local compno=0
	qui  cap assert `:word count `predlist'' <= `compno'
	if (_rc !=0) {
		disp as err "too many variables specified"
		exit 103
	}

	
	// handle rmse
	if "`rmse'" != "" {
		cap _stubstar2names `rmse', nvars(`predno') 
		local rc = _rc
		if `rc'==102 | `rc'==103 {
			local nr : word count `rmse'
			di as err "{p}specification {bf:rmse(`rmse')} "     ///
			"requires `predno' "                                ///
			`"`=plural(`predno',"name","names")', or use the "' ///
			"{bf:{it:stub*}} notation{p_end}"
			exit `rc'
		}
		else if (`rc') exit `rc'

		local rmselist `"`s(varlist)'"'
		local rtyplist `"`s(typlist)'"'

		local alllist `"`predlist' `rmselist'"'
		local kall :    word count `alllist'
		local alllist : list uniq   alllist
		if `:word count `alllist'' != `kall' {
			di as err "{p}duplicate names exist in the " ///
			"{bf:varlist} and the {bf:rmse()} option{p_end}"

			exit 198
		}
	}

	// dynamic
	if ("`dynamic'" == "") markout `touse' `observed' 
	if ("`dynamic'" != "") {
	summarize `tvar' if `touse', meanonly
        if `dynamic'<r(min) | `dynamic'>r(max)+1 {
                local fmt : format `tvar'
                di as err "{p}{bf:dynamic(`dynamic')} is invalid; " ///
                 "dynamic() must be in [" `fmt' r(min) ", " `fmt'   ///
                 r(max) "]{p_end}"
                exit 459
        }
	}


	if("`dynamic'" != "") {
		tempvar dy
		cap gen byte `dy' = (`tvar' < `dynamic')
		qui count if `dy'
		local dindex = r(N)+1
		local dynstart=`dindex'
	}
	else local dynstart=.

	// mean adjustment
	local meanflag 0
	if ("`demean'" == "") local meanflag 1


	// mata entry point
	mata: _dsge_p_main("`predlist'", "`ptyplist'", ///
	        "`rmselist'", "`rtyplist'",            ///
		`wflag',"`touse'", `dynstart', `meanflag')


	tempname all
	if(`wflag'==1 | `wflag'==2)       local all = e(observed)
	else if (`wflag'==3 | `wflag'==4) local all = e(state)
	gettoken first rest: all
	foreach var in `predlist' {
		lab var `var' "xb `states' prediction, `first', `method'"
		gettoken first rest: rest
	}

	if("`rmse'" != "") {
		tempname rmseall
		if(`wflag'==1 | `wflag'==2)       local rmseall = e(observed)
		else if (`wflag'==3 | `wflag'==4) local rmseall = e(state)
		gettoken first rest: rmseall
		foreach var in `rmselist' {
			lab var `var' "`statistic' RMSE, `first'"
			gettoken first rest: rest
		}
	}

end


program newVars, rclass
	syntax newvarlist
	return local varlist `varlist'
	return local typlist `typlist'
	local neq : word count `varlist'
	return local neq `neq'

end

program ParseSmethod, sclass
        syntax, [ ONEstep FIlter * ]

        local method `onestep' `filter'
        local n : word count `method'
        if "`options'"!="" | `n'>1 {
                local method `method' `options'
                local method : list retokenize method
                di as err "{p}smethod(`method') is not allowed; use "   ///
                 "{bf:onestep} or {bf:filter} in option " ///
                 "{bf:smethod()}{p_end}"
                exit 198
        }
        sreturn clear
        if (`n'==0) local method onestep

        sreturn local method `method'
end
