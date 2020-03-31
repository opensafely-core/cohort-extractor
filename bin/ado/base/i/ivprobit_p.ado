*! version 2.1.3  21oct2019

program define ivprobit_p
	local vcaller = string(_caller())
	version 8

	syntax [anything] [if] [in] [, xb stdp SCores * ]

	/* version 14 has the original evaluator, uses ADO -ml- 
 	 * version 14.1 has an updated evaluator uses Mata moptimize
 	 * version 16+ uses free parameter stripe syntax		*/
	local version = cond(missing(e(version)),14,e(version))
	if `"`scores'"' != "" {
		if `"`e(method)'"' == "twostep" {
			di as err ///
			"option {bf:scores} is not allowed with the two-step method"
			exit 322
		}
		if `version' < 14.1 {
			global IV_NEND `e(endog_ct)'
			ml score `0'
			macro drop IV_*
			exit
		} 
		local kscores = e(k_eq)
		_stubstar2names `anything', nvars(`kscores')
		local scores `s(varlist)'
		local stype : word 1 of `s(typlist)'

		forvalues i=1/`kscores' {
			tempvar s`i'
			qui gen double `s`i'' = .
			local slist `slist' `s`i''
		}
		tempvar touse
		tempname b 

		marksample touse
		local depvar : word 1 of `e(depvar)'
		local kendog = `e(endog_ct)'
		mat `b' = e(b)
		mata: ivfprobit_mopt("`b'","`depvar'",`kendog',"`touse'", ///
			"","","","","","","nolog","",1,0,"`slist'")

		local eqs : coleq `b'
		local eqs : list uniq eqs

		forvalues i=1/`kscores' {
			local si : word `i' of `scores'
			local eq : word `i' of `eqs'
			gen `stype' `si' = `s`i'' if `touse'
			label variable `si' "Scores for equation `eq'"
		}
		exit
	}
	if "`xb'`stdp'" != "" {
		_pred_se "" `0'
		if `s(done)' {
			exit
		}
	}
	_stubstar2names `anything', nvars(1)
	local vtyp `s(typlist)'
	local varn `s(varlist)'
	local 0 `if' `in' , `options'
	local myopts Pr ASIF RULEs XB 
	local myopts `myopts' STRuctural total		    /* undocumented */
	local myopts `myopts' INTPoints(string) fix(string) /* undocumented */
	local myopts `myopts' base(string) TARGet(string)   /* undocumented */

		/* Step 3:
			Parse your syntax.
		*/

	syntax [if] [in] [, `myopts' ]
	
		/* Step 4 not needed here */

		/* Step 5:
			quickly process default case if you can 
		*/
	if "`e(method)'" == "twostep"  & "`pr'`asif'`rules'`intpoints'" != "" {
		di as err "probabilities not available with two-step estimator"
		exit 198
	}
	if ("`pr'`asif'`rules'`xb'`intpoints'"=="") | ///
		("`e(method)'" == "twostep" & "`xb'" == "") {
		di as text "(option {bf:xb} assumed; fitted values)"
		local xb "xb"
	}
	if `vcaller' < 15 & "`structural'" != "" {
		di as error "{p 0 4 2}option {bf:structural} not available "
		di as error "with version `vcaller'{p_end}"
		exit 198			
	}
	if `vcaller' < 15 & "`intpoints'" != "" {
		di as error "{p 0 4 2}option {bf:intpoints()} not available "
		di as error "with version `vcaller'{p_end}"	
		exit 198
	}
	if `vcaller' < 15 & "`fix'" != "" {
		di as error "option {bf:fix()} not allowed under version `vcaller'"
		exit 198
	}
	if "`total'" != "" & "`structural'" != "" {
		opts_exclusive "total structural"
	}
	if "`total'" != "" & "`intpoints'" != "" {
		opts_exclusive "total intpoints()"
	}

	if "`xb'" != "" & "`structural'" != "" {
		opts_exclusive "structural xb"
	}
	if "`xb'" != "" & "`total'" != "" {
		opts_exclusive "xb total"
	}
	if "`xb'" != "" & "`intpoints'" != "" {
		opts_exclusive "xb intpoints()"
	}
	if "`xb'" != "" & "`rules'" != "" {
		opts_exclusive "xb rules"
	}
	if "`xb'" != "" & "`asif'" != "" {
		opts_exclusive "xb asif"
	}
	if "`xb'" != "" & "`fix'" != "" {
		opts_exclusive "xb fix()"
	}
	if "`xb'" != "" & "`base'" != "" {
		opts_exclusive "xb base()"
	}
	if "`xb'" != "" & "`target'" != "" {
		opts_exclusive "xb target()"
	}
	if "`xb'" != "" {
		_predict `vtyp' `varn' `if' `in' 
		label var `varn' "Fitted values"
		exit
	}

	if "`rules'" != "" & "`structural'" != "" {
		opts_exclusive "rules structural"
	}
	if "`rules'" != "" & "`intpoints'" != "" {
		opts_exclusive "rules intpoints()"
	}
	

		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse



		/* Step 8:
			handle switch options that can be used in-sample or 
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

				/* Get the model index (Xb), 
				 * required for all remaining options */
	
	if `: word count `asif' `rules'' > 1 {
		 di as error "options {bf:rules} and " ///
		  "{bf:asif} may not be specified together"
		exit 198
	}
	if "`intpoints'" != "" {
		capture confirm integer number `intpoints'
		local rc = _rc
		capture assert `intpoints' > 1 & `intpoints' < 129
		local rc = `rc' | _rc
		if (`rc') {
			di as error "option {bf:intpoints()} must be " ///
				"an integer greater than 1"  ///
				" and less than 129"
			exit 198 
		}	
	}				 
	tempvar Xb
	// go through fixed values
	ParseUbase, u(`target') target
	local nvt = `r(nvars)'
	forvalues i = 1/`nvt' {
		local tdv`i' `r(var`i')'
		tempvar ot`i'
		local stotype: type `tdv`i''
		qui gen `stotype' `ot`i'' = `tdv`i'' if `touse'
	}
	forvalues i = 1/`nvt' {
		tempvar tidv`i'
		capture qui gen double `tidv`i'' = `r(expr`i')' if `touse'
		if _rc {
			di as error "option {bf:target()} invalid; "
			qui gen double `tidv`i'' = `r(expr`i')' if `touse'
		}
		qui replace `tdv`i'' = `tidv`i'' if `touse'
	}
	qui _predict double `Xb' if `touse' ,xb
	forvalues i = 1/`nvt' {
		qui replace `tdv`i'' = `ot`i'' if `touse'
	}
	if "`base'" != "" {
		ParseUbase, u(`base') base
		local nvu = `r(nvars)'
		forvalues i = 1/`nvu' {
			local udv`i' `r(var`i')'
			tempvar ou`i'
			local stotype: type `udv`i''
			qui gen `stotype' `ou`i'' = `udv`i'' ///
				 if `touse'
		}	
	}
	local nb break
	if "`base'" != "" {
		local nb nobreak
	}
