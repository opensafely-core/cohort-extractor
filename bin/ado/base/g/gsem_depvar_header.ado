*! version 1.2.0  11feb2019
program gsem_depvar_header
	version 14

	if e(mecmd) == 1 {
		exit
	}

	if e(xtcmd) == 1 {
		exit
	}

	if c(noisily) == 0 {
		exit
	}

	if inlist("`e(gsem_vers)'", "", "2") {
		gsem_depvar_header_14 `0'
		exit
	}

	local OPTS	c1(int 1)	///
			c2(int 16)	///
			c3(int 49)	///
			c4(int 67)	///
			c4wfmt(int 10)	///
			midx(int 0)	///
			gidx(int 0)	///
			noHEADer

	syntax [, left(string) right(string) `OPTS' ]

	if "`e(gclevs)'" == "matrix" {
		local kmg : rowsof e(gclevs)
	}
	else {
		local kmg 1
	}
	if `midx' < 0 {
		local midx 0
	}
	if `midx' > `kmg' {
		local midx 0
	}
	if `gidx' < 0 {
		local gidx 0
	}
	if `gidx' > e(N_groups) {
		local gidx 0
	}

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

	if `"`e(_N)'"' != "matrix" {
		exit
	}
	local kdv : colsof e(_N)

	mata: st_gsem_depvar_header_getobs("getobs")

	if `kdv' > 1 & `kdv' != `kmg' & "`header'" == "" {
		local BLANK BLANK
	}
	else	local BLANK "*"

	if `gidx' {
		GetGroup gval : `gidx' `=`c3'-`c2'-4'
		RESPONSE `left' `c2' "`gval'" "Group" 0
		.`right'.Arrpush			///
			as txt				///
			_col(`c3') "Number of obs"	///
			_col(`c4') "= "			///
			as res %`c4wfmt'.0fc el(e(nobs),1,`gidx')
		`DISPLAY' `left' `right'
		exit
	}

	if `midx' & "`e(lclass)'" != "" {
		GetClass cval : `midx'
		if e(fmmcmd)==1 {
			RESPONSE `left' `c2' "`cval'" "`e(lclass)'" 0
		}
		else {
			RESPONSE `left' `c2' "`cval'" "Class" 0
		}
	}
	if "`header'" != "" {
		`BLANK' `left' `right'
		`DISPLAY' `left' `right'
		exit
	}

	local gidx0 0
	local gidx 0
	local rows 0
	local depvars `"`e(depvar)'"'
	forval i = 1/`kdv' {
		if `midx' == 0 & "`e(groupvar)'" != "" {
			local gidx = e(ygidx`i')
			if `gidx' == `gidx0' {
				local gidx 0
			}
			else {
				local gidx0 = `gidx'
			}
			BLANK `left' `right'
		}
		gettoken dv depvars : depvars
		BALANCE `left' `right'
		if `midx' == 0 {
			`BLANK' `left' `right'
		}
		else if `midx' == e(ymidx`i') {
			if `rows' < `.`left'.arrnels' {
				`BLANK' `left' `right'
				local rows = `.`left'.arrnels'
			}
		}
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
			`gidx'		///
			`midx'		///
			`BLANK'		///
			`dv'
	}
	if `midx' == 0 & "`e(prefix)'" != "svy" {
		if "`e(groupvar)'`e(lclass)'" != "" {
			BLANK `left' `right'
		}
		else {
			`BLANK' `left' `right'
		}
	}

	`DISPLAY' `left' `right'
end

