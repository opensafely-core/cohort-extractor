*! version 2.1.3  15oct2019

program define ivtobit_p
	local vcaller = string(_caller())
	version 8

	if "`e(cmd)'" != "ivtobit" {
		error 322
	}

	syntax [anything] [if] [in] [, xb stdp SCores * ]
	if `"`scores'"' != "" {
		if `"`e(method)'"' == "twostep" {
			di as err ///
			"option {bf:scores} is not allowed with the two-step method"
			exit 322
		}
		local version = cond(!missing(e(version)),e(version),14.1)
		if `version' < 15 {
			global IVT_NEND `e(endog_ct)'
			global IVT_ll `e(tobitll)'
			global IVT_ul `e(tobitul)'
			ml score `0'
			macro drop IVT_*
			exit
		}
		/* version 15+						*/
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

		mata: ivtobit_mopt("`b'","`depvar'",`kendog',`=e(llopt)', ///
			`=e(ulopt)',"`touse'","","","","","",0,"",0,"`slist'")

		local eqs : coleq `b'
		local eqs : list uniq eqs
		local nms : colnames `b'
		local k0 = 0
		local nms0 `"`nms'"'
		while "`nms0'" != "" {
			gettoken  nm nms0 : nms0, bind
			if strpos("`nm'","athrho") {
				continue, break
			}
			if strpos("`nm'","lnsigma") {
				continue, break
			}
			local `++k0'
		}

		local lab "equation-level score for "
		local k = `kendog' + 1
		forvalues i=1/`kscores' {
			local si : word `i' of `scores'
			local eq : word `i' of `eqs'
			gen `stype' `si' = `s`i'' if `touse'
			if `i' <= `k' {
				label variable `si' "`lab' [`eq'] from ivtobit"
			}
			else {
				if `version' >= 16 {
					/* free parameter		*/
					local eq : word `++k0' of `nms'
				}
				label variable `si' "`lab' /`eq' from ivtobit"
			}
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
	local 0 `if' `in', `options'
	local myopts "STDF E(string) Pr(string) YStar(string) "
	local myopts "`myopts' Mean STRuctural total"      /* undocumented */
	local myopts `"`myopts' fix(string) base(string)"' /* undocumented */ 
	local myopts `"`myopts' TARGet(string)"'	   /* undocumented */	
	
	syntax [if] [in] [, `myopts' ]

	if "`stdf'" != "" & "`fix'" != "" {
		opts_exclusive "stdf fix()"
	}
	if "`e'" != "" & "`fix'" != "" {
		opts_exclusive "e() fix()"
	}
	if "`ystar'" != "" & "`fix'" != "" {
		opts_exclusive "ystar() fix()"
	}
	if "`structural'" != "" & "`fix'" != "" {
		opts_exclusive "structural fix()"
	}
	if "`total'" != "" & "`fix'" != "" {
		opts_exclusive "total fix()"
	}
	if "`e(prefix)'" == "svy" {
		_prefix_nonoption after svy estimation, `stdf'
	}
	local type "`stdf'"
	local args `"`mean'`pr'`e'`ystar'"'

	/* quickly process default case if you can 			*/
	if "`type'"=="" & `"`args'"'=="" {
		di in gr "(option {bf:xb} assumed; fitted values)"
		if "`base'" != "" {
			opts_exclusive "xb base()"
		}
		if "`total'" != "" {
			opts_exclusive "xb total"
		}
		if "`fix'" != "" {
			opts_exclusive "xb fix()"
		}
		_predict `vtyp' `varn' `if' `in'
		exit
	}
	if "`e(method)'" == "twostep" & "`total'" != "" {
		di as error ///
			"option {bf:total} not available with two-step estimator"
		exit 198
	}
	if "`e(method)'" == "twostep" & "`base'" != "" {
		di as error ///
			"option {bf:base()} not available with two-step estimator"
		exit 198
	}
	if "`e(method)'" == "twostep" & "`fix'" != "" {
		di as error ///
			"option {bf:fix()} not available with two-step estimator"
		exit 198
	}
	/* If we've gotten this far, it's not xb or stdp 		*/
	if "`e(method)'" == "twostep" {
		if `"`pr'"' != "" {
			local type "pr()"
		}
		else if `"`e'"' != "" {
			local type "e()"
		}
		else if `"`ystar'"' != "" {
			local type "ystar()"
		}
		if `"`pr'`e'`ystar'"' != "" {
			di as error ///
				"{p 0 4 2}option {bf:`type'} not available " 
			di as error ///
				"with two-step estimator{p_end}"
			exit 198
		}
	}
	/* now determine whether to use structural or total		*/
	if "`structural'" != "" & "`total'" != "" {
		opts_exclusive "structural total"
	}
	if "`structural'" != "" & "`stdf'" != "" {
		opts_exclusive "structural stdf"
	}
	if "`structural'" != "" & `vcaller' < 15 {
		di as error ///
			"option {bf:structural} not allowed under version `vcaller'"
		exit 198
	}	
	if "`total'" != "" & `vcaller' < 15 {
		di as error ///
			"option {bf:total} not allowed under version `vcaller'"
		exit 198
	}
	if "`fix'" != "" & `vcaller' < 15 {
		di as error ///
			"option {bf:fix()} not allowed under version `vcaller'"
		exit 198
	}
	if "`base'" != "" & `vcaller' < 15 {
		di as error ///
			"option {bf:base()} not allowed under version `vcaller'"
		exit 198
	}
	if "`pr'" != "" & "`structural'" != "" {
		opts_exclusive "structural pr()"
	}
	if "`e'" != "" & "`structural'" != "" {
		opts_exclusive "structural e()"
	}
	if "`ystar'" != "" & "`structural'" != "" {
		opts_exclusive "structural ystar()"
	}
	if "`pr'" != "" & "`fix'" != "" {
		opts_exclusive "fix() pr()"
	}
	if "`e'" != "" & "`fix'" != "" {
		opts_exclusive "fix() e()"
	}
	if "`ystar'" != "" & "`fix'" != "" {
		opts_exclusive "fix() ystar()"
	}

	marksample touse
	/* 
		handle options that take argument one at a time.
		Comment if restricted to e(sample).
		Be careful in coding that number of missing values
		created is shown.
		Do all intermediate calculations in double.
	*/
	if `"`args'"'!="" & "`structural'" == "" {
		if "`type'"!="" { 
			error 198 
		}
		tempname sig
		if `vcaller' > 14.0 {
			/* adjust prediction with endogenous variables	*/
			local fxbadj ivadjust_xb
			tempname V v s
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
				mat `V' = e(Sigma)
				scalar `s' = `V'[1,1]
				local cindlist = subinstr(	///
					"`indlist'"," ",",",.)
				if `k' > 1 {
			                mata:st_matrix("`V'",		///
						st_matrix("`V'")[  	///
	                		        (`cindlist'),(`cindlist')])
			                local k = colsof(`V')
					mat `v' = `V'[2..`k',1]
					mat `V' = `V'[2..`k',2..`k']
					mat `V' = syminv(`V')
					mat `v' = `v''*`V'*`v' 
					scalar `v' = `v'[1,1]
					scalar `sig' = sqrt(`s'-`v')
				}
				else {
					scalar `sig' = sqrt(`s')
				}				
			}
			else {
				mat `V' = e(Sigma)
				local k = e(endog_ct) + 1
				scalar  `s' = `V'[1,1]
				mat `v' = `V'[2..`k',1]
				mat `V' = `V'[2..`k',2..`k']
				mat `V' = syminv(`V')
				mat `v' = `v''*`V'*`v' 
				scalar `v' = `v'[1,1]
				scalar `sig' = sqrt(`s'-`v')
			}
		}
		else {
			GetRMSE
			scalar `sig' = `s(rmse)'
		}
		if "`mean'" != "" & "`pr'" != "" {
			opts_exclusive "mean pr()"
		}
		else if "`mean'" != "" & "`e'" != "" {
			opts_exclusive "mean e()"
		}	
		else if "`mean'" != "" & "`ystar'" != "" {
			opts_exclusive "mean ystar()"
		}
		else if "`pr'" != "" & "`e'" != "" {
			opts_exclusive "pr() e()"
		}
		else if "`pr'" != "" & "`ystar'" != "" {
			opts_exclusive "pr() ystar()"
		}
		else if "`e'" != "" & "`ystar'" != "" {
			opts_exclusive "e() ystar()"
	
		}
		if "`mean'" != "" {
			local e .,.
		}
		regre_p2 "`vtyp'" "`varn'" "`touse'" "" `"`pr'"' `"`e'"' ///
			`"`ystar'"' "`sig'" "" "`fxbadj'" "`indlist'"    ///
			`"`base'"' `"`target'"'
		if "`mean'" != "" {
			local first: word 1 of `e(depvar)'
			label variable `varn' "mean of `first'"
		}
		exit
	}
	else if "`structural'" != "" {
		_predict `vtyp' `varn' if `touse', xb
		di as text "{p 0 4 2}predicting the "
		di as text "{help j_asf##|_new:asf} "
		di as text "of the mean{p_end}"
		local dv `e(depvar)'
		local first: word 1 of `dv'
		local lab `"Structural mean of `first'"'
		label variable `varn' `"`lab'"'	
		exit
	}
	/* 
		handle switch options that can be used in-sample or
		out-of-sample one at a time.
		Be careful in coding that number of missing values
		created is shown.
		Do all intermediate calculations in double.
	*/
	if "`type'"=="stdf" {
		tempvar stdp
		qui _predict double `stdp' if `touse', stdp 
		GetRMSE
		gen `vtyp' `varn' = sqrt(`stdp'^2 + `s(rmse)'^2) if `touse'
		label var `varn' "S.E. of the forecast"
		exit
	}
	/* The user specified more than one option		 	*/
	error 198
end

program define GetRMSE, sclass

	sret clear
	tempname mat se
	mat `mat' = e(Sigma)
	mat `se' = `mat'[1,1]
	scalar `se' = sqrt(trace(`se'))
	sret local rmse = `se'
	
end

exit
