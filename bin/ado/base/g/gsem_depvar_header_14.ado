*! version 1.1.0  23jan2019
program gsem_depvar_header_14
	version 14

	local OPTS	c1(int 1)	///
			c2(int 18)	///
			c3(int 51)	///
			c4(int 67)	///
			c4wfmt(int 10)

	syntax [, left(string) right(string) `OPTS' ]

	if "`left'`right'" != "" {
		syntax , left(string) right(string) [ `OPTS' ]
		BALANCE `left' `right'
		local DISPLAY "*"
	}
	else {
		tempname left right
		.`left' = {}
		.`right' = {}
		local DISPLAY DISPLAY
	}

	local kdv = e(k_dv)
	if missing(`kdv') | "`e(_N)'" != "matrix" {
		exit
	}

	tempname getobs
	mata: st_gsem_depvar_header_getobs("getobs")

	if `kdv' > 1 {
		local BLANK BLANK
	}
	else	local BLANK "*"

	local depvars `"`e(depvar)'"'
	forval i = 1/`kdv' {
		gettoken dv depvars : depvars
		BALANCE `left' `right'
		`BLANK' `left' `right'
		DVINFO	`left'		///
			`right'		///
			`c1'		///
			`c2'		///
			`c3'		///
			`c4'		///
			`c4wfmt'	///
			`getobs'	///
			`kdv'		///
			`i'		///
			`dv'
	}
	`BLANK' `left' `right'

	`DISPLAY' `left' `right'
end

program BLANK
	args left right

	.`left'.Arrpush ""
	.`right'.Arrpush ""
end

program BALANCE
	args left right

	local nl = `.`left'.arrnels'
	local nr = `.`right'.arrnels'
	local diff = `nr' - `nl'
	if `diff' > 0 {
		local arr : copy local left
	}
	else if `diff' < 0 {
		local diff = abs(`diff')
		local arr : copy local right
	}
	forval i = 1/`diff' {
		.`arr'.Arrpush ""
	}
end

program DVINFO
	args left right c1 c2 c3 c4 c4wfmt getobs kdv i dv

	local family = e(family`i')
	gettoken family fargs : family
	local fargs : list retok fargs
	if inlist("`family'", "bernoulli", "gaussian", "poisson", "weibull") {
		local family = proper("`family'")
	}
	local link = e(link`i')
	gettoken link : link

	if "`getobs'" == "yes" {
		.`right'.Arrpush			///
			as txt				///
			_col(`c3') "Number of obs"	///
			_col(`c4') "= "			///
			as res %`c4wfmt'.0fc el(e(_N),1,`i')
	}

	if "`family'" == "binomial" {
		RESPONSE `left' `c2' `dv'
		capture confirm name `fargs'
		if c(rc) == 0 {
			local fargs = abbrev("`fargs'", 12)
		}
		.`left'.Arrpush			///
			as txt			///
			"Denominator"		///
			_col(`c2') ": "		///
			as res "`fargs'"
	}
	else if "`family'" == "multinomial" {
		RESPONSE `left' `c2' `dv'
		.`left'.Arrpush			///
			as txt			///
			"Base outcome"		///
			_col(`c2') ": "		///
			as res "`fargs'"
	}
	else if "`family'" == "Gaussian" {
		local k_yinfo = e(k_yinfo)
		local RESPONSE RESPONSE
		forval i = 1/`k_yinfo' {
			if "`dv'" != "`e(yinfo`i'_name)'" {
				continue
			}
			if "`e(yinfo`i'_cens_info)'" != "matrix" {
				continue
			}
			CENS_INFO	`left'		///
					`right'		///
					`c1'		///
					`c2'		///
					`c3'		///
					`c4'		///
					`c4wfmt'	///
					`i'		///
					`dv'		///
					"`fargs'"
			local RESPONSE "*"
			continue, break
		}
		`RESPONSE' `left' `c2' `dv'
	}
	else {
		RESPONSE `left' `c2' `dv'
	}

	.`left'.Arrpush				///
		as txt				///
		"Family"			///
		_col(`c2') ": "			///
		as res `"`family'"'

	if "`family'" == "nbinomial" {
		.`left'.Arrpush			///
			as txt			///
			"Dispersion"		///
			_col(`c2') ": "		///
			as res "`fargs'"
	}
	local survival	exponential		///
			gamma			///
			loglogistic		///
			lognormal		///
			Weibull
	if `:list family in survival' {
		local k_yinfo = e(k_yinfo)
		forval i = 1/`k_yinfo' {
			if "`dv'" != "`e(yinfo`i'_name)'" {
				continue
			}
			if "`e(yinfo`i'_cens_info)'" != "matrix" {
				continue
			}
			SURV_INFO	`left'		///
					`right'		///
					`c1'		///
					`c2'		///
					`c3'		///
					`c4'		///
					`c4wfmt'	///
					`i'		///
					`dv'		///
					"`fargs'"
			continue, break
		}
	}

	.`left'.Arrpush				///
		as txt				///
		"Link"				///
		_col(`c2') ": "			///
		as res `"`link'"'
