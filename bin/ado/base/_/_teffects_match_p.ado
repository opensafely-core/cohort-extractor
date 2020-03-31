*! version 1.1.4  24jan2019

program define _teffects_match_p
	version 13
	syntax  anything(id="varlist" name=vlist), [ te po DISTance ps ///
			biasadj km kn iterate(passthru) NOISILY        ///
			TLevel(string) LNSigma ]

	if ("`te'" != "") {
		local tlevels `e(tlevels)'
		local lomit = "`e(control)'"
		local tlevels: list tlevels - lomit
	}
	else {
		local tlevels `e(tlevels)'
	}
	local lomit = "`e(control)'"
	local otlevels: list tlevels - lomit
	local etlevel: word 1 of `otlevels' 

	local nlevs: word count `tlevels'
	if real("`tlevel'") != .  {
		local validtrt = 0
                forvalues i = 1/`nlevs' {
                       	local j: word `i' of `tlevels'
                       	if (`tlevel' == `j') {
				local validtrt = 1
                               	continue, break
                       	}
                }
               	if !`validtrt' & "`tlevel'" == "`e(control)'" {
			di as error ///
		"{bf:tlevel()} must be valid noncontrol treatment level"
			exit 198
		}
               	else if !`validtrt' {
			di as error ///
			"{bf:tlevel()} must be valid treatment level"
			exit 198
		}               
	}
	else if "`tlevel'" != "" {
		di as error "`tlevel' invalid argument to {bf:tlevel()}"
		exit 198
	}
	if ("`tlevel'" != "" & "`po'`ps'" == "") {
		di as error ///
	"{bf:tlevel()} may only be specified with {bf:po} or {bf:ps}"
		exit 198
	}
	if ("`tlevel'" != "" & "`ps'" == "") {
		if ("`tlevel'" == "`e(control)'") {
			local outcome control
		}
		else {
			local outcome treated
		}
	}
	if ("`ps'" != "") {
		capture _stubstar2names `vlist', nvars(2)
		if !(_rc) {
			local twospec = 1
			local fvar: word 1 of `s(varlist)'
			local ftype: word 1 of `s(typlist)'
			local oanything `vlist'
			local svar: word 2 of `s(varlist)'
			local stype: word 2 of `s(typlist)'
			local vlist `stype' `svar'  
		}
		else {
			_stubstar2names `vlist', nvars(1)
			local fvar: word 1 of `s(varlist)'
		}
	}


	if "`e(subcmd)'"=="nnmatch" {
		if "`ps'"!="" {
			di as err "option {bf:ps} not allowed"
			exit 198
		}
		if "`lnsigma'"!="" {
			di as err "option {bf:lnsigma} not allowed"
			exit 198
		}
		local k : word count `te' `po' `distance' `biasadj' `km' `kn'
		local more "{bf:biasadj}, "
	}
	else {	// psmatch
		if "`biasadj'" != "" {
			di as err "option {bf:biasadj} not allowed"
			exit 198
		}
		local which `te' `po' `ps' `distance' `km' `kn' `lnsigma'
		local k : word count `which'
	}
	if `k' > 1 {
		di as err "{p}only one of {bf:te}, {bf:po}, {bf:km}, " ///
 "{bf:kn}, {bf:ps}, {bf:lnsigma} or {bf:distance} may be specified{p_end}"
		exit 184
	}
	if !`k' {
		local which te
	di as txt "{p}(option {bf:te} assumed; treatment effects){p_end}"
	}
	else local which `te'`po'`ps'`distance'`biasadj'`km'`kn'
	
	if ("`lnsigma'" != "") {
		if "`e(tmodel)'" != "hetprobit" {
			di as err "{p}option {bf:lnsigma} is only allowed " ///
			 "with the {bf:hetprobit} {it:tmodel}{p_end}"
			exit 322
		}
		local which ps
	} 
		
	cap noi checkestimationsample
	if c(rc) {
		di as err "{p}postestimation can only be performed on the " ///
		 "estimation sample{p_end}"
		exit 459
	}
	if _N != e(Nobs) {
		/* can drop !e(sample) and not change data signature	*/
		di as err "{p}there were " e(Nobs) " observations at " ///
		 "estimation time but there are " _N " now; "  ///
		 "nearest-neighbor indices are no longer valid{p_end}"
		exit 459
	}
	if "`e(indexvar)'" == "" {
		di as err "{p}postestimation can only be performed when "  ///
		 "the {bf:generate({it:stub})} option is used during "     ///
		 "estimation; see "				   	   ///
		 "{help teffects##generate:help {bf:generate({it:stub})}}" ///
		 "{p_end}"
		exit 322
	}
	if "`which'"!="po" & "`outcome'"!="" {
		di as err "{p}option {bf:outcome()} may only be used with " ///
		 "option {bf:po}{p_end}"
		exit 184
	}
	local dops = ("`which'"=="ps")
	if `dops' & "`e(subcmd)'"!="psmatch" {
		di as err "option {bf:ps} is only valid for " ///
		 "{bf:teffects psmatch}" 
		exit 198
	}
	local nnvars `e(indexvar)'
	local kvar : word count `nnvars'
	if "`which'" == "distance" {
		if "`e(subcmd)'"=="nnmatch" & "`e(mvarlist)'" == "" {
			di as err "{p}no outcome model was specified for " ///
			 "nearest-neighbor matching; distances cannot be " ///
			 "computed{p_end}"
			exit 322
		}
		_stubstar2names `vlist', nvars(`kvar') outcome nosubcommand

		local varlist `s(varlist)'
		local typlist : word 1 of `s(typlist)'

		forvalues i = 1/`kvar' {
			tempvar v`i'
			local vars `vars' `v`i''
			qui gen double `v`i'' = .
		}
		local dops = ("`e(subcmd)'"=="psmatch")
	}
	else if "`lnsigma'" != "" {
		_stubstar2names `vlist', nvars(1) outcome nosubcommand
		tempvar psit
		local varlist `psit' `s(varlist)'
		local typlist : word 1 of `s(typlist)'
	}
	else if "`which'" == "po" {
		if "`outcome'" != "" {
			ParseOutcome, `outcome'
			local outcome `s(outcome)'
			if ("`outcome'" == "treated") local which pot
			else local which poc
			_stubstar2names `vlist', nvars(1) outcome nosubcommand
			local varlist `s(varlist)'
			local typlist `s(typlist)'

			tempvar vars
			qui gen double `vars' = .
		}
		else {
			capture _stubstar2names `vlist', nvars(2) outcome zero
			if !_rc {
				local varlist `s(varlist)'
				local typlist : word 1 of `s(typlist)'

				tempvar v1 v2
				qui gen double `v1' = .
				qui gen double `v2' = .
				local vars `v1' `v2'
			}
			else {
				local tlevel = min(`e(control)',`etlevel')
				if ("`tlevel'" == "`e(control)'") {
					local outcome control
				}
				else {
					local outcome treated
				}
				ParseOutcome, `outcome'
				local outcome `s(outcome)'
				if ("`outcome'" == "treated") local which pot
				else local which poc

				_stubstar2names `vlist', nvars(1) outcome ///
				nosubcommand
				local varlist `s(varlist)'
				local typlist `s(typlist)'

				tempvar vars
				qui gen double `vars' = .
			}
			
		}
	}
	else if "`which'"=="biasadj" & "`e(bavarlist)'"=="" {
		di as err "{p}option {bf:biasadj} not allowed; bias " ///
		 "adjustment was not used at estimation{p_end}"
		exit 322
	}
	else {
		_stubstar2names `vlist', nvars(1) outcome nosubcommand
		local varlist `s(varlist)'
		local typlist `s(typlist)'

		if !`dops' {
			tempvar vars
			qui gen double `vars' = .
		}
	}
	tempvar touse

	qui gen byte `touse' = e(sample)
	if `dops' {
		tempvar ps
		if "`lnsigma'" != "" {
			gettoken varlist sigma : varlist
			tempvar sig
		}
		/* propensity score					*/
		DoPScore `ps' `sig', touse(`touse') `iterate' `noisily'
		if "`which'" == "ps" {
			qui gen `typlist' `varlist' = `ps'
			local lab: value label `e(tvar)'
			local lev = `etlevel'
			if ("`lab'" != "") {
				local lev: label `lab' `lev'
			}
			label variable `varlist' ///
			`"propensity score, `e(tvar)'=`lev'"'
			if "`lnsigma'" != "" {
				qui gen `typlist' `sigma' = `sig'
				label variable `sigma' ///
		`"propensity score, log square root of latent variance"' 
			}
			if ("`twospec'"=="1") {
				gen `ftype' `fvar' = 1-`svar'
				order `fvar', before(`svar')	
				local lab: value label `e(tvar)'
				local lev `e(control)' 
				if ("`lab'" != "") {
					local lev: label `lab' `lev'
				}
				label variable `fvar' ///
				`"propensity score, `e(tvar)'=`lev'"'
			}
			else if ("`ps'" != "" & "`lnsigma'" == "") {
				if ("`tlevel'" == "") {			
					local tlevel = ///
					min(`e(control)',`etlevel')	
				}
				if ("`tlevel'" == "`e(control)'") {
					qui replace `fvar' = 1-`fvar'
					local lab: value label `e(tvar)'
					local lev `e(control)' 
					if ("`lab'" != "") {
						local lev: label `lab' `lev'
					}
					label variable `fvar' ///
					`"propensity score, `e(tvar)'=`lev'"'
				}
			}
			exit
		}
		local X `ps'
	}
	local y `e(depvar)'
	tempvar trt 
	
	qui gen byte `trt' = cond(`e(tvar)'==`e(control)',0,1) if `touse'

	if "`which'" == "distance" & "`e(subcmd)'"=="nnmatch" {
		tempname mean

		mat `mean' = e(mstats)
		if "`e(metric)'" == "ivariance" {
			tempname stdev

			mat `stdev' = e(stdevs)
		}
		local vlist `e(fvdvarlist)'
		local X
		local j = 0
		while `"`vlist'"' != "" {
			gettoken v vlist : vlist, bind

			local i = colnumb(`mean',"`v'")
			if missing(`i') {
				/* sanity check; should not happen	*/
				di as err "variable `v' not found in " ///
				 "matrix e(mstats)" 
				exit 322
			}
			if (`++j' != `i') {
				/* sanity check; should not happen	*/
				di as err "variable list in e(fvdvarlist) " ///
				 "and stripe for e(mstats) do not match"
				exit 322
			}
			tempvar v`i'
			_ms_parse_parts `v'

			if r(omit) {
				qui gen double `v`i'' = 0 if `touse'
				local X `X' `v`i''
				continue
			}

			qui gen double `v`i'' = (`v'-`mean'[1,`i']) if `touse'
			if "`stdev'" != "" {
				qui replace `v`i'' = `v`i''/`mean'[2,`i'] ///
					if `touse'
			}
			local X `X' `v`i''
		}
		if "`e(metric)'"=="mahalanobis" |	///
			bsubstr("`e(metric)'",1,6)=="matrix" {
			local V e(mscale)
		}
	}
	else if "`e(bavarlist)'"!="" & "`which'"!="km" & "`which'"!="kn" {
		local X `e(fvbavarlist)'
		local V e(bias_adj)
	}

	local wtype `e(wtype)'
	if "`wtype'" != "" {
		tempvar wt
		gen double `wt'`e(wexp)'
	}
	local robust = ("`e(vce)'"=="robust")

	mata: _match_postestimates("`which'","`vars'","`e(stat)'","`y'",   ///
		"`trt'","`wtype'","`wt'","`touse'","`nnvars'","`X'","`V'", ///
		`robust')
	
	if "`which'" == "distance" {
		local i = 0
		if ("`e(subcmd)'"=="nnmatch") local metric `e(metric)'
		else local metric "propensity score"

		foreach v of varlist `vars' {
			local vi : word `++i' of `varlist'
			qui gen `typlist' `vi' = `v'
			local lab "nearest-neighbor distance using `metric'"
			label variable `vi' "`lab'"
		}
	}
	else if "`which'" == "te" {
		qui gen `typlist' `varlist' = `vars'
		label variable `varlist' "treatment effects"
	}
	else if "`which'" == "biasadj" {
		qui gen `typlist' `varlist' = `vars'
		label variable `varlist' "bias adjustment"
	}
	else if "`which'" == "km" {
		qui gen `typlist' `varlist' = `vars'
		local lab "# times observation included in a cluster"
		label variable `varlist' "`lab'"
	}
	else if "`which'" == "kn" {
		qui gen `typlist' `varlist' = `vars'
		local lab "# observations in cluster"
		label variable `varlist' "`lab'"
	}
	else {
		if "`which'" == "po" {
			gettoken y0 y1 : varlist
		}
		else if "`which'" == "pot" {
			local y1 `varlist'
			local v2 `vars'
		}
		else {
			local y0 `varlist'
			local v1 `vars'
		}
		if "`y0'" != "" {
			qui gen `typlist' `y0' = `v1'
			local lab: value label `e(tvar)'
			local lev `e(control)' 
			if ("`lab'" != "") {
				local lev: label `lab' `lev'
			}
			label variable `y0' ///
				"potential outcome, `e(tvar)'=`lev'"

		}
		if "`y1'" != "" {
			qui gen `typlist' `y1' = `v2'
			local lev `e(treated)'
			local lab: value label `e(tvar)'
			if ("`lab'" != "") {
				local lev: label `lab' `lev'
			} 	
			label variable `y1' ///
				"potential outcome, `e(tvar)'=`lev'"
		}
	}
