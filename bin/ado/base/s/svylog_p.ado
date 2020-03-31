*! version 1.0.4  21oct2019
program define svylog_p /* predict for svylogit and svyprobit */
	version 6, missing

/* Note: Cannot use _pred_se, etc., since must process RULEs and ASIF options.
*/

	syntax newvarname [if] [in] [, P Index XB STDP RULEs ASIF noOFFset]

/* Check syntax. */

	local nopt : word count `p' `index' `xb' `stdp'
	if `nopt' > 1 {
		version 7: di in red "only one of options {bf:p}, {bf:xb}, or {bf:stdp} can be specified"
		exit 198
	}
	if "`rules'"!="" & "`asif'"!="" {
		version 7: di in red "options {bf:rules} and {bf:asif} may not be specified together"
		exit 198
	}
	if "`index'`xb'`stdp'"!="" & "`rules'"!="" {
		version 7: di in red "option {bf:rules} cannot be specified with option {bf:`index'`xb'`stdp'}"
		exit 198
	}

/* Mark sample. */

	cap matrix list e(perfect) /* if _rc==0, perfect prediction */

	if _rc==0 & ("`asif'"=="" | "`rules'"!="") {
		local qui "quietly"
		local varname `varlist'
		tempvar varlist
	}

	if "`index'`xb'`stdp'"!="" {
		`qui' _predict `typlist' `varlist' `if' `in', /*
		*/ `index'`xb'`stdp' `offset'
	}
	else { /* compute p */
		if "`p'"=="" {
			version 7: di in gr "(option {bf:p} assumed; Pr(`e(depvar)'))"
		}
		tempvar xb
		qui _predict double `xb' `if' `in', `offset'
		if "`e(cmd)'"=="svylogit" {
			`qui' gen `typlist' `varlist' = cond(`xb'>0, /*
			*/ 1/(1 + exp(-`xb')), exp(`xb')/(1 + exp(`xb')))
		}
		else { /* svyprobit */
			`qui' gen `typlist' `varlist' = normprob(`xb')
		}
		label var `varlist' "Probability of positive outcome"
	}

	if "`qui'"=="" { exit }

	if "`rules'"!="" {
		Rules `varname' `varlist'
	}
	else	Perfect `varname' `varlist'
end

program define Perfect
	args varname varlist
	quietly {
		tempname perfect
		mat `perfect' = e(perfect)
		local vars : colnames `perfect'
		local i 1
		while "`vars'"!="" {
			gettoken var vars : vars
			confirm numeric variable `var'
			replace `varlist' = . if `var'!=`perfect'[1,`i']
			local i = `i' + 1
		}
		count if `varlist'>=.
	}
	rename `varlist' `varname'
	SayMiss `r(N)'
end

program define Rules
	args varname varlist
	quietly {
		tempname perfect
		mat `perfect' = e(perfect)
		local vars : colnames `perfect'
		local i 1
		while "`vars'"!="" {
			gettoken var vars : vars
			confirm numeric variable `var'
			replace `varlist' = `perfect'[2,`i'] /*
			*/ if `var'!=`perfect'[1,`i'] & `varlist'<.
			local i = `i' + 1
		}
		count if `varlist'>=.
	}
	rename `varlist' `varname'
	SayMiss `r(N)'
end

program define SayMiss
	args nmiss
	if `nmiss' == 0 { exit }
	if `nmiss' == 1 {
		di in blu "(1 missing value generated)"
		exit
	}
	di in blu "(`nmiss' missing values generated)"
end