end

program RESPONSE
	args left c2 dv title

	if "`title'" == "" {
		local title Response
	}

	.`left'.Arrpush				///
		as txt				///
		"`title'"			///
		_col(`c2') ": "			///
		as res abbrev("`dv'", 20)
end

program CENS_INFO
	args left right c1 c2 c3 c4 c4wfmt i dv fargs

	local 0 `"`fargs'"'
	syntax [,	LDepvar(name)		///
			UDepvar(name)		///
			LCensored(string)	///
			RCensored(string)	///
			*			///
	]

	local interval no
	if "`ldepvar'" != "" {
		RESPONSE `left' `c2' `ldepvar'	"Lower response"
		RESPONSE `left' `c2' `dv	"Upper response"
		local interval yes
	}
	else if "`udepvar'" != "" {
		RESPONSE `left' `c2' `dv'	"Lower response"
		RESPONSE `left' `c2' `udepvar'	"Upper response"
		local interval yes
	}
	else {
		RESPONSE `left' `c2' `dv'
		if "`lcensored'" != "" {
			.`left'.Arrpush			///
				as txt			///
				"Lower limit"		///
				_col(`c2') ": "		///
				as res abbrev("`lcensored'", 20)
		}
		if "`rcensored'" != "" {
			.`left'.Arrpush			///
				as txt			///
				"Upper limit"		///
				_col(`c2') ": "		///
				as res abbrev("`rcensored'", 20)
		}
	}

	.`right'.Arrpush				///
		as txt					///
		_col(`c3') "Uncensored"			///
		_col(`c4') "= "				///
		as res %`c4wfmt'.0fc el(e(yinfo`i'_cens_info), 1, 1)

	.`right'.Arrpush				///
		as txt					///
		_col(`c3') "Left-censored"		///
		_col(`c4') "= "				///
		as res %`c4wfmt'.0fc el(e(yinfo`i'_cens_info), 1, 2)

	.`right'.Arrpush				///
		as txt					///
		_col(`c3') "Right-censored"		///
		_col(`c4') "= "				///
		as res %`c4wfmt'.0fc el(e(yinfo`i'_cens_info), 1, 3)

	if "`interval'" == "yes" {
		.`right'.Arrpush				///
			as txt					///
			_col(`c3') "Interval"			///
			_col(`c4') "= "				///
			as res %`c4wfmt'.0fc el(e(yinfo`i'_cens_info), 1, 4)
	}
end

program SURV_INFO
	args left right c1 c2 c3 c4 c4wfmt i dv fargs

	local 0 `"`fargs'"'
	syntax [, aft ph *]
	if "`aft'" == "" {
		local form proportional hazards
	}
	else {
		local form accelerated failure-time
	}
	.`left'.Arrpush			///
		as txt			///
		"Form"			///
		_col(`c2') ": "		///
		as res "`form'"

	.`right'.Arrpush				///
		as txt					///
		_col(`c3') "No. of failures"		///
		_col(`c4') "= "				///
		as res %`c4wfmt'.0fc el(e(yinfo`i'_cens_info), 1, 1)

	.`right'.Arrpush				///
		as txt					///
		_col(`c3') "Time at risk"		///
		_col(`c4') "= "				///
		as res %`c4wfmt'.0g e(yinfo`i'_risk)
end

program DISPLAY
	args left right

	local nl = `.`left'.arrnels'
	local nr = `.`right'.arrnels'
	local K = max(`nl', `nr')

	forval i = 1/`K' {
		di as txt `.`left'[`i']' as txt `.`right'[`i']'
	}
end

mata:

void st_gsem_depvar_header_getobs(string scalar getobs)
{
	real	scalar	eN
	real	vector	e_N

	eN	= st_numscalar("e(N)")
	e_N	= st_matrix("e(_N)")

	if (all(e_N :== eN)) {
		st_local(getobs, "no")
	}
	else {
		st_local(getobs, "yes")
	}
}

end

exit