capture noi `nb' {
	if "`base'" != "" {
		forvalues i = 1/`nvu' {
			tempvar ub`i'
			capture qui gen double `ub`i'' ///
				= `r(expr`i')' if `touse'
			if _rc {
				version 15: di as error "option {bf:base()} invalid;"
				qui gen double `ub`i'' ///
					= `r(expr`i')' if `touse'
			}
			qui replace `udv`i'' = `ub`i'' ///
				if `touse'
		}
	}
	// handle structural case
	if "`structural'" != "" {
		di as text "{p 0 4 2} predicting the "
		di as text "{help j_asf##|_new:asf} of the "
		di as text "probability{p_end}"
		if "`intpoints'" != "" {
			tempname V v s sigma0 sigmau
			mat `V' = e(Sigma)
			scalar `s' = `V'[1,1]
			local k = e(endog_ct)
			local k1 = `k' + 1
			mat `v' = `V'[2..`k1',1]
			mat `V' =  `V'[2..`k1',2..`k1']'
			mat `V' = invsym(`V')
			mat `v' = `v''*`V'*`v' 
			scalar `v' = `v'[1,1]
			scalar `sigma0' = sqrt(`s'-`v')
			scalar `sigmau' = sqrt(`v')
			tempvar stor
			qui gen double `stor' = .
			if "`intpoints'" == "" {
				local intpoints 7
			}
			mata:_erm_asf_probit("`stor'",	///
				`intpoints',"`Xb'",	///
				"`sigma0'","`sigmau'",0,"`touse'")
			gen `vtyp' `varn' = `stor' if `touse'
		}
		else {
			gen `vtyp' `varn' = normal(`Xb') if `touse'
		}
		label variable `varn' ///
			"Structural probability of positive outcome"
		exit 
	}
	if "`asif'" != "" {
		local pr 
	}
	if "`rules'" != "" {
		local pr
	}
	if `vcaller' > 14.0 {
		local indlist
		if "`fix'" != "" {
			capture tsunab fix: `fix'
			if _rc {
				di as error "option {bf:fix()} invalid;"
				tsunab fix: `fix'
			}
			local pre "{p 0 4 2}option {bf:fix()} invalid; "
			local post1 "cannot specify outcome variable"
			local post1 "`post1'{p_end}"
			local post2 " is not a dependent variable" 
			local post2 "`post2'{p_end}"
			local edepvar `e(depvar)'
			tsunab edepvar: `edepvar'
			local fixin: list fix in edepvar
			if `fixin' == 0 {
				local notin: list fix - edepvar
				gettoken fnotin notin: notin
				di as error "`pre'{bf:`fnotin'}`post2'"
				exit 198
			}
			gettoken first edepvar: edepvar
			local firstin: list first in fix
			if `firstin' == 1 {
				di as error "`pre'`post1'"
				exit 498
			} 
			local indlist 1 
			local i = 2
			local k = 1
			foreach val of local edepvar {
				local vin: list val in fix
				if !`vin' {
					local indlist `indlist' `i'
					local k = `k' + 1
				}
				local i = `i' + 1
			}
		}
		ivadjust_xb `Xb', touse(`touse') index(`indlist')
	}

	if "`asif'" != "" {		/* Just return norm(xb), no rules */
		gen `vtyp' `varn' =  norm(`Xb') if `touse'
		if `vcaller' <= 14.0 {
        		label var `varn' "Prob of positive outcome when corr=0"   
		}
		else {
			label var `varn' "Probability of positive outcome"
		}
		if "`base'" != "" {
			forvalues i = 1/`nvu' {
				qui replace `udv`i'' = `ou`i'' if `touse'
			}
		}
		exit
	}
	
        tempname rulmat j
        mat `rulmat' = e(rules)
	local names : rownames(`rulmat')
	local rows = rowsof(`rulmat')
	gen `vtyp' `varn' = norm(`Xb') if `touse'
	if `vcaller' <= 14.0 {
        	label var `varn' "Prob of positive outcome when rho=0"   
	}
	else {
		label var `varn' "Probability of positive outcome"
	}
	if (`rulmat'[1,1] == 0 & `rulmat'[1,2] == 0 & ///
		`rulmat'[1,3] == 0 & `rulmat'[1,4] == 0) {
		/* No rules to apply; exit */
		if "`base'" != "" {
			forvalues i = 1/`nvu' {
				qui replace `udv`i'' = `ou`i'' if `touse'
			}
		}
		exit
	}

	if "`rules'" != "" {
		forvalues i = 1/`rows' {
			if `rulmat'[`i',1] == 4 {
				continue
			}
			local v : word `i' of `names'
			sca `j' = `rulmat'[`i', 2]
			if `rulmat'[`i', 3] == 0 {
				qui replace `varn' = 0 if `v' != `j' & `touse'
			}
			if `rulmat'[`i', 3] == 1 {
				qui replace `varn' = 1 if `v' != `j' & `touse'
			}
			if `rulmat'[`i', 3] == -1 {
				if `rulmat'[`i', 1] == 2 {
					qui replace `varn' = 1 ///
						if `v' > `j' & `touse'
					qui replace `varn' = 0 ///
						if `v' < `j' & `touse'
				}
				else {
					qui replace `varn' = 1 ///
						if `v' < `j' & `touse'
					qui replace `varn' = 0 ///
						if `v' > `j' & `touse'
				}
			}
		}
		if "`base'" != "" {
			forvalues i = 1/`nvu' {
				qui replace `udv`i'' = `ou`i'' if `touse'
			}
		}
		exit
	}
	
	if "`pr'" != "" {
		/* Go through and set to missing if rules omitted obs.*/
		forvalues i = 1/`rows' {
			if `rulmat'[`i',1] == 4 {
				continue
			}	
			local v : word `i' of `names'
			sca `j' = `rulmat'[`i', 2]
			if `rulmat'[`i', 3] == 0 | `rulmat'[`i', 3] == 1 | /*
				*/ `rulmat'[`i', 3] == -1 {
				qui count if `v' != `j' & `touse'
				loc n = r(N)
				loc s "s"
				if `n' == 1 {
					loc s ""
				}
				qui replace `varn' = . if `v' != `j' & `touse'
				di "(`n' missing value`s' generated)"
			}
		}
		if "`base'" != "" {
			forvalues i = 1/`nvu' {
				qui replace `udv`i'' = `ou`i'' if `touse'
			}
		}
		exit
	}
}
	local rc = _rc