program BLANK
	args left right

	local kl = `.`left'.arrnels'
	local kr = `.`right'.arrnels'
	if `kl' & `kr' {
		if `"`.`left'[`kl']'`.`right'[`kr']'"' == "" {
			exit
		}
	}
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
	args left right c1 c2 c3 c4 c4wfmt getobs kdv i gidx midx BLANK dv

	local model = e(model`i')
	local family = e(family`i')
	gettoken family fargs : family
	local fargs : list retok fargs
	if inlist("`family'", "bernoulli", "gaussian", "poisson", "weibull") {
		local family = proper("`family'")
	}
	local link = e(link`i')
	gettoken link : link

	if `"`e(ymidx`i')'"' != "" {
		if `i' > 1 {
			local cval0 = e(ymidx`=`i'-1')
		}
		else	local cval0 0
		local cval = e(ymidx`i')
		if `gidx' {
			GetGroup gval : `gidx' `=`c3'-`c2'-4'
			RESPONSE `left' `c2' "`gval'" "Group" 0
			.`right'.Arrpush			///
				as txt				///
				_col(`c3') "Number of obs"	///
				_col(`c4') "= "			///
				as res %`c4wfmt'.0fc el(e(nobs),1,`gidx')
			`BLANK' `left' `right'
		}
		if `midx' == 0 {
		    if "`e(lclass)'" != "" & `cval0' != `cval' {
			GetClass cval : `cval'
			local glen = udstrlen("`cval'")
			BLANK `left' `right'
			if e(fmmcmd)==1 {
				RESPONSE `left' `c2' "`cval'" "`e(lclass)'" 0
			}
			else {
				RESPONSE `left' `c2' "`cval'" "Class" 0
			}
			`BLANK' `left' `right'
		    }
		}
		else if `midx' != `cval' {
			exit
		}
	}

	if "`getobs'" == "yes" {
		.`right'.Arrpush			///
			as txt				///
			_col(`c3') "Number of obs"	///
			_col(`c4') "= "			///
			as res %`c4wfmt'.0fc el(e(_N),1,`i')
	}

	if "`family'" == "binomial" & e(fmmcmd) != 1 {
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
	else if "`family'" == "multinomial" & e(fmmcmd) != 1 {
		RESPONSE `left' `c2' `dv'
		.`left'.Arrpush			///
			as txt			///
			"Base outcome"		///
			_col(`c2') ": "		///
			as res "`fargs'"
	}
	else if "`family'" == "Gaussian" {
		local cens_info = "`e(cens_info`i')'"
		if "`cens_info'" != "" {
			if (!missing(e(N_reps)) | "`e(prefix)'"=="svy" | ///
			    e(k_dv)>1) {
				local censobs_head "censobsheader"
			}
			if ("`getobs'"=="yes") {
				local censobs_head ""
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
					"`fargs'"	///
					"`cens_info'"	///
					`censobs_head'
		}
		else	RESPONSE `left' `c2' `dv'
	}
	else {
		RESPONSE `left' `c2' `dv'
	}

	if e(fmmcmd) == 1 {
		.`left'.Arrpush				///
			as txt				///
			"Model"				///
			_col(`c2') ": "			///
			as res `"`model'"'
	}
	else {
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
	}
	local survival	exponential		///
			gamma			///
			loglogistic		///
			lognormal		///
			Weibull
	if `:list family in survival' {
		local cens_info = "`e(cens_info`i')'"
		if "`cens_info'" != "" {
			local risk = e(risk`i')
			SURV_INFO	`left'		///
					`right'		///
					`c1'		///
					`c2'		///
					`c3'		///
					`c4'		///
					`c4wfmt'	///
					`i'		///
					`dv'		///
					"`fargs'"	///
					"`cens_info'"	///
					`risk'
		}
	}

	if e(fmmcmd) != 1 {
		.`left'.Arrpush				///
			as txt				///
			"Link"				///
			_col(`c2') ": "			///
			as res `"`link'"'
	}
end

program GetGroup
	args c_gval COLON gidx maxlen

	if `"`maxlen'"' == ""{
		local maxlen = c(namelen)
	}

	_ms_element_info, matrix(e(groupvalue)) el(`gidx')
	local gval `"`r(level)'"'
	local glen = udstrlen("`gval'")
	if `glen' > `maxlen' {
		local gval = udsubstr("`gval'",1,`maxlen'-2) + ".."
	}
	c_local `c_gval' `"`gval'"'
end

program GetClass
	args c_cval COLON midx

	mata: st_local("cval", st_matrixrowstripe("e(gclevs)")[`midx',2])
	if "`e(groupvar)'" != "" {
		local pos = strpos("`cval'", "#")
		local cval = substr("`cval'", `pos'+1, .)
	}
	local pos = strpos("`cval'", "#")
	if `pos' == 0 {
		_ms_parse_parts `cval'
		local cval `"`r(level)'"'
	}
	else {
		local cval : subinstr local cval "bn." ".", all
	}

	c_local `c_cval' "`cval'"
end

program RESPONSE
	args left c2 dv title abbrev

	if "`title'" == "" {
		local title Response
	}
	if "`abbrev'" == "" {
		local abbrev 20
	}

	if "`e(cmd2)'" == "irt" {
		local title "`title': "
		local colon
	}
	else {
		local colon `"_col(`c2') ": ""'
	}

	if `abbrev' == 0 {
		.`left'.Arrpush				///
			as txt				///
			"`title'"			///
			`colon'				///
			as res "`dv'"
		exit
	}

	.`left'.Arrpush				///
		as txt				///
		"`title'"			///
		_col(`c2') ": "			///
		as res abbrev("`dv'", `abbrev')
end

program CENS_INFO
	args left right c1 c2 c3 c4 c4wfmt i dv fargs cens_info censobs_head

	local 0 `"`fargs'"'
	syntax [,	LDepvar(string)		///
			UDepvar(string)		///
			LCensored(string)	///
			RCensored(string)	///
			LTruncated(string)	///
			RTruncated(string)	///
			*			///
	]

	local has_cens `ldepvar' `udepvar' `lcensored' `rcensored'
	local has_cens : list sizeof has_cens
	local has_trunc `ltruncated' `rtruncated'
	local has_trunc : list sizeof has_trunc
	if `has_trunc' {
		if "`ltruncated'" == "" {
			local ltruncated "-inf"
		}
		else {
			local ltruncated = abbrev("`ltruncated'", `c4wfmt')
		}
		if "`rtruncated'" == "" {
			local rtruncated "+inf"
		}
		else {
			local rtruncated = abbrev("`rtruncated'", `c4wfmt')
		}
	}

	if e(fmmcmd) != 1 {
		if "`censobs_head'" != "" {
			if e(k_dv) == 1 {
				.`left'.Arrpush
			}
			.`left'.Arrpush
		}
	}

	local interval no
	if "`ldepvar'" != "" {
		RESPONSE `left' `c2' `ldepvar'	"Lower response"
		RESPONSE `left' `c2' `dv'	"Upper response"
		local interval yes
	}
	else if "`udepvar'" != "" {
		RESPONSE `left' `c2' `dv'	"Lower response"
		RESPONSE `left' `c2' `udepvar'	"Upper response"
		local interval yes
	}
	else if e(fmmcmd) != 1 {
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
	else {
		RESPONSE `left' `c2' `dv'
	}

	// also see _coef_table_header.ado and _censobs_header.ado
	if "`censobs_head'" != "" & `has_cens' {
		if e(k_dv) == 1 {
			.`right'.Arrpush
		}
		.`right'.Arrpush				///
			as txt _col(`c3') "Censoring of obs:"
	}
	if `has_cens' {
		.`right'.Arrpush				///
			as txt					///
			_col(`c3') "   Uncensored"		///
			_col(`c4') "= "				///
			as res %`c4wfmt'.0fc el(`cens_info', 1, 1)

		.`right'.Arrpush				///
			as txt					///
			_col(`c3') "   Left-censored"		///
			_col(`c4') "= "				///
			as res %`c4wfmt'.0fc el(`cens_info', 1, 2)

		.`right'.Arrpush				///
			as txt					///
			_col(`c3') "   Right-censored"		///
			_col(`c4') "= "				///
			as res %`c4wfmt'.0fc el(`cens_info', 1, 3)
	}
	if "`interval'" == "yes" {
		.`right'.Arrpush				///
			as txt					///
			_col(`c3') "   Interval-cens."		///
			_col(`c4') "= "				///
			as res %`c4wfmt'.0fc el(`cens_info', 1, 4)
	}
	if `has_trunc' {
		.`right'.Arrpush				///
			as txt					///
			_col(`c3') "Limit: lower"		///
			_col(`c4') "= "				///
			as res %`c4wfmt's "`ltruncated'"
		.`right'.Arrpush				///
			as txt					///
			_col(`c3') "       upper"		///
			_col(`c4') "= "				///
			as res %`c4wfmt's "`rtruncated'"
	}
end

program SURV_INFO
	args left right c1 c2 c3 c4 c4wfmt i dv fargs cens_info risk

	local 0 `"`fargs'"'
	syntax [, aft ph *]
	if "`aft'" == "" {
		local form proportional hazards
	}
	else {
		local form accelerated failure-time
	}
	if e(fmmcmd) != 1 {
		.`left'.Arrpush			///
			as txt			///
			"Form"			///
			_col(`c2') ": "		///
			as res "`form'"
	}

	.`right'.Arrpush				///
		as txt					///
		_col(`c3') "No. of failures"		///
		_col(`c4') "= "				///
		as res %`c4wfmt'.0fc el(`cens_info', 1, 1)

	.`right'.Arrpush				///
		as txt					///
		_col(`c3') "Time at risk"		///
		_col(`c4') "= "				///
		as res %`c4wfmt'.0g `risk'
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
	real	vector	eN
	real	vector	e_N

	if (st_global("e(groupvar)") == "") {
		eN	= st_numscalar("e(N)")
		e_N	= st_matrix("e(_N)")
		if (all(e_N :== eN)) {
			st_local(getobs, "no")
		}
		else {
			st_local(getobs, "yes")
		}
		return
	}

	real	scalar	k
	real	scalar	i
	real	scalar	g

	eN	= st_matrix("e(nobs)")
	e_N	= st_matrix("e(_N)")

	k	= cols(e_N)
	for (i=1; i<=k; i++) {
		g = st_numscalar(sprintf("e(ygidx%f)",i))
		if (eN[g] != e_N[i]) {
			st_local(getobs, "yes")
			return
		}
	}
	st_local(getobs, "no")
}

end

exit
