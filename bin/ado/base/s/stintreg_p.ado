*! version 1.0.6  21mar2017
program stintreg_p, sort
	version 15

	if `"`e(cmd2)'"' != "stintreg" {
		error 301
	}

	syntax [anything] [if] [in] [, SCores *]
	if "`scores'" != "" {
		Score `0'
		exit
	}

	syntax newvarlist(min=1 max=2) [if] [in] [, 	///
				       TIME		///
				       LNTime		///
				       HAzard		///
				       HR		///
				       XB		///
				       STDP		///
				       Surv		///
				       CSNell		///
				       MGale		///
				       MEDian		///
				       MEAN		///
				       noOFFset		///
				       ADJUSTed	/*UNDOC*/	///
				       LOWer /*UNDOC*/	///
				       UPper /*UNDOC*/	///
				       OOS		]

	
	local type "`time' `lntime' `hazard' `hr' `xb' `stdp'"
	local type "`type' `surv' `csnell' `mgale'"

	if `:word count `type'' > 1 {
		di as err "{p 0 4 2}only one of "
		di as inp "`: list uniq type' "
		di as err "may be specified{p_end}"
		exit 198
	}
	local type : word 1 of `type'
	
	
	if "`lower'" != "" | "`upper'" != "" {
		if "`lower'" != "" & "`upper'" != "" {
			di as err "only one of {bf:lower} or {bf:upper} " ///
				"is allowed."
			exit 198
		}
		local position "`lower'`upper'"
	}

	if "`adjusted'" != "" {
		if "`csnell'" == "" {
			di as err "{bf:adjusted} is only allowed with " ///
				"{bf:csnell}"
			exit 198
		}
		else if "`position'" != "" {
			di as err "{bf:adjusted} is not allowed with " ///
				"{bf:`position'}"
			exit 198
		}
	}

	local type2 "`surv'`csnell'`hazard'"
	tokenize `varlist'
	if "`2'" != "" {
		if "`type2'" == "" {
			di as err "only one {it:newvar} is allowed for " ///
				"{bf:predict, `type'}" 
			exit 198
		}
		else if "`type2'" == "csnell" {
			if "`adjusted'" != "" {
				di as err "only one {it:newvar} is " ///
				"allowed for {bf:predict, csnell adjusted}"

				exit 198
			}
			else if "`position'" != "" {
				di as err "only one {it:newvar} is " ///
				"allowed for {bf:predict, `type2' `position'}"

				exit 198
			}
		}
		else if "`position'" != "" {
			di as err "only one {it:newvar} is allowed " ///
				"for {bf:predict, `type2' `position'}"

			exit 198
		}
	}

	if !inlist("`type'", "", "time", "lntime") {
		if "`mean'`median'" != "" {
			di as err "{p 0 4 2}options mean and median not "
			di as err "allowed for this prediction type{p_end}"
			exit 198
		}
	}

	if inlist("`type'", "csnell", "mgale") & "`e(prefix)'" == "svy" {
		di as err "{p 0 4 2}option `type' not allowed after svy "
		di as err "estimation{p_end}"
		exit 322
	}

	`e(predict_sub)' `typlist' `varlist' `if' `in', `type' `offset' ///
			 `median' `mean' `adjusted' `position' `oos'

end

program Score

	syntax [anything] [if] [in] [, SCores * ]

	_score_spec `anything'
	local typlist `s(typlist)'
	local varlist `s(varlist)'
	local coleq `s(coleq)'

	local neq: word count `coleq'
	local sclist 
	forvalues i = 1/`neq' {
		tempvar score`i'
		local sclist `sclist' `score`i''
	}
 
	tempname hold
	_est hold `hold', copy restore

	`e(cmdline)' score(`sclist')
		
	local nvar: word count `varlist'
	forvalues i = 1/`nvar' {
		gettoken vtyp typlist : typlist
		gettoken varn varlist : varlist
		gettoken eq coleq : coleq
	
		if (`i' == 1 ) gen `vtyp' `varn' = `score`i'' `if' `in'
		else qui gen `vtyp' `varn' = `score`i''	`if' `in'

		label var `varn' "equation-level score for `eq'"
	}

end

exit