end

program define DoPScore
	syntax newvarlist, touse(varname)

	tempname match b

	local which "propensity scores"

	if "`e(tmodel)'" == "hetprobit" {
		local hoffset `e(hoffset)'
		gettoken varlist sigma : varlist 
		if "`sigma'" == "" {
			tempvar sigma
		}
	}
	mat `b' = e(bps)
	mat score double `varlist' = `b' if `touse', eq(`e(tvar)')

	if "`e(tmodel)'" == "logit" {
		qui replace `varlist' = invlogit(`varlist')
	}
	else {
		if "`e(tmodel)'"=="hetprobit" {
			if "`e(hoffset)'" != "" {
				qui replace `varlist' = `varlist' + `e(hoffset)'
			}
			if c(userversion) >= 16 {
				local heteq lnsigma
			}
			else {
				local heteq lnsigma2
			}
			mat score double `sigma' = `b' if `touse', eq(`heteq')
			qui replace `varlist' = `varlist'/exp(`sigma') ///
				if `touse'
		}
		qui replace `varlist' = normal(`varlist')
	}
end

program define ParseOutcome, sclass
	cap noi syntax, [ Treated Control ]
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:outcome()}"
		exit `rc'
	}
	local k : word count `treated' `control'
	if !`k' {
		di as err "{p}option {bf:outcome()} improperly specified; " ///
		 "either {bf:treated} or {bf:control} is required{p_end}"
		exit 198
	}
	if `k' == 2 {
		di as err "{p}option {bf:outcome()} improperly specified; " ///
		 "suboptions {bf:treated} and {bf:control} may not be "     ///
		 "combined{p_end}"
		exit 184
	}
	sreturn local outcome `treated'`control'
end

exit

program define ParseSigma, sclass
	syntax, [ ps(string) * ]

	if "`options'" != "" {
		di as err "{bf:`options'} not allowed"
		exit 198
	}
	local 0, `ps'
	cap noi syntax, [ LNSIGma ]
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:ps(`ps')}"
		exit 198
	}
end

