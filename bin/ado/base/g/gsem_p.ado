*! version 1.4.5  01nov2018
program gsem_p, sortpreserve
	version 13
	local vv : display "version " _caller() ":"

	set emptycells keep
	tempname tname
	capture noisily `vv' Predict `tname' `0'
	local rc = c(rc)
	capture drop `tname'*
	capture mata: rmexternal("`tname'")
	exit `rc'
end

program Predict
	version 13
	local vv : display "version " _caller() ":"
	if e(mecmd) == 1 {
		local MEOPTS stdp
	}
	local mip = c(max_intpoints)
	gettoken TNAME 0 : 0
	syntax  anything(id="stub* or newvarlist") 	///
		[if] [in] [,				///
		mu					/// statistics
		pr					///
		xb					///
		`MEOPTS'				///
		LATent					///
		eta					///
		DENsity					///
		DISTribution				///
		SURVival				///
		LATent1(string)				///
		se(string)				///
		EXPression(string)			///
		SCores					///
		likelihood				/// undocumented
		classpr					///
		CLASSPOSTeriorpr			///
		NOOFFset				/// options
		FIXEDonly				/// undocumented
		MEANs					/// undocumented
		EBMEANs					///
		MODEs					/// undocumented
		EBMODEs					///
		CONDitional1(string)			///
		CONDitional				///
		UNCONDitional				/// undocumented
		MARGinal				///
		PMARGinal				///
		Outcome(string)				///
		EQuation(string)			/// NOT documented
		CLASS(string)				///
		INTPoints(numlist int max=1 >0 <=`mip')	///
		ITERate(numlist int max=1 >0)		///
		TOLerance(numlist max=1 >=0)		///
		LOG					/// NOT documented
		NOMARGINSDEFAULT			/// NOT documented
		MCSTART					/// NOT documented
	]

	if "`nomarginsdefault'" != "" {
		if "`e(groupvar)'" != "" {
			di as err "{p 0 0 2}"
			di as err ///
	"default predictions for {bf:margins} not available;{break}"
			di as err ///
	"prediction outcomes are not the same across levels of the "
			di as err ///
	"{bf:group()} variable"
			di as err "{p_end}"
			exit 322
		}
		di as err "default predictions for {bf:margins} not available"
		exit 322
	}

	if "`intpoints'" == "1" {
		di as err "invalid intpoints() option;"
		di as err "intpoints(1) is not allowed by predict"
		exit 198
	}

	CheckXB, `xb'

	// parse statistics

	if `:length local equation' {
		if `:length local outcome' {
			opts_exclusive "outcome() equation()"
		}
		local outcome : copy local equation
	}
	if `:length local expression' {
		local EXP expression()
	}

	local STAT	`mu'			///
			`pr'			///
			`xb'			///
			`stdp'			///
			`latent'		///
			`eta'			///
			`density'		///
			`distribution'		///
			`survival'		///
			`likelihood'		///
			`classpr'		///
			`classposteriorpr'	///
			`EXP'
	opts_exclusive "`STAT'"

	if "`scores'" != "" {
		`vv' GenScores `TNAME' `0'
		exit
	}

	if `:length local latent1' {
		local STAT : list STAT - latent
		opts_exclusive "`STAT' latent()"
		local STAT latent
		local latent latent()
	}
	if `:length local outcome' {
		opts_exclusive "outcome() `latent'"
	}
	if "`STAT'" != "latent" & `:length local se' {
		di as err "option {bf:se(}) requires the {bf:latent} option"
		exit 198
	}
	if "`STAT'" == "" {
		di as txt "(option {bf:mu} assumed)"
		local STAT mu
	}

	// parse options

	if "`unconditional'" != "" {
		opts_exclusive "unconditional `xb'"
		opts_exclusive "unconditional `stdp'"
		opts_exclusive "unconditional `pmarginal'"
		opts_exclusive "unconditional `fixedonly'"
		opts_exclusive "unconditional `latent'"
		opts_exclusive "unconditional `ebmeans'"
		opts_exclusive "unconditional `means'"
		opts_exclusive "unconditional `ebmodes'"
		opts_exclusive "unconditional `modes'"
		local marginal marginal
	}
	if "`conditional1'" == "" {
		if "`conditional'" != "" {
			opts_exclusive "conditional `xb'"
			opts_exclusive "conditional `stdp'"
			opts_exclusive "conditional `unconditional'"
			opts_exclusive "conditional `marginal'"
			opts_exclusive "conditional `pmarginal'"
			opts_exclusive "conditional `fixedonly'"
			opts_exclusive "conditional `ebmodes'"
			opts_exclusive "conditional `modes'"
			local means means
		}
	}
	else {
		ParseCond1, `conditional1'
		local condopt "conditional(`conditional1')"
		opts_exclusive "`condopt' `xb'"
		opts_exclusive "`condopt' `stdp'"
		opts_exclusive "`condopt' `unconditional'"
		opts_exclusive "`condopt' `marginal'"
		opts_exclusive "`condopt' `pmarginal'"
		if "`conditional1'" != "fixedonly" {
			opts_exclusive "`condopt' `fixedonly'"
		}
		else {
			opts_exclusive "`condopt' `latent'"
			local fixedonly fixedonly
		}
		if "`conditional1'" != "ebmeans" {
			opts_exclusive "`condopt' `ebmeans'"
			opts_exclusive "`condopt' `means'"
			opts_exclusive "`condopt' `conditional'"
		}
		else	local means means
		if "`conditional1'" != "ebmodes" {
			opts_exclusive "`condopt' `ebmodes'"
			opts_exclusive "`condopt' `modes'"
		}
		else	local modes modes
	}

	opts_exclusive "`fixedonly' `latent'"
	opts_exclusive "`fixedonly' `ebmeans' `ebmodes' `marginal' `pmarginal'"
	opts_exclusive "`stdp' `xb' `ebmeans' `ebmodes' `marginal' `pmarginal'"
	if "`ebmeans'" != "" {
		local means means
	}
	if "`ebmodes'" != "" {
		local modes modes
	}

	if `"`e(lclass)'"' == "" {
		if `"`class'"' != "" {
			local optspec "class()"
		}
		else	local optspec	`likelihood'		///
					`classpr'		///
					`classposteriorpr'	///
					`pmarginal'
		if "`optspec'" != "" {
			di as err "option {bf:`optspec'} not allowed"
			exit 198
		}
	}
	else {
		local cond `means' `modes'
		if "`cond'" != "" {
			di as err ///
			"option {bf:conditional(eb`cond')} not allowed"
			exit 198
		}
		else if "`fixedonly'" != "" {
			di as err ///
			"option {bf:conditional(fixedonly)} not allowed"
			exit 198
		}
		local marginal `marginal' `pmarginal'
		opts_exclusive "`marginal'"
		if "`class'" != "" {
			opts_exclusive "`marginal' class()"
		}
		else if "`marginal'" == "" {
			if "`STAT'-`c(marginscmd)'" == "mu-on" {
				local marginal marginal
			}
		}
		if "`marginal'" != "" {
			if "`STAT'" == "mu" {
				if "`marginal'" == "marginal" {
					local STAT mumarg
				}
				else {
					local STAT mupost
				}
			}
			else {
				di as err "option {bf:`marginal'} not allowed;"
				di as err "{p 0 0 2}"
				di as err ///
	"option {bf:`marginal'} is not allowed with"
				di as err ///
	"statistic {bf:`STAT'} for models with latent classes"
				di as err "{p_end}"
				exit 198
			}
		}
	}

	opts_exclusive "`fixedonly' `means' `modes' `marginal'"
	opts_exclusive "`stdp' `xb' `means' `modes' `marginal'"
	if "`STAT'" == "xb" {
		local STAT eta
		local fixedonly fixedonly
	}
	else if e(k_hinfo) == 0 {
		if "`STAT'" == "latent" {
			di as err "option {bf:`latent'} not allowed;"
			di as err ///
	"no continuous latent variables present in estimation results"
			exit 198
		}
		if "`marginal'" != "" & "`e(lclass)'" == "" {
			local latopt `marginal'
		}
		else if "`ebmeans'`means'" != "" {
			local latopt conditional(ebmeans)
		}
		else if "`ebmodes'`modes'" != "" {
			local latopt conditional(ebmodes)
		}
		if "`latopt'" != "" {
			di as txt "{p 0 6 2}"
			di as txt "note: Option {bf:conditional(fixedonly)} "
			di as txt "is assumed and option "
			if "`condopt'" != "" {
				di as txt "{bf:`condopt'}"
			}
			else	di as txt "{bf:`latopt'}"
			di as txt "is ignored because no "
			di as txt "latent variables are present in "
			di as txt "estimation results."
			di as txt "{p_end}"
			local marginal
			local means
			local modes
		}
		else if "`fixedonly'" == "" & "`e(lclass)'" == "" {
			di as txt "(option {bf:conditional(fixedonly)} assumed)"
		}
		if "`marginal'" == "" {
			local fixedonly fixedonly
		}
	}
	else {
		if "`pmarginal'" != "" {
			di as err "option {bf:pmarginal} not allowed"
			exit 198
		}
		if "`stdp'" != "" {
			local fixedonly fixedonly
		}
		if "`fixedonly'`means'`modes'`marginal'" == "" {
			if "`c(marginscmd)'" == "on" {
				local marginal marginal
			}
			else if "`STAT'" == "latent" {
				di as txt "(option {bf:ebmeans} assumed)"
				local means means
			}
			else {
				local means means
				di as txt ///
				"(option {bf:conditional(ebmeans)} assumed)"
			}
		}
	}
	local EBTYPE `means' `modes'
	if "`EBTYPE'" == "" {
		local EBTYPE means
	}

	// postestimation sample

	tempname touse
	mark `touse' `if' `in'

	if "`STAT'" == "stdp" {
		if `:length local outcome' {
			capture _ms_unab outcome : `outcome'
		}
		if `:length local outcome' {
			local depvar : copy local outcome
		}
		else {
			if bsubstr("`e(family1)'",1,4) == "mult" {
				local depvar : coleq e(b)
			}
			else {
				local depvar "`e(depvar)'"
			}
			gettoken depvar : depvar
		}
		if e(mecmd) == 0 {
			capture local vlabel : variable label `depvar'
			if c(rc) | !`:length local vlabel' {
				local vlabel : copy local depvar
			}
			local vlabel `" (`vlabel')"'
		}
		if strpos("`anything'", "*") {
			_stubstar2names `anything', nvars(1)
		}
		else {
			gsem_newvarlist `anything', nvars(1)
		}
		local typ "`s(typlist)'"
		local var "`s(varlist)'"
		local empty 0
		local match 0
		forval i = 1/`e(k_yinfo)' {
		    if "`e(yinfo`i'_name)'" == "`depvar'" {
			if "`e(yinfo`i'_finfo_family)'" == "ordinal" {
			    if "`e(yinfo`i'_xvars)'" == "" {
				local empty 1
			    }
			}
			local match 1
			continue, break
		    }
		}
		if `empty' {
			gen `typ' `var' = 0
		}
		else {
			_predict `typ' `var', stdp equation(`outcome')
		}
		if e(k_hinfo) {
			local fixmsg ", fixed portion only"
		}
		if e(xtcmd) == 1 {
			label var `var' ///
			"S.E. of the linear prediction of `e(depvar)'"
		}
		else {
			label var `var' ///
			"S.E. of the linear prediction`vlabel'`fixmsg'"
		}
		exit
	}

	// All the following mata functions produce a local macro named
	// VARLIST that contains the list of generated variables.

	local offset = "`nooffset'" == ""

	local k_newvars 0
	if strpos("`anything'", "*") == 0 {
		CountNewvars k_newvars `anything'
	}

	if "`class'`outcome'" == "" {
		if e(fmmcmd) == 1 {
			local k_newvars 0
		}
	}

	if "`STAT'" == "likelihood" {
		if "`outcome'" != "" {
			opts_exclusive "`STAT' outcome()"
		}
		`vv'						///
		mata: _gsem_predict_CL(	"`TNAME'",		///
					"`anything'",		///
					`k_newvars',		///
					"`touse'",		///
					"`class'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "classpr" {
		if "`outcome'" != "" {
			opts_exclusive "`STAT' outcome()"
		}
		`vv'							///
		mata: _gsem_predict_classpr(	"`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						"`class'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "classposteriorpr" {
		if "`outcome'" != "" {
			opts_exclusive "`STAT' outcome()"
		}
		`vv'							///
		mata: _gsem_predict_classpost(	"`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						"`class'")
		MISSMSG `VARLIST'
		exit
	}

	if inlist("`STAT'", "mumarg", "mupost") {
		`vv'							///
		mata: _gsem_predict_mu_overall(	"`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`outcome'",		///
						"`STAT'" == "mupost")
		MISSMSG `VARLIST'
		exit
	}

	if "`fixedonly'" != "" {
		if "`EXP'" != "" {
			`vv'						///
			mata: _gsem_predict_exp("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`class'",		///
						"`expression'")
		}
		else if "`STAT'" == "eta" {
			`vv'						///
			mata: _gsem_predict_xb(	"`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`class'",		///
						"`outcome'")
		}
		else if "`STAT'" == "density" {
			`vv'						///
			mata: _gsem_predict_dens("`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`class'",		///
						"`outcome'")
		}
		else if "`STAT'" == "distribution" {
			`vv'						///
			mata: _gsem_predict_dist("`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`class'",		///
						"`outcome'")
		}
		else if "`STAT'" == "survival" {
			`vv'						///
			mata: _gsem_predict_surv("`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`class'",		///
						"`outcome'")
		}
		else {
			`vv'						///
			mata: _gsem_predict_mu(	"`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`STAT'" == "pr",	///
						"`class'",		///
						"`outcome'")
		}
		MISSMSG `VARLIST'
		exit
	}

	if "`marginal'" != "" {
		if "`EXP'" != "" {
			`vv'						///
			mata: _gsem_predict_mexp("`TNAME'",		///
						"`anything'",		///
						"`touse'",		///
						`offset',		///
						"`expression'",		///
						"`intpoints'")
		}
		else if "`STAT'" == "eta" {
			`vv'						///
			mata: _gsem_predict_mxb("`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`outcome'",		///
						"`intpoints'")
		}
		else if "`STAT'" == "density" {
			`vv'						///
			mata: _gsem_predict_mdens("`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`outcome'",		///
						"`intpoints'")
		}
		else if "`STAT'" == "distribution" {
			`vv'						///
			mata: _gsem_predict_mdist("`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`outcome'",		///
						"`intpoints'")
		}
		else if "`STAT'" == "survival" {
			`vv'						///
			mata: _gsem_predict_msurv("`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`outcome'",		///
						"`intpoints'")
		}
		else {
			`vv'						///
			mata: _gsem_predict_mmu("`TNAME'",		///
						"`anything'",		///
						`k_newvars',		///
						"`touse'",		///
						`offset',		///
						"`STAT'" == "pr",	///
						"`outcome'",		///
						"`intpoints'")
		}
		MISSMSG `VARLIST'
		exit
	}

	// The following predictions use empirical Bayes' estimates.

	local log = "`log'" != ""

	if _caller() < 14.2 {
		capture checkestimationsample
		if c(rc) {
			di as err "{p 0 0 2}"
			di as err "data have changed since estimation;{break}"
			di as err ///
"prediction of empirical Bayes `EBTYPE' requires the original " ///
"estimation data"
			di as err "{p_end}"
			exit 459
		}
		tempname esample
		quietly gen byte `esample' = e(sample)
	}
	else {
		local esample : copy local touse
	}

	if "`STAT'" == "latent" {
		local hasRdot 0
		if e(mecmd) {
			local revars = e(revars)
			local xx : subinstr local revars "R." "R.", ///
				all count(local hasRdot)
		}
		if `hasRdot' {
			if "`e(intmethod)'" == "laplace" {
				local hasRdot 0
			}
		}
		if `hasRdot' {
			local dim : list sizeof revars
			_stubstar2names `anything', nvars(`dim')
			local lvarlist `s(varlist)'
			local ltyplist `s(typlist)'
			tempname t
			local tstar double `t'*
			if `:length local se' {
				_stubstar2names `se', nvars(`dim')
				local sevarlist `s(varlist)'
				local setyplist `s(typlist)'
				tempname s
				local sestar double `s'*
			}
		}
		else {
			local tstar : copy local anything
			local sestar : copy local se
		}
		`vv'							///
		mata: _gsem_predict_latent(	"`TNAME'",		///
						"`tstar'",		///
						"`sestar'",		///
						"`esample'",		///
						"`EBTYPE'",		///
						"`latent1'",		///
						"`intpoints'",		///
						"`iterate'",		///
						"`tolerance'",		///
						`log')
		if _caller() < 14.2 {
			capture assert `touse' == `esample'
			if c(rc) {
				FILL `touse' `VARLIST'
			}
		}
		if `hasRdot' {
			REremap `ltyplist' : `lvarlist' : `LVARLIST'
			local VARLIST `r(varlist)'
			if `"`se'"' != "" {
				REremap `setyplist' : `sevarlist' : `SEVARLIST'
				local VARLIST `VARLIST' `r(varlist)'
			}
		}
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "pr" {
		local prok 0
		local kdv = e(k_dv)
		forval i = 1/`kdv' {
			if inlist(substr("`e(family`i')'",1,4), "bern",	///
								"ordi",	///
								"mult") {
				local prok 1
				continue, break
			}
		}
		if (e(is_me)) {
			if inlist(substr("`e(family)'",1,4),	"bern",	///
								"ordi",	///
								"mult") {
				local prok 1
			}
		}
		if (e(irtcmd) == 1) {
			local prok 1
		}
		if `prok' == 0 {
			di as err "option pr not allowed;"
			di as err "{p 0 0 2}"
			di as err "no depvars were specified using"
			di as err "family(bernoulli),"
			di as err "family(ordinal),"
			di as err "or family(multinomial)"
			di as err "{p_end}"
			exit 198
		}
	}

	quietly d, varlist
	local sortlist `"`r(sortlist)'"'

	`vv'							///
	mata: _gsem_predict_latent(	"`TNAME'",		///
					"double `TNAME'_*",	///
					"",			///
					"`esample'",		///
					"`EBTYPE'",		///
					"",			///
					"`intpoints'",		///
					"`iterate'",		///
					"`tolerance'",		///
					`log')
	if _caller() < 14.2 {
		capture assert `touse' == `esample'
		if c(rc) {
			FILL `touse' `VARLIST'
		}
	}
	local LATENT : copy local VARLIST

	if "`sortlist'" != "" {
		sort `sortlist'
	}

	if "`EXP'" != "" {
		`vv'						///
		mata: _gsem_predict_lexp("`TNAME'",		///
					"`anything'",		///
					"`touse'",		///
					`offset',		///
					"`expression'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "eta" {
		`vv'						///
		mata: _gsem_predict_lxb("`TNAME'",		///
					"`anything'",		///
					`k_newvars',		///
					"`touse'",		///
					`offset',		///
					"`outcome'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "density" {
		`vv'						///
		mata: _gsem_predict_ldens("`TNAME'",		///
					"`anything'",		///
					`k_newvars',		///
					"`touse'",		///
					`offset',		///
					"`outcome'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "distribution" {
		`vv'						///
		mata: _gsem_predict_ldist("`TNAME'",		///
					"`anything'",		///
					`k_newvars',		///
					"`touse'",		///
					`offset',		///
					"`outcome'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	if "`STAT'" == "survival" {
		`vv'						///
		mata: _gsem_predict_lsurv("`TNAME'",		///
					"`anything'",		///
					`k_newvars',		///
					"`touse'",		///
					`offset',		///
					"`outcome'",		///
					"`LATENT'")
		MISSMSG `VARLIST'
		exit
	}

	`vv'						///
	mata: _gsem_predict_lmu("`TNAME'",		///
				"`anything'",		///
				`k_newvars',		///
				"`touse'",		///
				`offset',		///
				"`STAT'" == "pr",	///
				"`outcome'",		///
				"`LATENT'")
	MISSMSG `VARLIST'
end

program ParseCond1
	local	OPTS	EBMEANs		///
			EBMODEs		///
			FIXEDonly
	capture syntax [, `OPTS' ]
	if c(rc) {
		di as err "invalid {bf:conditional()} option;"
		syntax [, `OPTS' ]
		error 198 // [sic]
	}
	local cond `ebmeans' `ebmodes' `fixedonly'
	if `:list sizeof cond' > 1 {
		di as err "invalid {bf:conditional()} option;"
		opts_exclusive "`cond'"
	}
	c_local conditional1 `cond'
end

program GenScores
	version 13
	local vv : display "version " _caller() ":"
	gettoken TNAME 0 : 0
	syntax  anything(id="stub* or newvarlist") 	///
	[if] [in]					///
	[,						///
		SCores					///
		LOG					/// NOT documented
		MCSTART					/// NOT documented
	]

	if "`e(n_quad)'" == "1" | "`e(intmethod)'" == "laplace" {
		di as err ///
"option scores not allowed with intmethod(laplace) results"
		exit 198
	}

	_score_spec `anything', ignoreeq strict
	local varlist `s(varlist)'
	local typlist `s(typlist)'

	local log = "`log'" != ""

	if `"`if'`in'"' != "" {
		tempname touse
		mark `touse' `if' `in'
	}

	if "`e(intmethod)'" != "" {
		checkestimationsample
	}
	tempname esample
	quietly gen byte `esample' = e(sample)
	foreach var of local varlist {
		gettoken type typlist : typlist
		quietly gen `type' `var' = 0
	}
	`vv'							///
	mata: _gsem_predict_scores(	"`TNAME'",		///
					"`varlist'",		///
					"`esample'",		///
					`log')
	local colna : colfullna e(b)
	foreach var of local varlist {
		gettoken spec colna : colna
		label var `var' "Score for _b[`spec']"
		quietly replace `var' = . if !e(sample)
	}
	if "`touse'" != "" {
		foreach var of local varlist {
			quietly replace `var' = . if !`touse'
		}
	}
	MISSMSG `varlist'
end

program MISSMSG
	tempname touse
	quietly gen byte `touse' = 1
	markout `touse' `0'
	quietly count if !`touse'
	if r(N) {
		di as txt "(`r(N)' missing values generated)"
	}
