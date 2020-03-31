*! version 1.0.0  24mar2017
* replicate code from -ivregress.CheckVars- and used by -ivtobit- -ivfprobit-

program ivrmcollin, sclass
	version 14.1

	_on_colon_parse `0'
	local ivprog `s(before)'
	local 0 `s(after)'
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	syntax varlist(ts min=1 max=1), touse(varname)        ///
		envars(varlist fv ts) [ ivvars(varlist fv ts) ///
		exvars(varlist fv ts) PERfect NOCONSTANT      ///
		wgts(string) normwt(varname) ]

	local depvar `varlist'
        local fvops = "`s(fvops)'" == "true" | _caller() >= 11
        local tsops = "`s(tsops)'" == "true" 

        if `fvops' {
                if _caller() < 11 {
                        local vv "version 11:"
                }
		local expand "expand"
		fvexpand `exvars' if `touse'
		local exvars  "`r(varlist)'"
		fvexpand `ivvars' if `touse'
		local ivvars  "`r(varlist)'"
		fvexpand `envars' if `touse'
		local envars "`r(varlist)'"
	}
	if "`wgts'" != "" {
		gettoken wtype wvar : wgts
		if "`wvar'" == "" {
			local wvar "`wgts'"
			local wtype fweight
		}
		if "`normwt'" == "" {
			/* normalized weights for _rmcoll2list		*/
			tempvar normwt 
			qui gen double `normwt' = `wvar' if `touse'
			if "`wtype'" == "aweight" | "`wtype'" == "pweight" {
				summ `normwt' if `touse', mean
				di as text "(sum of wgt is " %12.4e r(sum) ")"
				qui replace `normwt' = r(N)*`normwt'/r(sum) ///
					if `touse'
				markout `touse' `normwt'
			}
		}
	}
	else if "`normwt'" == "" {
		tempvar normwt 
		qui gen double `normwt' = 1 if `touse'
	}

	/* catch specification errors 					*/	
	local both : list exvars & envars
	foreach x of local both {
		di as err "`x' included in both exogenous and endogenous " ///
		 "variable lists"
		exit 498
	}
	
	if "`perfect'" == "" {
		local both : list envars & ivvars
		foreach x of local both {
			di as err "`x' included in both endogenous and " ///
			 "excluded exogenous variable lists"
			exit 498
		}
	}
	
	local both : list depvar & envars
	if "`both'" != "" {
		di as err "`both' specified as both regressand and " ///
		 "endogenous regressor"
		exit 498
	}
	local both : list depvar & exvars
	if "`both'" != "" {
		di as err "`both' specified as both regressand and " ///
		 "exogenous regressor"
		exit 498
	}

	local both : list depvar & ivvars
	if "`both'" != "" {
		di as err "`both' specified as both regressand and " ///
		 "excluded exogenous variable"
		exit 498
	}
	/* collinearities 						*/
	/* [envars exvars] must be full rank				*/
	`vv' ///
	_rmdcoll `depvar' `envars' `exvars' `wgt' if `touse', `noconstant' ///
		`expand'
	local vlist  `r(varlist)'
	local kendrop = 0
	local omitted = 0
	if "`r(k_omitted)'" != "" {
		local omitted = `r(k_omitted)'
	}
	if !`omitted' {
		local envars : list envars & vlist
		local exvars  : list exvars & vlist
	}
	else {
		foreach var of local vlist {
			_ms_parse_parts `var'

			if "`r(type)'" != "variable" {
				local inen : list var in envars
			}
			else {
				local name `r(name)'
				if "`r(ts_op)'" != "" {
					local name `r(ts_op)'.`name'
				}
				local inen : list name in envars
			}
			if (`inen') {
				local kendrop = `kendrop' + r(omit)
				local enkeep `enkeep' `var'
			}
			else {
				local exkeep `exkeep' `var'
			}
		}
		local envars `enkeep'
		local exvars `exkeep'
	}
	/* [exvars ivvars] must be full rank				*/
	`vv' ///
	_rmcoll `ivvars', `noconstant' `expand'
	local ivvars `r(varlist)'
	if "`ivvars'" != "" & "`envars'`exvars'" != "" {
		if "`noconstant'"  == "" {
			tempvar tmpcons
			qui gen double `tmpcons' = 1 if `touse'
		}
		else {
			local tmpcons
		}
		if "`perfect'" == "" {
			/* -_rmcoll2list- will drop variables not omit	*/
			`vv' ///
			_rmcoll2list, alist(`envars' `exvars' `tmpcons') ///
				blist(`ivvars') normwt(`normwt') touse(`touse')
			local ivvars `r(blist)'
		}
		else if "`exvars'" != "" {
			/* allowing perfect instruments			*/
			`vv' ///
			_rmcoll2list, alist(`exvars' `tmpcons') ///
				blist(`ivvars') normwt(`normwt') touse(`touse')
			local ivvars `r(blist)'
		}
	}
	if `kendrop' {
		di as err "may not drop an endogenous regressor"
		exit 498
	}
	local ken : list sizeof envars
	local kiv : list sizeof ivvars
	if `ken' > `kiv' {
		di as err "equation not identified"
		di as txt "{phang}There must be at least as many " ///
		 "instruments not in the regression as there are "  ///
		 "instrumented variables.{p_end}"
		 exit 481
	}
	sreturn local envars `envars'
	sreturn local exvars `exvars'
	sreturn local ivvars `ivvars'
	sreturn local depvar `depvar'
	sreturn local fvops `fvops'
	sreturn local tsops `tsops'
end

exit

