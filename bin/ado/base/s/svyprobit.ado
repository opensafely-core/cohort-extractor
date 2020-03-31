*! version 3.0.1  29sep2004
program define svyprobit
	version 8, missing

	args flag query doit

	if "`flag'"!="0" {
		if _caller() < 8 {
			svy_est_7 svyprobit `0'
		}
		else {
			svy_est svyprobit `0'
		}
		exit
	}
	if "`query'"=="syntax" {
		Syntax
		exit
	}
	if "`query'"=="how_many_scores" {
		HowMany
		exit
	}
	if "`query'"=="save" {
		Save
		exit
	}
	if "`query'"=="scores" {

	/* When here, probit has just been called.
	   We now remove any "perfectly predicted" obs from sample,
	   and remove any dropped variables from S_VYindv.
	*/
		Perfect `doit'
		exit
	}
	if "`query'"=="footnote" {
		Footnote
		exit
	}

	di in red "0 invalid name"
	exit 198
end

program define Syntax, sclass
	sret clear
	sret local title    "Survey probit regression"
	sret local cmd      "probit"
	sret local k_depvar "1"
	sret local okopts   "OFFset(varname numeric) ASIS"
				   /* additional allowed options */
	sret local mlopts   "yes"  /* ml options are allowed */
end

program define HowMany, rclass
	ret scalar k_scores = 1 /* one score index */
	ret scalar cmdcando = 1 /* probit can compute it */
end

program define Save, eclass
	eret local predict "svylog_p"

/* Count completely determined successes and failures. */

	tempvar xb
	quietly {
		_predict `xb' if $S_VYsub, xb
		count if `xb' > 6 & $S_VYsub
		if r(N) > 0 {
			eret scalar N_succ = r(N)
		}
		count if `xb' < -6 & $S_VYsub
		if r(N) > 0 {
			eret scalar N_fail = r(N)
		}
	}

/* Save rules for perfect predictors. */

	cap di matrix($S_VYtmp1[1,1])
	if _rc == 0 {
		eret matrix perfect $S_VYtmp1
	}

/* Double saves. */

	global S_E_succ = e(N_succ)
	global S_E_fail = e(N_fail)
end

program define Footnote
	if "`e(N_fail)'`e(N_succ)'"=="" {
		exit
	}

	if "`e(N_fail)'"!="" {
		local nfail "`e(N_fail)'"
	}
	else	local nfail 0
	if "`e(N_succ)'"!="" {
		local nsucc "`e(N_succ)'"
	}
	else	local nsucc 0
	if `nfail'==1 {
		local failure "failure"
	}
	else	local failure "failures"
	if `nsucc'==1 {
		local success "success"
	}
	else	local success "successes"
	di in blu "Note: `nfail' `failure' and `nsucc' " /*
	*/ "`success' completely determined."

	if "`e(fpc)'"!="" {
		di /* newline */
	}
end

program define Perfect
	args doit

	if "$S_VYexp"!="" {
		local wtnot0 "&($S_VYexp)!=0"
	}

	cap assert !(e(sample)==0 & $S_VYsub `wtnot0')
	if _rc == 0 { /* no perfect predictions */
		exit
	}

/* Fix markvar `doit'. */

	qui replace `doit' = 0 if e(sample)==0 & $S_VYsub `wtnot0'

/* Fix indepvars S_VYindv. */

	_evlist
	local oldvars   $S_VYindv
	local newvars   `s(varlist)'
	global S_VYindv `s(varlist)'
	global S_VYmodl `s(varlist)'

/* Find dropped variable(s). */

	gettoken new newvars : newvars
	while "`oldvars'"!="" {
		gettoken old oldvars : oldvars
		if "`old'"=="`new'" {
			gettoken new newvars : newvars
		}
		else	local drops `drops' `old'
	}

/* Save rules for perfect prediction (needed by predict). */

	tempname A
	while "`drops'"!="" {
		gettoken drop drops : drops
		mat `A' = (0 \ 0)
		mat colname `A' = `drop'
		qui summarize `drop' /*
		*/ if !(e(sample)==0 & $S_VYsub `wtnot0'), meanonly
		mat `A'[1,1] = r(min)
		qui summarize $S_VYdepv if `drop'!=r(min), meanonly
		mat `A'[2,1] = r(min)
		mat $S_VYtmp1 = nullmat($S_VYtmp1) , `A'
	}
end