end

program FILL
	gettoken touse 0 : 0
	foreach var of local 0 {
		local gvars : char `var'[gvars]
		if "`gvars'" != "" {
			quietly bysort `gvars' (`var') : ///
			replace `var' = `var'[1] if `touse'
		}
		quietly replace `var' = . if !`touse'
	}
end

program CheckXB
	syntax [, xb]
	if e(mecmd) == 1 | e(irtcmd) == 1 {
		exit
	}
	if "`xb'" == "" {
		exit
	}
	di as err "option xb not allowed;"
	di as err "{p 0 0 2}"
	di as err "For linear predictions use the {bf:eta} option."
	if e(k_hinfo) != 0 {
		di as err "{break}"
		di as err "For linear predictions that treat all latent"
		di as err "variables as fixed at zero, use options"
		di as err "{bf:eta} and {bf:conditional(fixedonly)}."
	}
	di as err "{p_end}"
	exit 198
end

program CountNewvars
	gettoken c_dim 0 : 0
	syntax newvarlist
	c_local `c_dim' : list sizeof varlist
end

program REremap, rclass
	_on_colon_parse `0'
	local typlist `s(before)'
	_on_colon_parse `s(after)'
	local varlist `s(before)'
	local VARLIST `s(after)'

	foreach VAR of local VARLIST {
		local factor : char `VAR'[factor]
		if "`factor'" == "" {
			gettoken var varlist : varlist
			gettoken typ typlist : typlist
			quietly gen `typ' `var' = `VAR'
			label var `var' `"`:var label `VAR''"'
			local gvars0
			local name0
			continue
		}
		local gvars : char `VAR'[gvars]
		_ms_parse_parts `factor'
		local name = r(name)
		if "`gvars' `name'" != "`gvars0' `name0'" {
			gettoken var varlist : varlist
			gettoken typ typlist : typlist
			quietly gen `typ' `var' = `VAR'
			local label `"`:var label `VAR''"'
			local pos = strpos(`"`label'"', " for ")
			local label = substr(`"`label'"', 1, `pos') ///
				+ " for _cons[`gvars'>`name']"
			label var `var' `"`label'"'
			local gvars0 : copy local gvars
			local name0 : copy local name
			continue
		}
		quietly replace `var' = `VAR' if `factor' == 1
	}
end

exit
