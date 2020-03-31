*! version 1.6.0  13mar2018
program _svy_setup, rclass
	version 9
	local vv : di "version " string(_caller()) ":"
	syntax [anything] [pw iw] [, SVY * ]
	if "`svy'" == "" {
		syntax [anything] [pw iw] [,		///
			cmdname(name)			///
			over(passthru)			///
			SUBpop(passthru)		///
			SRSsubpop			///
			STRata(varname)			///
			CLuster(varname)		///
			FPC(varname)			///
			RESAMPLING			/// undocumented
		]
	}
	else {
		syntax [anything] [pw iw] [,		///
			cmdname(name)			///
			SVY				///
			BRR				///
			BStrap BOOTstrap		///
			JACKknife JKNIFE		///
			SDR				///
			hasover				///
			over(passthru)			///
			SUBpop(passthru)		///
			SRSsubpop			///
			VCE(string)			///
			STSET				///
			group(passthru)			/// _svy_check_group
			groupoptname(passthru)		/// _svy_check_group
			RESAMPLING			/// undocumented
			CALIBRATE			/// undocumented
		]
	}

	if "`bstrap'" != "" {
		local bootstrap bootstrap
	}
	if "`jknife'" != "" {
		local jackknife jackknife
	}

	local kex : word count `brr' `bootstrap' `jackknife' `sdr'
	if `"`vce'"' != "" {
		local ++kex
	}
	if `kex' > 1 {
		opts_exclusive "brr bootstrap jackknife sdr vce()" vce
	}

	local nvars : word count `anything'
	if !inlist(`nvars', 2, 3) {
		local 0 `anything'
		syntax namelist(min=2 max=3)
	}
	confirm name `anything'
	tokenize `anything'
	args	touse		/// already exists
		subuse		/// new variable
		wvar		//  new variable, optional

	if "`wvar'" == "" {
		tempname wvar
	}
	else {
		capture confirm variable `wvar'
		if c(rc) == 0 {
			tempname wvar
		}
	}

	if "`svy'" != "" {
		if `"`weight'"' != "" {
			di as err ///
		"weights can only be supplied to {help svyset##|_new:svyset}"
			exit 198
		}
		quietly svyset
		if "`r(settings)'" == ", clear" {
			di as err ///
		"data not set up for svy, use {help svyset##|_new:svyset}"
			exit 119
		}
		local stages_wt 0
		if "`r(wtype)'" != "" {
			local wexp `"`r(wexp)'"'
			gettoken equal wvarset : wexp, parse(" =")
			if "`equal'" != "=" {
				di as err "invalid svyset"
				exit 459
			}
			quietly gen double `wvar' = `wvarset'
		}
		else if !inlist("`r(stages_wt)'", "0", "") {
			local stages_wt = r(stages_wt)
			local wlist `"`r(wlist)'"'
			local wvarset : subinstr local wlist " " "*", all
			quietly gen double `wvar' = `wvarset'
			return local wtype "pweight"
			return local wexp "= `wvarset'"
		}
		else {
			quietly gen double `wvar' = `touse'
		}
		if "`calibrate'" != "" & "`r(calmethod)'" != "" {
			tempname wvar0
			rename `wvar' `wvar0'
			local calmethod	`"`r(calmethod)'"'
			local calmodel	`"`r(calmodel)'"'
			local calopts	`"`r(calopts)'"'
			quietly					///
			svycal `calmethod' `calmodel'		///
				[pw=`wvar0']			///
				if `touse',			///
				generate(`wvar')		///
				`calopts'			///
			// blank
		}
		local numvars `wvar' `r(postweight)'
		local strvars `r(poststrata)'
		local stages = cond(missing(r(stages)), 0, r(stages))
		forval i = 1/`stages' {
			if "`r(su`i')'" != "_n" {
				local su `r(su`i')'
			}
			else	local su
			local strvars	`strvars' `r(strata`i')' `su'
			local numvars	`numvars' `r(fpc`i')'
		}
		local su_last `"`r(su`stages')'"'
		if `stages_wt' {
			local numvars `numvars' `wlist'
		}
		return add
		return local settings
		local strata `return(strata1)'
	}
	else {
		if `"`weight'"' != "" {
			quietly gen `wvar'`exp' if `touse'
		}
		else {
			quietly gen byte `wvar' = `touse'
		}
		local numvars `wvar' `fpc'
		local strvars `strata' `cluster'
	}
	markout `touse' `numvars'
	markout `touse' `strvars', strok

	// identify subpopulation observations
	if "`resampling'" == "" {
		capture drop `subuse'
	}
	`vv'					///
	_svy_subpop `touse' `subuse',		///
		`over'				///
		`hasover'			///
		`subpop'			///
		wvar(`wvar')			///
		strata(`strata')		///
		`resampling'			///
		// blank
	return add

	if "`cmdname'" != "tabulate" {
		// only -svy:tabulate- cares about the -srssubpop- option
		return local srssubpop
	}

	if "`return(wtype)'" == "pweight" {
		quietly count if `wvar' < 0 & `touse'
		if r(N) {
			error 402
		}
	}
	// check st settings
	if "`stset'" != "" {
		st_is 2 analysis
		_svy_check_stset `"`wvarset'"' `"`su_last'"'
		local stid	`"`r(stid)'"'
		local stwgt	`"`r(stwgt)'"'
		local wexp	`"`r(wexp)'"'
		markout `touse' `r(stmarkout)', strok
		if "`return(wtype)'" == "" {
			return local wtype	`"`r(stwt)'"'
			quietly svyset `stwgt', noclear
			if "`wexp'" != "" {
				quietly replace `wvar' `wexp'
			}
		}
		return local stid	`"`stid'"'
		return local stwgt	`"`stwgt'"'
		return local wexp	`"`wexp'"'

		// drop observations which are outside the -stset- -if()-,
		// -ever()-, -never()-, -after()-, and -before()- conditions

	    if "`resampling'" == "" {
		quietly replace `subuse' = 0 if _st == 0 | `touse' != 1
		quietly count if `subuse'
		if r(N) == 0 {
			di as err "no observations;" _n ///
"stset and subpop() option identify disjoint subsets of the data"
			exit 2000
		}
	    }
	}
	if `:length local group' {
		_svy_check_group, `group' `groupoptname' lastunit(`su_last')
	}

end
exit