nobreak {
	if "`base'" != "" {
		forvalues i = 1/`nvu' {
			qui replace `udv`i'' = `ou`i'' if `touse'
		}
	}
}
	if `rc' {
		exit `rc'
	
	}

			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	error 198
end

program ParseUbase, rclass
	syntax, [u(string) target base] 
	if "`u'" == "" {
		return local nvars = 0
		exit
	} 
	local ou `u'
	local i = 1
	while "`u'" != "" {
		gettoken var u: u, bind parse("=")
		capture confirm variable `var'
		if _rc {
			di as error "option {bf:`base'`target'()} invalid; "
			confirm variable `var'
			exit 198
		}
		return local var`i' `var'
		gettoken eq u: u, bind parse("=")
		capture assert "`eq'" == "=" 
		if _rc {
			di as error "option {bf:`base'`target'()} invalid"
			exit 198
		}
		gettoken expr u: u, bind parse(" ")
		local ok 0
		capture confirm number `expr'
		if !_rc {
			local ok 1
		}
		capture confirm variable `expr'
		if !_rc {
			local ok 1
		}
		if ~`ok' {
			local lu = ustrltrim(ustrrtrim(`"`expr'"'))
			local ok = usubstr(`"`lu'"',1,1)=="(" & ///
				   usubstr(`"`lu'"',-1,1)==")" 
		}
		if ~`ok' {
			di as error "option {bf:`base'`target'()} invalid"
			exit 198
		}					
		return local expr`i' `expr'
		local i = `i' + 1		
	}
	return local nvars = `i'-1	
end

exit

